import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:idream/common/exception_handler.dart';
import 'package:idream/custom_widgets/custom_pop_up.dart';
import 'package:idream/model/user_plan_status_model/user_plan_status_model.dart';

class UserActivationRepository {
  Dio dio = Dio();
  Future<ActivationResponseModel?> userActivation(
      ActivationModel data, context) async {
    try {
      final userActivation = await dio.post(
        "https://learn.iprep.in/api/testprep/activate",
        data: data,
      );
      log(userActivation.data.toString());
      if (userActivation.statusCode == 200) {
        final response = ActivationResponseModel.fromJson(userActivation.data);
        return response;
      }
    } on DioError catch (e) {
      final errorMessage = DioException.fromDioError(e).toString();
      testUserPlanStatusPopUp(
          context: context,
          titleHd: "Alert",
          titleBd: errorMessage,
          buttonText: "Cancel");
    }
    return null;
  }
}
