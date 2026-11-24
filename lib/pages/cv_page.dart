import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

const _nom = 'Justin Mutuza';
const _titre = 'Étudiant en Informatique · Développeur Web & Mobile Junior';
const _lieu = 'Goma, République Démocratique du Congo';
const _github = 'github.com/justinkan243-gif/cv_flutter_justin';
const _presentation =
    "Étudiant en Licence 3 en Informatique Appliquée à la Gestion des Entreprises à l'ISIG Goma, "
    "je m'intéresse au développement d'applications mobiles et web ainsi qu'à l'analyse des systèmes "
    "de gestion. J'aime concevoir des solutions structurées, claires et utiles pour répondre à des "
    "besoins concrets.";

class CvPage extends StatelessWidget {
  const CvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon CV')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _Entete(),
          const SizedBox(height: 24),
          _Section(
            titre: 'Profil',
            items: const [
              Text(_presentation, style: TextStyle(height: 1.5, color: AppColors.textMuted)),
            ],
          ),
          _Section(
            titre: 'Formation',
            items: const [
              _Entree(
                titre: 'Licence 3 — Informatique Appliquée à la Gestion des Entreprises (LIAGE)',
                sous: 'ISIG Goma',
                periode: '2023 – 2026',
              ),
            ],
          ),
          _Section(
            titre: 'Expériences',
            items: const [
              _Entree(
                titre: 'Stagiaire académique',
                sous: 'REGIDESO — Station de pompage Lac 2 & Agence de Goma',
                periode: 'Juin 2026',
                points: [
                  'Analyse des flux et processus opérationnels manuels, sur site et en agence.',
                  'Identification des points de friction dans le suivi quotidien.',
                  'Rédaction de recommandations orientées transformation numérique.',
                ],
              ),
              _Entree(
                titre: 'Photographe & vidéaste indépendant',
                sous: 'Be Alive',
                periode: '2026',
                points: [
                  'Captation, retouche et montage photo et vidéo pour événements et portraits.',
                ],
              ),
            ],
          ),
          _Section(
            titre: 'Projets',
            items: const [
              _Entree(
                titre: 'cv_flutter_justin',
                sous: 'Application mobile CV et portfolio, avec authentification et gestion de membres via API REST',
                tags: ['Flutter', 'Dart', 'REST API', 'GitHub'],
              ),
              _Entree(
                titre: 'Direct Immobilier',
                sous: 'Plateforme immobilière à Goma : catalogue foncier, vérification documentaire, réservations',
                tags: ['WordPress', 'Next.js', 'SQL'],
              ),
              _Entree(
                titre: 'Gestion des étudiants',
                sous: 'Application web CRUD (TP PHP, LIC2 LIAGE)',
                tags: ['PHP', 'MySQL', 'HTML/CSS'],
              ),
              _Entree(
                titre: 'Gestion de stock',
                sous: 'Application de bureau pour la gestion de stock et d\'inventaire',
                tags: ['C#', 'SQL Server'],
              ),
            ],
          ),
          _Section(
            titre: 'Compétences',
            items: const [
              _Groupe(
                label: 'Développement',
                tags: ['Dart', 'Flutter', 'JavaScript', 'Next.js', 'Node.js', 'PHP', 'HTML/CSS', 'C#', 'Python'],
              ),
              _Groupe(
                label: 'Données & outils',
                tags: ['MySQL', 'SQL Server', 'Git / GitHub', 'VS Code'],
              ),
              _Groupe(
                label: 'Création',
                tags: ['Photoshop', 'Lightroom', 'Premiere Pro', 'CapCut'],
              ),
            ],
          ),
          _Section(
            titre: 'Langues',
            items: const [
              _Ligne(gauche: 'Français', droite: 'Courant'),
              _Ligne(gauche: 'Swahili', droite: 'Courant'),
              _Ligne(gauche: 'Anglais', droite: 'Intermédiaire'),
            ],
          ),
          _Section(
            titre: "Centres d'intérêt",
            items: const [
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [_Tag('Développement mobile et web'), _Tag('Photographie')],
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ---------- Widgets internes ----------

class _Entete extends StatelessWidget {
  const _Entete();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/profile.jpg',
                width: 84,
                height: 84,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 84,
                  height: 84,
                  color: const Color(0xFFE6EBEF),
                  child: const Icon(Icons.person, size: 40, color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _nom,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  const Text(_titre, style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.place_outlined, size: 14, color: AppColors.textMuted),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(_lieu, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(Icons.code, size: 14, color: AppColors.textMuted),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(_github,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String titre;
  final List<Widget> items;

  const _Section({required this.titre, required this.items});

  List<Widget> _separer() {
    final out = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) {
        out.addAll(const [SizedBox(height: 12), Divider(height: 1), SizedBox(height: 12)]);
      }
      out.add(items[i]);
    }
    return out;
  }

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _separer(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Entree extends StatelessWidget {
  final String titre;
  final String sous;
  final String periode;
  final List<String> points;
  final List<String> tags;

  const _Entree({
    required this.titre,
    required this.sous,
    this.periode = '',
    this.points = const [],
    this.tags = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(titre, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            if (periode.isNotEmpty)
              Text(periode,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 2),
        Text(sous, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
        if (points.isNotEmpty) ...[
          const SizedBox(height: 8),
          for (final p in points)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('•  $p', style: const TextStyle(height: 1.4)),
            ),
        ],
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [for (final t in tags) _Tag(t)],
          ),
        ],
      ],
    );
  }
}

class _Groupe extends StatelessWidget {
  final String label;
  final List<String> tags;

  const _Groupe({required this.label, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.textMuted, fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [for (final t in tags) _Tag(t)],
        ),
      ],
    );
  }
}

class _Ligne extends StatelessWidget {
  final String gauche;
  final String droite;

  const _Ligne({required this.gauche, required this.droite});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(gauche, style: const TextStyle(fontWeight: FontWeight.w500))),
        Text(droite, style: const TextStyle(color: AppColors.textMuted)),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;

  const _Tag(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}