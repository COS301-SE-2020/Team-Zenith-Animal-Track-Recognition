import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/fake_api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ConfirmedViewModel extends BaseViewModel{

  String tag;
  int _tagIndex = 0;
  List<TempObject> identifiedList;
  int get tagIndex => _tagIndex;

  final NavigationService _navigationService = locator<NavigationService>();
  final Api _api = locator<FakeApi>();

  void confirm(var context){
     List<ConfirmModel> list;
    // for(int i = 0; i < identifiedList.length; i++){
    //   print(identifiedList[i].accuracyScore);
    //   ConfirmModel confirmModel = ConfirmModel(accuracyScore: identifiedList[i].accuracyScore, animalName: identifiedList[i].animalName,
    //     image: identifiedList[i].image, type: identifiedList[i].type,species: identifiedList[i].species,
    //   ); 
    //   list.add(confirmModel);
    // }
    _api.sendConfirmationSpoor(list, tag);
    Navigator.of(context).pop();
  }

  void recapture(var context){

    if(false){
      Navigator.of(context).popAndPushNamed("/confirmed-view");
    }else{
      Navigator.of(context).popAndPushNamed("/not-confirmed-view");
    }
  }

  void setTag(String  tag){
    this.tag = tag;
  }

  void setTagIndex(int index){
    _tagIndex = index;
  }
  
  void navigate(context) {
     Navigator.of(context).pop();
  }
 
  Future<FinalObject> getConfirm() async{
    List<ConfirmModel> temp = await _api.getConfirmModel();
    identifiedList = new List();
    for(int i = 0; i < 5; i++){
      identifiedList.add(TempObject(accuracyScore: temp[i].accuracyScore, animalName: temp[i].animalName ,image: temp[i].image,
        type: temp[i].type ,species: temp[i].species,
      ));
    }
    List<String> tags = await _api.getTags();
    FinalObject finalObject = new FinalObject(identifiedList: identifiedList, tags: tags);
    return finalObject;
  }
}

class TempObject{
  String image;
  String type;
  String animalName;
  String species;
  double accuracyScore;

  TempObject({this.accuracyScore,this.animalName,this.image,this.species,this.type});
}

class FinalObject{
  List<TempObject> identifiedList;
  List<String> tags;
  FinalObject({this.identifiedList,this.tags});
}