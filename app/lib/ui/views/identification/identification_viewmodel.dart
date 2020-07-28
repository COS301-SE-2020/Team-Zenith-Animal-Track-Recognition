import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/fake_api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class IdentificationViewModel extends BaseViewModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final Api _api = locator<FakeApi>();

  SpoorModel _confident;
  List<SpoorModel> _recentIdentifications;
  SimilarSpoorModel _similarSpoorModel;
  bool loaded = false;

  SpoorModel get confident => _confident;
  List<SpoorModel> get recentIdentifications => _recentIdentifications;
  SimilarSpoorModel get similarSpoorModel => _similarSpoorModel;

  void setConfident(SpoorModel _confident){
    this._confident = _confident;
  }

  void setRecentIdentifications(List<SpoorModel> _recentIdentifications){
    List<SpoorModel> temp = new List();
    temp.addAll(_recentIdentifications);
    this._recentIdentifications = new List();
    this._recentIdentifications.addAll(temp);
  }
  
  void setSimilarSpoorModel(SimilarSpoorModel _similarSpoorModel){
    this._similarSpoorModel = _similarSpoorModel;
  }

  Future<int> getResults(String animal) async {
    if(loaded == false){
      _recentIdentifications = await _api.getSpoorModel(animal);
      _confident  = recentIdentifications[0];
      recentIdentifications.removeAt(0);
      _similarSpoorModel = await _api.getSpoorSimilarModel(animal);
      loaded = true;
    }
    return 21;
  }

  void reclassify(int index){
    print(index);
    _recentIdentifications.add(_confident);
   _confident = _recentIdentifications[index];
    _recentIdentifications.removeAt(index);
    notifyListeners();
  }


  
  List<String> _tags = new List<String>();
  List<String>  get tags => _tags;

  void setTags(){
    _tags.clear();
    _tags.add("Endangered");
    _tags.add("Harmless");
  }

}