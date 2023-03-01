import 'package:flutter/foundation.dart';
import 'package:idream/common/references.dart';

class BasicContentsTexting {
  contentsStatus({
    required String subject,
    required String classNo,
    String? stream,
    required String language,
    String? topicName,
    required String board,
    required String dataNotFoundIn,
  }) async {
    try {
      await dbRef
          .child("on_data_found_in_iprep_app")
          .child(board)
          .child(language)
          .child(classNo)
          .child(subject)
          // .child(datetime)
          .push()
          .set({
        "date_time": DateTime.now().toUtc().toString(),
        "subject_name": subject,
        "topic_name": topicName,
        "data_not_found": dataNotFoundIn
      }).then((_) async {
        if (kDebugMode) {
          print("Saved UsersNotes Data successfully");
        }
      });
    } catch (error) {
      if (kDebugMode) {
        print("Saved UsersNotes not Data successfully");
      }
    }
  }
}
