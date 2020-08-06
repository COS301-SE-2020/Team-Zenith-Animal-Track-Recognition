import 'dart:convert';
import 'dart:io';

import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/fake_api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  
  final NavigationService _navigationService = locator<NavigationService>();
  final Api _api = locator<FakeApi>();

  Future<List<HomeModel>>getRecentIdentifications() async {
    List<HomeModel> recentIdentifications = await _api.getHomeModel();
    return recentIdentifications;
  }

}
  