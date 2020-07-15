import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/fake_api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UploadViewModel extends BaseViewModel{
  String tag;
  int _tagIndex = 0;
  int get tagIndex => _tagIndex;

  final NavigationService _navigationService = locator<NavigationService>();
  final Api _api = locator<FakeApi>();

  void navigate(context) {
     Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  void setTag(String  tag){
    this.tag = tag;
  }

  void setTagIndex(int index){
    _tagIndex = index;
  }
}
