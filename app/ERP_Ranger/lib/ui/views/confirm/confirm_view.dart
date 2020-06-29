import 'package:ERP_Ranger/core/services/mock_api.dart';
import 'package:ERP_Ranger/core/services/user.dart';
import 'package:ERP_Ranger/ui/views/confirm/unconfirmed_view.dart';
import 'package:flutter/material.dart';
import '../../../core/viewmodels/confirm_viewmodel.dart';
import 'package:image_picker/image_picker.dart';
import '../base_view.dart';
import 'dart:io';

List<String> listLink = new List();
List<String> listNames = new List();
List<String> listSpecies = new List();
List<String> listAccuracy = new List();


class ConfirmView extends StatefulWidget {
  List<User> animal;
  ConfirmView({@required this.animal});
  @override
  _ConfirmView createState() => _ConfirmView();
}

class _ConfirmView extends State<ConfirmView> {

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    
    listLink.add("https://images.unsplash.com/flagged/photo-1557650454-65194af63bf9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60");
    listLink.add("https://images.unsplash.com/photo-1508605375977-9fe795aea86a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60");
    listLink.add("https://images.unsplash.com/photo-1541793647037-86afaddc1cf0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80");
    listNames.add("Rhino");
    listNames.add("Buffalo");
    listNames.add("Antelope");
    listSpecies.add("White Rhino");
    listSpecies.add("Cape Bufallo");
    listSpecies.add("Steenbok");
    listAccuracy.add("13%");
    listAccuracy.add("11%");
    listAccuracy.add("9%");
  }
  @override
  Widget build(BuildContext context) {

    return BaseView<ConfirmModel>(
        builder: (context, model, child) => Scaffold(
          body: Stack(
              children: <Widget>[
              //  ImagesView(),
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
    bool _isVisible = true;
    void showToast() {
      setState(() {
        _isVisible = !_isVisible;
      });
    }
    return NotificationListener<DraggableScrollableNotification>(
        onNotification: (notification) {
          print("${notification.extent}");
          if(notification.extent > 0.5){
            
          }
        },
        child: DraggableScrollableSheet(
        initialChildSize: 0.12,
        minChildSize: 0.12,
        maxChildSize: 0.99,
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
                  Column(
                    children: <Widget>[
                      identifyText,
                      Row(
                        children: <Widget>[
                          Expanded(flex: 1, child: confidentImageBlock),
                          Expanded(flex: 1, child: confidentImageDetails),
                        ],
                      ),
                    ],
                  ),
                  dividerGrey,
                  Column(
                    children:
                     <Widget>[
                       otherMatches,
                       Row(
                         children: <Widget>[
                          Expanded(flex:1,
                           child: similarSpoor,
                          )
                         ]
                       )
                    ],
                  ),
                  dividerGrey,
                  Column(
                    children: <Widget>[
                      attachTag,
                      ToggleButton()
                    ],
                  ),
                  dividerGrey,
                  Row(
                    children: <Widget>[
                      Expanded(flex:1 ,child: button1),
                      SizedBox(height: 1.0,),
                      Expanded(flex:1 ,child: button2),
                      SizedBox(height: 1.0,),
                      Expanded(flex:1 ,child: button3(model,context)),
                      SizedBox(height: 1.0,),
                      Expanded(flex:1 ,child: button4)
                    ],
                  ),
              ],
            ),
          );
        }
      ),
    );
  }
}


//===============================
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
  margin: new EdgeInsets.only(bottom: 3, left: 10, right: 3),
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
              "African Bush Elephant",
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
  padding: new EdgeInsets.all(0.0),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    //border: Border.all(color: Colors.black,width: 1)
  ),
  width: 10,
  height: 50,
  child: Column(
    children: <Widget>[
      Expanded(
        flex: 2,
        child: Text(
          "67%",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize:30,
            fontFamily: 'Arciform',
            color: Colors.black
          ),
        ),
      ),
      Expanded(
        flex: 1,
        child: Text(
          "MATCH",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize:15,
            fontFamily: 'Arciform',
            color: Colors.black
          ),
        ),
      ),
  ],)
);

Widget dividerGrey = new Container(
  child: Divider(color: Colors.grey, thickness: 1.2,),
  margin: EdgeInsets.only(top: 7, bottom: 7),
);

