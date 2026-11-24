import 'package:flutter/material.dart';
import '../models/membre_famille.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class FamillePage extends StatefulWidget {
  const FamillePage({super.key});

  @override
  State<FamillePage> createState() => _FamillePageState();
}

class _FamillePageState extends State<FamillePage> {
  final _api = ApiService();
  late Future<List<MembreFamille>> _futureMembres;

  @override
  void initState() {
    super.initState();
    _futureMembres = _api.getFamilyMembers();
  }

  Future<void> _recharger() {
    setState(() => _futureMembres = _api.getFamilyMembers());
    return _futureMembres.then((_) {}, onError: (_) {});
  }

  Future<void> _executer(Future<void> Function() action, String messageSucces) async {
    try {
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(messageSucces)));
      _recharger();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<MembreFamille?> _ouvrirFormulaire([MembreFamille? existant]) {
    return showModalBottomSheet<MembreFamille>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => MembreFormSheet(membre: existant),
    );
  }

  Future<void> _ajouter() async {
    final membre = await _ouvrirFormulaire();
    if (membre == null) return;
    await _executer(() => _api.ajouterMembre(membre), 'Membre ajouté.');
  }

  Future<void> _modifier(MembreFamille existant) async {
    final membre = await _ouvrirFormulaire(existant);
    if (membre == null || existant.id == null) return;
    await _executer(() => _api.modifierMembre(existant.id!, membre), 'Membre modifié.');
  }

  Future<void> _supprimer(MembreFamille membre) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ce membre ?'),
        content: Text(membre.nomComplet),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirme != true || membre.id == null) return;
    await _executer(() => _api.supprimerMembre(membre.id!), 'Membre supprimé.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ma famille')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _ajouter,
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
      body: RefreshIndicator(
        onRefresh: _recharger,
        child: FutureBuilder<List<MembreFamille>>(
          future: _futureMembres,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _Erreur(
                message: snapshot.error.toString(),
                onReessayer: _recharger,
              );
            }
            final membres = snapshot.data ?? const <MembreFamille>[];
            if (membres.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(child: Text('Aucun membre pour le moment.')),
                ],
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: membres.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _MembreCard(
                membre: membres[i],
                onModifier: () => _modifier(membres[i]),
                onSupprimer: () => _supprimer(membres[i]),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MembreCard extends StatelessWidget {
  final MembreFamille membre;
  final VoidCallback onModifier;
  final VoidCallback onSupprimer;

  const _MembreCard({
    required this.membre,
    required this.onModifier,
    required this.onSupprimer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE6EBEF),
          foregroundColor: AppColors.primary,
          child: Text(membre.initiales, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        title: Text(membre.nomComplet, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${membre.parente} · ${membre.dateNaissance} · ${membre.lieuNaissance}',
          style: const TextStyle(color: AppColors.textMuted),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (v) => v == 'modifier' ? onModifier() : onSupprimer(),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'modifier', child: Text('Modifier')),
            PopupMenuItem(
              value: 'supprimer',
              child: Text('Supprimer', style: TextStyle(color: AppColors.danger)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Erreur extends StatelessWidget {
  final String message;
  final VoidCallback onReessayer;

  const _Erreur({required this.message, required this.onReessayer});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 60),
        const Icon(Icons.cloud_off_outlined, size: 48, color: AppColors.textMuted),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        Center(
          child: OutlinedButton(onPressed: onReessayer, child: const Text('Réessayer')),
        ),
      ],
    );
  }
}

class MembreFormSheet extends StatefulWidget {
  final MembreFamille? membre;

  const MembreFormSheet({super.key, this.membre});

  @override
  State<MembreFormSheet> createState() => _MembreFormSheetState();
}

String? _obligatoire(String? v) =>
    (v == null || v.trim().isEmpty) ? 'Champ obligatoire.' : null;

class _MembreFormSheetState extends State<MembreFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _nom = TextEditingController(text: widget.membre?.nom);
  late final _postnom = TextEditingController(text: widget.membre?.postnom);
  late final _prenom = TextEditingController(text: widget.membre?.prenom);
  late final _lieu = TextEditingController(text: widget.membre?.lieuNaissance);
  late final _date = TextEditingController(text: widget.membre?.dateNaissance);
  late final _parente = TextEditingController(text: widget.membre?.parente);

  @override
  void dispose() {
    for (final c in [_nom, _postnom, _prenom, _lieu, _date, _parente]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _choisirDate() async {
    final actuelle = DateTime.tryParse(_date.text) ?? DateTime(2000, 1, 1);
    final choisie = await showDatePicker(
      context: context,
      initialDate: actuelle,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (choisie != null) {
      _date.text = choisie.toIso8601String().substring(0, 10);
    }
  }

  void _valider() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      MembreFamille(
        id: widget.membre?.id,
        nom: _nom.text.trim(),
        postnom: _postnom.text.trim(),
        prenom: _prenom.text.trim(),
        lieuNaissance: _lieu.text.trim(),
        dateNaissance: _date.text.trim(),
        parente: _parente.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.membre == null ? 'Ajouter un membre' : 'Modifier le membre',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nom,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: _obligatoire,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _postnom,
                decoration: const InputDecoration(labelText: 'Postnom'),
                validator: _obligatoire,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _prenom,
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: _obligatoire,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lieu,
                decoration: const InputDecoration(labelText: 'Lieu de naissance'),
                validator: _obligatoire,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _date,
                readOnly: true,
                onTap: _choisirDate,
                decoration: const InputDecoration(
                  labelText: 'Date de naissance',
                  suffixIcon: Icon(Icons.calendar_today_outlined),
                ),
                validator: _obligatoire,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _parente,
                decoration: const InputDecoration(labelText: 'Parenté (ex. Père, Sœur)'),
                validator: _obligatoire,
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _valider, child: const Text('Enregistrer')),
            ],
          ),
        ),
      ),
    );
  }
}