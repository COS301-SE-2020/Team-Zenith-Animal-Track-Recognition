// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:ERP_RANGER/services/third_party_services_module.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:ERP_RANGER/services/api/graphQL.dart';
<<<<<<< Updated upstream
=======
import 'package:ERP_RANGER/services/identification_service.dart';
import 'package:ERP_RANGER/services/api/mock_api.dart';
>>>>>>> Stashed changes
import 'package:get_it/get_it.dart';

void $initGetIt(GetIt g, {String environment}) {
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  g.registerLazySingleton<DialogService>(
      () => thirdPartyServicesModule.dialogService);
  g.registerLazySingleton<GraphQL>(() => GraphQL());
<<<<<<< Updated upstream
=======
  g.registerLazySingleton<IdentificationService>(() => IdentificationService());
  g.registerLazySingleton<MockApi>(() => MockApi());
>>>>>>> Stashed changes
  g.registerLazySingleton<NavigationService>(
      () => thirdPartyServicesModule.navigationService);
  g.registerLazySingleton<SnackbarService>(
      () => thirdPartyServicesModule.snackBarService);
}

class _$ThirdPartyServicesModule extends ThirdPartyServicesModule {
  @override
  DialogService get dialogService => DialogService();
  @override
  NavigationService get navigationService => NavigationService();
  @override
  SnackbarService get snackBarService => SnackbarService();
}
