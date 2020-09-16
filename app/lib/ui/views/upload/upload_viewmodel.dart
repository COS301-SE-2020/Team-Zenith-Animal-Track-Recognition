import 'dart:convert';
import 'dart:io';
import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/graphQL.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

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

  bool _showCameraError = false;
  bool get showCameraError => _showCameraError;

  bool _showGalleryError = false;
  bool get showGalleryError => _showGalleryError;

  bool _showAnimalError = false;
  bool get showAnimalError => _showAnimalError;

  String _animalErrorString;
  String get animalErrorString => _animalErrorString;

  bool _showTagError = false;
  bool get showTagError => _showTagError;

  String _tagErrorString;
  String get tagErrorString => _tagErrorString;

  bool _showLongError = false;
  bool get showLongError => _showLongError;

  String _longErrorString;
  String get longErrorString => _longErrorString;

  bool _showLatError = false;
  bool get showLatError => _showLatError;

  String _latErrorString;
  String get latErrorString => _latErrorString;

  final NavigationService _navigationService = locator<NavigationService>();
  final Api api = locator<GraphQL>();

  Future<List<String>> getSuggestions(String query) async {
    List<String> matches = List();
    await this.setAnimals();

    if (query == "") {
      if (_animals.length > 2) {
        for (int i = 0; i < 2; i++) {
          matches.add(_animals[i]);
        }
      } else {
        matches.addAll(_animals);
      }
    } else {
      matches.addAll(_animals);
      matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    }

    return matches;
  }

  Future<List<String>> getTagSuggestions(String query) async {
    List<String> matches = List();
    await this.addTags();

    if (query == "") {
      if (_tags.length > 3) {
        for (int i = 0; i < 3; i++) {
          matches.add(_tags[i]);
        }
      } else {
        matches.addAll(_tags);
      }
    } else {
      matches.addAll(_tags);
      matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    }

    return matches;
  }

  Future<void> setAnimals() async {
    _animals = await api.getAnimalTags();
    _animals.add(" ");
  }

  Future<void> addTags() async {
    _tags = await api.getTags();
    tags.add(" ");
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

  void setLong(String long) {
    _longitude = long;
  }

  void setLat(String lat) {
    _latitude = lat;
  }

  bool validateLongInput() {
    if (_longitude == null) {
      print("000000");
      _showLongError = true;
      _longErrorString = "Longitude input cannot be let empty";
    } else {
      bool isValid = false;
      if (RegExp(
              r"^(\+|-)?(?:180(?:(?:\.0{1,6})?)|(?:[0-9]|[1-9][0-9]|1[0-7][0-9])(?:(?:\.[0-9]{1,6})?))$")
          .hasMatch(_longitude)) {
        isValid = true;
      }
      if (isValid == false) {
        _showAnimalError = true;
        _longErrorString = "Invalid longitude value";
      }
    }
    return _showAnimalError;
  }

  bool validateLatInput() {
    if (_latitude == null) {
      _showLatError = true;
      _latErrorString = "Latitude input cannot be let empty";
    } else {
      bool isValid = false;
      if (RegExp(
              r"^(\+|-)?(?:90(?:(?:\.0{1,6})?)|(?:[0-9]|[1-8][0-9])(?:(?:\.[0-9]{1,6})?))$")
          .hasMatch(_latitude)) {
        isValid = true;
      }
      if (isValid == false) {
        _showLatError = true;
        _latErrorString = "Invalid Latitude value";
      }
    }
    return _showAnimalError;
  }

  bool validateAnimalInput() {
    if (chosenAnimal == null) {
      _showAnimalError = true;
      _animalErrorString = "Animal name input cannot be let empty";
    } else {
      bool isValid = false;
      for (int i = 0; i < _animals.length; i++) {
        if (chosenAnimal == _animals[i]) {
          _showAnimalError = false;
          isValid = true;
        }
      }
      if (isValid == false) {
        _showAnimalError = true;
        _animalErrorString = "Animal name is not found";
      }
    }
    print(_showAnimalError);
    return _showAnimalError;
  }

  bool validateTagInput() {
    if (tag == null) {
      _showTagError = true;
      _tagErrorString = "Tags field cannot be let empty";
    } else {
      bool isValid = false;
      for (int i = 0; i < tags.length; i++) {
        if (tag == tags[i]) {
          _showTagError = false;
          isValid = true;
        }
      }
      if (isValid == false) {
        _showTagError = true;
        _tagErrorString = "Tag not found";
      }
    }
    return _showTagError;
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
      _showCameraError = false;
      _showGalleryError = false;
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
      _showCameraError = false;
      _showGalleryError = false;
      notifyListeners();
    }

    return null;
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
    bool showErrors = false;
    if (_showCameraError == true || _showGalleryError == true) {
      _showCameraError = true;
      _showGalleryError = true;
      showErrors = true;
    }
    validateAnimalInput();
    validateTagInput();
    validateLongInput();
    validateLatInput();
    if (_showAnimalError ||
        _showTagError ||
        _showLongError ||
        _showLatError ||
        showErrors) {
      notifyListeners();
    } else {
      _longitude = null;
      _latitude = null;
      _valueCamera = false;
      _valueGallery = false;
      _showCameraError = false;
      _showGalleryError = false;
      _showAnimalError = false;
      _showTagError = false;
      _showLongError = false;
      _showLatError = false;
      _latErrorString = null;
      _longErrorString = null;
      _animalErrorString = null;
      _tagErrorString = null;

      notifyListeners();
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
}
