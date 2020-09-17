import 'dart:io';
import 'package:flutter/services.dart';
import 'package:social_share/social_share.dart';
import 'package:stacked/stacked.dart';

class NotConfirmedViewModel extends BaseViewModel {
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
