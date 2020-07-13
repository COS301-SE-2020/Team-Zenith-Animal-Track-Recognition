import 'package:ERP_RANGER/ui/views/confirmed/confirmed_viewmodel.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ConfirmedView extends StatelessWidget {
  const ConfirmedView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ConfirmedViewModel>.reactive(
      builder: (context, model, child) => FutureBuilder(
        future: model.getConfirm(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasError){
             return text("Error", 20);
          }
          if(snapshot.hasData){
            return WillPopScope(
              onWillPop:() async{
                if(Navigator.canPop(context)){
                  model.navigate(context);
                }
                return;
              }, 
              child: Scaffold(
                body: Stack(
                  children: <Widget>[
                    imageBlock(snapshot.data.identifiedList[0].image),
                    BackButton(),
                    Scroll(finalObject: snapshot.data)
                  ],
                ),
              ),
            );
          }else{
            return text("Null no Data", 20);
          }
        },
      ),
      viewModelBuilder: () => ConfirmedViewModel(),
    );
  }
}

Widget imageBlock (String imageLink) {
    return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(imageLink),
        fit: BoxFit.cover,
      ),
    ),

  );
}

class BackButton extends ViewModelWidget<ConfirmedViewModel> {
  BackButton({Key key}) : super(key: key, reactive:true);

  @override
  Widget build(BuildContext context, ConfirmedViewModel model) {
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
        model.navigate(context);
      },
      child: Center(
        child:Icon(Icons.arrow_back, color:Colors.black),
      ),
    )
  );
  }
}

class Scroll extends ViewModelWidget<ConfirmedViewModel> {
  FinalObject finalObject;
  Scroll({Key key, this.finalObject}) : super(key: key, reactive:true);

  @override
  Widget build(BuildContext context, ConfirmedViewModel model) {
    return DraggableScrollableSheet(
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
          child: ListView(
            padding: new EdgeInsets.only(top:10.0),
            controller: myscrollController,   
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(flex:1 ,child: LeadingIcon()),
                  SizedBox(height: 1.0,),
                  Expanded(flex:4 ,child: textDisplay(finalObject.identifiedList[0].species +" "+ finalObject.identifiedList[0].animalName)),
                  SizedBox(height: 1.0,),
                  Expanded(flex:1 ,child: blocks(finalObject.identifiedList[0].accuracyScore)),
                ],
              ),
              Divider(),
              Column(
                children: <Widget>[
                  identifyText,
                  SpoorIdentification(animalIdentified:finalObject.identifiedList[0]),
                ],
              ),
              Divider(),
              Column(children: <Widget>[
                otherMatches,
                Row(children: <Widget>[Expanded(flex:1, child: similarSpoor(finalObject.identifiedList),)],)]
              ,),
              Divider(),
              Column(
                children: <Widget>[
                  tagText,
                  Tags(tags:finalObject.tags)
                ],
              ),
              Divider(),
              Row(children: <Widget>[
                Expanded(flex:1,child: IconButtons(iconData:Icons.check,subTitle:"CONFIRM SPOOR",index:0)),
                Expanded(flex:1,child: IconButtons(iconData:Icons.search,subTitle:"EDIT GEOTAG",index:1)),
                Expanded(flex:1,child: IconButtons(iconData:Icons.camera_alt,subTitle:"RECAPTURE SPOOR",index:2)),
                Expanded(flex:1,child: IconButtons(iconData:Icons.file_download,subTitle:"DOWNLOAD IMAGE",index:3)),
              ],)
            ],        
          ),
        );     
      }
    );
  }
}

class SpoorIdentification extends ViewModelWidget<ConfirmedViewModel> {
  TempObject animalIdentified;
  SpoorIdentification({Key key, this.animalIdentified}) : super(key: key, reactive:true);

  @override
  Widget build(BuildContext context, ConfirmedViewModel model) {
    return Container(
      child: Row(children: <Widget>[
        Expanded(flex:1,child: confidentImageBlock(animalIdentified.image)),
        Expanded(flex:1,child: confidentImageDetails(animalIdentified.type, animalIdentified.animalName, animalIdentified.species, animalIdentified.accuracyScore))
      ],),
    );
  }
}

class IconButtons extends ViewModelWidget<ConfirmedViewModel> {
  IconData iconData;
  String subTitle;
  int index;
  IconButtons({Key key, this.iconData, this.subTitle,this.index}) : super(key: key, reactive:true);

  @override
  Widget build(BuildContext context, ConfirmedViewModel model) {
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
            icon:Icon(iconData), 
            onPressed: () {
              if(index == 0){
                model.confirm(context);
              }else if(index == 1){

              }else if(index == 2){
                model.recapture(context);
              }else if(index == 3){
                
              }
            },
          ),
        ),
        text2(subTitle, 13)
      ],
  ),
    );
  }
}
//================================== TEXT TEMPLATES =============================
class LeadingIcon  extends ViewModelWidget<ConfirmedViewModel> {
  LeadingIcon({Key key,}) : super(key: key, reactive:true);
 
  @override
  Widget build(BuildContext context, ConfirmedViewModel model) {
    return Container(
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
  }
}

// ignore: must_be_immutable
class PossibleTags extends ViewModelWidget<ConfirmedViewModel> {
  String image;
  String name;
  String species;
  double score;
  PossibleTags({Key key,this.image,this.name,this.score,this.species}) : super(key: key);

