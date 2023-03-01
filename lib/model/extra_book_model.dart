class ExtraBookModel {
  String? subjectID;
  String? subjectName;
  List<ExtraBooks>? bookList;

  ExtraBookModel.fromJson(Map<String, dynamic> json)
      : subjectID = json['subjectID'],
        subjectName = null,
        bookList = null;

  ExtraBookModel({
    this.subjectID,
    this.subjectName,
    this.bookList,
  });
}

class ExtraBooks {
  String? bookName;
  List<Topics>? topics;

  ExtraBooks.fromJson(Map<String, dynamic> json)
      : bookName = json['name'],
        topics = null;

  ExtraBooks({
    this.bookName,
    this.topics,
  });
}

class Topics {
  String? detail;
  String? id;
  String? name;
  String? offlineLink;
  String? offlineThumbnail;
  String? onlineLink;
  String? thumbnail;
  String? topicName;

  Topics.fromMap(Map<String, dynamic> map) {
    detail = map["detail"];
    id = map["id"];
    name = map["name"];
    offlineLink = map["offlineLink"];
    offlineThumbnail = map["offlineThumbnail"];
    onlineLink = map["onlineLink"];
    thumbnail = map["thumbnail"];
    topicName = map["topicName"];
  }

  Map<String, dynamic> toJson() => {
        if (detail != null) 'detail': detail,
        if (id != null) 'id': id,
        if (name != null) 'name': name,
        if (offlineLink != null) 'offlineLink': offlineLink,
        if (offlineThumbnail != null) 'offlineThumbnail': offlineThumbnail,
        if (onlineLink != null) 'onlineLink': onlineLink,
        if (thumbnail != null) 'thumbnail': thumbnail,
        if (topicName != null) 'topicName': topicName
      };

  Topics({
    this.detail,
    this.id,
    this.name,
    this.offlineLink,
    this.offlineThumbnail,
    this.onlineLink,
    this.thumbnail,
    this.topicName,
  });
}
