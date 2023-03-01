class StreamsModel {
  String? boardName;
  String? classID;
  String? streamID;
  String? streamName;
  String? icon;

  StreamsModel.fromJson(Map<String, dynamic> json)
      : boardName = json['boardName'],
        classID = json['classID'],
        streamID = json['streamID'],
        streamName = json['streamName'],
        icon = json['icon'];

  // Map<String, dynamic> toJson() => {
  //   if (id != null) 'id': id,
  //   if (name != null) 'name': name,
  //   if (description != null) 'description': description,
  //   if (alreadySelected != null) 'alreadySelected': alreadySelected,
  // };

  StreamsModel({
    this.boardName,
    this.classID,
    this.streamID,
    this.streamName,
    this.icon,
  });
}
