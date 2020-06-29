import 'package:ERP_Ranger/core/services/api.dart';
import 'package:ERP_Ranger/core/services/user.dart';
import 'package:ERP_Ranger/locator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'base_model.dart';


class HomeModel extends BaseModel{
  final Api _api = locator<Api>();

  Future<bool> imagePicker() async{
    File image ;
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if(pickedFile.path != null){
      image = File(pickedFile.path);
    }
    //String url = base64Encode(image.readAsBytesSync());
    //Map map = {};
    //_api.updateImage(url, map);
    //print(image);
    return true;
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

