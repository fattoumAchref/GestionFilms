import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gestionfilms/classes/film.dart';
import 'package:gestionfilms/services/filmService.dart';
import 'package:gestionfilms/services/filmhomeService.dart';
import 'package:gestionfilms/services/service.dart';

class accueil extends StatefulWidget {
  accueil({Key? key}) : super(key: key);

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<accueil> {
  bool isDarkMode = false;

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform logout action here
                Service.logout();
                Navigator.pushNamed(context, '/');
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void movieAdded(BuildContext buildContext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Movie Added'),
          content: Text('The movie has been added to your watchlist.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  FilmhomeService filmhomeService =
      FilmhomeService(baseUrl: 'http://192.168.1.3:3000/filmhome');
  FilmService filmService =
      FilmService(baseUrl: 'http://192.168.1.3:3000/film');
  List<Film> films = [];
  List<Film> filteredFilms = [];
  TextEditingController _searchController = TextEditingController();

  // List of available genres
  List<String> genres = [
    "TV Dramas",
    "Crime",
    "Medical TV",
    "TV Shows",
    "TV Mysteries",
    "TV Reality"
  ];
  String selectedGenre = ""; // Currently selected genre

  @override
  void initState() {
    super.initState();
    // Initialize both lists with the same data
    filmhomeService.fetchAllFilms().then((value) {
      setState(() {
        films = value;
        filteredFilms = films;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
        home: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.redAccent[700]),
            backgroundColor: Colors.black,
            title: Text(
              "Home",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent[700],
              ),
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
            ],
          ),
          drawer: Drawer(
            backgroundColor: Colors.redAccent[700],
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.redAccent[700]),
                  accountName: Text(Service.getUserName().toString()),
                  accountEmail: Text(Service.getUserEmail().toString()),
                ),
                ListTile(
                  title: Text('My movies'),
                  leading: Icon(Icons.movie),
                  onTap: () {
                    Navigator.pushNamed(context, '/listefilm');
                  },
                ),
                ListTile(
                  title: Text('Logout'),
                  leading: Icon(Icons.logout),
                  onTap: () {
                    showLogoutConfirmationDialog(context);
                  },
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              SingleChildScrollView(
                child: Container(
                  height: 50,
                  child: Column(children: [
                    /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    for (int i = 0; i < 3; i++)
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _filterFilmsByGenre(genres[i]);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: selectedGenre == genres[i]
                                ? Colors.redAccent[700]
                                : Colors.grey,
                          ),
                          child: Text(
                            genres[i],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 3; i < genres.length; i++)
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: ElevatedButton(
                              onPressed: () {
                                _filterFilmsByGenre(genres[i]);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: selectedGenre == genres[i]
                                    ? Colors.redAccent[700]
                                    : Colors.grey,
                              ),
                              child: Text(
                                genres[i],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ]),
                ),
              ),
              // Add a search bar
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    _filterFilms(_searchController.text);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey,
                    hintText: 'Search by title',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();

                        _filterFilms('');
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredFilms.length,
                  itemBuilder: (context, index) {
                    final film = filteredFilms[index];
                    return Card(
                      elevation: 5,
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: Card(
                          child: Column(
                            children: [
                              // Image (replace 'Image.network' with your image widget)
                              Image.network(
                                'https://images.unsplash.com/photo-1627873649417-c67f701f1949?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              // Content of the Card
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
                                    // Genre
                                    Text(
                                      'Genre: ${film.genre}',
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    // Description
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
                            caption: 'Add',
                            color: Colors.redAccent[700],
                            icon: Icons.add,
                            onTap: () {
                              filmService.insertFilm(
                                title: film.title!,
                                genre: film.genre!,
                                anneeSortie: film.year!,
                                realisateur: film.realisateur!,
                                duree: film.duree!,
                                note: film.note!,
                                description: film.description!,
                                image: '',
                              );
                              movieAdded(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }

  void _filterFilms(String title) {
    setState(() {
      filteredFilms = _filterFilmsByTitle(title);
    });
  }

  List<Film> _filterFilmsByTitle(String title) {
    if (title.isEmpty) {
      return films; // Return the complete list if the title is empty
    } else {
      return films
          .where((film) =>
              (film.title?.toLowerCase() ?? '').contains(title.toLowerCase()))
          .toList();
    }
  }

  void _filterFilmsByGenre(String genre) {
    setState(() {
      // Update the selected genre and filter films accordingly
      selectedGenre = genre;
      if (genre.isEmpty) {
        // Show all films if the genre is empty
        filteredFilms = films;
      } else {
        // Show only films with the selected genre
        filteredFilms = films
            .where((film) =>
                (film.genre?.toLowerCase() ?? '').contains(genre.toLowerCase()))
            .toList();
      }
    });
  }
}
