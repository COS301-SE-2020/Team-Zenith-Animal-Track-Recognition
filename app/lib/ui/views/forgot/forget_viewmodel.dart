import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/graphQL.dart';
import 'package:stacked/stacked.dart';
import 'package:ERP_RANGER/app/locator.dart';

class ForgetViewModel extends BaseViewModel {
  final Api _api = locator<GraphQL>();

  String _username = "";
  String get username => _username;

  String _password = "";
  String get passwords => _password;

  String _confirmPassword = "";
  String get confirmPasswords => _confirmPassword;

  String _userNameErrorString = "";
  String get userNameErrorString => _userNameErrorString;

  String _passErrorString = "";
  String get passErrorString => _passErrorString;

  String _errorString = "";
  String get errorString => _errorString;

  bool _errorPassStringBool = false;
  bool get errorPassStringBool => _errorPassStringBool;

  bool _errorStringBool = false;
  bool get errorStringBool => _errorStringBool;

  bool valid = true;
  bool get isNameValid => valid;

  bool _isUserNameEmpty = false;
  bool get isUserNameEmpty => _isUserNameEmpty;

  bool _isPassEmpty = true;
  bool get isPassEmpty => _isPassEmpty;

  bool _isPassConfirmEmpty = true;
  bool get isPassConfirmEmpty => _isPassConfirmEmpty;

  bool _isPassConfirmEqual = false;
  bool get isPassConfirmEqual => _isPassConfirmEqual;

  bool _obscureText = true;
  bool get obscureText => _obscureText;

  bool _obscureConfirmText = true;
  bool get obscureConfirmText => _obscureConfirmText;

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

  void confirmPassword(String value) {
    _confirmPassword = value;
    if (value == "") {
      _isPassConfirmEmpty = true;
    } else {
      _isPassConfirmEmpty = false;
    }

    notifyListeners();
  }

  void setObscure() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  void setObscureConfirm() {
    _obscureConfirmText = !_obscureConfirmText;
    notifyListeners();
  }

  void submitForget() {
    userNameErrorChecker();
    errorChecker();
    passEmptyChecker();
    if (_isPassConfirmEqual == true &&
        _isPassConfirmEmpty == false &&
        _isPassEmpty != true &&
        isUserNameEmpty == false &&
        valid == true) {
      print("success");
      _username = "";
      _password = "";
      _confirmPassword = "";
      valid = true;
      _isPassConfirmEmpty = true;
      _isPassEmpty = true;
      _isPassConfirmEqual = false;
      _isUserNameEmpty = true;
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  void userNameErrorChecker() {
    if (_username == "" || _username == null) {
      print("$_username=============");
      valid = false;
      _userNameErrorString = "Username Field Cannot Be left Empty";
    } else if (_username != "") {
      print("$_username=============");
      valid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(_username);
      if (valid == false) {
        _userNameErrorString = "Invalid Email Input";
      }
    }
  }

  void passEmptyChecker() {
    if (_isPassEmpty) {
      _passErrorString = "Password Field Cannnot Be Left Empty!";
      _errorPassStringBool = true;
    } else {
      _errorPassStringBool = false;
    }
  }

  void errorChecker() {
    if (_isPassConfirmEmpty) {
      _errorString = "Password Field Cannnot Be Left Empty!";
      _errorStringBool = true;
    } else if (_confirmPassword == _password) {
      _isPassConfirmEqual = false;
      _errorString = "Password Fields Must Match Each Other!";
      _errorStringBool = true;
    } else {
      _errorStringBool = false;
    }
  }
}
