import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/fake_api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class InformationViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final Api _api = locator<FakeApi>();
  InfoModel _animalInfo;
  InfoModel get animalInfo => _animalInfo;

  void setAnimalInfo(InfoModel _animalInfo){
    this._animalInfo = _animalInfo;
  }

  Future<int>getInfo() async{
    return 0;
  }

}

