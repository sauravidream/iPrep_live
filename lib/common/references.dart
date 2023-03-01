import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/local_db_helper.dart';
import 'package:idream/model/user.dart';
import 'package:idream/network/network_info.dart';
import 'package:idream/repository/analytics_repository.dart';
import 'package:idream/repository/api_handler.dart';
import 'package:idream/repository/assignment_repository.dart';
import 'package:idream/repository/assignment_tracking_repository.dart';
import 'package:idream/repository/batch_repository.dart';
import 'package:idream/repository/board_selection_repository.dart';
import 'package:idream/repository/book_repository.dart';
import 'package:idream/repository/class_repository.dart';
import 'package:idream/repository/coach_onboarding_repository.dart';
import 'package:idream/repository/contents_testing_repository.dart';
import 'package:idream/repository/dashboard_repository.dart';
import 'package:idream/repository/how_the_app_works_repository.dart';
import 'package:idream/repository/messaging_repository.dart';
import 'package:idream/repository/my_reports_repository.dart';
import 'package:idream/repository/new_version_repository.dart';
import 'package:idream/repository/notes_repository.dart';
import 'package:idream/repository/notification_repository.dart';
import 'package:idream/repository/onboarding_repository.dart';
import 'package:idream/repository/practice_repository.dart';
import 'package:idream/repository/share_earn_repository.dart';
import 'package:idream/repository/stem_video_repository.dart';
import 'package:idream/repository/stream_selection_repository.dart';
import 'package:idream/repository/subject_repository.dart';
import 'package:idream/repository/test_repository.dart';
import 'package:idream/repository/upgrade_plan_repository.dart';
import 'package:idream/repository/user_last_login_repository.dart';
import 'package:idream/repository/user_location_repository.dart';
import 'package:idream/repository/user_profile_rpository.dart';
import 'package:idream/repository/user_repository.dart';
import 'package:idream/repository/video_lesson_repository.dart';
import 'package:idream/ui/dashboard/dashboard_page.dart';
import 'package:idream/ui/onboarding/teacher/my_iprep_referrals_repository.dart';
import '../custom_packages/src/quality_links.dart';
import '../repository/api_dio_handler.dart';
import '../repository/login_repository.dart';
import '../repository/super_app/repository/iprep_store_repository.dart';
import '../repository/user_permission_request_repository.dart';
import 'global_variables.dart';

final APIHandler apiHandler = APIHandler();
final OnBoardingRepository onBoardingRepository = OnBoardingRepository();
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseMessaging firebaseMessaging =
    FirebaseMessaging.instance /*FirebaseMessaging()*/;
final UserRepository userRepository = UserRepository();
final UserPermissions userPermissions = UserPermissions();
final NetworkInfoImpl networkInfoImpl = NetworkInfoImpl();
final BasicContentsTexting basicContentsTexting = BasicContentsTexting();
final ClassRepository classRepository = ClassRepository();
final LoginRepository loginRepository = LoginRepository();
final BoardSelectionRepository boardSelectionRepository =
    BoardSelectionRepository();
final StreamSelectionRepository streamSelectionRepository =
    StreamSelectionRepository();
final DashboardRepository dashboardRepository = DashboardRepository();
final UserProfileRepository userProfileRepository = UserProfileRepository();
final HowTheAppWorksRepository howTheAppWorksRepository =
    HowTheAppWorksRepository();
final TestRepository testRepository = TestRepository();
final NewVersion newVersion = NewVersion();

final PracticeRepository practiceRepository = PracticeRepository();
final MyReportsRepository myReportsRepository = MyReportsRepository();
final NotificationRepository notificationRepository = NotificationRepository();
final ShareEarnRepository shareEarnRepository = ShareEarnRepository();
final SubjectRepository subjectRepository = SubjectRepository();
final UserLoginRepository userLoginRepository = UserLoginRepository();
final CoachOnBoardingRepository coachOnBoardingRepository =
    CoachOnBoardingRepository();