//================================
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
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: IconButton(
          icon:Icon(Icons.check), 
          onPressed: () {},
        ),
      ),
      Text(
        "CONFIRM             SPOOR",
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

Widget button2 = new Container(
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

Widget button3 (model,context){
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

Widget button4 = new Container(
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


//===============================

Widget identifyText = new Container(
  alignment: Alignment.centerLeft,
  margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
  padding: new EdgeInsets.all(5) ,
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
  ),
  //height: 0,
  child: Text(
    "Spoor Identification Results",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:20,
      fontFamily: 'Arciform',
      color: Colors.grey
    ),
  ),
);

Widget confidentImageBlock = new Container(
  alignment: Alignment.center,
  margin: new EdgeInsets.only(bottom:10, left:15,right:10,top:10 ),
  //padding: new EdgeInsets.all(5),
    decoration: BoxDecoration(
    image: DecorationImage(
      image: NetworkImage( "https://images.unsplash.com/photo-1551316679-9c6ae9dec224?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"),
      fit: BoxFit.fill,
    ),
    color: Colors.grey,
    borderRadius: BorderRadius.circular(15),
  ),
  height: 170,
  width: 130,
);

Widget confidentImageDetails = new Container(
  alignment: Alignment.center,
  margin: new EdgeInsets.all(10),
  padding: new EdgeInsets.only(left:8),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
  ),
  height: 170,
  width: 130,
  child: Column(
    children:<Widget>[
      Expanded(
        flex:1,
        child: Row(
          children: <Widget>[
            Expanded(flex:1,child: type),
            Expanded(flex:1,child: typeVal("Track")),
          ],
        )
      ),
      Expanded(
        flex:1,
        child: Row(
          children: <Widget>[
            Expanded(flex:1,child: animal),
            Expanded(flex:1,child: animalVal("Elephant")),
          ],
        )
      ),
      Expanded(
        flex:1,
        child: Row(
          children: <Widget>[
            Expanded(flex:1,child: species),
            Expanded(flex:1,child: speciesVal("African Bush")),
          ],
        )
      ),
      Expanded(
        flex:1,
        child: accuracy
      ),
      Expanded(
        flex:2,
        child: score
      ),      
    ]
  ),
);

Widget type = new Container(
    alignment: Alignment.centerLeft,
    padding: new EdgeInsets.all(0),
    child: Text(
    "Type:",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:15,
      fontFamily: 'Arciform',
      color: Colors.black
    ),
  ),
);

Widget typeVal(String track){
  return new Container(
      alignment: Alignment.centerLeft,
      padding: new EdgeInsets.all(0),
      child: Text(
      track,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize:15,
        fontFamily: 'Arciform',
        color: Colors.grey
      ),
    ),
  );
} 

Widget animal = new Container(
    alignment: Alignment.centerLeft,
    padding: new EdgeInsets.all(0),
    child: Text(
    "Animal:",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:15,
      fontFamily: 'Arciform',
      color: Colors.black
    ),
  ),
);

Widget animalVal(String name){
  return new Container(
      alignment: Alignment.centerLeft,
      padding: new EdgeInsets.all(0),
      child: Text(
      name,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize:15,
        fontFamily: 'Arciform',
        color: Colors.grey
      ),
    ),
  );
} 

Widget species = new Container(
    alignment: Alignment.centerLeft,
    padding: new EdgeInsets.all(0),
    child: Text(
    "Species:",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:15,
      fontFamily: 'Arciform',
      color: Colors.black
    ),
  ),
);

Widget speciesVal(String species){
  return new Container(
      alignment: Alignment.centerLeft,
      padding: new EdgeInsets.all(0),
      child: Text(
      species,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize:15,
        fontFamily: 'Arciform',
        color: Colors.grey
      ),
    ),
  );
} 

Widget accuracy = new Container(
    alignment: Alignment.centerLeft,
    padding: new EdgeInsets.all(0),
    child: Text(
    "Accuracy Score:",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:15,
      fontFamily: 'Arciform',
      color: Colors.black
    ),
  ),
);

Widget score = new Container(
    alignment: Alignment.centerLeft,
    padding: new EdgeInsets.all(0),
    child: Text(
    "67%",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:45,
      fontFamily: 'Arciform',
      color: Colors.black
    ),
  ),
);
//===============================
Widget otherMatches = new Container(
  alignment: Alignment.centerLeft,
  margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
  padding: new EdgeInsets.all(5) ,
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
  ),
  //height: 0,
  child: Text(
    "Other Possible Matches",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:20,
      fontFamily: 'Arciform',
      color: Colors.grey
    ),
  ),
);

Widget innerImageBlock (String link){
    return new Container(
    alignment: Alignment.center,
    margin: new EdgeInsets.all(5),
    padding: new EdgeInsets.all(5),
      decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(10),
      image: DecorationImage(
          image: NetworkImage( link),
          fit: BoxFit.fill,
          
      ),
    ),
    height: 115,
    // width: 75,
  );
}

Widget name(String name){
  return new Container(
      alignment: Alignment.centerLeft,
      padding: new EdgeInsets.all(5),
      margin: new EdgeInsets.only(left: 2),
      child: Text(
      name,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize:15,
        fontFamily: 'Arciform',
        color: Colors.black
      ),
    ),
  );
}

