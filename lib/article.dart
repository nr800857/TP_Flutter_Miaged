class Article {
  String nom;
  String marque;
  String image;
  double prix;
  String taille;
  String type;
  String id;
  String userID;

  Article(this.nom, this.marque, this.image, this.prix, this.taille, this.type, this.id, this.userID);

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'marque': marque,
      'image': image,
      'prix': prix,
      'taille': taille,
      'type': type,
      'id': id,
      'userID': userID,
    };
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      json['nom'],
      json['marque'],
      json['image'],
      json['prix'],
      json['taille'],
      json['type'],
      json['id'],
      json['userID'],);
  }
}
