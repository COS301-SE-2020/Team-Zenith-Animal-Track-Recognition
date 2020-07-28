import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';

 @module
abstract class ThirdPartyServicesModule{
  
  @lazySingleton
  NavigationService get navigationService;
  @lazySingleton
  DialogService get dialogService;
  @lazySingleton
  SnackbarService get snackBarService;
}
  // g.registerLazySingleton<FakeApi>(() => FakeApi());
  // g.registerLazySingleton<GraphQL>(() => GraphQL());

  // final _pagesMap = <Type, AutoRouteFactory>{
  //   HomeView: (RouteData data) {
  //     var args =
  //         data.getArgs<HomeViewArguments>(orElse: () => HomeViewArguments());
  //     return PageRouteBuilder(
  //       pageBuilder: (context, animation1, animation2) => HomeView(key: args.key),
  //       settings: data,
  //     );
  //   },

  //   AnimalView: (RouteData data) {
  //     var args = data.getArgs<AnimalViewArguments>(
  //         orElse: () => AnimalViewArguments());
  //     return  PageRouteBuilder(
  //       pageBuilder: (context, animation1, animation2) => AnimalView(key: args.key),
  //       settings: data,
  //     );
  //   },

  //   ConfirmedView: (RouteData data) {
  //     var args = data.getArgs<ConfirmedViewArguments>(
  //         orElse: () => ConfirmedViewArguments());
  //     return PageRouteBuilder(
  //       pageBuilder: (context, animation1, animation2) => ConfirmedView(key: args.key),
  //       settings: data,
  //     );
  //   },
  //   GalleryView: (RouteData data) {
  //     var args = data.getArgs<GalleryViewArguments>(
  //         orElse: () => GalleryViewArguments());
  //     return PageRouteBuilder(
  //       pageBuilder: (context, animation1, animation2) => GalleryView(key: args.key),
  //       settings: data,
  //     );
  //   },
  //   IdentificationView: (RouteData data) {
  //     var args = data.getArgs<IdentificationViewArguments>(
  //         orElse: () => IdentificationViewArguments());
  //     return PageRouteBuilder(
  //       pageBuilder: (context, animation1, animation2) => IdentificationView(key: args.key),
  //       settings: data,
  //     );
  //   },
  //   NotConfirmedView: (RouteData data) {
  //     var args = data.getArgs<NotConfirmedViewArguments>(
  //         orElse: () => NotConfirmedViewArguments());
  //     return PageRouteBuilder(
  //       pageBuilder: (context, animation1, animation2) => NotConfirmedView(key: args.key),
  //       settings: data,
  //     );
  //   },
  //   ProfileView: (RouteData data) {
  //     var args = data.getArgs<ProfileViewArguments>(
  //         orElse: () => ProfileViewArguments());
  //     return PageRouteBuilder(
  //       pageBuilder: (context, animation1, animation2) => ProfileView(key: args.key),
  //       settings: data,
  //     );
  //   },
  //   UploadView: (RouteData data) {
  //     var args = data.getArgs<UploadViewArguments>(
  //         orElse: () => UploadViewArguments());
  //     return PageRouteBuilder(
  //       pageBuilder: (context, animation1, animation2) => UploadView(key: args.key),
  //       settings: data,
  //     );
  //   },
  //   InformationView: (RouteData data) {
  //     var args = data.getArgs<InformationViewArguments>(
  //         orElse: () => InformationViewArguments());
  //     return PageRouteBuilder(
  //       pageBuilder: (context, animation1, animation2) => InformationView(key: args.key),
  //       settings: data,
  //     );
  //   },
  //   LoginView: (RouteData data) {
  //     var args =
  //         data.getArgs<LoginViewArguments>(orElse: () => LoginViewArguments());
  //     return PageRouteBuilder(
  //       pageBuilder: (context, animation1, animation2) => LoginView(key: args.key),
  //       settings: data,
  //     );
  //   },
  //   SearchView: (RouteData data) {
  //     var args = data.getArgs<SearchViewArguments>(
  //         orElse: () => SearchViewArguments());
  //     return PageRouteBuilder(
  //       pageBuilder: (context, animation1, animation2) => SearchView(key: args.key),
  //       settings: data,
  //     );
  //   },
  // };