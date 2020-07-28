import 'dart:async';

import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:ERP_RANGER/ui/views/animals/animal_view.dart';
import 'package:ERP_RANGER/ui/views/identification/identification_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class IdentificationView extends StatelessWidget {
  IdentificationView({@required this.name});
  String name;
  CameraPosition _myLocation = CameraPosition(
    target: LatLng(-25.882171, 28.264653),
    zoom: 15,
  );

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<IdentificationViewModel>.reactive(
      builder: (context, model, child) =>FutureBuilder(
      future: model.getResults(name),
      builder: (context, snapshot) {
        if(snapshot.hasError){
           return text1("Error", 20);
        }
        if (snapshot.hasData) {       
     
          return WillPopScope(
            onWillPop: () async {
              if (Navigator.canPop(context)) {
                model.navigate(context);
              }
              return;
            },
            child: Scaffold(
              body: Stack(
                children: <Widget>[
                  Container(
                    child: GoogleMap(
                      initialCameraPosition: _myLocation,
                      mapType: MapType.normal,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),
                  backButton(context),
                  SpoorListBody(confident: model.confident,list: model.recentIdentifications, similarSpoorModel: model.similarSpoorModel,),
                ],
              ),
            ),
          );
        }else{
          return text1("Null no Data", 20);
        }
    }),
      viewModelBuilder: () => IdentificationViewModel(),
    );
  }
}

class SpoorListBody extends ViewModelWidget<IdentificationViewModel> {
  SpoorModel confident;
  List<SpoorModel> list;
  SimilarSpoorModel similarSpoorModel;
  SpoorListBody({Key key, this.list,this.similarSpoorModel,this.confident}) : super(reactive: true);

  @override
  Widget build(BuildContext context, IdentificationViewModel model) {
    return NotificationListener<DraggableScrollableNotification>(
      child: DraggableScrollableSheet(
        initialChildSize: 0.12,
        minChildSize: 0.12,
        maxChildSize: 0.99,
        builder: (BuildContext context, ScrollController myscrollController) {
          return Scaffold(
              body: Stack(
                children: <Widget>[
                  Container(
                    padding: new EdgeInsets.all(0.0),
                    margin: new EdgeInsets.all(0.0),
                    decoration: BoxDecoration(color: Colors.white),
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
                              Expanded(flex: 4, child: text(model.confident.name)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        barInfo,
                        dividerGrey,
                        Column(
                          children: <Widget>[
                            identifyText,
                            Row(
                              children: <Widget>[
                                Expanded(flex: 1, child: confidentImageBlock(confident.pic)),
                                Expanded(flex: 1, child: confidentImageDetails(confident)),
                              ],
                            )
                          ],
                        ),
                        dividerGrey,
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(flex: 1, child: OtherMatches(list:list))
                              ],
                            )
                          ],
                        ),
                        dividerGrey,
                        Column(
                          children: <Widget>[
                            similarSpoors,
                            Row(
                              children: <Widget>[
                                Expanded(flex: 1, child: similarSpoor(similarSpoorModel))
                              ],
                            )
                          ],
                        ),
                        dividerGrey,
                        Column(
                          children: <Widget>[
                            attachATag,
                          ],
                        ),
                        dividerGrey,
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(flex: 1, child: button1),
                              SizedBox(height: 1.0),
                              Expanded(flex: 1, child: button2),
                              SizedBox(height: 1.0),
                              Expanded(flex: 1, child: button3),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ));
        },
      ),
    );
  }
}


//_____________________________________________________________________________//
Widget icon = new Container(
  alignment: Alignment(0, 0),
  margin: new EdgeInsets.only(bottom: 3, left: 3, right: 3),
  decoration: BoxDecoration(
      color: Colors.grey[850],
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey[850])),
  child: Center(
    child: IconButton(
      alignment: Alignment(0, 0),
      icon: Icon(
        Icons.keyboard_arrow_up,
        color: Colors.white,
      ),
      onPressed: () {},
    ),
  ),
);

