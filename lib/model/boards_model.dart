class BoardsModel {
  String? abbr;
  String? icon;
  String? id;
  String? boardName;
  String? detail;
  String? language;
  // bool isSelected;

  BoardsModel.fromJson(Map<String, dynamic> json)
      : abbr = json['abbr'],
        icon = json['icon'],
        id = json['boardID'],
        boardName = json['name'],
        detail = json['detail'],
        language = json['language'];
  // isSelected = false;

  // Map<String, dynamic> toJson() => {
  //   if (id != null) 'id': id,
  //   if (name != null) 'name': name,
  //   if (description != null) 'description': description,
  //   if (alreadySelected != null) 'alreadySelected': alreadySelected,
  // };

  BoardsModel({
    this.abbr,
    this.icon,
    this.id,
    this.boardName,
    this.detail,
    this.language,
    // this.isSelected = false,
  });
}
