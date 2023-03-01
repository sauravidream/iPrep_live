import 'package:flutter/cupertino.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/books_model.dart';
import 'package:idream/model/extra_book_model.dart';
import 'package:idream/model/notes_model.dart';

class AssignmentTrackingRepository {
  Future trackAssignedBooks(String? subjectName,
      {int? spentTimeInSec,
      BooksModel? booksModel,
      String? subjectID,
      required String batchId,
      required String assignmentId,
      required String assignmentIndex,
      String? language,
      String? teacherId,

      String? boardId,
      String? classId}) async {
    //Saving this to the user's general report section

    if (!usingIprepLibrary) {
      await booksRepository.saveUsersBooksReport(
        subjectName,
        subjectID: subjectID!,
        durationInSeconds: spentTimeInSec,
        currentBooksModel: booksModel!,
        language: language,
        boardID: boardId,
        classID: classId,
      );
    }

    //Saving this to the assignment node
    String? _userID = await (getStringValuesSF("userID"));
    await dbRef
        .child("assignments")
        .child(batchId)
        .child("subjects")
        .child(assignmentId)
        .child("books")
        .child(assignmentIndex)
        .child("student_report")
        .child(_userID!)
        .child("progress")
        .child(DateTime.now().microsecondsSinceEpoch.toString())
        .set({
      "updated_time": DateTime.now().toUtc().toString(),
      "duration": spentTimeInSec.toString(),
      "total_pages": totalBookOrNotesPageCount.toString(),
      "page_read": totalReadBookOrNotesPageCount.toString(),
      "progress_text":
          "Progress ${((totalReadBookOrNotesPageCount! * 100) / totalBookOrNotesPageCount!).ceil()}%",
      "progress_text_color":
          totalReadBookOrNotesPageCount == totalBookOrNotesPageCount
              ? "0xFF22C59B"
              : "0xFF3399FF",
    }).then((_) async {
      debugPrint("Saved assignment progress status for books successfully");
      saveRecentAssignment(
        teacherId: teacherId.toString(),
        assignmentId: assignmentId,
        assignmentIndex: assignmentIndex,
        batchId: batchId,
        totalBookOrNotesPage: totalBookOrNotesPageCount,
        totalReadBookOrNotesPage: totalReadBookOrNotesPageCount,
        assignmentType: 'books',
        spentTimeInSec: spentTimeInSec
      );
      debugPrint("Saved Recent assignment progress status for books successfully");
      resetBookOrNotesPageCountVariables();
    }).catchError((onError) {
      debugPrint(onError.toString());
      resetBookOrNotesPageCountVariables();
    });
  }

  Future trackAssignedNotes(String? subjectName,
      {int? spentTimeInSec,
      NotesModel? notesModel,
      String? subjectID,
      required String batchId,
      required String assignmentId,
      required String assignmentIndex,
      String? language,
      String? boardId,
      String? classId,
        String? teacherId,
      }) async {
    //Saving this to the user's general report section
    if (!usingIprepLibrary) {
      await notesRepository.saveUsersNotesReport(
        subjectName,
        subjectID: subjectID!,
        durationInSeconds: spentTimeInSec,
        currentNotesModel: notesModel!,
        language: language,
        boardID: boardId,
        classID: classId,
      );
    }
    //Saving this to the assignment node
    String? _userID = await (getStringValuesSF("userID"));
    await dbRef
        .child("assignments")
        .child(batchId)
        .child("subjects")
        .child(assignmentId)
        .child("notes")
        .child(assignmentIndex)
        .child("student_report")
        .child(_userID!)
        .child("progress")
        .child(DateTime.now().microsecondsSinceEpoch.toString())
        .set({
      "updated_time": DateTime.now().toUtc().toString(),
      "duration": spentTimeInSec.toString(),
      "total_pages": totalBookOrNotesPageCount.toString(),
      "page_read": totalReadBookOrNotesPageCount.toString(),
      "progress_text":
          "Progress ${((totalReadBookOrNotesPageCount! * 100) / totalBookOrNotesPageCount!).ceil()}%",
      "progress_text_color":
          totalReadBookOrNotesPageCount == totalBookOrNotesPageCount
              ? "0xFF22C59B"
              : "0xFF3399FF",
    }).then((_) async {
      saveRecentAssignment(
          teacherId: teacherId.toString(),
          assignmentId: assignmentId,
          assignmentIndex: assignmentIndex,
          batchId: batchId,
          totalBookOrNotesPage: totalBookOrNotesPageCount,
          totalReadBookOrNotesPage: totalReadBookOrNotesPageCount,
          assignmentType: 'notes',
          spentTimeInSec: spentTimeInSec
      );
      debugPrint("Saved assignment progress status for notes successfully");
      resetBookOrNotesPageCountVariables();
    }).catchError((onError) {
      debugPrint(onError.toString());
      resetBookOrNotesPageCountVariables();
    });
  }

