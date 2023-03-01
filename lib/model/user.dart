class AppUser {
  String? userID;
  String? fullName;
  String? age;
  String? address;
  String? gender;
  String? boardID;
  String? classID;
  String? city;
  String? email;
  String? dateOfBirth;
  // String dateStarted;
  String? deviceID;
  String? educationBoard;
  // String isSDCardAvailable;
  String? language;
  String? mobile;
  String? parentContact;
  String? school;
  String? packageLanguage;
  String? studentClass;
  String? stream;
  String? state;
  String? version;
  String? token;
  TotalTime? totalTime;
  String? userType;
  UserPlans? userPlans;
  String? profilePhoto;
  List<LoggedInDevices>? loggedInDevices;
  UserProfile? userProfile;

  AppUser.fromJson(Map<String, dynamic> json)
      : fullName = json['full_name'],
        age = json['age'],
        gender = json["gender"],
        dateOfBirth = json["date_of_birth"],
        address = json['address'],
        boardID = json['board_id'],
        classID = json['class_id'],
        version = json['version'] ?? "",
        city = json['city'],
        email = json['email'],
        deviceID = json['device_id'],
        educationBoard = json['education_board'],
        language = json['language'],
        mobile = json['mobile'],
        parentContact = json['parent_contact'],
        school = json['school'],
        packageLanguage = json['package_language'],
        studentClass = json['student_class'],
        state = json['state'],
        token = json['token'],
        totalTime = json['total_time'],
        userType = json['user_type'],
        userPlans = UserPlans.fromJson(json['users_plans']),
        profilePhoto = json['profile_photo'],
        loggedInDevices = json['device_info']
            ?.values
            ?.map<LoggedInDevices>((i) => LoggedInDevices.fromJson(i))
            ?.toList(),
        userProfile = json['users_profile'] != null
            ? UserProfile.fromJson(json['users_profile'] ?? '')
            : null;

  AppUser(
      {this.userID,
      this.fullName,
      this.age,
      this.gender,
      this.dateOfBirth,
      this.address,
      this.email,
      this.boardID,
      this.classID,
      this.city,
      this.deviceID,
      this.educationBoard,
      this.language,
      this.mobile,
      this.parentContact,
      this.school,
      this.packageLanguage,
      this.studentClass,
      this.stream,
      this.version,
      this.state,
      this.token,
      this.totalTime,
      this.userType,
      this.userPlans,
      this.profilePhoto,
      this.userProfile});
}

class TotalTime {
  String? videoLessons;
  String? ncertBooks;
  String? testPapers;

  TotalTime.fromJson(Map<String, dynamic> json)
      : videoLessons = (json == null) ? "" : json['video_lessons'],
        ncertBooks = (json == null) ? "" : json['ncert_books'],
        testPapers = (json == null) ? "" : json['test_papers'];

  //       Map<String, dynamic> toJson() => {
  //   if (id != null) 'id': id,
  //   if (name != null) 'name': name,
  //   if (description != null) 'description': description,
  //   if (alreadySelected != null) 'alreadySelected': alreadySelected,
  // };

  TotalTime({this.videoLessons, this.ncertBooks, this.testPapers});
}

class UserPlans {
  String? dateStarted;
  String? planDuration;
  String? status;

  UserPlans.fromJson(Map<String, dynamic>? json)
      : dateStarted = (json == null) ? "" : json['date_started'],
        planDuration = (json == null) ? "" : json['plan_duration'],
        status = (json == null) ? "" : json['status'];

  UserPlans({this.dateStarted, this.planDuration, this.status});
}

class LoggedInDevices {
  String? deviceId;
  String? logInTime;

  LoggedInDevices.fromJson(Map<String, dynamic> json)
      : deviceId = json['device_id'],
        logInTime = json['log_in_time'];

  LoggedInDevices({
    this.deviceId,
    this.logInTime,
  });
}

//MigratedUserDetails

class UsersPlans {
  String? dateStarted;
  String? planDuration;
  String? status;

  UsersPlans({this.dateStarted, this.planDuration, this.status});

  UsersPlans.fromJson(Map<String, dynamic> json) {
    dateStarted = json['dateStarted'];
    planDuration = json['planDuration'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['dateStarted'] = dateStarted;
    data['planDuration'] = planDuration;
    data['status'] = status;
    return data;
  }
}

// User Profile data for the dashboard

class UserProfile {
  Location? location;
  String? userBoard;
  String? userClass;
  String? userLanguage;
  String? userRegistrationDate;

  UserProfile(
      {this.location,
      this.userBoard,
      this.userClass,
      this.userLanguage,
      this.userRegistrationDate});

  UserProfile.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    userBoard = json['user_board'];
    userClass = json['user_class'];
    userLanguage = json['user_language'];
    userRegistrationDate = json['user_registration_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['user_board'] = this.userBoard;
    data['user_class'] = this.userClass;
    data['user_language'] = this.userLanguage;
    data['user_registration_date'] = this.userRegistrationDate;
    return data;
  }
}

class Location {
  String? administrativeArea;
  String? isoCountryCode;
  String? locality;
  String? locationName;
  String? postalCode;
  String? street;
  String? subLocality;
  String? subThoroughfare;
  String? thoroughfare;

  Location(
      {this.administrativeArea,
      this.isoCountryCode,
      this.locality,
      this.locationName,
      this.postalCode,
      this.street,
      this.subLocality,
      this.subThoroughfare,
      this.thoroughfare});

  Location.fromJson(Map<String, dynamic> json) {
    administrativeArea = json['administrativeArea'];
    isoCountryCode = json['isoCountryCode'];
    locality = json['locality'];
    locationName = json['locationName'];
    postalCode = json['postalCode'];
    street = json['street'];
    subLocality = json['subLocality'];
    subThoroughfare = json['subThoroughfare'];
    thoroughfare = json['thoroughfare'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['administrativeArea'] = this.administrativeArea;
    data['isoCountryCode'] = this.isoCountryCode;
    data['locality'] = this.locality;
    data['locationName'] = this.locationName;
    data['postalCode'] = this.postalCode;
    data['street'] = this.street;
    data['subLocality'] = this.subLocality;
    data['subThoroughfare'] = this.subThoroughfare;
    data['thoroughfare'] = this.thoroughfare;
    return data;
  }
}
