import 'package:get_it/get_it.dart';
import 'core/services/api.dart';
import 'core/viewmodels/confirm_viewmodel.dart';
import 'core/viewmodels/home_viewmodel.dart';
import 'core/viewmodels/login_viewmodel.dart';
import 'core/viewmodels/info_viewmodel.dart';
import 'core/viewmodels/heatmap_viewmodel.dart';
GetIt locator = GetIt.instance;

void setupLocator()
{
    locator.registerLazySingleton(() => Api());

    locator.registerFactory(() => LoginModel());
    locator.registerFactory(() => HomeModel());
    locator.registerFactory(() => InfoModel());
    locator.registerFactory(() => ConfirmModel());
    locator.registerFactory(() => HeatMapModel());
}