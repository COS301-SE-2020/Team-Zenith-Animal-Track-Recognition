
import 'dart:async';

import 'package:ERP_Ranger/core/services/mock_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



var data = MockApi.getData;

Completer<GoogleMapController> _controller = Completer();

final CameraPosition _myLocation = CameraPosition(
  target: LatLng(-25.882171,28.264653),
  zoom: 15,
);

class spoor_identification_1 extends StatefulWidget {
  @override
  _spoor_identification_1State createState() => _spoor_identification_1State();
}

class _spoor_identification_1State extends State<spoor_identification_1> {

Widget build(BuildContext context){
  return Scaffold(
    body: Stack(
      children: <Widget>[
        Container(
          child: GoogleMap(
            initialCameraPosition: _myLocation,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
            },
          ),
        ),
        backButton(context),
        Sheet(),
      ],
    ),
  );
}

}

class Sheet extends StatefulWidget{
  @override
 _Sheet createState() => _Sheet();

}

class _Sheet extends State<Sheet>{
  @override
  Widget build(BuildContext context) {
    bool _isVisible = true;
    void showToast(){
      setState(() {
        _isVisible = !_isVisible;
      });
    }
    return NotificationListener<DraggableScrollableNotification>(
      child: DraggableScrollableSheet(
        initialChildSize: 0.12,
        minChildSize: 0.12,
        maxChildSize: 0.99,
        builder: (BuildContext context, ScrollController myscrollController){
          return Scaffold(
              body: Stack(
                children: <Widget>[
                  Container(
                    padding: new EdgeInsets.all(0.0),
                    margin: new EdgeInsets.all(0.0),
                    decoration: BoxDecoration(
                        color: Colors.white
                    ),
                    child: ListView(
                      padding: new EdgeInsets.only(top: 10.0),
                      controller: myscrollController,
                      children: <Widget>[
                        Container(
                          color: Colors.grey[850],
                          child: Row(
                            children: <Widget>[
                              Expanded(flex: 1, child: icon),
                              SizedBox(height: 1.0),
                              Expanded(flex: 4, child: text),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        barInfo,
                        dividerGrey,
                        Column(
                          children: <Widget>[
                            identifyText,
                            Row(
                              children: <Widget>[
                                Expanded(flex: 1,child: confidentImageBlock),
                                Expanded(flex: 1, child: confidentImageDetails),
                              ],
                            )
                          ],
                        ),
                        dividerGrey,
                        Column(
                          children: <Widget>[
                            otherMatches,
                            Row(
                              children: <Widget>[
                                Expanded(flex: 1, child: similarSpoor)
                              ],
                            )
                          ],
                        ),
                        dividerGrey,
                        Column(children: <Widget>[
                          attachTag,
                        ],),
                        dividerGrey,
                        Row(
                          children: <Widget>[
                            Expanded(flex: 1,child: button1),
                            SizedBox(height: 1.0),
                            Expanded(flex: 1,child: button2),
                            SizedBox(height: 1.0),
                            Expanded(flex: 1,child: button3),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              )
          );
        },
      ),
    );
  }
}

//_____________________________________________________________________________//
Widget icon = new Container(
  alignment: Alignment(0,0),
  margin: new EdgeInsets.only(bottom: 3,left: 3,right: 3),
  decoration: BoxDecoration(
    color: Colors.grey[850],
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.grey[850])
  ),
  child: Center(
    child: IconButton(
      alignment: Alignment(0,0),
      icon: Icon(Icons.keyboard_arrow_up, color: Colors.white,),
      onPressed: () {},
    ),
  ),
);

Widget barInfo = new Container(
  alignment: Alignment(0,0),
  margin: new EdgeInsets.only(bottom: 3,left: 10, right: 3),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        child: Row(
          children: <Widget>[
            Expanded(flex: 1, child: Icon(
              Icons.location_on,
              color: Colors.black,
            )),
            Expanded(flex: 3, child: Text('Spoor Location', style: TextStyle(color: Colors.black, fontSize: 15),),),
          ],
        ),
      ),
      SizedBox(height: 10,),
      Container(
        alignment: Alignment.centerLeft,
        margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
        padding: new EdgeInsets.all(5) ,
        child: Row(
          children: <Widget>[
            Expanded(child: Text('Kruger National Park'),)
          ],
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
        padding: new EdgeInsets.all(5) ,
        child: Row(
          children: <Widget>[
            Expanded(flex: 1,child: Text('Date: ',style: TextStyle(color: Colors.black, fontSize: 15),),),
            Expanded(flex: 3,child: Text('09/09/2020',style: TextStyle(color: Colors.grey, fontSize: 15),),)
          ],
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
        padding: new EdgeInsets.all(5) ,
        child: Row(
          children: <Widget>[
            Expanded(flex: 1,child: Text('Coordinates: ',style: TextStyle(color: Colors.black, fontSize: 15),),),
            Expanded(flex: 3,child: Text('-240.19097, 31.559270',style: TextStyle(color: Colors.grey, fontSize: 15),),)
          ],
        ),
      )
    ],
  ),
);


Widget text = new Container(
  alignment: Alignment(0,0),
  margin: new EdgeInsets.only(bottom: 3,left: 10, right: 3),
  decoration: BoxDecoration(
    color: Colors.grey[850],
    borderRadius: BorderRadius.circular(10),
  ),
  height: 50,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Expanded(
        flex: 1,
        child: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Elephant Spoor identified',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      Expanded(
        flex: 1,
        child: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Swipe up for more options',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.white
            ),
          ),
        ),
      )
    ],
  ),
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
        "EDIT               SPOOR",
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
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: IconButton(
          icon:Icon(Icons.pets),
          onPressed: () {},
        ),
      ),
      Text(
        "VIEW                       ANIMAL INFO",
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
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.grey[850])
      ),
      child: GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: Center(
          child:Icon(Icons.arrow_back, color:Colors.white),
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
              Expanded(child: innerImageBlock(data[index]['pic']) ,flex:4),
              Expanded(child: name(data[index]['name']),flex:1),
              Expanded(child: animalSpecies(data[index]['species']),flex:1),
              Expanded(child: accuracyScore(data[index]['score']),flex:1),
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