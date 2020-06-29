import 'package:ERP_Ranger/ui/views/home/home_view.dart';
import 'package:flutter/material.dart';
import '../../../core/viewmodels/confirm_viewmodel.dart';
import '../base_view.dart';
import 'dart:io';


class ConfirmView extends StatefulWidget {
  @override
  _ConfirmView createState() => _ConfirmView();
}

class _ConfirmView extends State<ConfirmView> {
  @override
  Widget build(BuildContext context) {

    return BaseView<ConfirmModel>(
        builder: (context, model, child) => Scaffold(
          body: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                  child: Column(
                      children: <Widget>[
                          Heading(),
                          SubHeading(),
                          ViewButton(model: model),
                          ViewButtonInfo(model: model,),
                          DownLoadButton(model: model),
                          RecaptureButton(model: model)
                      ]
                  )
              ),
          ),
        ),
    );
  }
}

class Heading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        //height: 20,
        margin: new EdgeInsets.only(top:20),
        child: Text('SPOOR IDENTIFIED!',
          style: TextStyle(fontSize: 35,
            fontFamily: 'Arciform',
            fontWeight: FontWeight.bold)
        ),
      ),
    );
  }
}

class SubHeading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        //height: 20,
        margin: new EdgeInsets.only(bottom:20),
        child: Text('Please select an option below',
          style: TextStyle(fontSize: 20,
            fontFamily: 'Arciform',
            color: Colors.grey,
            fontWeight: FontWeight.normal)
        ),
      ),
    );
  }
}

class ViewButton extends StatelessWidget {
  var model;

  ViewButton({@required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 325,
        margin: const EdgeInsets.only(top: 20.0),
        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
        ),
        child: RaisedButton(
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          splashColor: Colors.grey,
          child: Text(
            'View Spoor',
            style: TextStyle(fontSize: 15,
            fontFamily: 'Arciform',
            fontWeight: FontWeight.bold),
          ),
          onPressed: () async{
        
          },
        ),
        
    );
  }
}

class ViewButtonInfo extends StatelessWidget {
  var model;

  ViewButtonInfo({@required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 325,
        margin: const EdgeInsets.only(top: 20.0),
        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
        ),
        child: RaisedButton(
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          splashColor: Colors.grey,
          child: Text(
            'View Spoor Info',
            style: TextStyle(fontSize: 15,
            fontFamily: 'Arciform',
            fontWeight: FontWeight.bold),
          ),
          onPressed: () async{
              Navigator.push(context, 
                new MaterialPageRoute(builder: (context) => HomeView())
              );
          },
        ),
        
    );
  }
}

class DownLoadButton extends StatelessWidget {
  var model;

  DownLoadButton({@required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 325,
        margin: const EdgeInsets.only(top: 20.0),
        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
        ),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          splashColor: Colors.grey,
          textColor: Colors.white,
          child: Text(
            'Download Image',
            style: TextStyle(fontSize: 15,
            fontFamily: 'Arciform',
            fontWeight: FontWeight.bold),
          ),
          onPressed: () async{
          
              
          },
        ),
        
    );
  }
}

class RecaptureButton extends StatelessWidget {
  var model;

  RecaptureButton({@required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 325,
        margin: const EdgeInsets.only(top: 20.0),
        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
        ),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          splashColor: Colors.grey,
          textColor: Colors.white,
          child: Text(
            'Recapture Image',
            style: TextStyle(fontSize: 15,
            fontFamily: 'Arciform',
            fontWeight: FontWeight.bold),
          ),
          onPressed: () async{
              bool boolean = await model.imagePicker();
              Navigator.push(context, 
                  new MaterialPageRoute(builder: (context) => ConfirmView())
              );
          },
        ),
        
    );
  }
}