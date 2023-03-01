import 'dart:convert';

class AppLanguage {
  // String abbr;
  // String icon;
  // String id;
  String? languageName;
  // String boardName;
  bool isSelected;

  // AppLanguage.fromJson(Map<String, dynamic> json)
  //     : abbr = json['abbr'],
  //       icon = json['icon'],
  //       id = json['id'],
  //       languageName = json['languageName'],
  //       boardName = json['name'];
  // isSelected = false;

  // Map<String, dynamic> toJson() => {
  //   if (id != null) 'id': id,
  //   if (name != null) 'name': name,
  //   if (description != null) 'description': description,
  //   if (alreadySelected != null) 'alreadySelected': alreadySelected,
  // };

  AppLanguage({
    // this.abbr,
    // this.icon,
    // this.id,
    this.languageName,
    // this.boardName,
    this.isSelected = false,
  });
}

// To parse this JSON data, do
//
//     final languageModel = languageModelFromJson(jsonString);

LanguageModel languageModelFromJson(String str) =>
    LanguageModel.fromJson(json.decode(str));

String languageModelToJson(LanguageModel data) => json.encode(data.toJson());

class LanguageModel {
  LanguageModel({
    this.language,
  });

  List<Language>? language;

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
        language: List<Language>.from(
            json["language"].map((x) => Language.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "language": List<dynamic>.from(language!.map((x) => x.toJson())),
      };
}

class Language {
  Language({
    this.color,
    this.icon,
    this.id,
    this.name,
    this.shortName,
  });

  String? color;
  String? icon;
  String? id;
  String? name;
  String? shortName;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        color: json["color"],
        icon: json["icon"],
        id: json["id"],
        name: json["name"],
        shortName: json["short_name"],
      );

  Map<String, dynamic> toJson() => {
        "color": color,
        "icon": icon,
        "id": id,
        "name": name,
        "short_name": shortName,
      };
}
