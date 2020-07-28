import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/graphQL.dart';
import 'package:stacked/stacked.dart';
import 'package:ERP_RANGER/app/locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends BaseViewModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final Api _api = locator<GraphQL>();
  
  String _username ;
  String get username => _username;

  String _password ;
  String get passwords => _password;


  void userName(String value) {
    _username = value;
    notifyListeners();
  }

  void password(String value) {
    _password = value;
    notifyListeners();
  }

  void login()async {
    _api.getLoginModel(_username, _password);
    _username = "";
    _password = "";
    _navigationService.navigateTo(Routes.homeViewRoute);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("loggedIn", true);
  }
}