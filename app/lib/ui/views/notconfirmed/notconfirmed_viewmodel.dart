import 'dart:io';

import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/mock_api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:social_share/social_share.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NotConfirmedViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  File picture;

  Future<String> imagePicker(File pic) async {
    picture = pic;
    String url = picture.path;
    return url;
  }

  Future<void> shareImage() async {
    try {
      SocialShare.shareOptions("Check out this track", imagePath: picture.path);
    } on PlatformException catch (error) {
      print(error);
    }
  }
}
