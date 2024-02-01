import 'package:flutter/material.dart';
import 'package:gestionfilms/classes/film.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:gestionfilms/services/filmService.dart';
import 'package:gestionfilms/widgets/editFilmForm.dart';

class FilmList extends StatefulWidget {
  FilmList({
    super.key,
  });

  @override
  _FilmListState createState() => _FilmListState();
}

class _FilmListState extends State<FilmList> {
  bool isDarkMode = false;
  @override
  void initState() {
    super.initState();
  }

  List<Film> films = [];
  FilmService filmService =
      FilmService(baseUrl: 'http://192.168.1.3:3000/film');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.redAccent[700]),
            backgroundColor: Colors.black,
            title: Text(
              'My Movies',
              style: TextStyle(color: Colors.redAccent[700]),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
            ),
            actions: [
              Switch(
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
              ),
              SizedBox(
                width: 10,
              )
            ]),
        body: FutureBuilder<List<Film>>(
          future: filmService.fetchAllFilms(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Erreur: ${snapshot.error}');
            } else {
              List<Film> films = snapshot.data!;
              return ListView.builder(
                itemCount: films.length,
                itemBuilder: (context, index) {
                  final film = films[index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title
                                  Text(
                                    '${film.title}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Genre: ${film.genre}',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Description: ${film.description}',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      secondaryActions: [
                        IconSlideAction(
                          caption: 'Edit',
                          color: Colors.redAccent[700],
                          icon: Icons.edit,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditFilmForm(
                                  film: film,
                                  filmId: film.id.toString(),
                                ),
                              ),
                            ).then((updatedFilm) {
                              if (updatedFilm != null) {
                                setState(() {
                                  film.title = updatedFilm.title;
                                  film.genre = updatedFilm.genre;
                                });
                              }
                            });
                          },
                        ),
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.redAccent[700],
                          icon: Icons.delete,
                          onTap: () async {
                            bool confirmDelete = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Delete Film'),
                                  content: Text(
                                      'Are you sure you want to delete this Film?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmDelete == true) {
                              try {
                                await filmService.deleteFilm(film.id!);
                                setState(() {
                                  films.removeAt(index);
                                });
                              } catch (e) {
                                print('Error deleting patient: $e');
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.redAccent[700],
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/ajoutFilm');
            }),
      ),
    );
  }
}
