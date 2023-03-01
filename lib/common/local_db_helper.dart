import 'dart:io';
import 'package:flutter/material.dart';
import 'package:idream/model/boards_model.dart';
import 'package:idream/model/books_model.dart';
import 'package:idream/model/class_model.dart';
import 'package:idream/model/notes_model.dart';
import 'package:idream/model/streams_model.dart';
import 'package:idream/model/subject_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

const String columnId = '_id';
//subject table
const String tableVideoLessons = 'videoLessons';
const String tableBooks = 'books';
const String tableNotes = 'notes';
const String tableClasses = 'classes';
const String tableEducationBoards = 'boards';
const String tableStreams = 'streams';
const String tableSubjects = 'subjects';
const String unreadChatHistory = 'chatHistory';
/*//reportType table
final String tableReportType = 'reportType';
//reportSubType table
final String tableReportSubType = 'reportSubType';*/

// Categories data model class
class VideoLessons {
  int? id;
  String? boardID;
  String? classID;
  String? language;
  String? subjectName;
  String? chapterName;
  String? videoType; //videoLessons in case of chapter videos
  String? videoDetails;
  String? videoID;
  String? videoName;
  String? videoOfflineLink;
  String? videoOfflineThumbnail;
  String? videoOnlineLink;
  String? videoThumbnail;
  String? videoTopicName;

  VideoLessons({
    this.id,
    this.boardID,
    this.classID,
    this.language,
    this.subjectName,
    this.chapterName,
    this.videoType,
    this.videoDetails,
    this.videoID,
    this.videoName,
    this.videoOfflineLink,
    this.videoOfflineThumbnail,
    this.videoOnlineLink,
    this.videoThumbnail,
    this.videoTopicName,
  });

