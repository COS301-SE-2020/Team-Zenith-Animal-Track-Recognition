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
          body: Stack(children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 25),
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
        ),
        Container(
          height: double.infinity,
          child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 70,
                    ),
                    logo,
                    SizedBox(
                      height: 35,
                    ),
                    UserName(),
                    SizedBox(
                      height: 25,
                    ),
                    Password(),
                    SizedBox(
                      height: 25,
                    ),
                    UploadButton()
                  ],
                ),
              )),
        ),
      ])),
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
        // right: 15,
        // left: 15,
        top: 5,
        bottom: 5,
      ),
      width: 300,
      child: RaisedButton(
        key: Key('LoginButton'),
        onPressed: () {
          model.login(context);
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
              color: Color.fromRGBO(61, 122, 172, 1),
              borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50),
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
          hintText: "Email",
          filled: true,
          fillColor: Colors.grey[300]),
      onSubmitted: (value) => {model.login(context)},
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
      onSubmitted: (value) => {model.login(context)},
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
