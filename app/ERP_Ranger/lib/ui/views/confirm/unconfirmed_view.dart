import 'package:ERP_Ranger/core/services/user.dart';
import 'package:flutter/material.dart';
import '../../../core/viewmodels/confirm_viewmodel.dart';
import 'package:image_picker/image_picker.dart';
import '../base_view.dart';
import 'dart:io';

import 'confirm_view.dart';


class UnConfirmView extends StatefulWidget {
  @override
  _UnConfirmView createState() => _UnConfirmView();
}

class _UnConfirmView extends State<UnConfirmView> {

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return BaseView<ConfirmModel>(
        builder: (context, model, child) => Scaffold(
          body: Stack(
              children: <Widget>[
               // ImagesView(),
                backButton(context),
                Scroll(model: model,)
              ],
          )
        )
    );
  }
}

class ImageGet{
    Future<File> imagePicker() async{
      File image;
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.gallery);    
      image = File(pickedFile.path);
      return image;
    }

}

class ImagesView extends StatelessWidget {

  ImageGet picker = new ImageGet();
  File image;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: picker.imagePicker(),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          print(snapshot.error);
        }
        if(snapshot.data != null){
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage (
                  snapshot.data.readAsBytesSync(),
                ),
                fit: BoxFit.cover,
              )
            ),
          );
        }else{
          print(snapshot.data);
          return Container(
            child: Center(child: Text("Error"))
          );
        }
      },
    );
  }
}

class Scroll extends StatefulWidget {
  var model;
  Scroll({@required this.model});
  @override
  _Scroll createState() => _Scroll(model: model);
}

class _Scroll extends State<Scroll> {
  var model;
  _Scroll({@required this.model});
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.12,
      minChildSize: 0.12,
      maxChildSize: 0.250,
      builder:  (BuildContext context, ScrollController myscrollController){
        return Container(
          padding: new EdgeInsets.all(0.0),
          margin: new EdgeInsets.all(0.0),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child:ListView(
            padding: new EdgeInsets.only(top:10.0),
            controller: myscrollController,
            children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(flex:1 ,child: icon),
                    SizedBox(height: 1.0,),
                    Expanded(flex:4 ,child: text),
                    SizedBox(height: 1.0,),
                    Expanded(flex:1 ,child: blocks),
                  ],
                ),
                dividerGrey,
                Row(
                  children: <Widget>[
                    Expanded(flex:1 ,child: button1),
                    SizedBox(height: 1.0,),
                    Expanded(flex:1 ,child: button2(model, context)),
                    SizedBox(height: 1.0,),
                    Expanded(flex:1 ,child: button3),
                  ],
                ),
            ],
          ),
        );
      }
    );
  }
}

Widget icon = new Container(
  alignment: Alignment(0.0,0.0),
  margin: new EdgeInsets.only(bottom: 3, left: 3, right: 3),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.white)
  ),
  child: Center(
    child: IconButton(
      alignment: Alignment(0.0,0.0),
      icon:Icon(Icons.keyboard_arrow_up, color:Colors.black), 
      onPressed: () {},
    ),
  )
);

Widget text = new Container(
  alignment: Alignment(0.0,0.0),
  margin: new EdgeInsets.only(bottom: 3, left: 3, right: 3),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
  ),
  height: 50,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
        Expanded(
          flex:1,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Spoor could not be identified",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:20,
                fontFamily: 'Arciform',
                color: Colors.black
              ),
            )
          )
        ),
        Expanded(
          flex:1,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Swipe up for more options",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:15,
                fontFamily: 'Arciform',
                color: Colors.black38
              ),          
            )
          )
        )
    ],
  )
);

Widget blocks = new Container(
  alignment: Alignment(0.0,0.0),
  margin: new EdgeInsets.only(bottom: 3, left: 3, right: 3),
  decoration: BoxDecoration(
    color: Colors.grey,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.grey)
  ),
  width: 10,
  height: 50,
);

Widget dividerGrey = new Container(
  child: Divider(color: Colors.grey, thickness: 1.2,),
  margin: EdgeInsets.only(top: 7, bottom: 7),
);

Widget button1 = new Container(
  margin: new EdgeInsets.only(bottom: 0, left: 3, right: 3),
  padding: new EdgeInsets.all(0.0),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: IconButton(
          icon:Icon(Icons.sync_problem), 
          onPressed: () {},
        ),
      ),
      Text(
        "RECLASSIFY       SPOOR",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize:13,
          fontFamily: 'Arciform',
          color: Colors.black
        ),
      )
    ],
  ),
);

Widget button2 (model,context){
 return Container(
  margin: new EdgeInsets.only(bottom: 0, left: 3, right: 3),
  padding: new EdgeInsets.all(0.0),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: IconButton(
          icon:Icon(Icons.camera_alt), 
          onPressed: () async{
          List<User> animals = await model.imagePicker();
          if(animals == null){
            Navigator.push(context, 
              new MaterialPageRoute(builder: (context) => UnConfirmView())
            ); 
            }else{
              Navigator.push(context, 
                new MaterialPageRoute(builder: (context) => ConfirmView(animal: animals,))
              ); 
            }
          },
        ),
      ),  
      Text(
        "RECAPTURE           SPOOR",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize:13,
          fontFamily: 'Arciform',
          color: Colors.black
        ),
      )
    ],
  ),
);
}

Widget button3 = new Container(
  margin: new EdgeInsets.only(bottom: 0, left: 3, right: 3),
  padding: new EdgeInsets.all(0.0),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: IconButton(
          icon:Icon(Icons.file_download), 
          onPressed: () {},
        ),
      ),
      Text(
        "DOWNLOAD             IMAGE",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize:13,
          fontFamily: 'Arciform',
          color: Colors.black
        ),
      )
    ],
  ),
);

Widget backButton (context){
  return Container(
    padding: new EdgeInsets.all(0.0),
    height: 50,
    width:  50,
    alignment: Alignment(0.0,0.0),
    margin: new EdgeInsets.only(top: 10, left: 10,),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: Colors.white)
    ),
    child: GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: Center(
        child:Icon(Icons.arrow_back, color:Colors.black),
      ),
    )
  );
}