  Future trackAssignedExtraBooks(
      {int? spentTimeInSec,
      Topics? extraBookModel,
      String? subjectID,
      required String batchId,
      required String assignmentId,
      required String assignmentIndex,
      String? language,
      String? boardId,
      String? classId,
        String? teacherId,
      }) async {
    //Saving this to the user's general report section

    if (!usingIprepLibrary) {
      await dashboardRepository.saveBookLibraryReport(
        bookLibraryModel: extraBookModel!,
        durationInSeconds: spentTimeInSec,
        language: language,
        boardID: boardId,
        classID: classId,
      );
    }
    //Saving this to the assignment node
    String? _userID = await (getStringValuesSF("userID"));
    await dbRef
        .child("assignments")
        .child(batchId)
        .child("extra_books")
        .child(assignmentId)
        .child("extra_books")
        .child(assignmentIndex)
        .child("student_report")
        .child(_userID!)
        .child("progress")
        .child(DateTime.now().microsecondsSinceEpoch.toString())
        .set({
      "updated_time": DateTime.now().toUtc().toString(),
      "duration": spentTimeInSec.toString(),
      "total_pages": totalBookOrNotesPageCount.toString(),
      "page_read": totalReadBookOrNotesPageCount.toString(),
      "progress_text":
          "Progress ${((totalReadBookOrNotesPageCount! * 100) / totalBookOrNotesPageCount!).ceil()}%",
      "progress_text_color":
          totalReadBookOrNotesPageCount == totalBookOrNotesPageCount
              ? "0xFF22C59B"
              : "0xFF3399FF",
    }).then((_) async {
      saveRecentAssignment(
          teacherId: teacherId.toString(),
          assignmentId: assignmentId,
          assignmentIndex: assignmentIndex,
          batchId: batchId,
          totalBookOrNotesPage: totalBookOrNotesPageCount,
          totalReadBookOrNotesPage: totalReadBookOrNotesPageCount,
          assignmentType: 'extra_books',
          spentTimeInSec: spentTimeInSec
      );
      debugPrint("Saved assignment progress status for notes successfully");
      resetBookOrNotesPageCountVariables();
    }).catchError((onError) {
      debugPrint(onError.toString());
      resetBookOrNotesPageCountVariables();
    });
  }

  Future trackAssignedVideos({
    required int videoTotalDuration,
    required int watchedDuration,
    /*VideoLessonModel videoLessonModel,
      String subjectID,*/
    required String batchId,
    required String assignmentId,
    required String assignmentIndex,required
    String? teacherId,
  }) async {
    //Saving this to the assignment node
    String? _userID = await (getStringValuesSF("userID"));
    await dbRef
        .child("assignments")
        .child(batchId)
        .child("subjects")
        .child(assignmentId)
        .child("videos")
        .child(assignmentIndex)
        .child("student_report")
        .child(_userID!)
        .child("progress")
        .child(DateTime.now().microsecondsSinceEpoch.toString())
        .set({
      "updated_time": DateTime.now().toUtc().toString(),
      "total_duration": videoTotalDuration.toString(),
      "watched_duration": watchedDuration.toString(),
      "progress_text":
          "Progress ${((watchedDuration * 100) / videoTotalDuration).ceil()}%",
      "progress_text_color":
          watchedDuration == videoTotalDuration ? "0xFF22C59B" : "0xFF3399FF",
    }).then((_) async {
      saveRecentAssignment(
        teacherId: teacherId.toString(),
        assignmentId: assignmentId,
        assignmentIndex: assignmentIndex,
        batchId: batchId,
        assignmentType: 'videos',
        videoTotalDuration: videoTotalDuration,
        watchedDuration: watchedDuration,
      );
      debugPrint("Saved assignment progress status for notes successfully");
      resetBookOrNotesPageCountVariables();
    }).catchError((onError) {
      debugPrint(onError.toString());
      resetBookOrNotesPageCountVariables();
    });
  }

