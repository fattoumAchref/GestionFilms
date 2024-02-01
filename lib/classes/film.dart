class Film {
  String? id;
  String? title;
  String? genre;
  String? year;
  String? realisateur;
  String? duree;
  String? note;
  String? description;
  String? image;

  Film(
      {required this.id,
      required this.title,
      required this.genre,
      required this.year,
      required this.realisateur,
      required this.description,
      required this.duree,
      required this.note,
      required this.image});

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
        id: json['_id'],
        title: json['title'],
        genre: json['genre'],
        year: json['anneeSortie'],
        realisateur: json['realisateur'],
        duree: json['duree'],
        note: json['note'],
        description: json['description'],
        image: json['image']);
  }
}
