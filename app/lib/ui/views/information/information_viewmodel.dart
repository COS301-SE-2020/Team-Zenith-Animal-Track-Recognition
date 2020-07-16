import 'package:stacked/stacked.dart';

class InformationViewModel extends BaseViewModel{
  String _title = 'Home View';
  String get title => '$_title $_counter ';

  int _counter = 0;
  int get counter => _counter;

  void updateCounter(){
    _counter++;
    notifyListeners();
  }
}

// import '../../../services/datamodels/api_models.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:stacked/stacked.dart';

// class SpoorIdentificationViewModel extends BaseViewModel {

//   CameraPosition _myLocation = CameraPosition(
//   target: LatLng(-25.882171, 28.264653),
//   zoom: 15,
//   );

//   CameraPosition get myLocation => _myLocation;

//   int _cardLength = 6;
//   int get cardLength => _cardLength;

//   String _tag = "Dangerous";
//   String get tag => _tag;


// }