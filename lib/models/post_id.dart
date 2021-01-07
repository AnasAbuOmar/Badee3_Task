import 'dart:convert';

class PostsId {
  PostsId({
    this.owner,
    this.id,
    this.image,
    this.publishDate,
    this.text,
    this.tags,
    this.link,
    this.likes,
  });

  Owner owner;
  String id;
  String image;
  DateTime publishDate;
  String text;
  List<String> tags;
  String link;
  int likes;

  factory PostsId.fromJson(String str) => PostsId.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PostsId.fromMap(Map<String, dynamic> json) => PostsId(
        owner: json["owner"] == null ? null : Owner.fromMap(json["owner"]),
        id: json["id"] == null ? null : json["id"],
        image: json["image"] == null ? null : json["image"],
        publishDate: json["publishDate"] == null
            ? null
            : DateTime.parse(json["publishDate"]),
        text: json["text"] == null ? null : json["text"],
        tags: json["tags"] == null
            ? null
            : List<String>.from(json["tags"].map((x) => x)),
        link: json["link"] == null ? null : json["link"],
        likes: json["likes"] == null ? null : json["likes"],
      );

  Map<String, dynamic> toMap() => {
        "owner": owner == null ? null : owner.toMap(),
        "id": id == null ? null : id,
        "image": image == null ? null : image,
        "publishDate":
            publishDate == null ? null : publishDate.toIso8601String(),
        "text": text == null ? null : text,
        "tags": tags == null ? null : List<dynamic>.from(tags.map((x) => x)),
        "link": link == null ? null : link,
        "likes": likes == null ? null : likes,
      };
}

class Owner {
  Owner({
    this.id,
    this.email,
    this.title,
    this.picture,
    this.firstName,
    this.lastName,
  });

  String id;
  String email;
  String title;
  String picture;
  String firstName;
  String lastName;

  factory Owner.fromJson(String str) => Owner.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Owner.fromMap(Map<String, dynamic> json) => Owner(
        id: json["id"] == null ? null : json["id"],
        email: json["email"] == null ? null : json["email"],
        title: json["title"] == null ? null : json["title"],
        picture: json["picture"] == null ? null : json["picture"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "email": email == null ? null : email,
        "title": title == null ? null : title,
        "picture": picture == null ? null : picture,
        "firstName": firstName == null ? null : firstName,
        "lastName": lastName == null ? null : lastName,
      };
}
