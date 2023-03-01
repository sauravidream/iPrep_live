import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

class Constants {
  static const String apiUrl = "https://i-prep.firebaseio.com/";

  /*kDebugMode
      ? "https://iprep-dev.firebaseio.com/"
      : "https://i-prep.firebaseio.com/";*/
  static const String language = "languages/";
  static const String baseurl =
      "https://iprep-7f10a.firebaseio.com/" /*this is use for the user migration */;
  static const String testPrepBaseUrl = "https://exams.iprep.in/";
  static const String testPrepCryptUrl = "api/v1/auth/crypt_cbc_login";
  static const String testPrepSecretKey = "1234567890abcdef";

  static const String thumbnail =
      "https://firebasestorage.googleapis.com/v0/b/iprep-7f10a.appspot.com/o/ssas.JPG?alt=media&token=e23d37e4-34b5-45c9-b87f-c35cf9ded7a8";

  //Contact Us information
  static const String supportMobileUrl = "tel://9810669749";
  static const String supportEmail = "app@idreameducation.org";
  static const String termsAndConditions = "app@idreameducation.org";

  static const String supportWhatsappUrl =
      "https://wa.me/+919810669749?text=Hi Team iPrep";

  static const String contactUsForSpecialOffers = "+919310993976";

  static const shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFCBCACA),
      Color(0xFFEBEBF4),
    ],
    stops: [
      0.1,
      0.2,
      0.3,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );

  static const int numberOfAllowedUsersPerAccount = 3;

  static int daysBetween({DateTime? from, int? duration}) {
    int? differenceDay = DateTime.now().difference(from!).inDays;

    int dayRemains = duration! - differenceDay;

    return dayRemains > 0 ? dayRemains : 0;
  }

  static String squareApplicationId = "sandbox-sq0idb-76lM6Wc6sov-nKsNcU23EQ";
  static String squareLocationId = "L5FFM0241H8ED";
  static String applePayMerchantId = "merchant.org.idreameducation.iprepapp";

  //Firebase urls
  static const String languageUrl = "StaticTextDB/StudentApp/0/LanguageList";
  static const String studentUserDetailsUrl = "users/students/";
  static const String teacherUserDetailsUrl = "users/teachers/";

  static const String studentUserMigrationDetailsUrl =
      "iDreamClone/Users/Students/";
  static const String teacherUserMigrationDetailsUrl =
      "iDreamClone/Users/Teachers/";
  static const String playStoreUrl =
      "https://play.google.com/store/apps/details?id=org.idreameducation.iprepapp";
  static const String appStoreUrl =
      "https://apps.apple.com/us/app/iprep-learning-app/id1547212891";
  static final RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 0,
    minLaunches: 0,
    remindDays: 0,
    remindLaunches: 0,
    googlePlayIdentifier: 'org.idreameducation.iprepapp',
    appStoreIdentifier: '1547212891',
  );

  static const downloadLinkText =
      "Hi, I invite you to learn from iPrep, with Animated Video lessons, Practice & Test questions, Projects, Digital Book Library, Notes & much more.\n\nYou get access to all classes not just one, so happily cover your learning gaps and learn unlimited!\n\nTry it Now\n\n";

  static getBatchJoiningLink({
    String? teacherName,
    String? batchName,
    String? subjectsText,
    String? className,
  }) {
    return ('Click on the above link to join batch - "$batchName" for class $className for subjects - $subjectsText on iPrep\n\nOnce you are connected, you can ask questions, clarify your doubts outside the classroom and continue to learn and grow under the guidance of your coach $teacherName.');
  }

  //UI static decoration
  static final InputBorder inputTextOutline = OutlineInputBorder(
    borderSide: const BorderSide(
      color: Color(0xFFDEDEDE),
      width: 1,
    ),
    borderRadius: BorderRadius.circular(12),
  );
  static final InputBorder focusedTextOutline = OutlineInputBorder(
    borderSide: const BorderSide(
      color: Color(0xFF0077FF),
      width: 1,
    ),
    borderRadius: BorderRadius.circular(12),
  );
  static final InputBorder inputTextOutlineFocus = OutlineInputBorder(
    borderSide: const BorderSide(
      color: Color(0xFF0077FF),
      width: 1,
    ),
    borderRadius: BorderRadius.circular(12),
  );

  static final TextStyle noDataTextStyle = TextStyle(
    color: Colors.grey[500],
    fontSize: 15,
  );

  static final InputBorder newBroadcastInputTextOutline = OutlineInputBorder(
    borderSide: const BorderSide(
      color: Color(0xFFDEDEDE),
      width: 1,
    ),
    borderRadius: BorderRadius.circular(12),
  );

  static const String defaultSubjectImagePath =
      "https://firebasestorage.googleapis.com/v0/b/iprep-7f10a.appspot.com/o/subjects%2FPhysics.png?alt=media&token=f4071aa7-f2dc-4353-8a82-0941b9f8f7bd";
  static const int defaultSubjectHexColor = 0xFFFCAC52;

  static const List bookImageList = [
    "https://firebasestorage.googleapis.com/v0/b/iprep-7f10a.appspot.com/o/book_listing_icon%2Fbook1.png?alt=media&token=2ad5ec04-bc68-4845-a632-a6be1ac61178",
    "https://firebasestorage.googleapis.com/v0/b/iprep-7f10a.appspot.com/o/book_listing_icon%2Fbook6.png?alt=media&token=4d77427c-2db5-4471-9bd2-1c60ea4a4732",
    "https://firebasestorage.googleapis.com/v0/b/iprep-7f10a.appspot.com/o/book_listing_icon%2Fbook5.png?alt=media&token=cc996a1d-c9f0-4198-91bd-3e6eb34332b2",
    "https://firebasestorage.googleapis.com/v0/b/iprep-7f10a.appspot.com/o/book_listing_icon%2Fbook4.png?alt=media&token=1641a23b-0df7-4b69-8378-cf0c4632c4da",
    "https://firebasestorage.googleapis.com/v0/b/iprep-7f10a.appspot.com/o/book_listing_icon%2Fbook3.png?alt=media&token=c07f1b5e-14a3-4f58-a736-6cf97ef6677b",
    "https://firebasestorage.googleapis.com/v0/b/iprep-7f10a.appspot.com/o/book_listing_icon%2Fbook2.png?alt=media&token=e12a59a4-4a55-4a9e-9e28-25c184e02e51",
  ];

  static const defaultProfileImagePath =
      "https://firebasestorage.googleapis.com/v0/b/iprep-7f10a.appspot.com/o/user.jpeg?alt=media&token=f0370ceb-ef63-4725-b925-6fbded11b1e9";

  static const List months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const daysInMonth = [
    0,
    31,
    28,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31
  ];

  static const Map subjectColorAndImageMap = {
    "physics": {
      "subjectColor": 0xFF5dc4f2,
      "assetPath": "assets/images/physics.png",
    },
    "chemistry": {
      "subjectColor": 0xFF5F63AA,
      "assetPath": "assets/images/chemistry.png",
    },
    "math": {
      "subjectColor": 0xFF268e57,
      "assetPath": "assets/images/maths.png",
    },
    "biology": {
      "subjectColor": 0xFFff2217,
      "assetPath": "assets/images/biology.png",
    },
    "hindi": {
      "subjectColor": 0xFF3C663E,
      "assetPath": "assets/images/biology.png",
    },
    "english": {
      "subjectColor": 0xFF3C663E,
      "assetPath": "assets/images/biology.png",
    },
    "science": {
      "subjectColor": 0xFF37A3EC,
      "assetPath": "assets/images/science.png",
    },
    "english_lit": {
      "subjectColor": 0xFFff4c48, //
      "assetPath": "assets/images/english_lit.png",
    },
    "english_gr": {
      "subjectColor": 0xFFFB9E36, //
      "assetPath": "assets/images/english_gr.png",
    },
    "computers": {
      "subjectColor": 0xFFff7f00, //
      "assetPath": "assets/images/computers.png",
    },
    "hindi_gr": {
      "subjectColor": 0xFFc91768, //
      "assetPath": "assets/images/computers.png",
    },
    "history": {
      "subjectColor": 0xFFfcb400, //
      "assetPath": "assets/images/history.png",
    },
    "geography": {
      "subjectColor": 0xFFc9c900, //
      "assetPath": "assets/images/geography.png",
    },
    "civics": {
      "subjectColor": 0xFFff6839, //
      "assetPath": "assets/images/civics.png",
    },
    "political_science": {
      "subjectColor": 0xFFFFB12C, //
      "assetPath": "assets/images/political_science.png",
    },
    "economics": {
      "subjectColor": 0xFFff7f00, //
      "assetPath": "assets/images/economics.png",
    },
    "accountancy": {
      "subjectColor": 0xFFff2217, //
      "assetPath": "assets/images/accountancy.png",
    },
    "statistics": {
      "subjectColor": 0xFFff2217, //
      "assetPath": "assets/images/statistics.png",
    },
    "business_st": {
      "subjectColor": 0xFFff7f00, //
      "assetPath": "assets/images/business_st.png",
    },
    "sociology": {
      "subjectColor": 0xFFff7f00, //
      "assetPath": "assets/images/sociology.png",
    },
    "psychology": {
      "subjectColor": 0xFFff2217, //
      "assetPath": "assets/images/psychology.png",
    },
    "arts_and_history": {
      "subjectColor": 0xFFfcb400, //
      "assetPath": "assets/images/arts_and_history.png",
    },
    "inspirational": {
      "subjectColor": 0xFF74b6e5, //
      "assetPath": "assets/images/inspirational.png",
    },
    "pictures_and_comics": {
      "subjectColor": 0xFFff706c, //
      "assetPath": "assets/images/picture_and_comics.png",
    },
    "poems": {
      "subjectColor": 0xFFffBB82, //
      "assetPath": "assets/images/poems.png",
    },
    "story_books": {
      "subjectColor": 0xFFF5B0CE, //
      "assetPath": "assets/images/storybook.png",
    },
    "social_and_environmental": {
      "subjectColor": 0xFFb6d168, //
      "assetPath": "assets/images/social_and_environment.png",
    }
  };

  //Static Text
  static const String noBatchCreatedText =
      'Click on “New” and create your first batch.';
  static const String noRecentMessageText =
      'You will see the messages you send to your students here. To send a new message, start by creating your first batch.';
  static const String noRecentAssignmentText =
      'Here, you will see a list of all the learning content that you would assign to your students. To assign content, create your first batch to begin your teaching.';
  static const String noRecentMessageTextBatchCreated =
      'You will see the messages you send to your students here.';
  static const String noRecentAssignmentTextBatchCreated =
      'Here, you will see a list of all the learning content that you would assign to your students.';
  static const String noRecentMessageTextBatchCreatedStudentView =
      'You will see the messages you send to your teachers here.';

  //Error Messages
  static const String invalidOtp = "Invalid OTP, Try Again";
  static const String errorValidatingOtp = "Error validating OTP, try again";
  static const String incorrectMobileNumber =
      "Please enter the valid mobile number";
  static const String incorrectEmail = "Please enter the valid email id";
  static const String googleLoginError =
      "Error logging in, please try again later";

  static const String somethingWentWong =
      "Error logging in, please try again later";
  static const String allField = "Error all fields are required";

  static const String emailAlreadyExist =
      "The email/username is already in use. Please choose another email/username";
  static const String languageSelectionAlert =
      "Please select your preferred language for the app";
  static const String userTypeSelectionAlert =
      "lease select an option to move forward";
  static const String classSelectionAlert = "Please select your class";
  static const String nameAlert = "Please enter your full name";
  static const String streamAlert = "Please select your stream to move forward";
  static const String batchCreationError =
      "Currently, we are facing some issues while creating batch for you. Please try later.";
  static const String boardSelectionAlert =
      "Please select your board to move ahead";
  static const String passWord = "Please enter the valid password";
  static const String verificationField =
      "Please enter email id or phone number";
  static const String noCategoryDataAvailableForSubjects =
      "Sorry, we cannot proceed further. Please try later";
  static const String dialerError =
      "There is an error while opening the dialer, please try later";
  static const String whatsappError =
      "There is an error while opening the Whatsapp, please try later";
  static const String emailError =
      "There is an error while opening your email, please try later ";
  static const String email = "Please enter a valid email or password ";
  static const String emailSi = "Please enter a valid user name ";
  static const String imageProcessingError =
      "Not able to process your selected image. Please try later";
  static const String noInformationToUpdate =
      "No change in the profile to save.";
  static const String profilePhotoUpdationBackEndError =
      "We are unable to update your profile photo at this moment, please try later";
  static const String profilePhotoUpdateCatchError =
      "We are unable to update your profile photo at this moment, please try later";
  static const String assignmentEndDateSelectionAlert =
      "Please choose assignment end date to proceed";
  static const String assignmentNoItemSelectionAlert =
      "You must select at-least one piece of content to assign to your students";
  static const String noStudentSelectionErrorForAssignment =
      "Please select at-least one student to proceed further";
  static const String dashboardNewMessageNoBatchSelectionAlert =
      "To assign any content, you will have to first select your batch";
  static const String dashboardNewMessageNoStudentSelectionAlert =
      "Please select at least one student.";
  static const String dashboardNewMessageSendingError =
      "We are unable to send your message. Requesting to please send it again in some time";
  static const String dashboardNewMessageNoMessageAlert =
      "Please enter your message";
  static const String coachMyiPrepReferralError =
      "Failed to submit your information. Please retry.";
  static const String coachMyiPrepReferralFillDetailAlert =
      "Please fill in all the information before submitting it.";
  static const String discountCodeExpiryAlert =
      "Sorry, but the Discount Code you have entered has been used";
  static const String incorrectDiscountCode =
      "This is an Incorrect discount code";
  static const String incorrectDiscountCodeForPlan =
      "This is an Incorrect discount code for the selected plan. Please select valid plan";
  static const String batchUpdationError =
      "Sorry, currently we are facing an issue while updating your batch. Requesting you to please try again in sometime";
  static const String batchUpdationEntryFillAlert = "A Field cannot be empty.";
  static const String createBatchEntryFillAlert =
      "Please fill all the necessary information to successfully create your batch";
  static const String assignmentNoStudentJoinedBatchAlert =
      "You can only assign content if you have students added to your batch. To add students, click on “Add Students”";
  static const String broadcastMessagingError =
      "Error while sending message. Please try later.";
  static const String broadcastMessagingEmptyAlert =
      "Please enter your message.";
  static const String paymentFailedError =
      "Sorry, your Payment has failed. You were almost there, please try again";
  static const String masteryCompletionAlert =
      "You have already achieved mastery in this topic.";
  static const String assignmentEndDateUpdationError =
      "There is an error while updating the assignment. Please try again in sometime";
  static const String studentRemovalFromBatchError =
      "Unable to remove the student right now. Requesting you to please try again in sometime";
  static const String assignmentRemovalError =
      "We are facing an error while deleting the assignment, please try again later";

  //Success Messages
  static const String dashboardNewMessageSuccess =
      "Your message has been delivered.";
  static const String coachMyiPrepReferralSuccess =
      "Your information has been sent for review. We will get back to you asap.";
  static const String broadcastMessagingSuccess =
      "Your message is successfully delivered to all your students across all the batches";
  static const String paymentSuccess =
      "Congratulations! Your payment was successful. Your iPrep Plan is now activated. Learn Unlimited.";
  static const String assignmentEndDateUpdationSuccess =
      "Assignment end date has been updated";
  static const String assignmentRemovalSuccess = "Assignment has been removed";
  static const String studentBatchJoiningSuccess =
      "You are now added to the selected batch. Enjoy Learning.";
  static const String profileUpdationSuccess =
      "Your profile has been successfully updated";
  static const String contactInformation = "Please add your contact information for further procedures.";
}
