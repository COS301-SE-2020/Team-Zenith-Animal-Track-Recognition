import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/graphQL.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UserConfirmedViewModel extends BaseViewModel {
  bool _loaded = false;
  String tag;
  int _tagIndex = 0;
  List<ConfirmModel> _confirmedList;
  ConfirmModel _confidentAnimal;

  bool get loaded => _loaded;
  int get tagIndex => _tagIndex;
  ConfirmModel get confidentAnimal => _confidentAnimal;
  List<ConfirmModel> get confirmedList => _confirmedList;

  final NavigationService _navigationService = locator<NavigationService>();
  final Api _api = locator<GraphQL>();

  void setLoaded(bool loaded) {
    this._loaded = loaded;
  }

  void setConfirmedList(List<ConfirmModel> _confirmedList) {
    this._confirmedList = _confirmedList;
  }

  void setConfidentAnimal(ConfirmModel _confidentAnimal) {
    this._confidentAnimal = _confidentAnimal;
  }

  void confirm(var context) {
    List<ConfirmModel> list;
    _api.sendConfirmationSpoor(list, "tag");
    Navigator.of(context).pop();
  }

  void setTag(String tag) {
    this.tag = tag;
  }

  void setTagIndex(int index) {
    _tagIndex = index;
  }

  Future<FinalObject> getConfirm(List<String> tags) async {
    FinalObject finalObject = new FinalObject(tags: tags);
    return finalObject;
  }
}

class FinalObject {
  List<String> tags;
  FinalObject({this.tags});
}
