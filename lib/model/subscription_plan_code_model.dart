class CodeInfoModel {
  String? codeName;
  String? codeType;
  int? discountPercent;
  String? district;
  bool? isApplied;
  bool? oneTime;
  String? projectId;
  Schools? schools;
  String? state;
  String? timeStamp;
  UserPlan? userPlan;
  Validity? validity;

  CodeInfoModel(
      {this.codeName,
        this.codeType,
        this.discountPercent,
        this.district,
        this.isApplied,
        this.oneTime,
        this.projectId,
        this.schools,
        this.state,
        this.timeStamp,
        this.userPlan,
        this.validity});

  CodeInfoModel.fromJson(Map<String, dynamic> json) {
    codeName = json['codeName'];
    codeType = json['codeType'];
    discountPercent = json['discountPercent'];
    district = json['district'];
    isApplied = json['isApplied'];
    oneTime = json['oneTime'];
    projectId = json['projectId'];
    schools =
    json['schools'] != null ? Schools.fromJson(json['schools']) : null;
    state = json['state'];
    timeStamp = json['timeStamp'];
    userPlan = json['userPlan'] != null
        ? UserPlan.fromJson(json['userPlan'])
        : null;
    validity = json['validity'] != null
        ? Validity.fromJson(json['validity'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codeName'] = codeName;
    data['codeType'] = codeType;
    data['discountPercent'] = discountPercent;
    data['district'] = district;
    data['isApplied'] = isApplied;
    data['oneTime'] = oneTime;
    data['projectId'] = projectId;
    if (schools != null) {
      data['schools'] = schools!.toJson();
    }
    data['state'] = state;
    data['timeStamp'] = timeStamp;
    if (userPlan != null) {
      data['userPlan'] = userPlan!.toJson();
    }
    if (validity != null) {
      data['validity'] = validity!.toJson();
    }
    return data;
  }
}

class Schools {
  String? schoolAddress;
  String? schoolId;
  String? schoolName;

  Schools({this.schoolAddress, this.schoolId, this.schoolName});

  Schools.fromJson(Map<String, dynamic> json) {
    schoolAddress = json['schoolAddress'];
    schoolId = json['schoolId'];
    schoolName = json['schoolName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['schoolAddress'] = schoolAddress;
    data['schoolId'] = schoolId;
    data['schoolName'] = schoolName;
    return data;
  }
}

class UserPlan {
  String? currencyCode;
  String? currencySymbol;
  String? description;
  String? id;
  int? planDuration;
  String? price;
  int? rawPrice;
  String? title;

  UserPlan(
      {this.currencyCode,
        this.currencySymbol,
        this.description,
        this.id,
        this.planDuration,
        this.price,
        this.rawPrice,
        this.title});

  UserPlan.fromJson(Map<String, dynamic> json) {
    currencyCode = json['currencyCode'];
    currencySymbol = json['currencySymbol'];
    description = json['description'];
    id = json['id'];
    planDuration = json['plan_duration'];
    price = json['price'];
    rawPrice = json['rawPrice'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currencyCode'] = currencyCode;
    data['currencySymbol'] = currencySymbol;
    data['description'] = description;
    data['id'] = id;
    data['plan_duration'] = planDuration;
    data['price'] = price;
    data['rawPrice'] = rawPrice;
    data['title'] = title;
    return data;
  }
}

class Validity {
  Time? time;
  int? userLimit;

  Validity({this.time, this.userLimit});

  Validity.fromJson(Map<String, dynamic> json) {
    time = json['time'] != null ? Time.fromJson(json['time']) : null;
    userLimit = json['user_limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (time != null) {
      data['time'] = time!.toJson();
    }
    data['user_limit'] = userLimit;
    return data;
  }
}

class Time {
  String? endDate;
  String? startDate;

  Time({this.endDate, this.startDate});

  Time.fromJson(Map<String, dynamic> json) {
    endDate = json['endDate'];
    startDate = json['startDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['endDate'] = endDate;
    data['startDate'] = startDate;
    return data;
  }
}




class UseByUser {
  String? userId;
  int? length;

  UseByUser({this.userId, this.length});
}

class OfferCodeData {
  CodeInfoModel? codeInfoModel;
  UseByUser? useByUser;

  OfferCodeData({this.codeInfoModel, this.useByUser});
}

