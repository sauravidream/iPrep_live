class BooksModel {
  int? id;
  String? boardID;
  String? classID;
  String? language;
  String? subjectName;
  String? chapterName;
  String? bookDetails;
  String? bookID;
  String? bookName;
  String? bookOfflineLink;
  String? bookOfflineThumbnail;
  String? bookOnlineLink;
  String? bookThumbnail;
  String? bookTopicName;

  BooksModel({
    this.id,
    this.boardID,
    this.classID,
    this.language,
    this.subjectName,
    this.chapterName,
    this.bookDetails,
    this.bookID,
    this.bookName,
    this.bookOfflineLink,
    this.bookOfflineThumbnail,
    this.bookOnlineLink,
    this.bookThumbnail,
    this.bookTopicName,
  });

  // convenience constructor to create a Categories object
  BooksModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    boardID = map["boardID"];
    classID = map["classID"];
    language = map["language"];
    subjectName = map["subjectName"];
    chapterName = map["chapterName"];
    bookDetails = map["bookDetails"];
    bookID = map["bookID"];
    bookName = map["bookName"];
    bookOfflineLink = map["bookOfflineLink"];
    bookOfflineThumbnail = map["bookOfflineThumbnail"];
    bookOnlineLink = map["bookOnlineLink"];
    bookThumbnail = map["bookThumbnail"];
    bookTopicName = map["bookTopicName"];
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (boardID != null) 'boardID': boardID,
        if (classID != null) 'classID': classID,
        if (language != null) 'language': language,
        if (subjectName != null) 'subjectName': subjectName,
        if (chapterName != null) 'chapterName': chapterName,
        if (bookDetails != null) 'bookDetails': bookDetails,
        if (bookID != null) 'bookID': bookID,
        if (bookName != null) 'bookName': bookName,
        if (bookOfflineLink != null) 'bookOfflineLink': bookOfflineLink,
        if (bookOfflineThumbnail != null)
          'bookOfflineThumbnail': bookOfflineThumbnail,
        if (bookOnlineLink != null) 'bookOnlineLink': bookOnlineLink,
        if (bookThumbnail != null) 'bookThumbnail': bookThumbnail,
        if (bookTopicName != null) 'bookTopicName': bookTopicName,
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
      "bookDetails": bookDetails ?? "",
      "bookID": bookID ?? "",
      "bookName": bookName ?? "",
      "bookOfflineLink": bookOfflineLink ?? "",
      "bookOfflineThumbnail": bookOfflineThumbnail ?? "",
      "bookOnlineLink": bookOnlineLink ?? "",
      "bookThumbnail": bookThumbnail ?? "",
      "bookTopicName": bookTopicName ?? "",
    };
    return map;
  }
}
