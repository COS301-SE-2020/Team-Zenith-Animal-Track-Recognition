import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/fake_api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:ERP_RANGER/ui/views/search/search_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchViewModel extends BaseViewModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final Api _api = locator<FakeApi>();

  Future<TempObject> getSearchList()async{
    List<SearchModel> list = await _api.getSearchModel();
    List<SearchModel> tempList = new List();
    

    List<String> commonName = new List();
    List<String> species = new List();
    for(int i = 0; i < list.length; i++){
      commonName.add(list[i].commonName);
      species.add(list[i].species);
    }
    commonName.sort();
    species.sort();
  
    List<SearchModel> animals = new List();
    List<SearchModel> speciesList = new List();

    tempList.addAll(list);
    String holder = "";
    for(int i = 0; i < commonName.length; i++ ){
      if(holder != commonName[i]){
        holder = commonName[i];
        SearchModel animalsName = SearchModel(commonName:holder,image: "",species: "" );
        animals.add(animalsName);
      }
      for(int j = 0; j < tempList.length; j++){
        if(tempList[j].commonName == commonName[i]){
          animals.add(tempList[j]);
          tempList.removeAt(j);
          break;
        }
      }
    }

    tempList.clear();
    tempList.addAll(list);
    holder = "";
    for(int i = 0; i < species.length; i++){
      if(holder != species[i].substring(0,1)){
        holder = species[i].substring(0,1);
        SearchModel speciesInitials = SearchModel(commonName:holder,image: "",species: "" );
        speciesList.add(speciesInitials);
      }
      for(int j = 0; j < tempList.length; j++){
        if(tempList[j].species.substring(0) == species[i].substring(0)){
          speciesList.add(tempList[j]);
          tempList.removeAt(j);
          break;
        }
      }
    }

    List<SearchModel> displayList = new List();
    for(int i = 0; i < 4;i++){
      displayList.add(list[i]);
    }
    TempObject tempObject = new TempObject(animals: animals, species: speciesList,displayList:displayList,searchList:list);
    return tempObject;
  }

}

class TempObject{
  List<SearchModel> animals;
  List<SearchModel> species;
  List<SearchModel> displayList;
  List<SearchModel> searchList;
  TempObject({this.animals,this.species,this.displayList,this.searchList});

}