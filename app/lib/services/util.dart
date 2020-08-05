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

void navigateBack(context) {
  Navigator.of(context).pop();
}

void navigateToSearchView(){
  _navigationService.navigateTo(Routes.searchViewRoute);
}

void navigateToProfile(){
  _navigationService.navigateTo(Routes.profileViewRoute);
}

void navigateToInfo(String name) async{
  print(name);
  InfoModel infoModel = await _api.getInfoModel(name);
  _navigationService.navigateTo(Routes.informationViewRoute,
    arguments: InformationViewArguments(animalInfo:infoModel)
  );
}

void navigateToGallery(String i)async{
  GalleryModel galleryModel = await _api.getGalleryModel(i.toLowerCase());
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

void navigateToLogin(var context){
  Navigator.of(context).pushNamedAndRemoveUntil('/login-view', (route) => false);
}
//============================ Functionality Section ==================================//

//================================ Widget Section =====================================//
Widget logo = new Container(
    alignment: Alignment.center,
    //margin: new EdgeInsets.only(right:5,left:5),
    padding: new EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(10),
      image: DecorationImage(
        image: AssetImage("assets/images/logo.jpeg"),
        fit: BoxFit.fill,
      ),
    ),
    height: 130,
    width: 130,
);

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

Widget imageBlock (String imageLink) {
    return Container(
    alignment: Alignment.center,
    margin: new EdgeInsets.only(left:15,right:10,),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(imageLink),
        fit: BoxFit.fill,
      ),
      color: Colors.grey,
      borderRadius: BorderRadius.circular(15),
    ),
    height: 75,
  );
}

Widget textColumn(String name, String time, String species, String location, String capturedBy){
  return Container(
    height: 75,
    margin: new EdgeInsets.only(right:10,),
    child: Column(
      children: <Widget>[
        Expanded(flex:1,child:Row(children: <Widget>[
          Expanded(flex:1,child: Container(color: Colors.white,child: text18LeftBoldBlack(name),)),
          Expanded(flex:1,child: Container(color: Colors.white,child: text12RighttNormGrey(time),)),
        ],)),
        Expanded(flex:1,child:Row(children: <Widget>[
          Expanded(flex:1,child: Container(color: Colors.white,child: text12LeftNormBlack("Species: "),)),
          Expanded(flex:2,child: Container(color: Colors.white,child: text12LeftNormGrey(species,),)),
        ],)),      
        Expanded(flex:1,child:Row(children: <Widget>[
          Expanded(flex:1,child: Container(color: Colors.white,child: text12LeftNormBlack("Location: "),)),
          Expanded(flex:2,child: Container(color: Colors.white,child: text12LeftNormGrey(location),)),
        ],)),
        Expanded(flex:1,child:Row(children: <Widget>[
          Expanded(flex:1,child: Container(color: Colors.white,child: text12LeftNormBlack("Captured by: "),)),
          Expanded(flex:2,child: Container(color: Colors.white,child: text12LeftNormGrey(capturedBy),)),
        ],)),    ],
    ),
  );
}

Widget textRow(String accuracy){
  return Row(children: <Widget>[
    Expanded(flex: 2,child: text14LeftBoldGrey("ACCURACY SCORE")),
    Expanded(flex: 1,child: text14RightBoldGrey(accuracy)),
  ],);
}

Widget bottomNavigationText(String title, var context){
  return Text(
    title,
    textAlign: TextAlign.right,
    style: Theme.of(context).textTheme.subtitle1
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

//================================ Widget Section =====================================//

//================================ Text Section 1=====================================//

Widget text22LeftBoldBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text22CenterBoldBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}  

Widget text22RighttBoldBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}       
        
Widget text22LeftNormBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text22CenterNormBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text22RighttNormBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text22LeftBoldGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text22CenterBoldGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text22RighttBoldGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}       
        
Widget text22LeftNormGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text22CenterNormGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text22RightNormGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text22LeftBoldWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text22CenterBoldWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text22RightBoldWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}       
        
Widget text22LeftNormWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text22CenterNormWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text22RightNormWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}

//================================ Text Section 1=====================================//

//================================ Text Section 2=====================================//

Widget text20LeftBoldBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text20CenterBoldBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text20RightBoldBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}       
        
Widget text20LeftNormBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text20CenterNormBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text20RightNormBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text20LeftBoldGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text20CenterBoldGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text20RightBoldGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}       
        
Widget text20LeftNormGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text20CenterNormGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text20RightNormGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text20LeftBoldWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text20CenterBoldWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text20RightBoldWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}       
        
Widget text20LeftNormWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text20CenterNormWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text20RightNormWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}

//================================ Text Section 2=====================================//

//================================ Text Section 3=====================================//

Widget text18LeftBoldBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text18CenterBoldBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text18RightBoldBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}       
        
Widget text18LeftNormBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text18CenterNormalBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text18RightNormBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text18LeftBoldGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text18CenterBoldGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text18RightBoldGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}       
        
Widget text18LeftNormGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text18CenterNormalGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text18RightNormGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text18LeftBoldWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text18CenterBoldWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text18RightBoldWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}       
        
Widget text18LeftNormWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text18CenterNormalWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text18RightNormWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}

//================================ Text Section 3=====================================//

//================================ Text Section 4=====================================//

Widget text16LeftBoldBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text16CenterBoldBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text16RightBoldBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}       
        
Widget text16LeftNormBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text16CenterNormalBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text16RightNormBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text16LeftBoldGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text16CenterBoldGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text16RightBoldGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}       
        
Widget text16LeftNormGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text16CenterNormalGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text16RightNormGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text16LeftBoldWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text16CenterBoldWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text16RightBoldWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}       
        
Widget text16LeftNormWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text16CenterNormalWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text16RightNormWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}

//================================ Text Section 4=====================================//

//================================ Text Section 5=====================================//

Widget text14LeftBoldBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text14CenterBoldBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text14RightBoldBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}       
        
Widget text14LeftNormBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text14CenterNormalBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text14RightNormBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text14LeftBoldGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text14CenterBoldGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text14RightBoldGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}       
        
Widget text14LeftNormGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text14CenterNormalGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text14RightNormGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text14LeftBoldWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text14CenterBoldWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text14RightBoldWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}       

Widget text14LeftNormWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text14CenterNormWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text14RightNormWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}

//================================ Text Section 5=====================================//

//================================ Text Section 5=====================================//

Widget text12LeftBoldBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text12CenterBoldBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text12RighttBoldBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}       
        
Widget text12LeftNormBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text12CenterNormBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text12RighttNormBlack(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text12LeftBoldGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text12CenterBoldGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget tBoldGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}       

Widget text12LeftNormGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text12CenterNormGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text12RighttNormGrey(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
      fontFamily: 'MavenPro',
    ), 
  );
}

Widget text12LeftBoldWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text12CenterBoldWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
} 

Widget text12RighttBoldWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}       
        
Widget text12LeftNormWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}        

Widget text12CenterNormWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
} 

Widget text12RighttNormWhite(String value){
  return Text(
    value, 
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      fontFamily: 'MavenPro',
    ), 
  );
}

//================================ Text Section 6=====================================//