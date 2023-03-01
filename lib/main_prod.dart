import 'core/config/app_environment.dart';
import 'main_common.dart';

Future<void> main() async {
  await mainCommon(AppEnvironment.RELEASE);
}
