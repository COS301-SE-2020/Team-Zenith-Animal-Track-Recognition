import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/fake_api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
class NotConfirmedViewModel extends BaseViewModel{
  String _title = 'Home View';

  final NavigationService _navigationService = locator<NavigationService>();
  final Api _api = locator<FakeApi>();

  Future<String> imagePicker()async{
    return await "https://images.unsplash.com/photo-1551316679-9c6ae9dec224?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60";
  }

}