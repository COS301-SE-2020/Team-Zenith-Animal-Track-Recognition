import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/fake_api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NotConfirmedViewModel extends BaseViewModel {
  String _title = 'Home View';

  final NavigationService _navigationService = locator<NavigationService>();
  final Api _api = locator<FakeApi>();

  Future<String> imagePicker() async {
    return await "assets/images/Stock_Widllife_RhinoTrack.jpg";
  }

  void recapture(var context) {
    if (false) {
      Navigator.of(context).popAndPushNamed("/confirmed-view");
    } else {
      Navigator.of(context).popAndPushNamed("/not-confirmed-view");
    }
  }

  void navigate(context) {
    Navigator.of(context).pop();
  }

  void reclassify(context) {
    //Navigator.of(context).pop();
  }
}