Widget animalSpecies(String species){
  return new Container(
      alignment: Alignment.centerLeft,
      margin: new EdgeInsets.only(left: 2),
      padding: new EdgeInsets.all(5),
      child: Text(
      species,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize:15,
        fontFamily: 'Arciform',
        color: Colors.grey
      ),
    ),
  );
}

Widget accuracyScore(String score){
  return new Container(
      alignment: Alignment.centerLeft,
      margin: new EdgeInsets.only(left: 2),
      padding: new EdgeInsets.all(5),
      child: Text(
      score,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize:15,
        fontFamily: 'Arciform',
        color: Colors.grey
      ),
    ),
  );
}
//===============================
Widget similarSpoor = Container(
  height: 200,
  color: Colors.white,
  child: ListView.builder(
    shrinkWrap: true,
    scrollDirection: Axis.horizontal,
    itemCount: 3,
    itemBuilder: (BuildContext context, int index) {
      return Container(
        alignment: Alignment.center,
        margin: new EdgeInsets.only(left:8,bottom:5,top:5,),
        //padding: new EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 200,
        width: 110,
        child: Column(
          children: <Widget>[
            Expanded(child: innerImageBlock(listLink[index]) ,flex:4),
            Expanded(child: name(listNames[index]),flex:1),
            Expanded(child: animalSpecies(listSpecies[index]),flex:1),
            Expanded(child: accuracyScore(listAccuracy[index]),flex:1),
          ],
        ),
      );
    }
  ),
);
//===============================
Widget attachTag = new Container(
  alignment: Alignment.centerLeft,
  margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
  padding: new EdgeInsets.all(5) ,
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
  ),
  //height: 0,
  child: Text(
    "Attach A Tag",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:20,
      fontFamily: 'Arciform',
      color: Colors.grey
    ),
  ),
);

Widget track = new Container(

  child: Text(
    "Track",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:17,
      fontFamily: 'Arciform',
    ),
  ),
);

Widget blood = new Container(
  child: Text(
    "Blood",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:17,
      fontFamily: 'Arciform',
    ),
  ),
);

Widget stool = new Container(
  child: Text(
    "Stool",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:17,
      fontFamily: 'Arciform',
    ),
  ),
);

Widget hoof = new Container(

  child: Text(
    "Hoof",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:17,
      fontFamily: 'Arciform',
    ),
  ),
);

Widget tusk = new Container(
  child: Text(
    "Tusk",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:17,
      fontFamily: 'Arciform',
    ),
  ),
);

Widget horn = new Container(
  child: Text(
    "Horn",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:17,
      fontFamily: 'Arciform',
    ),
  ),
);

Widget fur = new Container(
  child: Text(
    "Fur",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:17,
      fontFamily: 'Arciform',
    ),
  ),
);

class ToggleButton extends StatefulWidget {
  ToggleButton({Key key, List<Widget> children}) : super(key: key);

  @override
  _ToggleButtons createState() => _ToggleButtons();
}

class _ToggleButtons extends State<ToggleButton> {
  List<bool> _selection = List.generate(7, (index) => false);
  FocusNode focusButton1 = FocusNode();
  FocusNode focusButton2 = FocusNode();
  FocusNode focusButton3 = FocusNode();
  FocusNode focusButton4 = FocusNode();
  FocusNode focusButton5 = FocusNode();
  FocusNode focusButton6 = FocusNode();
  FocusNode focusButton7 = FocusNode();
  List<FocusNode> focusToggle;

  @override
  void initState() { 
    super.initState();
    focusToggle = [focusButton1,focusButton2,focusButton3,focusButton4,focusButton5,focusButton6,focusButton7];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    focusButton1.dispose();
    focusButton2.dispose();
    focusButton3.dispose();
    focusButton4.dispose();
    focusButton5.dispose();
    focusButton6.dispose();
    focusButton7.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:ToggleButtons(
          children: [
            track,
            blood,
            stool,
            fur,
            hoof,
            tusk,
            horn,
          ], 
          isSelected: _selection, 
          focusNodes: focusToggle,
          onPressed: (int index){
            setState(() {
              for(int indexBtn=0; indexBtn<_selection.length;indexBtn++){
                if(indexBtn == index){
                   _selection[indexBtn] = true;
                }else{
                  _selection[indexBtn] = false;
                }
              }
            });
          },
          color: Colors.grey,
          selectedColor: Colors.white,
          selectedBorderColor: Colors.grey,
          fillColor: Colors.grey,
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize:20,
            fontFamily: 'Arciform',
          ),
          borderRadius: BorderRadius.only(topLeft:Radius.circular(15), bottomRight:Radius.circular(15)),
          borderWidth: 2,
          borderColor: Colors.grey,
        ),
    );
  }
}
