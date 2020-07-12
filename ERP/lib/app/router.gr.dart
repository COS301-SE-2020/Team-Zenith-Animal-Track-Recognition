// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ERP_RANGER/ui/views/home/home_view.dart';
import 'package:ERP_RANGER/ui/views/animals/animal_view.dart';
import 'package:ERP_RANGER/ui/views/confirmed/confirmed_view.dart';
import 'package:ERP_RANGER/ui/views/gallery/gallery_view.dart';
import 'package:ERP_RANGER/ui/views/identification/identification_view.dart';
import 'package:ERP_RANGER/ui/views/notconfirmed/notconfirmed_view.dart';
import 'package:ERP_RANGER/ui/views/profile/profile_view.dart';
import 'package:ERP_RANGER/ui/views/upload/upload_view.dart';
import 'package:ERP_RANGER/ui/views/information/information_view.dart';
import 'package:ERP_RANGER/ui/views/login/login_view.dart';
import 'package:ERP_RANGER/ui/views/search/search_view.dart';

class Routes {
  static const String homeViewRoute = '/';
  static const String animalViewRoute = '/animal-view';
  static const String confirmlViewRoute = '/confirmed-view';
  static const String gallerylViewRoute = '/gallery-view';
  static const String identificationViewRoute = '/identification-view';
  static const String notConfirmedViewRoute = '/not-confirmed-view';
  static const String profileViewRoute = '/profile-view';
  static const String uploadViewRoute = '/upload-view';
  static const String informationViewRoute = '/information-view';
  static const String loginViewRoute = '/login-view';
  static const String searchViewRoute = '/search-view';
  static const all = <String>{
    homeViewRoute,
    animalViewRoute,
    confirmlViewRoute,
    gallerylViewRoute,
    identificationViewRoute,
    notConfirmedViewRoute,
    profileViewRoute,
    uploadViewRoute,
    informationViewRoute,
    loginViewRoute,
    searchViewRoute,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.homeViewRoute, page: HomeView),
    RouteDef(Routes.animalViewRoute, page: AnimalView),
    RouteDef(Routes.confirmlViewRoute, page: ConfirmedView),
    RouteDef(Routes.gallerylViewRoute, page: GalleryView),
    RouteDef(Routes.identificationViewRoute, page: IdentificationView),
    RouteDef(Routes.notConfirmedViewRoute, page: NotConfirmedView),
    RouteDef(Routes.profileViewRoute, page: ProfileView),
    RouteDef(Routes.uploadViewRoute, page: UploadView),
    RouteDef(Routes.informationViewRoute, page: InformationView),
    RouteDef(Routes.loginViewRoute, page: LoginView),
    RouteDef(Routes.searchViewRoute, page: SearchView),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    HomeView: (RouteData data) {
      var args =
          data.getArgs<HomeViewArguments>(orElse: () => HomeViewArguments());
      return PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => HomeView(key: args.key),
        settings: data,
      );
    },

    AnimalView: (RouteData data) {
      var args = data.getArgs<AnimalViewArguments>(
          orElse: () => AnimalViewArguments());
      return  PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => AnimalView(key: args.key),
        settings: data,
      );
    },

    ConfirmedView: (RouteData data) {
      var args = data.getArgs<ConfirmedViewArguments>(
          orElse: () => ConfirmedViewArguments());
      return PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => ConfirmedView(key: args.key),
        settings: data,
      );
    },
    GalleryView: (RouteData data) {
      var args = data.getArgs<GalleryViewArguments>(
          orElse: () => GalleryViewArguments());
      return PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => GalleryView(key: args.key),
        settings: data,
      );
    },
    IdentificationView: (RouteData data) {
      var args = data.getArgs<IdentificationViewArguments>(
          orElse: () => IdentificationViewArguments());
      return PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => IdentificationView(key: args.key),
        settings: data,
      );
    },
    NotConfirmedView: (RouteData data) {
      var args = data.getArgs<NotConfirmedViewArguments>(
          orElse: () => NotConfirmedViewArguments());
      return PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => NotConfirmedView(key: args.key),
        settings: data,
      );
    },
    ProfileView: (RouteData data) {
      var args = data.getArgs<ProfileViewArguments>(
          orElse: () => ProfileViewArguments());
      return PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => ProfileView(key: args.key),
        settings: data,
      );
    },
    UploadView: (RouteData data) {
      var args = data.getArgs<UploadViewArguments>(
          orElse: () => UploadViewArguments());
      return PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => UploadView(key: args.key),
        settings: data,
      );
    },
    InformationView: (RouteData data) {
      var args = data.getArgs<InformationViewArguments>(
          orElse: () => InformationViewArguments());
      return PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => InformationView(key: args.key),
        settings: data,
      );
    },
    LoginView: (RouteData data) {
      var args =
          data.getArgs<LoginViewArguments>(orElse: () => LoginViewArguments());
      return PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => LoginView(key: args.key),
        settings: data,
      );
    },
    SearchView: (RouteData data) {
      var args = data.getArgs<SearchViewArguments>(
          orElse: () => SearchViewArguments());
      return PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => SearchView(key: args.key),
        settings: data,
      );
    },
  };

}

// *************************************************************************
// Arguments holder classes
// **************************************************************************

//HomeView arguments holder class
class HomeViewArguments {
  final Key key;
  HomeViewArguments({this.key});
}

//AnimalView arguments holder class
class AnimalViewArguments {
  final Key key;
  AnimalViewArguments({this.key});
}

//ConfirmedView arguments holder class
class ConfirmedViewArguments {
  final Key key;
  ConfirmedViewArguments({this.key});
}

//GalleryView arguments holder class
class GalleryViewArguments {
  final Key key;
  GalleryViewArguments({this.key});
}

//IdentificationView arguments holder class
class IdentificationViewArguments {
  final Key key;
  IdentificationViewArguments({this.key});
}

//NotConfirmedView arguments holder class
class NotConfirmedViewArguments {
  final Key key;
  NotConfirmedViewArguments({this.key});
}

//ProfileView arguments holder class
class ProfileViewArguments {
  final Key key;
  ProfileViewArguments({this.key});
}

//UploadView arguments holder class
class UploadViewArguments {
  final Key key;
  UploadViewArguments({this.key});
}

//InformationView arguments holder class
class InformationViewArguments {
  final Key key;
  InformationViewArguments({this.key});
}

//LoginView arguments holder class
class LoginViewArguments {
  final Key key;
  LoginViewArguments({this.key});
}

//SearchView arguments holder class
class SearchViewArguments {
  final Key key;
  SearchViewArguments({this.key});
}
