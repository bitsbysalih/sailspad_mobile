// ignore_for_file: public_member_api_docs, sort_constructors_first
class ArCard {
  String? id;
  String? cardImage;
  String? name;
  String? title;
  String? about;
  String? email;
  String? uniqueId;
  String? shortName;
  String? logoImage;
  String? backgroundImage;
  List? links;
  Map? marker;

  ArCard({
    this.id,
    this.name,
    this.title,
    this.about,
    this.email,
    this.links,
    this.marker,
    this.backgroundImage,
    this.logoImage,
    this.cardImage,
    this.shortName,
    this.uniqueId,
  });

  ArCard.fromJson(dynamic data) {
    id = data['id'];
    cardImage = data['cardImage'];
    name = data['name'];
    title = data['title'];
    about = data['about'];
    email = data['email'];
    uniqueId = data['uniqueId'];
    shortName = data['shortName'];
    logoImage = data['logoImage'];
    backgroundImage = data['backgroundImage'];
    links = data['links'];
    marker = data['marker'];
  }

  toJson() => {
        "id": id,
        "cardImage": cardImage,
        "name": name,
        'title': title,
        'about': about,
        'email': email,
        'uniqueId': uniqueId,
        'shortName': shortName,
        'logoImage': logoImage,
        'backgroundImage': backgroundImage,
        'links': links,
        'marker': marker,
      };
}
