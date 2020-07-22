import 'dart:convert';
import 'dart:io';
import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/fake_api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UploadViewModel extends BaseViewModel{
  String tag;
  int _tagIndex = 0;
  int get tagIndex => _tagIndex;

  bool _value = false;
  bool get value => _value;

  final NavigationService _navigationService = locator<NavigationService>();
  final Api _api = locator<FakeApi>();

  void navigate(context) {
     Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  void setTag(String  tag){
    this.tag = tag;
  }

  void setTagIndex(int index){
    _tagIndex = index;
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
  }

  void uploadFromCamera()async{
    File image;
    final picker = ImagePicker(); 
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if(pickedFile != null){
      image = File(pickedFile.path);
      String url = base64Encode(image.readAsBytesSync());
      _value = true;
    }else{
      _value =false;
    }
    
  }
 
  void uploadFromGallery()async{
    File image;
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null){
      image = File(pickedFile.path);
      String url = base64Encode(image.readAsBytesSync());
      _value = true;
    }else{
      _value =false;
    }
    
  }
}
