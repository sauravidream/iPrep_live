import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/model/app_details_model.dart';

class HowTheAppWorksRepository {
  Future fetchAppDetails() async {
    try {
      String _language = (await getStringValuesSF("language"))!.toLowerCase();
      var response = await apiHandler.getAPICall(
          endPointURL: "category_details/$_language");

      if (response == null) return response;
      List<AppDetails> _appDetailsList = [];
      await Future.forEach(response as List, (dynamic appDetails) async {
        AppDetails _appDetails = AppDetails(
          title: appDetails["title"],
          detail: appDetails["detail"],
        );
        _appDetailsList.add(_appDetails);
      }).then((value) {
        return _appDetailsList;
      }).catchError((error) {
        print(error.toString());
      });
      return _appDetailsList;
    } catch (error) {
      print(error);
    }
  }
}
