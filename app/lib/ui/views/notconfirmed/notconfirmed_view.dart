import 'package:ERP_RANGER/ui/views/notconfirmed/notconfirmed_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class NotConfirmedView extends StatelessWidget {
  const NotConfirmedView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotConfirmedViewModel>.reactive(
      builder: (context, model, child) => FutureBuilder(
        future: model.imagePicker(),
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
                    imageBlock(snapshot.data),
                    BackButton(),
                    Scroll()
                  ],
                ),
              )       
            );
          }else{
            return text("Null no Data", 20);
          }
        },
      ), 
      viewModelBuilder: () => NotConfirmedViewModel(),
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

class BackButton extends ViewModelWidget<NotConfirmedViewModel> {
  BackButton({Key key}) : super(key: key, reactive:true);

  @override
  Widget build(BuildContext context, NotConfirmedViewModel model) {
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

class IconButtons extends ViewModelWidget<NotConfirmedViewModel> {
  IconData iconData;
  String subTitle;
  int index;
  IconButtons({Key key, this.iconData, this.subTitle,this.index}) : super(key: key, reactive:true);

  @override
  Widget build(BuildContext context, NotConfirmedViewModel model) {
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

              }else if(index ==1){
                model.recapture(context);
              }else if(index ==2){

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

Widget textDisplay = new Container(
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
        child: Container(alignment: Alignment.centerLeft,child: text("Spoor could not be identified",20))
        ),
        Expanded(flex:1,
          child: Container( alignment: Alignment.centerLeft, child: text2("Swipe up for more options", 13))
        )
    ],
  )
);

class LeadingIcon  extends ViewModelWidget<NotConfirmedViewModel> {
  LeadingIcon({Key key,}) : super(key: key, reactive:true);
 
  @override
  Widget build(BuildContext context,NotConfirmedViewModel model) {
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

class Scroll extends ViewModelWidget<NotConfirmedViewModel> {
  const Scroll({Key key}) : super(key: key, reactive:true);

  @override
  Widget build(BuildContext context, NotConfirmedViewModel model) {
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
          child: ListView(
            padding: new EdgeInsets.only(top:10.0),
            controller: myscrollController,
            children: <Widget>[
              Row(children: <Widget>[
                Expanded(flex:1 ,child: LeadingIcon()),
                SizedBox(height: 1.0,),
                Expanded(flex:4 ,child: textDisplay,),
                SizedBox(height: 1.0,),
                Expanded(flex:1 ,child: blocks),
              ],),
              dividerGrey,
              Row(children: <Widget>[
                Expanded(flex:1,child: IconButtons(iconData:Icons.search,subTitle:"RECLASSIFY SPOOR", index: 0,)),
                Expanded(flex:1,child: IconButtons(iconData:Icons.camera_alt,subTitle:"RECAPTURE SPOOR", index: 1)),
                Expanded(flex:1,child: IconButtons(iconData:Icons.file_download,subTitle:"DOWNLOAD IMAGE", index: 2)),
              ],)
            ],
          ) 
        );     
      }
    );
  }
}
//================================== TEXT TEMPLATES =============================
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
  child: Divider(color: Colors.grey[300], thickness: 1.0),
  margin: EdgeInsets.only(top: 7, bottom: 7),
);

Widget text(String text, double font){
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
//================================== TEXT TEMPLATES =============================
