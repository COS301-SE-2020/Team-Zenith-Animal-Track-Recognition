import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/graphQL.dart';
import 'package:ERP_RANGER/services/api/mock_api.dart';
import 'package:stacked/stacked.dart';
import 'package:ERP_RANGER/app/locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final Api _api = locator<GraphQL>();
  //final Api _api = locator<MockApi>();

  String _username;
  String get username => _username;

  String _password;
  String get passwords => _password;

  bool _obscureText = true;
  bool get obscureText => _obscureText;

  bool valid = true;
  bool get isNameValid => valid;

  String _userNameErrorString = "";
  String get userNameErrorString => _userNameErrorString;

  bool _errorPassStringBool = false;
  bool get errorPassStringBool => _errorPassStringBool;

  String _passErrorString = "";
  String get passErrorString => _passErrorString;

  bool _isPassEmpty = true;
  bool get isPassEmpty => _isPassEmpty;

  bool _isUserNameEmpty = false;
  bool get isUserNameEmpty => _isUserNameEmpty;

  void userName(String value) {
    _username = value;
    if (value == "") {
      _isUserNameEmpty = true;
    } else {
      _isUserNameEmpty = false;
    }
    notifyListeners();
  }

  void password(String value) {
    _password = value;
    if (value == "") {
      _isPassEmpty = true;
    } else {
      _isPassEmpty = false;
    }
    notifyListeners();
  }

  void setObscure() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  void navigateToForget() {
    _navigationService.navigateTo(Routes.forgetViewRoute);
  }

  void passEmptyChecker() {
    if (_isPassEmpty) {
      _passErrorString = "Password Field Cannnot Be Left Empty!";
      _errorPassStringBool = true;
    } else {
      _errorPassStringBool = false;
    }
  }

  void userNameErrorChecker() {
    if (_username == "" || _username == null) {
      valid = false;
      _userNameErrorString = "Username Field Cannot Be left Empty";
    } else if (_username != "") {
      valid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(_username);
      if (valid == false) {
        _userNameErrorString = "Invalid Email Input";
      }
    }
  }

// NB come and fiz logic right here
  void login() async {
    userNameErrorChecker();
    passEmptyChecker();

    if (_isPassEmpty != true && isUserNameEmpty == false && valid == true) {
      print("success");
      valid = true;
      _isPassEmpty = true;
      _isUserNameEmpty = true;
      _navigationService.navigateTo(Routes.homeViewRoute);
      notifyListeners();
    } else {
      notifyListeners();
    }
  }
}
