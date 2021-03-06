import 'package:ERP_RANGER/services/util.dart';
import 'package:ERP_RANGER/ui/views/login/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
          body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              logo,
              Container(
                  key: Key('UserName'),
                  margin: new EdgeInsets.only(
                      right: 20, left: 20, top: 20, bottom: 10),
                  child: UserName()),
              Container(
                  key: Key('Password'),
                  margin: new EdgeInsets.only(
                      right: 20, left: 20, top: 10, bottom: 10),
                  child: Password()),
              UploadButton()
            ],
          ),
        ),
      )),
      viewModelBuilder: () => LoginViewModel(),
    );
  }
}

class UploadButton extends ViewModelWidget<LoginViewModel> {
  UploadButton({Key key}) : super(reactive: true);

  @override
  Widget build(BuildContext context, LoginViewModel model) {
    return Container(
      margin: EdgeInsets.only(
        right: 15,
        left: 15,
        top: 5,
        bottom: 5,
      ),
      width: 200,
      child: RaisedButton(
        key: Key('LoginButton'),
        onPressed: () {
          model.login();
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(33, 78, 125, 1),
                  Color.fromRGBO(80, 156, 208, 1)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            constraints: BoxConstraints(maxWidth: 200.0, minHeight: 50),
            alignment: Alignment.center,
            child: text20CenterBoldWhite("LOGIN"),
          ),
        ),
      ),
    );
  }
}

class UserName extends HookViewModelWidget<LoginViewModel> {
  UserName({
    Key key,
  }) : super(reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, LoginViewModel model) {
    var text = useTextEditingController();
    return TextField(
      key: Key('InputUser'),
      controller: text,
      onChanged: model.userName,
      textAlign: TextAlign.left,
      decoration: InputDecoration(
          isDense: true,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          errorText: model.isNameValid ? null : model.userNameErrorString,
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gapPadding: 0),
          errorStyle: TextStyle(
              fontFamily: 'MavenPro',
              fontWeight: FontWeight.normal,
              color: Colors.red),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gapPadding: 0),
          prefixIcon: Icon(Icons.person),
          hintText: "Username",
          filled: true,
          fillColor: Colors.grey[300]),
      onSubmitted: (value) => {model.login()},
      style: TextStyle(
          fontFamily: 'MavenPro',
          fontWeight: FontWeight.normal,
          color: Colors.black),
    );
  }
}

class Password extends HookViewModelWidget<LoginViewModel> {
  Password({
    Key key,
  }) : super(reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, LoginViewModel model) {
    var text = useTextEditingController();
    return TextField(
      key: Key('InputPassword'),
      controller: text,
      onChanged: model.password,
      textAlign: TextAlign.left,
      obscureText: model.obscureText,
      decoration: InputDecoration(
          isDense: true,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(Icons.remove_red_eye),
            onPressed: () {
              model.setObscure();
            },
          ),
          errorText: model.errorPassStringBool ? model.passErrorString : null,
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gapPadding: 0),
          errorStyle: TextStyle(
              fontFamily: 'MavenPro',
              fontWeight: FontWeight.normal,
              color: Colors.red),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gapPadding: 0),
          hintText: "Password",
          filled: true,
          fillColor: Colors.grey[300]),
      onSubmitted: (value) => {model.login()},
      style: TextStyle(
          fontFamily: 'MavenPro',
          fontWeight: FontWeight.normal,
          color: Colors.black),
    );
  }
}

Widget text(String text, double font) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
        fontSize: font,
        fontFamily: 'MavenPro',
        fontWeight: FontWeight.bold,
        color: Colors.blue[300]),
  );
}

// Container(
//   margin: EdgeInsets.only(
//         right: 15,
//         left: 15,
//         top: 5,
//         bottom: 5,
//       ),
//   width: 200,
//   child: RaisedButton(
//     onPressed: () {model.login();},
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
//     padding: EdgeInsets.all(0.0),
//     child: Ink(
//       decoration: BoxDecoration(
//           gradient: LinearGradient(colors: [Color(0xff374ABE), Color(0xff64B6FF)],
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//           ),
//           borderRadius: BorderRadius.circular(30.0)
//       ),
//       child: Container(
//         constraints: BoxConstraints(maxWidth: 200.0),
//         alignment: Alignment.center,
//         child: text20CenterBoldWhite("LOGIN"),
//       ),
//     ),
//   ),
// ),
