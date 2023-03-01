// To parse this JSON data, do
//
//     final videoModel = videoModelFromJson(jsonString);

import 'dart:convert';

VideoModel videoModelFromJson(String str) =>
    VideoModel.fromJson(json.decode(str));

String videoModelToJson(VideoModel data) => json.encode(data.toJson());

class VideoModel {
  VideoModel({
    this.videos,
  });

  Map<String, Video>? videos;

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
        videos: Map.from(json["videos"])
            .map((k, v) => MapEntry<String, Video>(k, Video.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "videos": Map.from(videos!)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class Video {
  Video({
    this.name,
    this.onlineLink,
    this.thumbnail,
    this.totalDuration,
    this.videoid,
  });

  String? name;
  String? onlineLink;
  String? thumbnail;
  int? totalDuration;
  String? videoid;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        name: json["name"],
        onlineLink: json["onlineLink"],
        thumbnail: json["thumbnail"],
        totalDuration: json["total_duration"],
        videoid: json["videoid"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "onlineLink": onlineLink,
        "thumbnail": thumbnail,
        "total_duration": totalDuration,
        "videoid": videoid,
      };
}
