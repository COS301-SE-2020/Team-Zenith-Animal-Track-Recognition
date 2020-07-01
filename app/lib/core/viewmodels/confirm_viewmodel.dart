import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ERP_Ranger/core/services/api.dart';
import 'package:ERP_Ranger/core/services/user.dart';
import 'package:ERP_Ranger/locator.dart';
import 'package:image_picker/image_picker.dart';
import 'base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmModel extends BaseModel{
  final Api _api = locator<Api>();

  Future navigateToHome() async{
  }

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

  String _title = " Confirm View";
  String get title => _title;


}