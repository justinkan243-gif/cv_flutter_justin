import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/membre_famille.dart';

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  static const _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  static const _delai = Duration(seconds: 10);

  Future<http.Response> _envoyer(Future<http.Response> Function() requete) async {
    try {
      return await requete().timeout(_delai);
    } catch (_) {
      throw const ApiException(
          "Serveur injoignable. Vérifiez qu'Apache et MySQL sont démarrés dans XAMPP.");
    }
  }

  Map<String, dynamic> _lire(http.Response res) {
    try {
      final corps = jsonDecode(res.body);
      if (corps is Map<String, dynamic>) return corps;
    } catch (_) {}
    throw ApiException('Réponse inattendue du serveur (HTTP ${res.statusCode}).');
  }

  void _verifier(http.Response res, Map<String, dynamic> corps, String messageDefaut) {
    final ok = res.statusCode >= 200 && res.statusCode < 300 && corps['success'] == true;
    if (!ok) throw ApiException(corps['message']?.toString() ?? messageDefaut);
  }

  /// Vérifie les identifiants auprès de l'API.
  Future<void> seConnecter(String email, String motDePasse) async {
    final res = await _envoyer(() => http.post(
          Uri.parse('$apiBaseUrl/accounts/login'),
          headers: _headers,
          body: jsonEncode({'email': email, 'password': motDePasse}),
        ));
    _verifier(res, _lire(res), 'Identifiants incorrects.');
  }

  Future<List<MembreFamille>> getFamilyMembers() async {
    final res = await _envoyer(() => http.get(
          Uri.parse('$apiBaseUrl/famille-membres'),
          headers: _headers,
        ));
    final corps = _lire(res);
    _verifier(res, corps, 'Impossible de charger les membres.');
    final data = corps['data'] as List<dynamic>? ?? const [];
    return data.map((e) => MembreFamille.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> ajouterMembre(MembreFamille membre) async {
    final res = await _envoyer(() => http.post(
          Uri.parse('$apiBaseUrl/famille-membres'),
          headers: _headers,
          body: jsonEncode(membre.toJson()),
        ));
    _verifier(res, _lire(res), "Impossible d'ajouter ce membre.");
  }

  Future<void> modifierMembre(int id, MembreFamille membre) async {
    final res = await _envoyer(() => http.put(
          Uri.parse('$apiBaseUrl/famille-membres/$id'),
          headers: _headers,
          body: jsonEncode(membre.toJson()),
        ));
    _verifier(res, _lire(res), 'Impossible de modifier ce membre.');
  }

  Future<void> supprimerMembre(int id) async {
    final res = await _envoyer(() => http.delete(
          Uri.parse('$apiBaseUrl/famille-membres/$id'),
          headers: _headers,
        ));
    if (res.statusCode >= 300) {
      throw ApiException('Suppression impossible (HTTP ${res.statusCode}).');
    }
  }
}