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
  int _tagIndex;
  int get tagIndex => _tagIndex;
 
  File _image;
  File get image => _image;

  String _imageLink;
  String get imageLink => _imageLink;

  bool _valueCamera = false;
  bool get valueCamera => _valueCamera;

  bool _valueGallery = false;
  bool get valueGallery => _valueGallery;

  String _longitude;
  String get longitude => _longitude;

  String _latitude;
  String get latitude => _latitude;

  List<String> _tags = new List<String>();
  List<String>  get tags => _tags;
  

  final NavigationService _navigationService = locator<NavigationService>();
  final Api _api = locator<FakeApi>();

  void navigate(context) {
     Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  void setTags(){
    _tags.clear();
    _tags.add("Dangerous");
    _tags.add("Endangered");
    _tags.add("Harmless");
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

  void uploadFromCamera()async{
    File image;
    final picker = ImagePicker(); 
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if(pickedFile != null){
      image = File(pickedFile.path);
      _image = image;
      String url = base64Encode(image.readAsBytesSync());
      _imageLink = url;
      _valueCamera = true;
      _valueGallery = false;
      notifyListeners();
    }
    _valueCamera = true;
    notifyListeners();
    return null;
  }
 
  void uploadFromGallery()async{
    File image;
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null){
      image = File(pickedFile.path);
      _image = image;
      String url = base64Encode(image.readAsBytesSync());
      _imageLink = url;
      _valueCamera = false;
      _valueGallery = true;
      notifyListeners();
    }
    _valueGallery = false;
    notifyListeners();
    return null;
  }

  void updateLong(String value) {
    _longitude = value;
    print(_longitude);
    notifyListeners();
  }

  void updateLat(String value) {
    _latitude = value;
    print(_latitude);
    notifyListeners();
  }

  void upload() {
    _image = null;
    _latitude = "";
    _longitude = "";
    _valueGallery = false;
    _valueCamera = false;
    _tagIndex = null;
  }
}
