class ChatModel {
  int? id;
  String? batchId;
  String? batchName;
  String? senderId;
  String? receiverId;
  String? senderName;
  String? senderUserType;
  String? message;
  String? messageTime;
  String? senderProfilePhoto;
  String? receiverProfilePhoto;

  ChatModel({
    this.id,
    this.batchId,
    this.batchName,
    this.senderId,
    this.senderName,
    this.receiverId,
    this.senderUserType,
    this.message,
    this.messageTime,
    this.senderProfilePhoto,
    this.receiverProfilePhoto,
  });

// convenience constructor to create a Categories object
  ChatModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    batchId = map["batchId"];
    batchName = map["batchName"];
    senderId = map["senderId"];
    senderName = map["senderName"];
    receiverId = map["receiverId"];
    senderUserType = map["senderUserType"];
    message = map["message"];
    messageTime = map["messageTime"];
    senderProfilePhoto = map["senderProfilePhoto"];
    receiverProfilePhoto = map["receiverProfilePhoto"];
  }

// convenience method to create a Map from this Categories object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "id": id,
      "batchId": batchId,
      "batchName": batchName,
      "senderId": senderId,
      "senderName": senderName,
      "receiverId": receiverId,
      "senderUserType": senderUserType,
      "message": message,
      "messageTime": messageTime,
      "senderProfilePhoto": senderProfilePhoto,
      "receiverProfilePhoto": receiverProfilePhoto,
    };
    return map;
  }
}
