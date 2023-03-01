class AppDetails {
  String? title;
  String? detail;

  AppDetails.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        detail = json['detail'];

  // Map<String, dynamic> toJson() => {
  //   if (id != null) 'id': id,
  //   if (name != null) 'name': name,
  //   if (description != null) 'description': description,
  //   if (alreadySelected != null) 'alreadySelected': alreadySelected,
  // };

  AppDetails({
    this.title,
    this.detail,
  });
}