Widget barInfo = new Container(
  alignment: Alignment(0, 0),
  margin: new EdgeInsets.only(bottom: 3, left: 10, right: 3),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Icon(
                  Icons.location_on,
                  color: Colors.black,
                )),
            Expanded(
              flex: 3,
              child: Text(
                'Spoor Location',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Arciform',
                    color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
        alignment: Alignment.centerLeft,
        margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
        padding: new EdgeInsets.all(5),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text('Kruger National Park',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arciform',
                      color: Colors.black)),
            )
          ],
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
        padding: new EdgeInsets.all(5),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(
                'Date: ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Arciform',
                    color: Colors.black),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                '09/09/2020',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            )
          ],
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
        padding: new EdgeInsets.all(5),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(
                'Coordinates: ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Arciform',
                    color: Colors.black),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                '-240.19097, 31.559270',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            )
          ],
        ),
      )
    ],
  ),
);

Widget text(String name){
  return Container(
    alignment: Alignment(0, 0),
    margin: new EdgeInsets.only(bottom: 3, left: 10, right: 3),
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
              '$name Spoor identified',
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
                  fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
            ),
          ),
        )
      ],
    ),
  );
} 

Widget dividerGrey = new Container(
  child: Divider(
    color: Colors.grey,
    thickness: 1.2,
  ),
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
          icon: Icon(Icons.sync_problem),
          onPressed: () {},
        ),
      ),
      Text(
        "EDIT",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            fontFamily: 'Arciform',
            color: Colors.black),
      ),
      Text(
        "SPOOR",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            fontFamily: 'Arciform',
            color: Colors.black),
      ),
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
          icon: Icon(Icons.pets),
          onPressed: () {},
        ),
      ),
      Text(
        "VIEW                       ANIMAL INFO",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            fontFamily: 'Arciform',
            color: Colors.black),
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
          icon: Icon(Icons.file_download),
          onPressed: () {},
        ),
      ),
      Text(
        "DOWNLOAD             IMAGE",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            fontFamily: 'Arciform',
            color: Colors.black),
      )
    ],
  ),
);