  @override
  Widget build(BuildContext context, ConfirmedViewModel model) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: new EdgeInsets.only(left:8,bottom:5,top:5,),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 200,
      width: 110,
      child: Column(children: <Widget>[
        Expanded(child: Container(alignment: Alignment.centerLeft, child: innerImageBlock(image)) ,flex:4),
        Expanded(child: Container(alignment: Alignment.centerLeft,margin: new EdgeInsets.only(left:8),child: text3(name,15)),flex:1),
        Expanded(child: Container(alignment: Alignment.centerLeft,margin: new EdgeInsets.only(left:8),child: text4(species,15)),flex:1),
        Expanded(child: Container(alignment: Alignment.centerLeft,margin: new EdgeInsets.only(left:8),child: text4("$score%",15)),flex:1),
      ],),
    );
  }
}

Widget confidentImageBlock(String image){
  return Container(
    alignment: Alignment.center,
    margin: new EdgeInsets.only(bottom:10, left:15,right:10,top:10 ),
    //padding: new EdgeInsets.all(5),
      decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage( image ),
        fit: BoxFit.fill,
      ),
      color: Colors.grey,
      borderRadius: BorderRadius.circular(15),
    ),
    height: 130,
  );
} 

Widget confidentImageDetails (String type, String name, String species, double score){
  return Container(
    alignment: Alignment.center,
    margin: new EdgeInsets.all(10),
    padding: new EdgeInsets.only(left:8),
      decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    height: 130,
    child: Column(
      children:<Widget>[
        Expanded(flex:1,child: Row(children: <Widget>[Expanded(flex:1,child: text3("Type:", 16)),Expanded(flex:1,child: text4(type, 16))])),
        Expanded(flex:1,child: Row(children: <Widget>[Expanded(flex:1,child: text3("Animal:", 16)),Expanded(flex:1,child: text4(name,16))])),
        Expanded(flex:1,child: Row(children: <Widget>[ Expanded(flex:1,child: text3("Species", 16)),Expanded(flex:1,child: text4(species, 15))])),
        Expanded(flex:1,child: Container(alignment: Alignment.centerLeft,child: text3("Accuracy Score:", 17))),
        Expanded(flex:2,child: Container(alignment: Alignment.centerLeft,child: text3("$score%", 47))),      
      ]
    ),
  );
} 

Widget otherMatches = new Container(
  alignment: Alignment.centerLeft,
  margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
  padding: new EdgeInsets.all(5) ,
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
  ),
  //height: 0,
  child: text("Other Possible Matches", 20),
);

Widget tagText = new Container(
  alignment: Alignment.centerLeft,
  margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
  padding: new EdgeInsets.all(5) ,
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
  ),
  //height: 0,
  child: text("Attach A Tag", 20),
);

Widget similarSpoor (List<TempObject> possibleAnimals){
  return Container(
    height: 200,
    color: Colors.white,
    child: ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: possibleAnimals.length,
      itemBuilder: (BuildContext context, int index) {
        return PossibleTags(image: possibleAnimals[index].image,name:possibleAnimals[index].animalName,species: possibleAnimals[index].species,score:possibleAnimals[index].accuracyScore,);
      }
    ),
  );
} 

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

Widget blocks(double percentage){
  return Container(
    alignment: Alignment(0.0,0.0),
    margin: new EdgeInsets.only(bottom: 3, left: 3, right: 3),
    padding: new EdgeInsets.all(0.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    width: 10,
    height: 50,
    child: Column(
      children: <Widget>[
        Expanded(flex: 2,child: text("$percentage%",30)),
        Expanded(flex: 1, child: text("MATCH",15)),
    ],)
  );
} 

Widget textDisplay (String name){
  return Container(
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
          Expanded(flex:1,
          child: Container(alignment: Alignment.centerLeft,child: text(name,20))
          ),
          Expanded(flex:1,
            child: Container( alignment: Alignment.centerLeft, child: text2("Swipe up for more options", 13))
          )
      ],
    )
  );
}

Widget identifyText = new Container(
  alignment: Alignment.centerLeft,
  margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
  padding: new EdgeInsets.all(5) ,
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
  ),
  child: text("Spoor Identification Results",20),
);

Widget text(String text, double font){
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

Widget text2(String text, double font){
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: font,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.bold,
      color: Colors.grey
    ),
  );
}

Widget text3(String text, double font){
  return Text(
    text,
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: font,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.bold,
      color: Colors.black
    ),
  );
}

Widget text4(String text, double font){
  return Text(
    text,
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: font,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.bold,
      color: Colors.grey
    ),
  );
}
//================================== TEXT TEMPLATES =============================

// ignore: must_be_immutable
class Tags extends ViewModelWidget<ConfirmedViewModel> {
  List<String> tags;
  
  Tags({Key key,this.tags}) : super(key: key, reactive:true);

  @override
  Widget build(BuildContext context,ConfirmedViewModel model) {
    int defualtChoiceIndex = model.tagIndex;
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: List<Widget>.generate(tags.length, (index){
        return ChoiceChip(
          avatar: CircleAvatar(
            backgroundColor: Colors.grey.shade600,
            child: Text(tags[index][0].toUpperCase())
          ),
          label: text(tags[index], 10),
          backgroundColor: Colors.grey[100],
          selected: defualtChoiceIndex==index,
          selectedColor: Colors.grey.shade600,
          onSelected: (bool selected){
            print(index);
             defualtChoiceIndex = selected ? index : null;
            if(defualtChoiceIndex == null){
              model.setTag(null);
              model.setTagIndex(null);
            }else{
              model.setTag(tags[index]);
              model.setTagIndex(index);
            }
            model.notifyListeners();
          },
        );     
      }),
    );
  }
}

