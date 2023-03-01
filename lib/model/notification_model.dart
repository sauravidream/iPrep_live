class NotificationModel {
  String? title;
  String? message;
  String? messageTime;

  // NotificationModel.fromJson(Map<String, dynamic> json)
  //     : classID = json['classID'],
  //       className = json['className'],
  //       boardName = json['boardName'];
  //
  // Map<String, dynamic> toJson() => {
  //   if (classID != null) 'classID': classID,
  //   if (className != null) 'className': className,
  //   if (boardName != null) 'boardName': boardName,
  // };

  NotificationModel({
    this.title,
    this.message,
    this.messageTime,
  });
}
