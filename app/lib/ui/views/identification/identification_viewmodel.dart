import 'dart:ui';

import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/fake_api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:social_share/social_share.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:image_downloader/image_downloader.dart';

import '../../../main.dart';

class IdentificationViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final Api _api = locator<FakeApi>();

  SpoorModel _confident;
  List<SpoorModel> _recentIdentifications;
  SimilarSpoorModel _similarSpoorModel;
  bool loaded = false;

  SpoorModel get confident => _confident;
  List<SpoorModel> get recentIdentifications => _recentIdentifications;
  SimilarSpoorModel get similarSpoorModel => _similarSpoorModel;

  String url =
      "https://images.unsplash.com/photo-1596467328033-1122519a3b16?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2134&q=80";
  String get getUrl => url;

  Future<void> shareImage() async {
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(
          "https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png");
      if (imageId == null) {
        return;
      }

      // Below is a method of obtaining saved image information.
      var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);
      SocialShare.shareOptions("Check out this track", imagePath: path);
    } on PlatformException catch (error) {
      print(error);
    }
  }
//=======================Date================================

  String date = '09/09/2020';
  String get getDate => date;

  bool editDate = false;
  bool get editDateBool => editDate;

  bool dateValid = true;
  bool get isDateValid => dateValid;

  String _userDateErrorString = "";
  String get userDateErrorString => _userDateErrorString;

  void setEditDate() {
    editDate = !editDate;
    notifyListeners();
  }

  void setDate(String value) {
    if (value == "" || value == null) {
      setEditDate();
    } else if (value != "" || value != null) {
      dateValid = RegExp(
              r"^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$")
          .hasMatch(value);
      if (dateValid == true) {
        date = value;
        setEditDate();
      } else {
        _userDateErrorString = "Invalid date format";
        notifyListeners();
      }
    }
    //date = value;
    //setEditDate();
  }

//=======================Date================================

//=======================Lat================================

  String coordinatesLat = '-240.19097';
  String get getCoordLat => coordinatesLat;

  bool editSpoorCoordLat = false;
  bool get editSpoorCoordLatBool => editSpoorCoordLat;

  bool latValid = true;
  bool get isLatValid => latValid;

  String _userLatErrorString = "";
  String get userLatErrorString => _userLatErrorString;

  void setEditSpoorCoordLat() {
    editSpoorCoordLat = !editSpoorCoordLat;
    notifyListeners();
  }

  void setLat(String value) {
    if (value == "" || value == null) {
      setEditSpoorCoordLat();
    } else if (value != "" || value != null) {
      latValid = RegExp(r"^(-?\d+(\.\d+)?)").hasMatch(value);
      if (latValid == true) {
        coordinatesLat = value;
        setEditSpoorCoordLat();
      } else {
        _userLatErrorString = "Invalid input";
        notifyListeners();
      }
    }
    ;
  }
//=======================Lat================================

//=======================Long================================

  String coordinatesLong = '31.559270';
  String get getCoordLong => coordinatesLong;

  bool editSpoorCoordLong = false;
  bool get editSpoorCoordLongBool => editSpoorCoordLong;

  bool longValid = true;
  bool get isLongValid => longValid;

  String _userLongErrorString = "";
  String get userLongErrorString => _userLongErrorString;

  void setEditSpoorCoordLong() {
    editSpoorCoordLong = !editSpoorCoordLong;
    notifyListeners();
  }

  void setLong(String value) {
    if (value == "" || value == null) {
      setEditSpoorCoordLong();
    } else if (value != "" || value != null) {
      longValid = RegExp(r"(-?\d+(\.\d+)?)$").hasMatch(value);
      if (longValid == true) {
        coordinatesLong = value;
        setEditSpoorCoordLong();
      } else {
        _userLongErrorString = "Invalid input";
        notifyListeners();
      }
    }
    ;
  }
//=======================Long================================

//=======================Confident Name================================

  bool editSpoorName = false;
  bool get editSpoorNameBool => editSpoorName;

  void setEditSpoorName() {
    editSpoorName = !editSpoorName;
    notifyListeners();
  }

  void setConfidentName(String value) {
    if (value == "" || value == null) {
      setEditSpoorName();
    } else if (value != "" || value != null) {
      _confident.name = value;
      setEditSpoorName();
    }
    ;
  }
//=======================Confident Name================================

//=======================Confident Species================================

  bool editSpoorSpecies = false;
  bool get editSpoorSpeciesBool => editSpoorSpecies;

  void setEditSpoorSpecies() {
    editSpoorSpecies = !editSpoorSpecies;
    notifyListeners();
  }

  void setConfidentSpecies(String value) {
    if (value == "" || value == null) {
      setEditSpoorSpecies();
    } else if (value != "" || value != null) {
      _confident.name = value;
      setEditSpoorSpecies();
    }
    ;
  }

//=======================Confident Species================================
  void setConfident(SpoorModel _confident) {
    this._confident = _confident;
  }

  void setRecentIdentifications(List<SpoorModel> _recentIdentifications) {
    List<SpoorModel> temp = new List();
    temp.addAll(_recentIdentifications);
    this._recentIdentifications = new List();
    this._recentIdentifications.addAll(temp);
  }

  void setSimilarSpoorModel(SimilarSpoorModel _similarSpoorModel) {
    this._similarSpoorModel = _similarSpoorModel;
  }

  Future<int> getResults(String animal) async {
    if (loaded == false) {
      _recentIdentifications = await _api.getSpoorModel(animal);
      _confident = recentIdentifications[0];
      recentIdentifications.removeAt(0);
      _similarSpoorModel = await _api.getSpoorSimilarModel(animal);
      loaded = true;
    }
    return 21;
  }

  void reclassify(int index) {
    print(index);
    _recentIdentifications.add(_confident);
    _confident = _recentIdentifications[index];
    _recentIdentifications.removeAt(index);
    notifyListeners();
  }

  List<String> _tags = new List<String>();
  List<String> get tags => _tags;

  void setTags() {
    _tags.clear();
    _tags.add("Endangered");
    _tags.add("Harmless");
  }
}
