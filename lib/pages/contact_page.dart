import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

const _lieu = 'Goma, Nord-Kivu, RDC';
const _github = 'https://github.com/justinkan243-gif';
const _email = 'contact@bealive-media.local';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  @override
  void dispose() {
    _nomCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _copier(String texte, String label) async {
    await Clipboard.setData(ClipboardData(text: texte));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label copié dans le presse-papiers.')),
    );
  }

  void _envoyer() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Merci ${_nomCtrl.text.trim()}, votre message est prêt.'),
      ),
    );
    _nomCtrl.clear();
    _emailCtrl.clear();
    _messageCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            titre: 'Coordonnées',
            child: Column(
              children: [
                const _Coordonnee(
                  icone: Icons.place_outlined,
                  libelle: 'Localisation',
                  valeur: _lieu,
                ),
                const Divider(height: 24),
                _Coordonnee(
                  icone: Icons.code,
                  libelle: 'GitHub',
                  valeur: _github,
                  onCopier: () => _copier(_github, 'Lien GitHub'),
                ),
                const Divider(height: 24),
                _Coordonnee(
                  icone: Icons.mail_outline,
                  libelle: 'Email',
                  valeur: _email,
                  onCopier: () => _copier(_email, 'Email'),
                ),
              ],
            ),
          ),
          _Section(
            titre: 'Envoyer un message',
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nomCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Saisissez votre nom.' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.mail_outline),
                    ),
                    validator: (v) =>
                        (v == null || !v.contains('@')) ? 'Saisissez un email valide.' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _messageCtrl,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Message',
                      alignLabelWithHint: true,
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Écrivez votre message.' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _envoyer,
                    child: const Text('Envoyer'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ---------- Widgets internes ----------

class _Section extends StatelessWidget {
  final String titre;
  final Widget child;

  const _Section({required this.titre, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titre.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _Coordonnee extends StatelessWidget {
  final IconData icone;
  final String libelle;
  final String valeur;
  final VoidCallback? onCopier;

  const _Coordonnee({
    required this.icone,
    required this.libelle,
    required this.valeur,
    this.onCopier,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFFE6EBEF),
          foregroundColor: AppColors.primary,
          child: Icon(icone, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                libelle,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                valeur,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        if (onCopier != null)
          IconButton(
            tooltip: 'Copier',
            icon: const Icon(Icons.copy_outlined, size: 20),
            color: AppColors.textMuted,
            onPressed: onCopier,
          ),
      ],
    );
  }
}