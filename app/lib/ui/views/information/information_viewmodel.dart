import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class InformationViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  void navigateToGalleryView() {
    _navigationService.navigateTo(Routes.gallerylViewRoute);
  }

}
