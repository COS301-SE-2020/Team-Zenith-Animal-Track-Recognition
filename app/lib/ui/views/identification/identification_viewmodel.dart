import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/fake_api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class IdentificationViewModel extends BaseViewModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final Api _api = locator<FakeApi>();

  Future<List<SpoorModel>> getResults() async {
    List<SpoorModel> recentIdentifications = await _api.getSpoorModel();
    return recentIdentifications;
  }


  String _tag = "Dangerous";
  String get tag => _tag;

  void navigate(context) {
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

}