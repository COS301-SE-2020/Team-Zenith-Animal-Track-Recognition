import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/graphQL.dart';
import 'package:ERP_RANGER/services/api/mock_api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:social_share/social_share.dart';
import 'package:image_downloader/image_downloader.dart';

class IdentificationViewModel extends BaseViewModel {
  //final Api _api = locator<GraphQL>();
  final Api _api = locator<MockApi>();

  SpoorModel _confident;
  List<SpoorModel> _recentIdentifications;
  SimilarSpoorModel _similarSpoorModel;
  bool loaded = false;
  String _location;
  String _date;
  String pic;

  String get location => _location;
  String get date => _date;

  SpoorModel get confident => _confident;
  List<SpoorModel> get recentIdentifications => _recentIdentifications;
  SimilarSpoorModel get similarSpoorModel => _similarSpoorModel;

  Future<void> shareImage() async {
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(pic);
      if (imageId == null) {
        return;
      }

      // Below is a method of obtaining saved image information.
      var path = await ImageDownloader.findPath(imageId);
      SocialShare.shareOptions("Check out this track", imagePath: path);
    } on PlatformException catch (error) {
      print(error);
    }
  }
//=======================Date================================

  String get getDate => _date;

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
        _date = value;
        setEditDate();
      } else {
        _userDateErrorString = "Invalid date format";
        notifyListeners();
      }
    }
  }

//=======================Date================================

//=======================Lat================================

  double coordinatesLat = -240.19097;
  double get getCoordLat => coordinatesLat;

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
        coordinatesLat = double.parse(value);
        setEditSpoorCoordLat();
      } else {
        _userLatErrorString = "Invalid input";
        notifyListeners();
      }
    }
  }
//=======================Lat================================

//=======================Long================================

  double coordinatesLong = 31.559270;
  double get getCoordLong => coordinatesLong;

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
        coordinatesLong = double.parse(value);
        setEditSpoorCoordLong();
      } else {
        _userLongErrorString = "Invalid input";
        notifyListeners();
      }
    }
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
      _location = _confident.location;
      var arr = _location.split(',');
      coordinatesLat = double.parse(arr[0].trim());
      coordinatesLong = double.parse(arr[1].trim());
      _date = _confident.time;
      pic = _confident.pic;
      recentIdentifications.removeAt(0);
      _similarSpoorModel = await _api.getSpoorSimilarModel(animal);
      loaded = true;
    }
    return 21;
  }

  void reclassify(int index) {
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
