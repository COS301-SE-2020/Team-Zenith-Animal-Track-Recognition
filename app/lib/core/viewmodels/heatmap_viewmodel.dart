import 'package:ERP_Ranger/locator.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'base_model.dart';

class HeatMapModel extends BaseModel{

 Future<bool> imagePicker() async{
    File image;
    final picker = ImagePicker();

    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    image = File(pickedFile.path);
    //String url = base64Encode(image.readAsBytesSync());
    //Map map = {};
    //_api.updateImage(url, map);
    //print(image);
    return true;
  }

}