import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/fake_api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchViewModel extends BaseViewModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final Api _api = locator<FakeApi>();

  Future<List<SearchModel>> getSearchList()async{
    List<SearchModel> list = await _api.getSearchModel();
    
    List<String> commonName = new List();
    List<String> species = new List();
    for(int i = 0; i < list.length; i++){
      commonName.add(list[i].commonName);
      species.add(list[i].species);
    }

    commonName.sort();
    species.sort();
  
    List<SearchModel> animals;
    List<SearchModel> speciesList;

    print(commonName);
    print(species);

    return list;
  }

 void navigate(context) {
     Navigator.of(context).pop();
  }

}

class TempObject{
  List<SearchModel> animals;
  List<SearchModel> species;
  TempObject({this.animals,this.species});

}