import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/mock_api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:ERP_RANGER/services/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class GalleryViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final Api _api = locator<MockApi>();

  Future<TempObject> getSpoor(var context) async {
    List<String> categories = new List();
    categories.add("Appearance");
    categories.add("Tracks");

    TabModel tabModel =
        TabModel(categories: categories, length: categories.length);
    List<Tab> tabs = new List();

    for (int i = 0; i < tabModel.categories.length; i++) {
      tabs.add(Tab(
          child: text12CenterBoldWhite(tabModel.categories[i].toUpperCase())));
    }
    return TempObject(tabs: tabs, length: tabModel.length);
  }
}

class TempObject {
  List<Tab> tabs;
  int length;
  TempObject({this.tabs, this.length});
}
