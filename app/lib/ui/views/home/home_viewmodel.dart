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

  void navigateToSearchView(){
    _navigationService.navigateTo(Routes.searchViewRoute);
  }
 
  void navigateToIdentification(String animal)async {
    
    await _navigationService.navigateTo(
      Routes.identificationViewRoute,
      arguments: IdentificationViewArguments(name:animal)
    );
  }
 
  void navigateToNotConfirmView(){
    _navigationService.navigateTo(Routes.notConfirmedViewRoute);
  }

  void captureImage() async
  {
    File image;
    final picker = ImagePicker();
    
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null){
      image = File(pickedFile.path);
      String url = base64Encode(image.readAsBytesSync());
      List<ConfirmModel> animals = await _api.identifyImage(url);
      if(animals != null){
        _navigationService.navigateTo(Routes.confirmlViewRoute,
          arguments: ConfirmedViewArguments(image: image, confirmedAnimals:animals )
        );
      }else{
        navigateToNotConfirmView();
      }
    }

    return null;
  }

}
  