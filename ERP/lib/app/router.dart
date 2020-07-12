import 'package:ERP_RANGER/ui/views/home/home_view.dart';
import 'package:ERP_RANGER/ui/views/animals/animal_view.dart';
import 'package:ERP_RANGER/ui/views/confirmed/confirmed_view.dart';
import 'package:ERP_RANGER/ui/views/gallery/gallery_view.dart';
import 'package:ERP_RANGER/ui/views/identification/identification_view.dart';
import 'package:ERP_RANGER/ui/views/information/information_view.dart';
import 'package:ERP_RANGER/ui/views/notconfirmed/notconfirmed_view.dart';
import 'package:ERP_RANGER/ui/views/profile/profile_view.dart';
import 'package:ERP_RANGER/ui/views/upload/upload_view.dart';
import 'package:ERP_RANGER/ui/views/login/login_view.dart';
import 'package:auto_route/auto_route_annotations.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: HomeView, initial: true, name: "homeViewRoute"),
    MaterialRoute(page: AnimalView, initial: false, name: "animalViewRoute"),
    MaterialRoute(page: ConfirmedView, initial: false, name: "confirmlViewRoute"),
    MaterialRoute(page: GalleryView, initial: false, name: "gallerylViewRoute"),
    MaterialRoute(page: IdentificationView, initial: false, name: "identificationViewRoute"),

    MaterialRoute(page: NotConfirmedView, initial: false, name: "notConfirmedViewRoute"),
    MaterialRoute(page: ProfileView, initial: false, name: "profileViewRoute"),
    MaterialRoute(page: UploadView, initial: false, name: "uploadViewRoute"),
    MaterialRoute(page: InformationView, initial: false, name: "informationViewRoute"),
    MaterialRoute(page: LoginView, initial: false, name: "loginViewRoute"),
  ]
)
class $Router {
}