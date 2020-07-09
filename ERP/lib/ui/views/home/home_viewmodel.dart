import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel{
  final NavigationService _navigationService = locator<NavigationService>();
  String _title = 'Home View';
  String get title => '$_title $_counter ';

  int _counter = 0;
  int get counter => _counter;

  void updateCounter(){
    _counter++;
    notifyListeners();
  }

  Future navigateToIdetification() async{
      await _navigationService.navigateTo(Routes.identificationViewRoute);
  }
}