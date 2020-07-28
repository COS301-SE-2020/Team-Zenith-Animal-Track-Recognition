import 'package:ERP_RANGER/services/util.dart';
import 'package:ERP_RANGER/ui/views/confirmed/confirmed_viewmodel.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'dart:io';

// ignore: must_be_immutable
class ConfirmedView extends StatelessWidget {
  List<ConfirmModel> confirmedAnimals;
  File image;
  ConfirmedView({this.confirmedAnimals,this.image});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ConfirmedViewModel>.reactive(
      builder: (context, model, child) => FutureBuilder(
        future: model.getConfirm(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasError){
             return progressIndicator();
          }
          if(snapshot.hasData){
            if(model.loaded == false){
              model.setConfidentAnimal(confirmedAnimals[0]);
              confirmedAnimals.removeAt(0);
              model.setConfirmedList(confirmedAnimals);
              model.setLoaded(true);
            }
            return WillPopScope(
              onWillPop:() async{
                if(Navigator.canPop(context)){
                  navigate(context);
                }
                return;
              }, 
              child: Scaffold(
                body: Stack(
                  children: <Widget>[
                    imageBlock(image),
                    BackButton(),
                    Scroll(finalObject: snapshot.data)
                  ],
                ),
              ),
            );
          }else{
            return progressIndicator();
          }
        },
      ),
      viewModelBuilder: () => ConfirmedViewModel(),
    );
  }
}

Widget imageBlock (File imageLink) {
    return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: MemoryImage(imageLink.readAsBytesSync()),
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
        navigate(context);
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
  ConfirmModel confidentAnimal;
  Scroll({Key key, this.finalObject}) : super(key: key, reactive:true);

  @override
  Widget build(BuildContext context, ConfirmedViewModel model) {
    confidentAnimal = model.confidentAnimal;

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
                  Expanded(flex:4 ,child: textDisplay(model.confidentAnimal.species +" "+ model.confidentAnimal.animalName,context)),
                  SizedBox(height: 1.0,),
                  Expanded(flex:1 ,child: blocks(model.confidentAnimal.accuracyScore)),
                ],
              ),
              Divider(),
              Column(
                children: <Widget>[
                  identifyText(context),
                  SpoorIdentification(),
                ],
              ),
              Divider(),
              Column(children: <Widget>[
                otherMatches(context),
                Row(children: <Widget>[Expanded(flex:1, child: SimilarSpoor(),)],)]
              ,),
              Divider(),
              Column(
                children: <Widget>[
                  tagText(context),
                  Tags(tags:finalObject.tags)
                ],
              ),
              Divider(),
              Row(children: <Widget>[
                Expanded(flex:1,child: IconButtons(iconData:Icons.check,subTitle:"CONFIRM SPOOR",index:0)),
                //Expanded(flex:1,child: IconButtons(iconData:Icons.search,subTitle:"EDIT GEOTAG",index:1)),
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
  SpoorIdentification({Key key}) : super(key: key, reactive:true);

  @override
  Widget build(BuildContext context, ConfirmedViewModel model) {
    return Container(
      child: Row(children: <Widget>[
        Expanded(flex:1,child: confidentImageBlock(model.confidentAnimal.image)),
        Expanded(flex:1,child: confidentImageDetails(model.confidentAnimal.type, model.confidentAnimal.animalName, model.confidentAnimal.species, model.confidentAnimal.accuracyScore,context))
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
                recapture(context);
              }else if(index == 3){
                
              }
            },
          ),
        ),
        confirmViewIconButtonText(subTitle, context)
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
  int score;
  int index;
  PossibleTags({Key key,this.image,this.name,this.score,this.species,this.index}) : super(key: key, reactive:true);

  @override
  Widget build(BuildContext context, ConfirmedViewModel model) {
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
          Expanded(child: Container(alignment: Alignment.centerLeft,margin: new EdgeInsets.only(left:8),child: confirmViewSimilarSpoorTextName(name,context)),flex:1),
          Expanded(child: Container(alignment: Alignment.centerLeft,margin: new EdgeInsets.only(left:8),child: confirmViewSimilarSpoorText(species,context)),flex:1),
          Expanded(child: Container(alignment: Alignment.centerLeft,margin: new EdgeInsets.only(left:8),child: confirmViewSimilarSpoorText("$score%",context)),flex:1),
        ],),
      ),
      onSelected: (value){
        if(value == 1){
          model.reclassify(index);
        }else if(value == 2){
          navigateToInfo(name.toLowerCase());
        }else{
          navigateToGallery(name.toLowerCase());
        }
        //different fuctionality insert here
      },
        offset: Offset(120,40),
      color: Colors.white,
    );
  }
}

