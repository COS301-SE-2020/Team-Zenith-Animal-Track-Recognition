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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              logo,
              Container(margin:new EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),child: UserName()),
              Container(margin:new EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),child: Password()),
              ForgotPassword(),
              UploadButton()
            ],
          ),
        )
      ), 
      viewModelBuilder: () => LoginViewModel(),
    );
  }
}

Widget logo = new Container(
    alignment: Alignment.center,
    //margin: new EdgeInsets.only(right:5,left:5),
    padding: new EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(10),
      image: DecorationImage(
        image: AssetImage("assets/images/logo.jpeg"),
        fit: BoxFit.fill,
      ),
    ),
    height: 130,
    width: 130,
);

class UploadButton extends ViewModelWidget<LoginViewModel> {
  UploadButton({Key key}) :super(reactive: true);

  @override
  Widget build(BuildContext context, LoginViewModel model) {
    return Container(
      margin: EdgeInsets.only(right:15, left: 15, top: 5,bottom: 5,),
      width: 200,
      child: RaisedButton(
        child: text("LOGIN",20),
        color: Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.all(10),
        onPressed: (){
          model.login();
        }
      ),
    );
  }
}

class UserName extends HookViewModelWidget<LoginViewModel>{
  UserName({Key key,}) :super(reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, LoginViewModel viewModel) {
    var text = useTextEditingController();
    return TextField(controller: text,onChanged: viewModel.userName,
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        prefixIcon: Icon(Icons.person),
        hintText: "Username",
        filled: true,
        fillColor: Colors.grey[300]
      ),
      style: TextStyle(
        fontFamily: 'Helvetica',
        fontWeight: FontWeight.normal,
        color: Colors.black
      ),
    );
  }
}

class Password extends HookViewModelWidget<LoginViewModel>{
  Password({Key key,}) :super(reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, LoginViewModel viewModel) {
    var text = useTextEditingController();
    return TextField(controller: text,onChanged: viewModel.password,
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        prefixIcon: Icon(Icons.lock),
        suffixIcon: Icon(Icons.remove_red_eye),
        hintText: "Password",
        filled: true,
        fillColor: Colors.grey[300]
      ),
      style: TextStyle(
        fontFamily: 'Helvetica',
        fontWeight: FontWeight.normal,
        color: Colors.black
      ),
    );
  }
}

class ForgotPassword extends ViewModelWidget<LoginViewModel>{
  ForgotPassword({Key key,}) :super(reactive: true);

  @override
  Widget build(BuildContext context, LoginViewModel viewModel) {
    return GestureDetector(
      child: Container(margin:new EdgeInsets.all(10),alignment: Alignment.center, child: text2("Forgot password?",17)),
    );
  }
}

Widget text(String text, double font){
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: font,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.bold,
      color: Colors.white
    ),
  );
}

Widget text2(String text, double font){
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: font,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.bold,
      color: Colors.blue[300]
    ),
  );
}