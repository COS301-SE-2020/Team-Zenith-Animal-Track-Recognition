import 'package:ERP_Ranger/ui/views/home/home_view.dart';
import 'package:ERP_Ranger/core/viewmodels/login_viewmodel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:ERP_Ranger/ui/views/base_view.dart';


final GlobalKey<FormState> formKey = GlobalKey<FormState>();
String _id;
String _password;

class LoginView extends StatefulWidget {
  LoginView({Key key}) : super(key: key);

  @override
  _LoginView createState() => _LoginView();
}

class _LoginView extends State<LoginView> {
  @override
  
  Widget build(BuildContext context) {
    return BaseView<LoginModel>(
        builder: (context, model, child) =>Scaffold(
            backgroundColor: Colors.white,
            body:  Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LoginLogo(),
                Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        _buildID(),
                        SizedBox(height: 5.0,),
                        _buildPassword()
                      ],
                    ),
                  ),
                ForgotPassword(),
                buildButton(model)
              ],
            ),
        )
    );
  }

  Widget _buildID() {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      decoration: new InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        isDense: true,
        prefixIcon: Icon(Icons.person),
        hintText: 'Ranger ID'
      ),
      // maxLength: 10,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Ranger ID is Required';
        }
        return null;
      }, 
      onSaved: (String value) {
        _id = value;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          isDense: true,
          prefixIcon: Icon(Icons.lock),
          suffixIcon: Icon(Icons.remove_red_eye),
          hintText: 'Password'
        ),
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        validator: (String value) {
          if (value.isEmpty) {
            setState(() {});
            return 'Password is required';
          }
          if (value.length < 4 ) {
            return 'Password is too short';
          }
          return null;
        }, 
        onSaved: (String value) {
          _password = value;
        },
      );
   }

  Widget buildButton(model) {
    return Container(
        height: 50,
        width: 325,
        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0), 
          ),
          color: Colors.grey[300],
          splashColor: Colors.grey,
          textColor: Colors.white,
          child: Text(
            'Login',
            style: TextStyle(fontSize: 17,
            fontFamily: 'Arciform'),
          ),
          onPressed: () async{
            final form = formKey.currentState;
            if(form.validate()){
                form.save();
                var boolean = await model.validateUser(_id, _password);

                if(boolean){
                  Fluttertoast.showToast(
                    msg: "Login Successful",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    fontSize: 16.0
                  );
                  Navigator.of(context).pushAndRemoveUntil(PageRouteBuilder(pageBuilder: (context, animation1, animation2) => HomeView(animal:null)), (Route<dynamic> route) => false);
                }else{
                  Fluttertoast.showToast(
                          msg: "Invalid Login Details",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          fontSize: 16.0
                      );
                }
                
            }
              
          },
        ),
        
    );
  }
}

class LoginLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
        child: Container(
          width: 100,
          child: Image.asset('assets/images/logo.jpeg'),
        ),
      );
    }
  }

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xffB1B4E5),
                  fontFamily: 'Helvetica',
                ),
              ),
              onPressed: () {
                // Navigator.push(context, PageRouteBuilder(
                //   pageBuilder: (context, animation1, animation2) => ForgotPasswordView(),
                // ),); 
              },
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        )
      )
    );
  }
}