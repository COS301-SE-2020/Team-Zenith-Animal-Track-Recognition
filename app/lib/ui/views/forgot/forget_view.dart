import 'package:ERP_RANGER/services/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'forget_viewmodel.dart';

class ForgetView extends StatelessWidget {
  const ForgetView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForgetViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              logo,
              Container(margin:new EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),child: UserName()),
              Container(margin:new EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),child: Password()),
              Container(margin:new EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),child: ConfirmPassword()),
              Container(margin:new EdgeInsets.only(right: 20, left: 20),child: UploadButton())
            ],
          ),
        )
      ), 
      viewModelBuilder: () => ForgetViewModel(),
    );
  }
}

class UserName extends HookViewModelWidget<ForgetViewModel>{
  UserName({Key key,}) :super(reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, ForgetViewModel model) {
    var text = useTextEditingController();
    return TextField(
      controller: text,
      onChanged: model.userName,
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
        errorText: model.isNameValid ? null :model.userNameErrorString,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gapPadding: 0
        ),
        errorStyle: TextStyle(
          fontFamily: 'MavenPro',
          fontWeight: FontWeight.normal,
          color: Colors.red
        ),  
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gapPadding: 0
        ),     
        prefixIcon: Icon(Icons.person),
        hintText: "Username",
        filled: true,
        fillColor: Colors.grey[300]
      ),
      onSubmitted: (value) => {
        model.submitForget()
      },
      style: TextStyle(
        fontFamily: 'MavenPro',
        fontWeight: FontWeight.normal,
        color: Colors.black
      ),
    );
  }
}

class Password extends HookViewModelWidget<ForgetViewModel>{
  Password({Key key,}) :super(reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, ForgetViewModel model) {
    var text = useTextEditingController();
    return TextField(controller: text,onChanged: model.password,
      textAlign: TextAlign.left,
      obscureText: model.obscureText,
      decoration: InputDecoration(
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        errorText: model.errorPassStringBool ? model.passErrorString : null ,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gapPadding: 0
        ),
        errorStyle: TextStyle(
          fontFamily: 'MavenPro',
          fontWeight: FontWeight.normal,
          color: Colors.red
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gapPadding: 0
        ),
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(Icons.remove_red_eye),
          onPressed: (){
            model.setObscure();
          },
        ),
        hintText: "Password",
        filled: true,
        fillColor: Colors.grey[300]
      ),
      onSubmitted: (value) => {
        model.submitForget()
      },
      style: TextStyle(
        fontFamily: 'MavenPro',
        fontWeight: FontWeight.normal,
        color: Colors.black
      ),
    );
  }
}

class ConfirmPassword extends HookViewModelWidget<ForgetViewModel>{
  ConfirmPassword({Key key,}) :super(reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, ForgetViewModel model) {
    var text = useTextEditingController();
    return TextField(controller: text,onChanged: model.confirmPassword,
      textAlign: TextAlign.left,
      obscureText: model.obscureConfirmText,
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
        suffixIcon: IconButton(
          icon: Icon(Icons.remove_red_eye),
          onPressed: (){
            model.setObscureConfirm();
          },
        ),
        errorText: model.errorStringBool ? model.errorString : null,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gapPadding: 0
        ),
        errorStyle: TextStyle(
          fontFamily: 'MavenPro',
          fontWeight: FontWeight.normal,
          color: Colors.red
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gapPadding: 0
        ),
        hintText: "Confirm Password",
        filled: true,
        fillColor: Colors.grey[300]
      ),
      onSubmitted: (value) => {
        model.submitForget()
      },
      style: TextStyle(
        fontFamily: 'MavenPro',
        fontWeight: FontWeight.normal,
        color: Colors.black
      ),
    );
  }
}

class UploadButton extends ViewModelWidget<ForgetViewModel> {
  UploadButton({Key key}) :super(reactive: true);

  @override
  Widget build(BuildContext context, ForgetViewModel model) {
    return Container(
      margin: EdgeInsets.only(right:15, left: 15, top: 5,bottom: 5,),
      width: 200,
      child: RaisedButton(
        child: text20CenterBoldWhite("Submit"),
        color: Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.all(10),
        onPressed: (){
          model.submitForget();
        }
      ),
    );
  }
}
