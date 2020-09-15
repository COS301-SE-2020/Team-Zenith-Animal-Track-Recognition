import 'dart:convert';
import 'dart:io';

import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/mock_api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BottomNavModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final Api _api = locator<MockApi>();

  Future<int> getUserLevel() async {
    int userlevel = await _api.getUserLevel();
    return userlevel;
  }

  // void navigateToSearchView(){
  //   _navigationService.navigateTo(Routes.searchViewRoute);
  // }

  // void navigateToInfo(){
  //   _navigationService.navigateTo(Routes.identificationViewRoute);
  // }

  // void navigateToConfirmView(){
  //   _navigationService.navigateTo(Routes.confirmlViewRoute);
  // }

  // void navigateToNotConfirmView(){
  //   _navigationService.navigateTo(Routes.notConfirmedViewRoute);
  // }

}
