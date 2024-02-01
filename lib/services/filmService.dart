import 'dart:convert';
import 'package:gestionfilms/classes/film.dart';
import 'package:http/http.dart' as http;

class FilmService {
  final String? baseUrl;
  FilmService({required this.baseUrl});
  Future<void> insertFilm(
      {required String title,
      required String genre,
      required String anneeSortie,
      required String realisateur,
      required String duree,
      required String note,
      required String description,
      required String image}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/createfilm'),
        body: jsonEncode({
          'title': title,
          'genre': genre,
          'anneeSortie': anneeSortie,
          'realisateur': realisateur,
          'duree': duree,
          'note': note,
          'description': description,
          'image': image
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Enregistrement réussi');
      } else {
        print('Échec de l\'enregistrement');
        print(response.body);
      }
    } catch (e) {
      print('Erreur lors de la connexion: $e');
    }
  }

  Future<List<Film>> fetchAllFilms() async {
    final response = await http.get(Uri.parse('$baseUrl/fetchAll'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Film> films = data.map((json) => Film.fromJson(json)).toList();

      return films;
    } else {
      throw Exception('Failed to fetch films');
    }
  }

  Future<void> deleteFilm(String id) async {
    print("'Deleting film with ID: $id'");
    final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));

    if (response.statusCode == 200) {
      // Patient deleted successfully
    } else {
      print('Failed to delete film. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to delete film');
    }
  }

  Future<void> updateFilm(String id, Map<String, dynamic> updatedData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
      } else {
        throw Exception('Failed to update film');
      }
    } catch (e) {
      print('Error during update request: $e');
      throw Exception('Failed to update film');
    }
  }
}
