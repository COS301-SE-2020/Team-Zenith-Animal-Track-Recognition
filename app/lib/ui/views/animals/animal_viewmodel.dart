import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/fake_api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:ERP_RANGER/services/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AnimalViewModel extends BaseViewModel{
  String _title = 'Home View';
  String get title => '$_title $_counter ';

  final NavigationService _navigationService = locator<NavigationService>();
  final Api _api = locator<FakeApi>();

  int _counter = 0;
  int get counter => _counter;

  Future<TempObject> getCategories(var context)async {
    TabModel tabModel = await _api.getTabModel("Big Five", "Big Cats","Large Antelopes");
    List<Tab> tabs = new List();
    for(int i = 0; i <3; i++){
      tabs.add( Tab( child:text12CenterBoldWhite(tabModel.categories[i])));
    }

    List<List<AnimalModel>> animalList = new List();
    for(int i = 0; i < 3; i++){
      List<AnimalModel> animals = await _api.getAnimalModel(tabModel.categories[i]);
      animalList.add(animals);
    }
    return TempObject(tabs: tabs,length: 3, animalList: animalList);
  } 





  
}

class TempObject{
  List<Tab> tabs;
  int length;
  List<List<AnimalModel>> animalList;
  TempObject({this.tabs, this.length, this.animalList});
}