  // convenience constructor to create a Categories object
  VideoLessons.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    boardID = map["boardID"];
    classID = map["classID"];
    language = map["language"];
    subjectName = map["subjectName"];
    chapterName = map["chapterName"];
    videoType = map["videoType"];
    videoDetails = map["videoDetails"];
    videoID = map["videoID"];
    videoName = map["videoName"];
    videoOfflineLink = map["videoOfflineLink"];
    videoOfflineThumbnail = map["videoOfflineThumbnail"];
    videoOnlineLink = map["videoOnlineLink"];
    videoThumbnail = map["videoThumbnail"];
    videoTopicName = map["videoTopicName"];
  }

  // convenience method to create a Map from this Categories object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "id": id,
      "boardID": boardID ?? "",
      "classID": classID ?? "",
      "language": language ?? "",
      "subjectName": subjectName ?? "",
      "chapterName": chapterName ?? "",
      "videoType": videoType ?? "",
      "videoDetails": videoDetails ?? "",
      "videoID": videoID ?? "",
      "videoName": videoName ?? "",
      "videoOfflineLink": videoOfflineLink ?? "",
      "videoOfflineThumbnail": videoOfflineThumbnail ?? "",
      "videoOnlineLink": videoOnlineLink ?? "",
      "videoThumbnail": videoThumbnail ?? "",
      "videoTopicName": videoTopicName ?? "",
    };
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static const _databaseName = "iPrepSqlite.db";
  // Increment this version when you need to change the schema.
  static const _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableVideoLessons (
                id INTEGER PRIMARY KEY AUTOINCREMENT,             
                boardID TEXT,
                classID TEXT,
                language TEXT,
                subjectName TEXT,
                chapterName TEXT,
                videoType TEXT,
                videoDetails TEXT,
                videoID TEXT,
                videoName TEXT,
                videoOfflineLink TEXT,
                videoOfflineThumbnail TEXT,
                videoOnlineLink TEXT,
                videoThumbnail TEXT,
                videoTopicName TEXT
              )
              ''');
    await db.execute('''
              CREATE TABLE $tableBooks (
                id INTEGER PRIMARY KEY AUTOINCREMENT,             
                boardID TEXT,
                classID TEXT,
                language TEXT,
                subjectName TEXT,
                chapterName TEXT,
                bookDetails TEXT,
                bookID TEXT,
                bookName TEXT,
                bookOfflineLink TEXT,
                bookOfflineThumbnail TEXT,
                bookOnlineLink TEXT,
                bookThumbnail TEXT,
                bookTopicName TEXT
              )
              ''');
    await db.execute('''
              CREATE TABLE $tableNotes (
                id INTEGER PRIMARY KEY AUTOINCREMENT,             
                boardID TEXT,
                classID TEXT,
                language TEXT,
                subjectName TEXT,
                chapterName TEXT,
                noteDetails TEXT,
                noteID TEXT,
                noteName TEXT,
                noteOfflineLink TEXT,
                noteOfflineThumbnail TEXT,
                noteOnlineLink TEXT,
                noteThumbnail TEXT,
                noteTopicName TEXT
              )
              ''');
    await db.execute('''
              CREATE TABLE $tableClasses (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                icon TEXT,
                boardName TEXT,
                classID TEXT,
                className TEXT,
                language TEXT
              )
              ''');
    await db.execute('''
              CREATE TABLE $tableEducationBoards (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                abbr TEXT,
                icon TEXT,
                boardID TEXT,
                name TEXT,
                detail TEXT,
                language TEXT
              )
              ''');
    await db.execute('''
              CREATE TABLE $tableStreams (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                boardName TEXT,
                classID TEXT,
                streamID TEXT,
                streamName TEXT,
                icon TEXT
              )
              ''');
    await db.execute('''
              CREATE TABLE $tableSubjects (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                boardName TEXT,
                classID TEXT,
                subjectID TEXT,
                subjectName TEXT,
                subjectIconPath TEXT,
                subjectColor TEXT,
                language TEXT,
                shortName TEXT
              )
              ''');
    await db.execute('''
              CREATE TABLE $unreadChatHistory (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                batchId TEXT,
                batchName TEXT,
                senderId TEXT,
                senderName TEXT,
                receiverId TEXT,
                senderUserType TEXT,
                message TEXT,
                messageTime TEXT,
                senderProfilePhoto TEXT,
                receiverProfilePhoto TEXT
              )
              ''');

    // await db.execute('''
    //           CREATE TABLE $tableReportSubType (
    //             _id INTEGER PRIMARY KEY,
    //             id INTEGER NOT NULL UNIQUE,
    //             typeId INTEGER NOT NULL,
    //             title TEXT NOT NULL,
    //             description TEXT NOT NULL,
    //             createdAt INTEGER NOT NULL,
    //             updatedAt INTEGER NOT NULL
    //           )
    //           ''');
  }

  // Database helper methods:
  // ignore: missing_return
  Future<int> insert({String? tableName, tableData}) async {
    Database? db = await database;
    int? id;
    try {
      await db!.transaction((txn) async {
        id = await txn.insert(tableName!, tableData.toMap());
      });
      // int id = await db.insert(tableName, tableData.toMap());
      return id!;
    } catch (e) {
      id = await db?.insert(tableName!, tableData.toJson());
      return id!;
    }
  }

  // ignore: missing_return
  Future<int?> rawInsertVideoLessons(
      {String? tableData, VideoLessons? videoLessons}) async {
    Database? db = await database;
    try {
      var result = await db!.rawInsert(tableData!, [
        videoLessons!.boardID,
        videoLessons.classID,
        videoLessons.language,
        videoLessons.subjectName,
        videoLessons.chapterName,
        videoLessons.videoType,
        videoLessons.videoDetails,
        videoLessons.videoID,
        videoLessons.videoName,
        videoLessons.videoOfflineLink,
        videoLessons.videoOfflineThumbnail,
        videoLessons.videoOnlineLink,
        videoLessons.videoThumbnail,
        videoLessons.videoTopicName
      ]);
      // int id = await db.insert(tableName, tableData.toMap());
      return result;
    } catch (e) {
      // int id = await db.insert(tableName, tableData.toJson());
      // return id;
      debugPrint(e.toString());
    }
  }

  // To get one row of a table on the basis of row ID
  Future queryDataOnRowIDAndTableName({int? id, String? tableName}) async {
    Database? db = await database;
    List<Map> maps = await db!.query(
      tableName!,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (maps.length > 0) {
      // return SavedBookmarks.fromMap(maps.first);
    }
    return null;
  }

  Future fetchChapterListBasisOnSubjectNameClassNameBoardNameLanguage(
      {String? subjectName,
        String? className,
        String boardName = "C_E_B",
        String language = "english"}) async {
    try {
      Database? db = await database;
      List<Map> maps = await db!.rawQuery(
          "SELECT DISTINCT chapterName FROM $tableVideoLessons WHERE subjectName = ? AND classID = ? AND boardID = ? AND language = ?",
          [subjectName, className, boardName, language]);
      return maps;
    } catch (exception) {
      List<Map> maps = [];
      return maps;
    }
  }

  Future fetchVideoLessonsBasisOnSubjectNameClassNameBoardNameLanguage(
      {String? subjectName,
        String? chapterName,
        String? className,
        String? boardName = "C_E_B",
        String? language = "english"}) async {
    try {
      Database? db = await database;
      List<Map> maps = await db!.rawQuery(
          "SELECT * FROM $tableVideoLessons WHERE subjectName = ? AND chapterName = ? AND classID = ? AND boardID = ? AND language = ?",
          [subjectName, chapterName, className, boardName, language]);
      return maps;
    } catch (exception) {
      List<Map> maps = [];
      return maps;
    }
  }

  //Books methods
  // ignore: missing_return
  Future<int?> rawInsertBooks({String? tableData, BooksModel? booksModel}) async {
    Database? db = await database;
    try {
      int result = await db!.rawInsert(tableData!, [
        booksModel!.boardID,
        booksModel.classID,
        booksModel.language,
        booksModel.subjectName,
        booksModel.chapterName,
        booksModel.bookDetails,
        booksModel.bookID,
        booksModel.bookName,
        booksModel.bookOfflineLink,
        booksModel.bookOfflineThumbnail,
        booksModel.bookOnlineLink,
        booksModel.bookThumbnail,
        booksModel.bookTopicName
      ]);
      // int id = await db.insert(tableName, tableData.toMap());
      return result;
    } catch (e) {
      // int id = await db.insert(tableName, tableData.toJson());
      // return id;
      debugPrint(e.toString());
    }
  }

  Future fetchBooksBasisOnSubjectNameClassNameBoardNameLanguage({
    String? subjectName,
    String? boardName,
    String? language,
    String? className,
  }) async {
    try {
      Database? db = await database;
      List<Map> maps = await db!.rawQuery(
          "SELECT * FROM $tableBooks WHERE subjectName = ?  AND boardID = ? AND classID = ? AND language = ?",
          [subjectName, boardName, className, language]);
      return maps;
    } catch (exception) {
      List<Map> maps = [];
      return maps;
    }
  }

  //Notes methods
  // ignore: missing_return
  Future<int?> rawInsertNotes({String? tableData, NotesModel? notesModel}) async {
    Database? db = await database;
    try {
      int result = await db!.rawInsert(tableData!, [
        notesModel!.boardID,
        notesModel.classID,
        notesModel.language,
        notesModel.subjectName,
        notesModel.chapterName,
        notesModel.noteDetails,
        notesModel.noteID,
        notesModel.noteName,
        notesModel.noteOfflineLink,
        notesModel.noteOfflineThumbnail,
        notesModel.noteOnlineLink,
        notesModel.noteThumbnail,
        notesModel.noteTopicName
      ]);
      // int id = await db.insert(tableName, tableData.toMap());
      return result;
    } catch (e) {
      // int id = await db.insert(tableName, tableData.toJson());
      // return id;
      debugPrint(e.toString());
    }
  }

  Future fetchNotesBasisOnSubjectNameClassNameBoardNameLanguage({
    String? subjectName,
    String? boardName,
    String? language,
    String? className,
  }) async {
    try {
      Database? db = await database;
      List<Map> maps = await db!.rawQuery(
          "SELECT * FROM $tableNotes WHERE subjectName = ? AND boardID = ? AND classID = ? AND language",
          [subjectName, boardName, className, language]);
      return maps;
    } catch (exception) {
      List<Map> maps = [];
      return maps;
    }
  }

// To get all data of a table
  Future queryAllDataOnTableName(String tableName) async {
    try {
      Database? db = await database;
      List<Map> maps = await db!.query(
        tableName,
      );
      return maps;
    } catch (exception) {
      List<Map> maps = [];
      return maps;
    }
  }

// TODO: delete(int id)
  Future deleteAllDataOnTableName(String tableName) async {
    Database? db = await database;
    int result = await db!.delete(tableName);
    return result;
  }

// TODO: update(Word word)

//Classes methods
  // ignore: missing_return
  Future<int?> rawInsertClasses(
      {String? tableData, ClassStandard? classesModel}) async {
    Database? db = await database;
    try {
      int result = await db!.rawInsert(tableData!, [
        classesModel!.icon,
        classesModel.boardName,
        classesModel.classID,
        classesModel.className,
        classesModel.language,
      ]);
      // int id = await db.insert(tableName, tableData.toMap());
      return result;
    } catch (e) {
      // int id = await db.insert(tableName, tableData.toJson());
      // return id;
      debugPrint(e.toString());
    }
  }

  Future fetchClassesBasisEducationBoardAndLanguage({
    String? boardName,
    String? language,
  }) async {
    try {
      Database? db = await database;
      List<Map> maps = await db!.rawQuery(
          "SELECT * FROM $tableClasses WHERE boardName = ? AND language = ? ",
          [boardName, language]);
      return maps;
    } catch (exception) {
      List<Map> maps = [];
      return maps;
    }
  }

  //Boards methods
  // ignore: missing_return
  Future<int?> rawInsertBoards(
      {String? tableData, BoardsModel? boardsModel}) async {
    Database? db = await database;
    try {
      int result = await db!.rawInsert(tableData!, [
        boardsModel!.abbr,
        boardsModel.icon,
        boardsModel.id,
        boardsModel.boardName,
        boardsModel.detail,
        boardsModel.language,
      ]);
      // int id = await db.insert(tableName, tableData.toMap());
      return result;
    } catch (e) {
      // int id = await db.insert(tableName, tableData.toJson());
      // return id;
      debugPrint(e.toString());
    }
  }

  Future fetchBoards({@required String? language}) async {
    try {
      Database? db = await database;
      List<Map> maps = await db!.rawQuery(
          "SELECT * FROM $tableEducationBoards WHERE language = ?", [language]);
      return maps;
    } catch (exception) {
      List<Map> maps = [];
      return maps;
    }
  }

  //Stream methods
  // ignore: missing_return
  Future<int?> rawInsertStreams(
      {String? tableData, StreamsModel? streamsModel}) async {
    Database? db = await database;
    try {
      int result = await db!.rawInsert(tableData!, [
        streamsModel!.boardName,
        streamsModel.classID,
        streamsModel.streamID,
        streamsModel.streamName,
        streamsModel.icon,
      ]);
      // int id = await db.insert(tableName, tableData.toMap());
      return result;
    } catch (e) {
      // int id = await db.insert(tableName, tableData.toJson());
      // return id;
      debugPrint(e.toString());
    }
  }

  Future fetchStreamsBasisEducationBoardAndClass({
    String? boardName,
    String? className,
  }) async {
    try {
      Database? db = await database;
      List<Map> maps = await db!.rawQuery(
          "SELECT * FROM $tableStreams WHERE boardName = ? AND classID = ?",
          [boardName, className]);
      return maps;
    } catch (exception) {
      List<Map> maps = [];
      return maps;
    }
  }

  //Subject methods
  // ignore: missing_return
  Future<int?> rawInsertSubjects(
      {String? tableData, SubjectModel? subjectModel}) async {
    Database? db = await database;
    try {
      int result = await db!.rawInsert(tableData!, [
        subjectModel!.boardName,
        subjectModel.classID,
        subjectModel.subjectID,
        subjectModel.subjectName,
        subjectModel.subjectIconPath,
        subjectModel.subjectColor,
        subjectModel.language,
        subjectModel.shortName,
      ]);
      // int id = await db.insert(tableName, tableData.toMap());
      return result;
    } catch (e) {
      // int id = await db.insert(tableName, tableData.toJson());
      // return id;
      debugPrint(e.toString());
    }
  }

  Future fetchSubjectsBasisEducationBoardClassAndLanguage({
    String? boardName,
    String? classID,
    String? language,
  }) async {
    try {
      Database? db = await database;
      List<Map> maps = await db!.rawQuery(
          "SELECT * FROM $tableSubjects WHERE boardName = ? AND classID = ? AND language = ?",
          [boardName, classID, language]);
      return maps;
    } catch (exception) {
      List<Map> maps = [];
      return maps;
    }
  }

  Future fetchSubjectNameBasisEducationBoardClassSubjectIDAndLanguage(
      {String? boardName,
        String? classID,
        String? subjectID,
        String? language}) async {
    try {
      Database? db = await database;
      List<Map> maps = await db!.rawQuery(
          "SELECT * FROM $tableSubjects WHERE boardName = ? AND classID = ? AND subjectID = ? AND language = ?",
          [boardName, classID, subjectID, language]);
      return maps;
    } catch (exception) {
      List<Map> maps = [];
      return maps;
    }
  }

  Future fetchChatFromLocalDB({String? receiverId, String? userType}) async {
    try {
      Database? db = await database;
      List<Map> maps = await db!.rawQuery(
          "SELECT * FROM $unreadChatHistory WHERE receiverId = ? AND senderUserType = ?",
          [receiverId, userType]);
      return maps;
    } catch (exception) {
      List<Map> maps = [];
      return maps;
    }
  }

  Future deleteReadMessage({int? chatId}) async {
    try {
      Database? db = await database;
      int? _count = await db?.rawDelete('DELETE FROM $unreadChatHistory WHERE id = ?', [chatId]);
      return _count;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future deleteAllOneToOneMessages({String? receiverId, String? senderId}) async {
    try {
      Database? db = await database;
      int _count = await db!.rawDelete(
          'DELETE FROM $unreadChatHistory WHERE senderId = ? AND receiverId = ? AND batchId = ?',
          [senderId, receiverId, null]);
      return _count;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future deleteAllBatchMessages({String? batchId}) async {
    try {
      Database? db = await database;
      int _count = await db!.rawDelete(
          'DELETE FROM $unreadChatHistory WHERE batchId = ?', [batchId]);
      return _count;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}