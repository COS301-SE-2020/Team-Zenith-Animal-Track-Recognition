import 'dart:async';

import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:ERP_RANGER/services/util.dart';
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
           return progressIndicator();
        }
        if (snapshot.hasData) {       
     
          return snapshot.hasData 
          ? WillPopScope(
            onWillPop: () async {
              if (Navigator.canPop(context)) {
                navigate(context);
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
          )
          : progressIndicator();
        }else{
          return progressIndicator();
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
        initialChildSize: 0.10,
        minChildSize: 0.10,
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
                              Expanded(flex: 4, child: text(model.confident.name,context)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        barInfo(context),
                        Divider(thickness: 2),
                        Column(
                          children: <Widget>[
                            identifyText(context),
                            Row(
                              children: <Widget>[
                                Expanded(flex: 1, child: confidentImageBlock(confident.pic)),
                                Expanded(flex: 1, child: confidentImageDetails(confident,context)),
                              ],
                            )
                          ],
                        ),
                        Divider(thickness: 2),
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(flex: 1, child: OtherMatches(list:list))
                              ],
                            )
                          ],
                        ),
                        Divider(thickness: 2),
                        Column(
                          children: <Widget>[
                            similarSpoors(context),
                            Row(
                              children: <Widget>[
                                Expanded(flex: 1, child: similarSpoor(similarSpoorModel))
                              ],
                            )
                          ],
                        ),
                        Divider(thickness: 2),
                        Column(
                          children: <Widget>[
                            attachATag(context),
                          ],
                        ),
                        Divider(thickness: 2),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(flex: 1, child: button1(context)),
                              SizedBox(height: 1.0),
                              Expanded(flex: 1, child: button2(context)),
                              SizedBox(height: 1.0),
                              Expanded(flex: 1, child: button3(context)),
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

Widget barInfo(var context){
return Container(
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
                child: Container(
                  padding: new EdgeInsets.only(left:10),
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.location_on,
                    color: Colors.black,
                  ),
                )),
            Expanded(
              flex: 8,
              child: cardTextLeft("Spoor Location", context)
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
              child: cardTextLeft('Kruger National Park', context),
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
              child: cardTextLeft( 'Date: ', context),
            ),
            Expanded(
              flex: 3,
              child: cardTextLeft('09/09/2020', context)
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
              child: cardTextLeft('Coordinates: ', context),
            ),
            Expanded(
              flex: 3,
              child: cardTextLeft('-240.19097, 31.559270', context),
            )
          ],
        ),
      )
    ],
  ),
);
}

Widget text(String name, var context){
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
            child: appBarTitle('$name Spoor identified', context),
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

Widget button1(var context) {

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
            icon: Icon(Icons.sync_problem),
            onPressed: () {},
          ),
        ),
        homeViewAccuracyScoreLeft("Edit Spoor",context),
      ],
    ),
  );
}

Widget button2(var context){
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
        homeViewAccuracyScoreLeft("View Animal Info", context)
      ],
    ),
  );
} 

