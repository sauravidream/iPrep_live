import 'package:flutter/foundation.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/video_lesson.dart';

class StemVideoRepository {
  Future saveUsersStemVideoWatchingData(
    String? subjectName, {
    int? duration,
    DateTime? videoStartTime,
    required String subjectID,
    required VideoLessonModel videoLesson,
    int? videoTotalDuration,
    String? batchId,
    String? assignmentId,
    String? assignmentIndex,
    String? teacherId,
    String? boardID, //Change for saving assignment's progress
    String? classID, //Change for saving assignment's progress
    String? language, //Change for saving assignment's progress
  }) async {
    try {
      String? _stream;
      String? _userID = await (getStringValuesSF("userID"));
      String? _educationBoard =
          boardID ?? (await getStringValuesSF("educationBoard"))!.toLowerCase();
      String? _language =
          language ?? (await getStringValuesSF("language"))!.toLowerCase();
      String? _classNumber = classID;
      if (_classNumber == null) {
        _classNumber = await getStringValuesSF("classNumber");
        if ((int.parse(_classNumber!)) > 10) {
          _stream = await getStringValuesSF("stream"); //2
          _classNumber = _classNumber + "_" + _stream!;
        } else {
          _classNumber = _classNumber;
        }
      }
      if (videoLesson.topicName!.contains("/")) {
        videoLesson.topicName = videoLesson.topicName!.replaceAll('/', "-");
      }

      await dbRef
          .child("reports")
          .child("app_reports")
          .child(_userID!)
          .child("data")
          .child(_classNumber)
          .child(_educationBoard)
          .child(_language)
          .child('stem_videos')
          .child(subjectID)
          .child(videoLesson.topicName!)
          .child(videoLesson.name!)
          .push()
          .set({
        "subject_id": subjectID,
        "updated_time": DateTime.now().toUtc().toString(),
        "video_id": videoLesson.id,
        "video_url": videoLesson.onlineLink,
        "video_total_duration": videoTotalDuration.toString(),
        "video_name": videoLesson.name,
        "topic_name": videoLesson.topicName,
        "duration": duration.toString(),
        "subject_name": subjectName,
        'user_name': appUser!.fullName,
        'class_name': _classNumber,
      }).then((_) async {
        debugPrint("Saved Stem Videos Data successfully");

        await myReportsRepository.saveOverallAppUses(
            subjectID: subjectID,
            categoryName: "stem_videos",
            className: _classNumber,
            userId: _userID,
            boardName: _educationBoard,
            language: _language,
            appUsesDuration: duration.toString());
        if (batchId != null) {
          await assignmentTrackingRepository.trackAssignedStemVideos(
            batchId: batchId,
            teacherId: teacherId!,
            assignmentId: assignmentId!,
            assignmentIndex: assignmentIndex!,
            videoTotalDuration: videoTotalDuration!,
            watchedDuration: duration!,
          );
        }
        return true;
      }).catchError((onError) {
        debugPrint(onError);
        return true;
      });
      return true;
    } catch (error) {
      debugPrint(error.toString());
      return true;
    }
  }
}
