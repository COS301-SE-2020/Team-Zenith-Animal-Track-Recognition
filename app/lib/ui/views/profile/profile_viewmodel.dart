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

class ProfileViewModel extends BaseViewModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final Api _api = locator<FakeApi>();

  Future<TempObject>getRecentIdentifications() async {
    List<ProfileModel> recentIdentifications = await _api.getProfileModel();
    ProfileInfoModel infoModel = await _api.getProfileInfoData();
    TempObject temp = TempObject(animalList: recentIdentifications,infoModel: infoModel);
    return temp;
  }

  void navigateToSearchView(){
    _navigationService.navigateTo(Routes.searchViewRoute);
  }
 
  void navigateToInfo(){
    _navigationService.navigateTo(Routes.identificationViewRoute);
  }

  void navigateToConfirmView(){
    _navigationService.navigateTo(Routes.confirmlViewRoute);
  }
 
  void navigateToNotConfirmView(){
    _navigationService.navigateTo(Routes.notConfirmedViewRoute);
  }

  void captureImage() async
  {
    File image;
    final picker = ImagePicker();
    
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if(pickedFile != null){
      image = File(pickedFile.path);
      String url = base64Encode(image.readAsBytesSync());
      List<ConfirmModel> animals = await _api.identifyImage(url);
      if(animals != null){
        navigateToConfirmView();
      }else{
        navigateToNotConfirmView();
      }
    }

    return null;
  }

}

class TempObject {
  List<ProfileModel> animalList;
  ProfileInfoModel infoModel;
  TempObject({this.animalList,this.infoModel});
}