class MembreFamille {
  final int? id;
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance; // format AAAA-MM-JJ
  final String parente;

  const MembreFamille({
    this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
  });

  factory MembreFamille.fromJson(Map<String, dynamic> json) {
    final date = json['date_naissance']?.toString() ?? '';
    return MembreFamille(
      id: int.tryParse('${json['id']}'),
      nom: json['nom']?.toString() ?? '',
      postnom: json['postnom']?.toString() ?? '',
      prenom: json['prenom']?.toString() ?? '',
      lieuNaissance: json['lieu_naissance']?.toString() ?? '',
      dateNaissance: date.length >= 10 ? date.substring(0, 10) : date,
      parente: json['parente']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'nom': nom,
        'postnom': postnom,
        'prenom': prenom,
        'lieu_naissance': lieuNaissance,
        'date_naissance': dateNaissance,
        'parente': parente,
      };

  String get nomComplet =>
      '$prenom $nom $postnom'.replaceAll(RegExp(r'\s+'), ' ').trim();

  String get initiales => [prenom, nom]
      .where((s) => s.isNotEmpty)
      .map((s) => s[0].toUpperCase())
      .take(2)
      .join();
}