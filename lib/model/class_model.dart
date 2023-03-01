class ClassStandard {
  String? icon;
  String? classID;
  String? className;
  String? boardName;
  String? language;

  ClassStandard.fromJson(Map<String, dynamic> json)
      : classID = json['classID'],
        className = json['className'],
        boardName = json['boardName'];

  Map<String, dynamic> toJson() => {
        if (classID != null) 'classID': classID,
        if (className != null) 'className': className,
        if (boardName != null) 'boardName': boardName,
      };

  ClassStandard({
    this.icon,
    this.classID,
    this.className,
    this.boardName,
    this.language,
  });
}