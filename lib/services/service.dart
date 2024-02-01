import 'dart:convert';
import 'package:http/http.dart' as http;

class Service {
  static const String apiUrlU = 'http://192.168.1.3:3000/user';
  static const String apiUrlF = 'http://192.168.1.3:3000/film';
  static String? _token;
  static String? _userName;
  static String? _userEmail;

  static Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrlU/login'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        _token = responseData['mytoken'];
        _userName = responseData['firstname'];
        _userEmail = responseData['email'];

        print('Building widget: $_userName, $_userEmail');

        return _token;
      } else {
        throw Exception('Échec de la connexion');
      }
    } catch (e) {
      print('Erreur lors de la connexion: $e');
      return null;
    }
  }

  // Méthodes pour obtenir le token et les informations utilisateur
  static String? getToken() => _token;
  static String? getUserName() => _userName;
  static String? getUserEmail() => _userEmail;

  /*
  static Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrlU/login'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String _token = responseData['mytoken'];
        return _token;
      } else {
        throw Exception('Échec de la connexion');
      }
    } catch (e) {
      print('Erreur lors de la connexion: $e');
      return null;
    }
  }
*/

  static void logout() {
    return _token = null;
  }

  static Future<void> register({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrlU/register'),
        body: jsonEncode({
          'firstname': firstname,
          'lastname': lastname,
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Enregistrement réussi
        print('Enregistrement réussi');
        // Vous pouvez gérer la suite en fonction de vos besoins, par exemple, navigation vers une nouvelle page.
      } else {
        // Gestion de l'échec de l'enregistrement
        print('Échec de l\'enregistrement');
        print(response.body);
      }
    } catch (e) {
      print('Erreur lors de l\'enregistrement: $e');
    }
  }
}
