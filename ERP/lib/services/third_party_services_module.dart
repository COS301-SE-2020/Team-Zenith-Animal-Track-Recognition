import 'package:injectable/injectable.dart';

import 'package:stacked_services/stacked_services.dart';
import 'package:injectable/injectable.dart';

abstract class ThirdPartyServicesModule{
  @lazySingleton
  NavigationService get navigationService;
  @lazySingleton
  DialogService get dialogService;
  @lazySingleton
  SnackbarService get snackBarService;
}