class NotesModel {
  int? id;
  String? boardID;
  String? classID;
  String? language;
  String? subjectName;
  String? chapterName;
  String? noteDetails;
  String? noteID;
  String? noteName;
  String? noteOfflineLink;
  String? noteOfflineThumbnail;
  String? noteOnlineLink;
  String? noteThumbnail;
  String? noteTopicName;

  NotesModel({
    this.id,
    this.boardID,
    this.classID,
    this.language,
    this.subjectName,
    this.chapterName,
    this.noteDetails,
    this.noteID,
    this.noteName,
    this.noteOfflineLink,
    this.noteOfflineThumbnail,
    this.noteOnlineLink,
    this.noteThumbnail,
    this.noteTopicName,
  });

  // convenience constructor to create a Categories object
  NotesModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    boardID = map["boardID"];
    classID = map["classID"];
    language = map["language"];
    subjectName = map["subjectName"];
    chapterName = map["chapterName"];
    noteDetails = map["noteDetails"];
    noteID = map["noteID"];
    noteName = map["noteName"];
    noteOfflineLink = map["noteOfflineLink"];
    noteOfflineThumbnail = map["noteOfflineThumbnail"];
    noteOnlineLink = map["noteOnlineLink"];
    noteThumbnail = map["noteThumbnail"];
    noteTopicName = map["noteTopicName"];
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (boardID != null) 'boardID': boardID,
        if (classID != null) 'classID': classID,
        if (language != null) 'language': language,
        if (subjectName != null) 'subjectName': subjectName,
        if (chapterName != null) 'chapterName': chapterName,
        if (noteDetails != null) 'bookDetails': noteDetails,
        if (noteID != null) 'bookID': noteID,
        if (noteName != null) 'bookName': noteName,
        if (noteOfflineLink != null) 'bookOfflineLink': noteOfflineLink,
        if (noteOfflineThumbnail != null)
          'bookOfflineThumbnail': noteOfflineThumbnail,
        if (noteOnlineLink != null) 'bookOnlineLink': noteOnlineLink,
        if (noteThumbnail != null) 'bookThumbnail': noteThumbnail,
        if (noteTopicName != null) 'bookTopicName': noteTopicName,
      };

  // convenience method to create a Map from this Categories object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "id": id,
      "boardID": boardID ?? "",
      "classID": classID ?? "",
      "language": language ?? "",
      "subjectName": subjectName ?? "",
      "chapterName": chapterName ?? "",
      "bookDetails": noteDetails ?? "",
      "bookID": noteID ?? "",
      "bookName": noteName ?? "",
      "bookOfflineLink": noteOfflineLink ?? "",
      "bookOfflineThumbnail": noteOfflineThumbnail ?? "",
      "bookOnlineLink": noteOnlineLink ?? "",
      "bookThumbnail": noteThumbnail ?? "",
      "bookTopicName": noteTopicName ?? "",
    };
    return map;
  }
}
