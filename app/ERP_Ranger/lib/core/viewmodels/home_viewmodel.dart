import 'dart:convert';
import 'package:ERP_Ranger/core/services/api.dart';
import 'package:ERP_Ranger/core/services/user.dart';
import 'package:ERP_Ranger/locator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeModel extends BaseModel{
  final Api _api = locator<Api>();

  Future<List<User>> imagePicker() async{
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

  
  Future navigateTo() async{
  }


  Future<List<User>> getResults() async {
      return _api.getResults();
  }

  void updateCounter(){
    notifyListeners();
  }

}

