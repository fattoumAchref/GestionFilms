import 'package:flutter/material.dart';
import 'package:gestionfilms/classes/film.dart';
import 'package:gestionfilms/services/filmService.dart';

class EditFilmForm extends StatefulWidget {
  final Film film;
  final String filmId;

  EditFilmForm({required this.film, required this.filmId});

  @override
  _EditFilmFormState createState() => _EditFilmFormState();
}

class _EditFilmFormState extends State<EditFilmForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController anneesortieController = TextEditingController();
  TextEditingController realisateurController = TextEditingController();
  TextEditingController dureeController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  final FilmService filmService =
      FilmService(baseUrl: 'http://192.168.1.3:3000/film');

  @override
  void initState() {
    super.initState();
    titleController.text = widget.film.title!;
    genreController.text = widget.film.genre!;
    anneesortieController.text = widget.film.year!;
    realisateurController.text = widget.film.realisateur!;
    dureeController.text = widget.film.duree!;
    noteController.text = widget.film.note!;
    descriptionController.text = widget.film.description!;
    imageController.text = widget.film.image.toString();
  }

  Future<void> updateFilm() async {
    final updatedData = {
      'title': titleController.text,
      'genre': genreController.text,
      'anneeSortie': anneesortieController.text,
      'realisateur': realisateurController.text,
      'duree': dureeController.text,
      'note': noteController.text,
      'description': descriptionController.text,
      'image': imageController.text
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content:
              Text('Are you sure you want to update the film information?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await filmService.updateFilm(widget.filmId, updatedData);
                  Navigator.pop(context);
                } catch (e) {
                  print('Error during update request: $e');
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.redAccent[700]),
          backgroundColor: Colors.black,
          title: Text(
            'Edit Films',
            style: TextStyle(color: Colors.redAccent[700]),
          ),
        ),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: genreController,
                  decoration: InputDecoration(
                    labelText: 'genre',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: anneesortieController,
                  decoration: InputDecoration(
                    labelText: 'Annnee Sortie',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: realisateurController,
                  decoration: InputDecoration(
                    labelText: 'Realisateur',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: dureeController,
                  decoration: InputDecoration(
                    labelText: 'Duree',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    labelText: 'Note',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: imageController,
                  decoration: InputDecoration(
                    labelText: 'image',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => updateFilm(),
                  child: Text('Mettre à jour'),
                ),
              ],
            ),
          ),
        ));
  }
}
