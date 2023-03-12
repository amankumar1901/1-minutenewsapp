// To parse this JSON data, do
//
//     final favouriteModel = favouriteModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

FavouriteModel favouriteModelFromJson(String str) =>
    FavouriteModel.fromJson(json.decode(str));

String favouriteModelToJson(FavouriteModel data) => json.encode(data.toJson());

class FavouriteModel {
  FavouriteModel({
    required this.name,
    required this.userfav,
    required this.pwd,
    required this.email,
  });

  String name;
  List<Userfav> userfav;
  String pwd;
  String email;

  FavouriteModel copyWith({
    String? name,
    List<Userfav>? userfav,
    String? pwd,
    String? email,
  }) =>
      FavouriteModel(
        name: name ?? this.name,
        userfav: userfav ?? this.userfav,
        pwd: pwd ?? this.pwd,
        email: email ?? this.email,
      );

  factory FavouriteModel.fromJson(Map<String, dynamic> json) => FavouriteModel(
        name: json["name"],
        userfav:
            List<Userfav>.from(json["userfav"].map((x) => Userfav.fromJson(x))),
        pwd: json["pwd"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "userfav": List<dynamic>.from(userfav.map((x) => x.toJson())),
        "pwd": pwd,
        "email": email,
      };
}

class Userfav {
  Userfav({
    required this.newsurl,
    required this.title,
  });

  String newsurl;
  String title;

  Userfav copyWith({
    String? newsurl,
    String? title,
  }) =>
      Userfav(
        newsurl: newsurl ?? this.newsurl,
        title: title ?? this.title,
      );

  factory Userfav.fromJson(Map<String, dynamic> json) => Userfav(
        newsurl: json["newsurl"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "newsurl": newsurl,
        "title": title,
      };
}