Widget backButton(context) {
  return Container(
      padding: new EdgeInsets.all(0.0),
      height: 50,
      width: 50,
      alignment: Alignment(0.0, 0.0),
      margin: new EdgeInsets.only(
        top: 10,
        left: 10,
      ),
      decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.grey[850])),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ));
}

 //===============================

 Widget identifyText = new Container(
   alignment: Alignment.centerLeft,
   margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
   padding: new EdgeInsets.all(5),
   decoration: BoxDecoration(
     color: Colors.white,
     borderRadius: BorderRadius.circular(10),
   ),
   //height: 0,
   child: Text(
     "Spoor Identification Results",
     style: TextStyle(
         fontWeight: FontWeight.bold,
         fontSize: 20,
         fontFamily: 'Arciform',
         color: Colors.black),
   ),
 );

 Widget confidentImageBlock(String image){
    return Container(
      alignment: Alignment.center,
      margin: new EdgeInsets.only(bottom: 10, left: 15, right: 10, top: 10),
      //padding: new EdgeInsets.all(5),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              image),
          fit: BoxFit.fill,
        ),
        color: Colors.grey,
        borderRadius: BorderRadius.circular(15),
      ),
      height: 170,
      width: 130,
    );
 } 

 Widget confidentImageDetails(SpoorModel confidentAnimal){
    return Container(
      alignment: Alignment.center,
      margin: new EdgeInsets.all(10),
      padding: new EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      height: 170,
      width: 130,
      child: Column(children: <Widget>[
        Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Expanded(flex: 1, child: animal),
                Expanded(flex: 1, child: animalVal(confidentAnimal.name)),
              ],
            )),
        Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Expanded(flex: 1, child: species),
                Expanded(flex: 1, child: speciesVal(confidentAnimal.species)),
              ],
            )),
        Expanded(flex: 1, child: accuracy),
        Expanded(flex: 2, child: score(confidentAnimal.score)),
      ]),
    );
 } 

 Widget animal = new Container(
   alignment: Alignment.centerLeft,
   padding: new EdgeInsets.all(0),
   child: Text(
     "Animal:",
     style: TextStyle(
         fontWeight: FontWeight.bold,
         fontSize: 15,
         fontFamily: 'Arciform',
         color: Colors.black),
   ),
 );

 Widget animalVal(String name) {
   return new Container(
     alignment: Alignment.centerLeft,
     padding: new EdgeInsets.all(0),
     child: Text(
       name,
       style: TextStyle(
           fontWeight: FontWeight.bold,
           fontSize: 15,
           fontFamily: 'Arciform',
           color: Colors.grey),
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
         fontSize: 15,
         fontFamily: 'Arciform',
         color: Colors.black),
   ),
 );

 Widget speciesVal(String species) {
   return new Container(
     alignment: Alignment.centerLeft,
     padding: new EdgeInsets.all(0),
     child: Text(
       species,
       style: TextStyle(
           fontWeight: FontWeight.bold,
           fontSize: 15,
           fontFamily: 'Arciform',
           color: Colors.grey),
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
         fontSize: 15,
         fontFamily: 'Arciform',
         color: Colors.black),
   ),
 );

 Widget score(String score){
  return Container(
    alignment: Alignment.centerLeft,
    padding: new EdgeInsets.all(0),
    child: Text(
      "$score",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 45,
          fontFamily: 'Arciform',
          color: Colors.black),
    ),
  );
 }
 //===============================


 Widget similarSpoors = new Container(
   alignment: Alignment.centerLeft,
   margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
   padding: new EdgeInsets.all(5),
   decoration: BoxDecoration(
     color: Colors.white,
     borderRadius: BorderRadius.circular(10),
   ),
   //height: 0,
   child: Text(
     "Similar Spoors",
     style: TextStyle(
         fontWeight: FontWeight.bold,
         fontSize: 20,
         fontFamily: 'Arciform',
         color: Colors.black),
   ),
 );

 Widget innerImageBlock(String link) {
   return new Container(
     alignment: Alignment.center,
     margin: new EdgeInsets.all(5),
     padding: new EdgeInsets.all(5),
     decoration: BoxDecoration(
       color: Colors.grey,
       borderRadius: BorderRadius.circular(10),
       image: DecorationImage(
         image: AssetImage(link),
         fit: BoxFit.fill,
       ),
     ),
     height: 150,
     width: 150,
   );
 }

 Widget name(String name) {
   return new Container(
     alignment: Alignment.centerLeft,
     padding: new EdgeInsets.all(5),
     margin: new EdgeInsets.only(left: 2),
     child: Text(
       name,
       style: TextStyle(
           fontWeight: FontWeight.bold,
           fontSize: 15,
           fontFamily: 'Arciform',
           color: Colors.black),
     ),
   );
 }

 Widget animalSpecies(String species) {
   return new Container(
     alignment: Alignment.centerLeft,
     margin: new EdgeInsets.only(left: 2),
     padding: new EdgeInsets.all(5),
     child: Text(
       species,
       style: TextStyle(
           fontWeight: FontWeight.bold,
           fontSize: 15,
           fontFamily: 'Arciform',
           color: Colors.grey),
     ),
   );
 }

 Widget accuracyScore(String score) {
   return new Container(
     alignment: Alignment.centerLeft,
     margin: new EdgeInsets.only(left: 2),
     padding: new EdgeInsets.all(5),
     child: Text(
       score,
       style: TextStyle(
           fontWeight: FontWeight.bold,
           fontSize: 15,
           fontFamily: 'Arciform',
           color: Colors.grey),
     ),
   );
 }

 //===============================
 Widget similarSpoor(SimilarSpoorModel similarSpoorModel) {
   return Container(
     height: 150,
     color: Colors.white,
     child: ListView.builder(
         shrinkWrap: true,
         scrollDirection: Axis.horizontal,
         itemCount: similarSpoorModel.similarSpoors.length,
         itemBuilder: (BuildContext context, int index) {
           return Container(
             alignment: Alignment.center,
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.circular(10),
             ),
             height: 100,
             width: 150,
             child: Column(
               children: <Widget>[
                 Expanded(child: innerImageBlock(similarSpoorModel.similarSpoors[index]), flex: 4),
               ],
             ),
           );
         }),
   );
 }

class OtherMatches  extends ViewModelWidget<IdentificationViewModel> {
  List<SpoorModel>list;
  OtherMatches({this.list});
 
