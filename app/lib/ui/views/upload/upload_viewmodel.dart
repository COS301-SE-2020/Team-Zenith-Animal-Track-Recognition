import 'dart:convert';
import 'dart:io';
import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/graphQL.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class UploadViewModel extends BaseViewModel {
  String tag;
  int _tagIndex;
  String chosenAnimal;

  List<String> _animals;
  List<String> get animals => _animals;

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
  List<String> get tags => _tags;

  final Api api = locator<GraphQL>();

  List<String> getSuggestions(String query) {
    List<String> matches = List();
    this.setAnimals();
    matches.addAll(_animals);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  Future<void> setAnimals() async {
    _animals = await api.getAnimalTags();
    _animals.add(" ");
  }

  void setTag(String tag) {
    this.tag = tag;
  }

  void setTagIndex(int index) {
    _tagIndex = index;
  }

  void setChosenAnimal(String animal) {
    chosenAnimal = animal;
  }

  void uploadFromCamera() async {
    File image;
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      _image = image;
      String url = base64Encode(image.readAsBytesSync());
      _imageLink = url;
      _valueCamera = true;
      _valueGallery = false;
      notifyListeners();
    }
    return null;
  }

  void uploadFromGallery() async {
    File image;
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      _image = image;
      String url = base64Encode(image.readAsBytesSync());
      _imageLink = url;
      _valueCamera = false;
      _valueGallery = true;
      notifyListeners();
    }

    return null;
  }

  void addTag(String value) {
    _tags.add(value);
    notifyListeners();
  }

  void updateLong(String value) {
    _longitude = value;
    notifyListeners();
  }

  void updateLat(String value) {
    _latitude = value;
    notifyListeners();
  }

  Future<void> upload() async {
    // double id = await api.getAnimalID(chosenAnimal);

    // Position position =
    //     await getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);

    // ConfirmModel animal = await api.manualClassification(
    //     _imageLink, position.latitude, position.longitude, id, _tags);

    // _navigationService.navigateTo(Routes.userConfirmedViewRoute,
    //     arguments: UserConfirmedViewArguments(
    //         image: _image, confirmedAnimal: animal, tags: _tags));
  }
}
