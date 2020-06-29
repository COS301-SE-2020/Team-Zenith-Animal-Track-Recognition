import 'package:ERP_Ranger/locator.dart';
import 'package:ERP_Ranger/locator.dart';
import '../services/user.dart';
import 'package:ERP_Ranger/core/services/api.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';



class InfoModel extends BaseModel{
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


  String _title = " Info View";
  String get title => _title;


}