  @override
  Widget build(BuildContext context, IdentificationViewModel model) {
    return ExpansionTile(
     title: Text(
       "Other Possible Matches",
       style: TextStyle(
           fontWeight: FontWeight.bold,
           fontSize: 20,
           fontFamily: 'Arciform',
           color: Colors.black),
     ),
     children: <Widget>[Container(
       height: 250,
       color: Colors.white,
       child: ListView.builder(
           shrinkWrap: true,
           scrollDirection: Axis.horizontal,
           itemCount: list.length,
           itemBuilder: (BuildContext context, int index) {
             return ChildPopup(pic:list[index].pic, aname: list[index].name, species: list[index].species, score: list[index].score,index: index);
           }),
        )]
   );
  }
}

class ChildPopup  extends ViewModelWidget<IdentificationViewModel>{
  String pic;
  String aname;
  String species;
  String score;
  int index;
  var models;

  ChildPopup({this.aname, this.index, this.pic, this.score, this.species,this.models}) : super(reactive:true);
 
  @override
  Widget build(BuildContext context, IdentificationViewModel model) {
    return  PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text('Reclassify', style: TextStyle(color: Colors.black)),
        ),
        PopupMenuItem(
          value: 2,
          child: Text('View Info', style: TextStyle(color: Colors.black)),
        ),
        PopupMenuItem(
          value: 3,
          child: Text('View Photos', style: TextStyle(color: Colors.black)),
        ),
      ],
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 110,
        width: 150,
        child: Column(
          children: <Widget>[
            Expanded(child: innerImageBlock(pic), flex: 4),
            Expanded(child: name(aname), flex: 1),
            Expanded(child: animalSpecies(species), flex: 1),
            Expanded(child: accuracyScore(score), flex: 1),
          ],
        ),
      ),
      onSelected: (value){
        if(value == 1){
          model.reclassify(index);
        }else if(value == 2){
          model.navigateToInfo(aname.toLowerCase());
        }else{
          model.navigateToGallery(aname.toLowerCase());
        }
          //different fuctionality insert here
      },
        offset: Offset(120,40),
      color: Colors.white,
    );
  }
}

Widget text1(String text, double font){
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

Widget text3(String text, double font){
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: font,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.bold,
      color: Colors.black
    ),
  );
}


 //===============================
 Widget attachTag(String tag) {
   return Container(
     alignment: Alignment.centerLeft,
     margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
     padding: new EdgeInsets.all(5),
     decoration: BoxDecoration(
       color: Colors.white,
       borderRadius: BorderRadius.circular(10),
     ),
     //height: 0,
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: <Widget>[
         Container(
           padding: const EdgeInsets.only(bottom: 6.0),
           child: Text(
             "Tags",
             style: TextStyle(
                 fontWeight: FontWeight.bold,
                 fontSize: 20,
                 fontFamily: 'Arciform',
                 color: Colors.black),
           ),
         ),
        Container(
          child: Tags(),
        )
       ],
     ),
   );
 }

Widget attachATag = new Container(
  height: 55,
  alignment: Alignment.centerLeft,
  padding: EdgeInsets.all(5),
  margin: EdgeInsets.all(5),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.white)
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Expanded(flex:1,child: attachATagButton),
      Expanded(flex:1,child: Tags()),
    ],
  ),
);

Widget attachATagButton = new Container(
    child: Row(children: <Widget>[
      Expanded(flex:1,child: containerTitle("Tag", 20)),
    ],),
);

Widget containerTitle(String title, double fontsize){
  return Container(
    margin: EdgeInsets.only(left:7),
    alignment: Alignment.centerLeft,
    child: text3(title,fontsize)
  );
} 

 class Tags extends ViewModelWidget<IdentificationViewModel> {
  Tags({Key key}) : super(key: key, reactive:true);

  @override
  Widget build(BuildContext context,IdentificationViewModel model) {
    model.setTags();
    return ListView.builder(
      padding: new EdgeInsets.all(0),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: model.tags.length,
      itemBuilder: (BuildContext context, int index) {
        return Chip(
          avatar: CircleAvatar(
            radius: 10,
            backgroundColor: Colors.black,
            child: Text(model.tags[index][0].toUpperCase())
          ),
          label: text2(model.tags[index], 15),
          backgroundColor: Colors.grey[100],
        );     
      }
    );
  }
}