import 'package:ERP_Ranger/locator.dart';
import 'package:ERP_Ranger/core/services/api.dart';
import 'package:ERP_Ranger/core/services/user.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadModel extends BaseModel{
final Api _api = locator<Api>();
 Future<String> imagePicker() async{
    File image;
    final picker = ImagePicker();

    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null){
      image = File(pickedFile.path);
      String url = base64Encode(image.readAsBytesSync());
      
      return url;
    }else{
      return "";
    }

  }

  Future<List<User>> imageID() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    File image;
    final picker = ImagePicker();

    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null){
      image = File(pickedFile.path);
      String url = base64Encode(image.readAsBytesSync());
      List<User> animals = await _api.idetify(url);
      prefs.setBool("loaded", true);
      return animals;
    }

    return null;
  }
}