class SubjectModel {
  String? boardName;
  String? classID;
  String? subjectID;
  String? subjectName;
  String? subjectIconPath;
  String? subjectColor;
  String? language;
  String? shortName;

  SubjectModel.fromJson(Map<String, dynamic> json)
      : boardName = json['boardName'],
        classID = json['classID'],
        subjectID = json['subjectID'],
        subjectName = json['subjectName'],
        subjectIconPath = json['subjectIconPath'],
        subjectColor = json['subjectColor'],
        language = json['language'],
        shortName = json['shortName'];

  Map<String, dynamic> toJson() => {
        if (boardName != null) 'boardName': boardName,
        if (classID != null) 'classID': classID,
        if (subjectID != null) 'subjectID': subjectID,
        if (subjectName != null) 'subjectName': subjectName,
        if (subjectIconPath != null) 'subjectIconPath': subjectIconPath,
        if (subjectColor != null) 'subjectColor': subjectColor,
        if (language != null) 'language': language,
        if (shortName != null) 'shortName': shortName,
      };

  SubjectModel({
    this.boardName,
    this.classID,
    this.subjectID,
    this.subjectName,
    this.subjectIconPath,
    this.subjectColor,
    this.language,
    this.shortName,
  });
}
