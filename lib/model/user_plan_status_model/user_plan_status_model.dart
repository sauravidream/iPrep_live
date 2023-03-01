class ActivationModel{
  ActivationModel({
    this.packageName,
    this.userData,
  });

  String? packageName;
  String? userData;

  Map<String, dynamic> toJson() => {
    "package_name": packageName,
    "user_data": userData,
  };
}

class ActivationResponseModel{
  ActivationResponseModel({
    this.errorMessage,
    this.message
  });

  String? errorMessage;
  String? message;

  factory ActivationResponseModel.fromJson(Map<String, dynamic> json) => ActivationResponseModel(
    errorMessage: json["error_message"],
    message: json["message"],
  );
}
