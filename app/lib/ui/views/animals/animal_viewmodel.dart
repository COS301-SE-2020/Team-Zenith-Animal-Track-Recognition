import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/graphQL.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:ERP_RANGER/services/util.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AnimalViewModel extends BaseViewModel {
  //final Api api = locator<MockApi>();
  final Api api = locator<GraphQL>();

  Future<TempObject> getCategories(var context) async {
    TabModel tabModel = await api.getTabModel();
    List<Tab> tabs = new List();
    for (int i = 0; i < tabModel.length; i++) {
      tabs.add(Tab(child: tabBarTitles(tabModel.categories[i], context)));
    }

    List<List<AnimalModel>> animalList = new List();
    for (int i = 0; i < tabModel.length; i++) {
      List<AnimalModel> animals =
          await api.getAnimalModel(tabModel.categories[i]);
      animalList.add(animals);
    }
    return TempObject(
        tabs: tabs, length: tabModel.length, animalList: animalList);
  }
}

class TempObject {
  List<Tab> tabs;
  int length;
  List<List<AnimalModel>> animalList;
  TempObject({this.tabs, this.length, this.animalList});
}
