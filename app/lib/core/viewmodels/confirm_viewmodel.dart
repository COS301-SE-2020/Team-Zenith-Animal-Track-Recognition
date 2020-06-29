import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'base_model.dart';
class ConfirmModel extends BaseModel{

  Future navigateToHome() async{
  }

  Future<bool> imagePicker() async{
    File image;
    final picker = ImagePicker();

    final pickedFile = await picker.getImage(source: ImageSource.camera);
    image = File(pickedFile.path);
    //String url = base64Encode(image.readAsBytesSync());
    //Map map = {};
    //_api.updateImage(url, map);
    //print(image);
    return true;
  }
  String _title = " Confirm View";
  String get title => _title;


}