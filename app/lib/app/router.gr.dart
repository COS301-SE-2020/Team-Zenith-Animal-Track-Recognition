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
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'dart:io';
import 'package:ERP_RANGER/ui/views/gallery/gallery_view.dart';
import 'package:ERP_RANGER/ui/views/identification/identification_view.dart';
import 'package:ERP_RANGER/ui/views/forgot/forget_view.dart';
import 'package:ERP_RANGER/ui/views/notconfirmed/notconfirmed_view.dart';
import 'package:ERP_RANGER/ui/views/profile/profile_view.dart';
import 'package:ERP_RANGER/ui/views/upload/upload_view.dart';
import 'package:ERP_RANGER/ui/views/information/information_view.dart';
import 'package:ERP_RANGER/ui/views/login/login_view.dart';
import 'package:ERP_RANGER/ui/views/search/search_view.dart';
import 'package:ERP_RANGER/ui/views/userconfirmed/user_confirmed_view.dart';

class Routes {
  static const String homeViewRoute = '/';
  static const String animalViewRoute = '/animal-view';
  static const String confirmlViewRoute = '/confirmed-view';
  static const String gallerylViewRoute = '/gallery-view';
  static const String identificationViewRoute = '/identification-view';
  static const String forgetViewRoute = '/forget-view';
  static const String notConfirmedViewRoute = '/not-confirmed-view';
  static const String profileViewRoute = '/profile-view';
  static const String uploadViewRoute = '/upload-view';
  static const String informationViewRoute = '/information-view';
  static const String loginViewRoute = '/login-view';
  static const String searchViewRoute = '/search-view';
  static const String userConfirmedViewRoute = '/user-confirmed-view';
  static const all = <String>{
    homeViewRoute,
    animalViewRoute,
    confirmlViewRoute,
    gallerylViewRoute,
    identificationViewRoute,
    forgetViewRoute,
    notConfirmedViewRoute,
    profileViewRoute,
    uploadViewRoute,
    informationViewRoute,
    loginViewRoute,
    searchViewRoute,
    userConfirmedViewRoute,
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
    RouteDef(Routes.forgetViewRoute, page: ForgetView),
    RouteDef(Routes.notConfirmedViewRoute, page: NotConfirmedView),
    RouteDef(Routes.profileViewRoute, page: ProfileView),
    RouteDef(Routes.uploadViewRoute, page: UploadView),
    RouteDef(Routes.informationViewRoute, page: InformationView),
    RouteDef(Routes.loginViewRoute, page: LoginView),
    RouteDef(Routes.searchViewRoute, page: SearchView),
    RouteDef(Routes.userConfirmedViewRoute, page: UserConfirmedView),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    HomeView: (RouteData data) {
      var args =
          data.getArgs<HomeViewArguments>(orElse: () => HomeViewArguments());
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeView(key: args.key),
        settings: data,
      );
    },
    AnimalView: (RouteData data) {
      var args = data.getArgs<AnimalViewArguments>(
          orElse: () => AnimalViewArguments());
      return MaterialPageRoute<dynamic>(
        builder: (context) => AnimalView(key: args.key),
        settings: data,
      );
    },
    ConfirmedView: (RouteData data) {
      var args = data.getArgs<ConfirmedViewArguments>(
          orElse: () => ConfirmedViewArguments());
      return MaterialPageRoute<dynamic>(
        builder: (context) => ConfirmedView(
            confirmedAnimals: args.confirmedAnimals, image: args.image),
        settings: data,
      );
    },
    GalleryView: (RouteData data) {
      var args = data.getArgs<GalleryViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => GalleryView(args.galleryModel),
        settings: data,
      );
    },
    IdentificationView: (RouteData data) {
      var args = data.getArgs<IdentificationViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => IdentificationView(name: args.name),
        settings: data,
      );
    },
    ForgetView: (RouteData data) {
      var args = data.getArgs<ForgetViewArguments>(
          orElse: () => ForgetViewArguments());
      return MaterialPageRoute<dynamic>(
        builder: (context) => ForgetView(key: args.key),
        settings: data,
      );
    },
    NotConfirmedView: (RouteData data) {
      var args = data.getArgs<NotConfirmedViewArguments>(
          orElse: () => NotConfirmedViewArguments());
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            NotConfirmedView(image: args.image, key: args.key),
        settings: data,
      );
    },
    ProfileView: (RouteData data) {
      var args = data.getArgs<ProfileViewArguments>(
          orElse: () => ProfileViewArguments());
      return MaterialPageRoute<dynamic>(
        builder: (context) => ProfileView(key: args.key),
        settings: data,
      );
    },
    UploadView: (RouteData data) {
      var args = data.getArgs<UploadViewArguments>(
          orElse: () => UploadViewArguments());
      return MaterialPageRoute<dynamic>(
        builder: (context) => UploadView(key: args.key),
        settings: data,
      );
    },
    InformationView: (RouteData data) {
      var args = data.getArgs<InformationViewArguments>(
          orElse: () => InformationViewArguments());
      return MaterialPageRoute<dynamic>(
        builder: (context) => InformationView(animalInfo: args.animalInfo),
        settings: data,
      );
    },
    LoginView: (RouteData data) {
      var args =
          data.getArgs<LoginViewArguments>(orElse: () => LoginViewArguments());
      return MaterialPageRoute<dynamic>(
        builder: (context) => LoginView(key: args.key),
        settings: data,
      );
    },
    SearchView: (RouteData data) {
      var args = data.getArgs<SearchViewArguments>(
          orElse: () => SearchViewArguments());
      return MaterialPageRoute<dynamic>(
        builder: (context) => SearchView(key: args.key),
        settings: data,
      );
    },
    UserConfirmedView: (RouteData data) {
      var args = data.getArgs<UserConfirmedViewArguments>(
          orElse: () => UserConfirmedViewArguments());
      return MaterialPageRoute<dynamic>(
        builder: (context) => UserConfirmedView(
          confirmedAnimal: args.confirmedAnimal,
          image: args.image,
          tags: args.tags,
        ),
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
  final List<ConfirmModel> confirmedAnimals;
  final File image;
  ConfirmedViewArguments({this.confirmedAnimals, this.image});
}

//GalleryView arguments holder class
class GalleryViewArguments {
  final GalleryModel galleryModel;
  GalleryViewArguments({@required this.galleryModel});
}

//IdentificationView arguments holder class
class IdentificationViewArguments {
  final String name;
  IdentificationViewArguments({@required this.name});
}

//ForgetView arguments holder class
class ForgetViewArguments {
  final Key key;
  ForgetViewArguments({this.key});
}

//NotConfirmedView arguments holder class
class NotConfirmedViewArguments {
  final File image;
  final Key key;
  NotConfirmedViewArguments({this.image, this.key});
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
  final InfoModel animalInfo;
  InformationViewArguments({this.animalInfo});
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

//UserConfirmedView arguments holder class
class UserConfirmedViewArguments {
  final ConfirmModel confirmedAnimal;
  final File image;
  final List<String> tags;
  UserConfirmedViewArguments({this.confirmedAnimal, this.image, this.tags});
}