final UpgradePlanRepository upgradePlanRepository = UpgradePlanRepository();
final UserLocationRepository userLocationRepository = UserLocationRepository();
final MessagingRepository messagingRepository = MessagingRepository();
final MyIprepReferralsRepository myIprepReferralsRepository =
    MyIprepReferralsRepository();
final BatchRepository batchRepository = BatchRepository();
final AssignmentTrackingRepository assignmentTrackingRepository =
    AssignmentTrackingRepository();
final AnalyticsRepository analyticsRepository = AnalyticsRepository();
final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;

final dbRef = FirebaseDatabase(
  databaseURL: Constants.apiUrl,

// ignore: deprecated_member_use
).reference();

FirebaseDatabase firebaseDatabase = FirebaseDatabase.instanceFor(
  app: firebaseApp!,
  databaseURL: Constants.apiUrl,
);

final FirebaseDatabase firebaseDatabaseInstance = FirebaseDatabase.instance;

final StemVideoRepository stemVideoRepository = StemVideoRepository();
final VideoLessonRepository videoLessonRepository = VideoLessonRepository();
final VideoRepository videoRepository = VideoRepository();
final AssignmentRepository assignmentRepository = AssignmentRepository();
final BooksRepository booksRepository = BooksRepository();
final NotesRepository notesRepository = NotesRepository();
final DatabaseHelper helper = DatabaseHelper.instance;
AppUser? appUser = AppUser();
AppUser updatedAppUser = AppUser();
DashboardScreenState? dashboardScreenState;

bool profileEdited = false;
String? videoIdBeingPlayed = "";
bool usingIprepLibrary = false;

bool firstTimeLanded = false;
bool restrictUser =
    true; //Is being used to block functionality when user's subscription gets expired or free trial gets ended.

final TextEditingController nameController = TextEditingController();
final TextEditingController pinEditingController = TextEditingController();
final TextEditingController ageController = TextEditingController();
final TextEditingController genderController = TextEditingController();
final TextEditingController dobController = TextEditingController();
final TextEditingController mobileController = TextEditingController();
final TextEditingController parentContactController = TextEditingController();
final TextEditingController verifyEmail = TextEditingController();
final TextEditingController usernameForLogin = TextEditingController();
final TextEditingController passwordForLogin = TextEditingController();

final TextEditingController verifyPhone = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController conformPasswordController = TextEditingController();
final TextEditingController addressController = TextEditingController();
final TextEditingController stateController = TextEditingController();
final TextEditingController cityController = TextEditingController();
final TextEditingController schoolController = TextEditingController();
String gender = genderController.text;
final Random random = Random();

int? totalBookOrNotesPageCount = 0;
int? totalReadBookOrNotesPageCount = 1;

setBookOrNotesPageCountVariables({int? totalCount = 0, int? readCount = 0}) {
  if (totalCount != 0) totalBookOrNotesPageCount = totalCount;
  if (readCount != 0) totalReadBookOrNotesPageCount = readCount;
}

resetBookOrNotesPageCountVariables() {
  totalBookOrNotesPageCount = 0;
  totalReadBookOrNotesPageCount = 0;
}

// Time convertor

Future getTotalTimeString(int duration) async {
  String timeSpentString = "";
  if (Duration(seconds: duration).inHours > 0) {
    timeSpentString += "${Duration(seconds: duration).inHours}h ";
  }
  if (Duration(seconds: duration).inMinutes.remainder(60) > 0) {
    timeSpentString +=
        "${Duration(seconds: duration).inMinutes.remainder(60)}m ";
  }
  if (Duration(seconds: duration).inSeconds.remainder(60) > 0) {
    timeSpentString +=
        "${Duration(seconds: duration).inSeconds.remainder(60)}s ";
  }
  return timeSpentString;
}

//   Super App

StoreRepository storeRepository = StoreRepository();
DioClient dio = DioClient();
