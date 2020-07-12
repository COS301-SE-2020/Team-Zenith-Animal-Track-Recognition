import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/fake_api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class GalleryViewModel extends BaseViewModel{
  String _title = 'Home View';
  String get title => '$_title $_counter ';

  final NavigationService _navigationService = locator<NavigationService>();
  final Api _api = locator<FakeApi>();

  int _counter = 0;
  int get counter => _counter;

  Future<TempObject>getSpoor() async{
      TabModel tabModel = await _api.getTabModel("Appearance", "Tracks","Droppings");
      List<Tab> tabs = new List();
      for(int i = 0; i < tabModel.categories.length; i++){
        tabs.add( Tab( child: Text( tabModel.categories[i], style: TextStyle( color:Colors.white, fontWeight: FontWeight.bold, fontSize: 10,)),));
      }
      List<List<String>> animalList = new List();
      GalleryModel galleryModel = await _api.getGalleryModel();
      animalList.add(galleryModel.appearance);
      animalList.add(galleryModel.tracks);
      animalList.add(galleryModel.droppings);
      return TempObject(tabs: tabs,length: tabModel.length, animalList: animalList);
  }

  void navigate(context) {
     Navigator.of(context).pushNamedAndRemoveUntil('/animal-view', ModalRoute.withName('/'));
  }

  void updateCounter(){
    _counter++;
    notifyListeners();
  }
}
class TempObject{
  List<Tab> tabs;
  int length;
  List<List<String>> animalList;
  TempObject({this.tabs, this.length, this.animalList});
}