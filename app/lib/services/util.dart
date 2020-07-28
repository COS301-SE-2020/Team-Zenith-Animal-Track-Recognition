import 'dart:convert';
import 'dart:io';

import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/fake_api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';
  
final NavigationService _navigationService = locator<NavigationService>();
final Api _api = locator<FakeApi>();

//============================ Functionality Section ==================================//

Future<bool> getLoggedIn() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool loggedIn = prefs.getBool('loggedIn') ?? false;
  return true; 
}

void captureImage() async{
    File image;
    final picker = ImagePicker();
    
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null){
      image = File(pickedFile.path);
      String url = base64Encode(image.readAsBytesSync());
      List<ConfirmModel> animals = await _api.identifyImage(url);
      animals = null;
      if(animals != null){
        _navigationService.navigateTo(Routes.confirmlViewRoute,
          arguments: ConfirmedViewArguments(image: image, confirmedAnimals:animals )
        );
      }else{
        _navigationService.navigateTo(Routes.notConfirmedViewRoute,
          arguments: NotConfirmedViewArguments(image: image)
        );
      }
    }

    return null;
  }

void recapture(var context) async{
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
     //Navigator.of(context).popAndPushNamed("/confirmed-view",arguments:image);
    }else{
      Navigator.of(context).popAndPushNamed("/not-confirmed-view",arguments:image);
    }
  }
}
    
void navigate(context) {
  Navigator.popUntil(context, ModalRoute.withName('/'));
}

void navigateToSearchView(){
  _navigationService.navigateTo(Routes.searchViewRoute);
}

void navigateToInfo(String name) async{
  print(name);
  InfoModel infoModel = await _api.getInfoModel(name);
  _navigationService.navigateTo(Routes.informationViewRoute,
    arguments: InformationViewArguments(animalInfo:infoModel)
  );
}

void navigateToGallery(String i)async{
  GalleryModel galleryModel = await _api.getGalleryModel(i);
  _navigationService.navigateTo(Routes.gallerylViewRoute,
    arguments: GalleryViewArguments(galleryModel: galleryModel)
  );
}

void navigateToIdentification(String animal)async {    
  await _navigationService.navigateTo(
    Routes.identificationViewRoute,
    arguments: IdentificationViewArguments(name:animal)
  );
}

//============================ Functionality Section ==================================//

//================================ Widget Section =====================================//

Widget progressIndicator(){
  return Container(
    color: Colors.white,
    child: Center(
      child: CircularProgressIndicator(
        value: 5,
        backgroundColor: Colors.blue,
      )
    ),
  ); 
}

Widget appBarTitle(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.left,
    style: Theme.of(context).textTheme.headline1,
  );
}

Widget cardTitle(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.left,
    style: Theme.of(context).textTheme.headline2,
  );
}

Widget cardTextLeft(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.left,
    style: Theme.of(context).textTheme.bodyText1,
  );
}

Widget cardTextValue(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.left,
    style: Theme.of(context).textTheme.bodyText2,
  );
}

Widget cardTextRight(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.right,
    style: Theme.of(context).textTheme.bodyText2,
  );
}

Widget animalViewCardBodyText(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.left,
    style: Theme.of(context).textTheme.headline4,
  );
}

Widget animalViewCardBodyTextRight(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.right,
    style: Theme.of(context).textTheme.headline4,
  );
}

Widget homeViewAccuracyScoreLeft(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.left,
    style: Theme.of(context).textTheme.subtitle1
  );
}

Widget homeViewAccuracyScoreRight(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.right,
    style: Theme.of(context).textTheme.subtitle1
  );
}

Widget tagText(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.center,
    style: Theme.of(context).textTheme.headline6
  );
}

Widget bottomNavigationText(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.right,
    style: Theme.of(context).textTheme.subtitle1
  );
}

Widget animalViewCardTitle(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.right,
    style: Theme.of(context).textTheme.subtitle1
  );
}

Widget tabBarTitles(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.center,
    style: Theme.of(context).textTheme.headline3
  );
}

Widget descriptionText(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.left,
    style: Theme.of(context).textTheme.subtitle1
  );
}

Widget confirmViewTitle(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.left,
    style: Theme.of(context).textTheme.headline2
  );
}

Widget confirmViewSubTitle(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.left,
    style: Theme.of(context).textTheme.subtitle1
  );
}

Widget confirmViewAnimalTitle(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.left,
    style: Theme.of(context).textTheme.headline2,
  );
}

Widget percentageText(String title, double font){
  return Text(
    title,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: font,
      fontFamily: 'MavenPro',
      fontWeight: FontWeight.bold,
      color: Colors.black
    ),
  );
}

Widget confirmViewConfidentDetailsRight(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.right,
    style: Theme.of(context).textTheme.bodyText2,
  );
}

Widget confirmViewConfidentDetailsLeft(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.left,
    style: Theme.of(context).textTheme.bodyText1,
  );
}

Widget confirmViewSimilarSpoorTextName(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.left,
    style: Theme.of(context).textTheme.bodyText1,
  );
}

Widget confirmViewSimilarSpoorText(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.left,
    style: Theme.of(context).textTheme.bodyText2,
  );
}

Widget confirmViewTagText(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.left,
    style: Theme.of(context).textTheme.bodyText1,
  );
}

Widget confirmViewIconButtonText(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.left,
    style: Theme.of(context).textTheme.bodyText2,
  );
}

Widget notConfirmViewTitle(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.left,
    style: Theme.of(context).textTheme.headline2
  );
}

Widget notConfirmViewSubTitle(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.left,
    style: Theme.of(context).textTheme.subtitle1
  );
}

Widget notConfirmViewIconButtonText(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.left,
    style: Theme.of(context).textTheme.bodyText2,
  );
}

Widget nameText(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.left,
    style: Theme.of(context).textTheme.subtitle2,
  );
}
//================================ Widget Section =====================================//