import 'dart:convert';
import 'dart:io';

import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/fake_api.dart';
import 'package:ERP_RANGER/services/api/graphQL.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfileViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final Api _api = locator<FakeApi>();
  final Api api = locator<GraphQL>();

  Future<TempObject> getRecentIdentifications() async {
    List<ProfileModel> recentIdentifications = await api.getProfileModel();
    ProfileInfoModel infoModel = await _api.getProfileInfoData();
    int userlevel = await _api.getUserLevel();
    TempObject temp = TempObject(
        animalList: recentIdentifications,
        infoModel: infoModel,
        userLevel: userlevel);
    return temp;
  }
}

class TempObject {
  List<ProfileModel> animalList;
  ProfileInfoModel infoModel;
  int userLevel;
  TempObject({this.animalList, this.infoModel, this.userLevel});
}