Widget button3(var context){ 
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
      homeViewAccuracyScoreLeft("Download Image",context)
    ],
  ),
);
}

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

 Widget identifyText(var context){
 return Container(
   alignment: Alignment.centerLeft,
   margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
   padding: new EdgeInsets.all(5),
   decoration: BoxDecoration(
     color: Colors.white,
     borderRadius: BorderRadius.circular(10),
   ),
   //height: 0,
   child: cardTitle("Spoor Identification Results", context),
 );
 }

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

 Widget confidentImageDetails(SpoorModel confidentAnimal, var context){
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
                Expanded(flex: 1, child: animal(context)),
                Expanded(flex: 1, child: animalVal(confidentAnimal.name, context)),
              ],
            )),
        Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Expanded(flex: 1, child: species(context)),
                Expanded(flex: 1, child: speciesVal(confidentAnimal.species,context)),
              ],
            )),
        Expanded(flex: 1, child: accuracy(context)),
        Expanded(flex: 2, child: score(confidentAnimal.score)),
      ]),
    );
 } 

 Widget animal(var context) {
    return Container(
    alignment: Alignment.centerLeft,
    padding: new EdgeInsets.all(0),
    child: nameText("Animal: ", context),
  );
 }

 Widget animalVal(String name, var context) {
   return new Container(
     alignment: Alignment.centerLeft,
     padding: new EdgeInsets.all(0),
     child: homeViewAccuracyScoreLeft(name, context),
   );
 }

 Widget species(var context){
  return Container(
    alignment: Alignment.centerLeft,
    padding: new EdgeInsets.all(0),
    child: nameText("Species:", context)
  );
 }

 Widget speciesVal(String species,var context) {
   return new Container(
     alignment: Alignment.centerLeft,
     padding: new EdgeInsets.all(0),
     child: homeViewAccuracyScoreLeft(species, context),
   );
 }

 Widget accuracy(var context) {
   return Container(
   alignment: Alignment.centerLeft,
   padding: new EdgeInsets.all(0),
   child: nameText("Accuracy Score:", context)
 );
 }
 
 Widget score(String score){
  return Container(
    alignment: Alignment.centerLeft,
    padding: new EdgeInsets.all(0),
    child: percentageText("$score", 45)
  );
 }
 //===============================


 Widget similarSpoors (var context){
  return Container(
    alignment: Alignment.centerLeft,
    margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
    padding: new EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    //height: 0,
    child: cardTitle("Similar Spoors", context),
  );
 } 

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

 Widget name(String name, var context) {
   return new Container(
     alignment: Alignment.centerLeft,
     padding: new EdgeInsets.all(5),
     margin: new EdgeInsets.only(left: 2),
     child: nameText(name, context));
 }

 Widget animalSpecies(String species,var context) {
   return  Container(
     alignment: Alignment.centerLeft,
     margin: new EdgeInsets.only(left: 2),
     padding: new EdgeInsets.all(5),
     child: homeViewAccuracyScoreLeft(species,context),
   );
 }

 Widget accuracyScore(String score, var context) {
   return new Container(
     alignment: Alignment.centerLeft,
     margin: new EdgeInsets.only(left: 2),
     padding: new EdgeInsets.all(5),
     child: homeViewAccuracyScoreLeft(score,context),
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
     title: cardTitle("Other Possible Matches", context),
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
            Expanded(child: name(aname, context), flex: 1),
            Expanded(child: animalSpecies(species,context), flex: 1),
            Expanded(child: accuracyScore(score, context), flex: 1),
          ],
        ),
      ),
      onSelected: (value){
        if(value == 1){
          model.reclassify(index);
        }else if(value == 2){
          navigateToInfo(aname.toLowerCase());
        }else{
          navigateToGallery(aname.toLowerCase());
        }
          //different fuctionality insert here
      },
        offset: Offset(120,40),
      color: Colors.white,
    );
  }
}

 //===============================
Widget attachATag(var context){
return Container(
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
      Expanded(flex:1,child: attachATagButton(context)),
      Expanded(flex:1,child: Tags()),
    ],
  ),
);
} 

Widget attachATagButton(var context){
return Container(
    child: Row(children: <Widget>[
      Expanded(flex:1,child: containerTitle("Spoor Tags", context)),
    ],),
);
} 

Widget containerTitle(String title, var context){
  return Container(
    margin: EdgeInsets.only(left:7),
    alignment: Alignment.centerLeft,
    child: cardTitle(title,context)
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
            backgroundColor: Colors.grey.
            shade600,
            child: confirmViewTagText(model.tags[index][0].toUpperCase(),context)
          ),
          label: confirmViewTagText(model.tags[index], context),
          backgroundColor: Colors.grey[100],
        );     
      }
    );
  }
}