  saveRecentAssignment({
    required String teacherId,
     int ?videoTotalDuration,
   int? watchedDuration,
   int? spentTimeInSec,
    required String batchId,
    required String assignmentId,
    required String assignmentIndex,
    required String assignmentType,
    double? masteryAchieved,
    int? totalReadBookOrNotesPage,
    int? totalBookOrNotesPage,
  }) async {
    String? userID = await (getStringValuesSF("userID"));


    if(assignmentType=='videos'||assignmentType=='stem_videos'){
      try {
        await dbRef
            .child("recent_assignment")
            .child(teacherId)
            .child(assignmentId)
            .child(assignmentType)
            .child(assignmentIndex)
            .child("student_report")
            .child(userID!)
            .child("progress")
            .child(DateTime.now().microsecondsSinceEpoch.toString())
            .set({
          "updated_time": DateTime.now().toUtc().toString(),
          "total_duration": videoTotalDuration.toString(),
          "watched_duration": watchedDuration.toString(),
          "progress_text":
          "Progress ${((watchedDuration! * 100) / videoTotalDuration!).ceil()}%",
          "progress_text_color":
          watchedDuration == videoTotalDuration ? "0xFF22C59B" : "0xFF3399FF",
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }else if(assignmentType=='practice'){
      try {
        await dbRef
            .child("recent_assignment")
            .child(teacherId)
            .child(assignmentId)
            .child(assignmentType)
            .child(assignmentIndex)
            .child("student_report")
            .child(userID!)
            .child("progress")
            .child(DateTime.now().microsecondsSinceEpoch.toString())
            .set({
          "updated_time": DateTime.now().toUtc().toString(),
          "progress_text": "Mastery ${(masteryAchieved! * 100).floor()}%",
          "progress_text_color":
          (masteryAchieved.ceil() != 100) ? "0xFF22C59B" : "0xFF3399FF",
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }else if(assignmentType=="books"){
      try {
        await dbRef
            .child("recent_assignment")
            .child(teacherId)
            .child(assignmentId)
            .child(assignmentType)
            .child(assignmentIndex)
            .child("student_report")
            .child(userID!)
            .child("progress")
            .child(DateTime.now().microsecondsSinceEpoch.toString())
            .set({
          "updated_time": DateTime.now().toUtc().toString(),
          "duration": spentTimeInSec.toString(),
          "total_pages": totalBookOrNotesPage.toString(),
          "page_read": totalReadBookOrNotesPage.toString(),
          "progress_text":
          "Progress ${((totalReadBookOrNotesPage! * 100) / totalBookOrNotesPage!).ceil()}%",
          "progress_text_color":
          totalReadBookOrNotesPage == totalBookOrNotesPage
              ? "0xFF22C59B"
              : "0xFF3399FF",
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }else if(assignmentType=="notes"){
      try {
        await dbRef
            .child("recent_assignment")
            .child(teacherId)
            .child(assignmentId)
            .child(assignmentType)
            .child(assignmentIndex)
            .child("student_report")
            .child(userID!)
            .child("progress")
            .child(DateTime.now().microsecondsSinceEpoch.toString())
            .set({
          "updated_time": DateTime.now().toUtc().toString(),
          "duration": spentTimeInSec.toString(),
          "total_pages": totalBookOrNotesPage.toString(),
          "page_read": totalReadBookOrNotesPage.toString(),
          "progress_text":
          "Progress ${((totalReadBookOrNotesPage! * 100) / totalBookOrNotesPage!).ceil()}%",
          "progress_text_color":
          totalReadBookOrNotesPage == totalBookOrNotesPage
              ? "0xFF22C59B"
              : "0xFF3399FF",
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }else if(assignmentType=="extra_books"){
      try {
        await dbRef
            .child("recent_assignment")
            .child(teacherId)
            .child(assignmentId)
            .child(assignmentType)
            .child(assignmentIndex)
            .child("student_report")
            .child(userID!)
            .child("progress")
            .child(DateTime.now().microsecondsSinceEpoch.toString())
            .set({
          "updated_time": DateTime.now().toUtc().toString(),
          "duration": spentTimeInSec.toString(),
          "total_pages": totalBookOrNotesPage.toString(),
          "page_read": totalReadBookOrNotesPage.toString(),
          "progress_text":
          "Progress ${((totalReadBookOrNotesPage! * 100) / totalBookOrNotesPage!).ceil()}%",
          "progress_text_color":
          totalReadBookOrNotesPage == totalBookOrNotesPage
              ? "0xFF22C59B"
              : "0xFF3399FF",
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }


    //
    // try {
    //   await dbRef
    //       .child("recent_assignment")
    //       .child(teacherId)
    //       .child(assignmentId)
    //       .child(assignmentType)
    //       .child(assignmentIndex)
    //       .child("student_report")
    //       .child(userID!)
    //       .child("progress")
    //       .set({
    //     "updated_time": DateTime.now().toUtc().toString(),
    //     "total_duration": videoTotalDuration.toString(),
    //     "watched_duration": watchedDuration.toString(),
    //     "progress_text":
    //         "Progress ${((watchedDuration! * 100) / videoTotalDuration!).ceil()}%",
    //     "progress_text_color":
    //         watchedDuration == videoTotalDuration ? "0xFF22C59B" : "0xFF3399FF",
    //   });
    // } catch (e) {
    //   debugPrint(e.toString());
    // }
  }

  Future trackAssignedPractice(
      {required double masteryAchieved,
      String? teacherId,
      required String batchId,
      required String assignmentId,
      required String assignmentIndex}) async {
    //Saving this to the assignment node
    String? _userID = await (getStringValuesSF("userID"));
    await dbRef
        .child("assignments")
        .child(batchId)
        .child("subjects")
        .child(assignmentId)
        .child("practice")
        .child(assignmentIndex)
        .child("student_report")
        .child(_userID!)
        .child("progress")
        .child(DateTime.now().microsecondsSinceEpoch.toString())
        .set({
      "updated_time": DateTime.now().toUtc().toString(),
      "progress_text": "Mastery ${(masteryAchieved * 100).floor()}%",
      "progress_text_color":
          (masteryAchieved.ceil() == 100) ? "0xFF22C59B" : "0xFF3399FF",
    }).then((_) async {

      saveRecentAssignment(
        teacherId: teacherId.toString(),
        assignmentId: assignmentId,
        assignmentIndex: assignmentIndex,
        batchId: batchId,
        assignmentType: 'practice',
        masteryAchieved: masteryAchieved
      );

      debugPrint("Saved assignment progress status for notes successfully");
      resetBookOrNotesPageCountVariables();
    }).catchError((onError) {
      debugPrint(onError.toString());
      resetBookOrNotesPageCountVariables();
    });
  }

  Future trackAssignedStemVideos(
      {required int videoTotalDuration,
      required String teacherId,
      required int watchedDuration,
      required String batchId,
      required String assignmentId,
      required String assignmentIndex}) async {
    //Saving this to the assignment node
    String? _userID = await (getStringValuesSF("userID"));
    await dbRef
        .child("assignments")
        .child(batchId)
        .child("stem_videos")
        .child(assignmentId)
        .child("stem_videos")
        .child(assignmentIndex)
        .child("student_report")
        .child(_userID!)
        .child("progress")
        .child(DateTime.now().microsecondsSinceEpoch.toString())
        .set({
      "updated_time": DateTime.now().toUtc().toString(),
      "total_duration": videoTotalDuration.toString(),
      "watched_duration": watchedDuration.toString(),
      "progress_text":
          "Progress ${((watchedDuration * 100) / videoTotalDuration).ceil()}%",
      "progress_text_color":
          watchedDuration == videoTotalDuration ? "0xFF22C59B" : "0xFF3399FF",
    }).then((_) async {
      saveRecentAssignment(
        teacherId: teacherId,
        assignmentId: assignmentId,
        assignmentIndex: assignmentIndex,
        batchId: batchId,
        assignmentType: 'stem_videos',
        videoTotalDuration: videoTotalDuration,
        watchedDuration: watchedDuration,
      );

      debugPrint(
          "Saved assignment progress status for Stem Videos successfully");
    }).catchError((onError) {
      debugPrint(onError.toString());
    });
  }
}