class SimilarSpoor  extends ViewModelWidget<ConfirmedViewModel> {
  SimilarSpoor({Key key,}) : super(key: key, reactive:true);
 
  @override
  Widget build(BuildContext context, ConfirmedViewModel model) {
    return Container(
      height: 200,
      color: Colors.white,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: model.confirmedList.length,
        itemBuilder: (BuildContext context, int index) {
          return PossibleTags(image: model.confirmedList[index].image,name:model.confirmedList[index].animalName,species: model.confirmedList[index].species,score:model.confirmedList[index].accuracyScore,index:index);
        }
      ),
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
        image: AssetImage( image ),
        fit: BoxFit.fill,
      ),
      color: Colors.grey,
      borderRadius: BorderRadius.circular(15),
    ),
    height: 130,
  );
} 

Widget confidentImageDetails (String type, String name, String species, int score, var context){
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
        Expanded(flex:1,child: Row(children: <Widget>[Expanded(flex:1,child: confirmViewConfidentDetailsLeft("Type: ", context)),Expanded(flex:1,child: confirmViewConfidentDetailsRight(type, context))])),
        Expanded(flex:1,child: Row(children: <Widget>[Expanded(flex:1,child: confirmViewConfidentDetailsLeft("Animal:", context)),Expanded(flex:1,child: confirmViewConfidentDetailsRight(name,context))])),
        Expanded(flex:1,child: Row(children: <Widget>[ Expanded(flex:1,child: confirmViewConfidentDetailsLeft("Species", context)),Expanded(flex:1,child: confirmViewConfidentDetailsRight(species, context))])),
        Expanded(flex:1,child: Container(alignment: Alignment.centerLeft,child: confirmViewConfidentDetailsLeft("Accuracy Score:", context))),
        Expanded(flex:2,child: Container(alignment: Alignment.centerLeft,child: percentageText("$score%", 47))),      
      ]
    ),
  );
} 

Widget otherMatches (var context){
  return Container(
    alignment: Alignment.centerLeft,
    margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
    padding: new EdgeInsets.all(5) ,
      decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    //height: 0,
    child: confirmViewAnimalTitle("Other Possible Matches", context),
  );
} 

Widget tagText(var context){
 return Container(
  alignment: Alignment.centerLeft,
  margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
  padding: new EdgeInsets.all(5) ,
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
  ),
  //height: 0,
  child: confirmViewAnimalTitle("Attach A Tag", context),
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
          image: AssetImage( link),
          fit: BoxFit.fill,
      ),
    ),
    height: 115,
    // width: 75,
  );
}

Widget blocks(int percentage){
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
        Expanded(flex: 2,child: percentageText("$percentage%",30)),
        Expanded(flex: 1, child: percentageText("MATCH",15)),
    ],)
  );
} 

Widget textDisplay (String name,var context){
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
          child: Container(alignment: Alignment.centerLeft,child: confirmViewTitle(name,context))
          ),
          Expanded(flex:1,
            child: Container( alignment: Alignment.centerLeft, child: confirmViewSubTitle("Swipe up for more options", context))
          )
      ],
    )
  );
}

Widget identifyText(var context){
  return Container(
    alignment: Alignment.centerLeft,
    margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
    padding: new EdgeInsets.all(5) ,
      decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: confirmViewAnimalTitle("Spoor Identification Results",context),
  );
} 

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
            child: confirmViewTagText(tags[index][0].toUpperCase(),context)
          ),
          label:confirmViewTagText(tags[index],context),
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


