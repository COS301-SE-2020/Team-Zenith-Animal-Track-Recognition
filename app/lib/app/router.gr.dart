// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../services/datamodels/api_models.dart';
import '../ui/views/achievements/achievements_view.dart';
import '../ui/views/animals/animal_view.dart';
import '../ui/views/confirmed/confirmed_view.dart';
import '../ui/views/forgot/forget_view.dart';
import '../ui/views/gallery/gallery_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/identification/identification_view.dart';
import '../ui/views/information/information_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/notconfirmed/notconfirmed_view.dart';
import '../ui/views/profile/profile_view.dart';
import '../ui/views/search/search_view.dart';
import '../ui/views/upload/upload_view.dart';
import '../ui/views/userconfirmed/user_confirmed_view.dart';

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
  static const String achievementsViewRoute = '/achievements-view';
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
    achievementsViewRoute,
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
    RouteDef(Routes.achievementsViewRoute, page: AchievementsView),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const HomeView(),
        settings: data,
      );
    },
    AnimalView: (data) {
      final args = data.getArgs<AnimalViewArguments>(
        orElse: () => AnimalViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => AnimalView(key: args.key),
        settings: data,
      );
    },
    ConfirmedView: (data) {
      final args = data.getArgs<ConfirmedViewArguments>(
        orElse: () => ConfirmedViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => ConfirmedView(
          confirmedAnimals: args.confirmedAnimals,
          image: args.image,
        ),
        settings: data,
      );
    },
    GalleryView: (data) {
      final args = data.getArgs<GalleryViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => GalleryView(args.galleryModel),
        settings: data,
      );
    },
    IdentificationView: (data) {
      final args = data.getArgs<IdentificationViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => IdentificationView(name: args.name),
        settings: data,
      );
    },
    ForgetView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ForgetView(),
        settings: data,
      );
    },
    NotConfirmedView: (data) {
      final args = data.getArgs<NotConfirmedViewArguments>(
        orElse: () => NotConfirmedViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => NotConfirmedView(
          image: args.image,
          key: args.key,
        ),
        settings: data,
      );
    },
    ProfileView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ProfileView(),
        settings: data,
      );
    },
    UploadView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const UploadView(),
        settings: data,
      );
    },
    InformationView: (data) {
      final args = data.getArgs<InformationViewArguments>(
        orElse: () => InformationViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => InformationView(animalInfo: args.animalInfo),
        settings: data,
      );
    },
    LoginView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const LoginView(),
        settings: data,
      );
    },
    SearchView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const SearchView(),
        settings: data,
      );
    },
    UserConfirmedView: (data) {
      final args = data.getArgs<UserConfirmedViewArguments>(
        orElse: () => UserConfirmedViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => UserConfirmedView(
          confirmedAnimal: args.confirmedAnimal,
          image: args.image,
          tags: args.tags,
        ),
        settings: data,
      );
    },
    AchievementsView: (data) {
      final args = data.getArgs<AchievementsViewArguments>(
        orElse: () => AchievementsViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => AchievementsView(key: args.key),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// AnimalView arguments holder class
class AnimalViewArguments {
  final Key key;
  AnimalViewArguments({this.key});
}

/// ConfirmedView arguments holder class
class ConfirmedViewArguments {
  final List<ConfirmModel> confirmedAnimals;
  final File image;
  ConfirmedViewArguments({this.confirmedAnimals, this.image});
}

/// GalleryView arguments holder class
class GalleryViewArguments {
  final GalleryModel galleryModel;
  GalleryViewArguments({@required this.galleryModel});
}

/// IdentificationView arguments holder class
class IdentificationViewArguments {
  final String name;
  IdentificationViewArguments({@required this.name});
}

/// NotConfirmedView arguments holder class
class NotConfirmedViewArguments {
  final File image;
  final Key key;
  NotConfirmedViewArguments({this.image, this.key});
}

/// InformationView arguments holder class
class InformationViewArguments {
  final InfoModel animalInfo;
  InformationViewArguments({this.animalInfo});
}

/// UserConfirmedView arguments holder class
class UserConfirmedViewArguments {
  final ConfirmModel confirmedAnimal;
  final File image;
  final List<String> tags;
  UserConfirmedViewArguments({this.confirmedAnimal, this.image, this.tags});
}

/// AchievementsView arguments holder class
class AchievementsViewArguments {
  final Key key;
  AchievementsViewArguments({this.key});
}
