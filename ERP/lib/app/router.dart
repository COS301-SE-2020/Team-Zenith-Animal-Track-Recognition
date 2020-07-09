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

@MaterialAutoRouter()
class $Router{
  @initial
  AnimalView animalViewRoute;
  ConfirmedView confirmlViewRoute;
  GalleryView gallerylViewRoute;
  HomeView homeViewRoute;
  IdentificationView identificationViewRoute;
  NotConfirmedView notConfirmedViewRoute;
  ProfileView profileViewRoute;
  UploadView uploadViewRoute;
  InformationView informationViewRoute;
  LoginView loginView;
}