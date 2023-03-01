class VideoLessonModel {
  String? detail;
  String? id;
  String? name;
  String? offlineLink;
  String? offlineThumbnail;
  String? onlineLink;
  String? thumbnail;
  String? topicName;
  String? videoCurrentProgress;
  int? videoTotalDuration;

  VideoLessonModel.fromJson(Map<String, dynamic> json)
      : detail = json['videoDetail'],
        id = json['videoID'].toString(),
        name = json['videoName'],
        offlineLink = json['videoOfflineLink'],
        offlineThumbnail = json['videoOfflineThumbnail'],
        onlineLink = json['videoOnlineLink'],
        thumbnail = json['videoThumbnail'],
        topicName = json['videoTopicName'],
        videoCurrentProgress = json['videoCurrentProgress'],
        videoTotalDuration = json['videoTotalDuration'];

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (name != null) 'name': name,
        if (detail != null) 'detail': detail,
        if (onlineLink != null) 'onlineLink': onlineLink,
        if (thumbnail != null) 'thumbnail': thumbnail,
        if (topicName != null) 'topicName': topicName,
      };

  VideoLessonModel({
    this.detail,
    this.id,
    this.name,
    this.offlineLink,
    this.offlineThumbnail,
    this.onlineLink,
    this.thumbnail,
    this.topicName,
    this.videoCurrentProgress,
    this.videoTotalDuration,
  });
}
