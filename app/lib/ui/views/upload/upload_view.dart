import 'package:ERP_RANGER/services/util.dart';
import 'package:ERP_RANGER/ui/views/upload/upload_viewmodel.dart';
import 'package:ERP_RANGER/ui/widgets/bottom_navigation/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class UploadView extends StatelessWidget {
  const UploadView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BottomNavigation bottomNavigation = BottomNavigation();
    bottomNavigation.setIndex(2);
    return ViewModelBuilder<UploadViewModel>.reactive(
      builder: (context, model, child) => WillPopScope(
        
        onWillPop:()async{
          if(Navigator.canPop(context)){
            navigate(context);
          }
          return;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            title: appBarTitle("Upload Spoor Geotag", context),
          ),
          body:Container(
            padding: EdgeInsets.all(10),
            color: Colors.grey[300], 
            child: SliverBody(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              captureImage();
            },
            child: Icon(Icons.camera_alt,),
            backgroundColor: Colors.black,
          ),
          bottomNavigationBar: BottomNavigation(),
          backgroundColor: Colors.grey,
        ),
      ),

      viewModelBuilder: () => UploadViewModel(),
    );
  }
}

class SliverBody extends ViewModelWidget<UploadViewModel> {
  SliverBody({Key key}) :super(reactive: true);

  @override
  Widget build(BuildContext context, UploadViewModel model) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            [
              header,
              spoorImageBlock,
              //animalInformation,
              SpoorLocationInput(),
              attachATag,
              UploadButton()
            ]
          ),
        )
      ],
    );
  }
}

Widget spoorImageBlock = new Container(
  height: 150,
  width: 100,
  padding: EdgeInsets.all(5),
  margin: EdgeInsets.all(15),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.white)
  ),
  child: Column(
    children: <Widget>[
      Expanded(flex:1,child: containerTitle("Spoor Image", 13)),
      Expanded(flex:1,child: CameraButton()),
      Expanded(flex:1,child: GalleryButton()),
    ],
  ),
);

Widget rightIcon = new Container(
  margin: new EdgeInsets.only(right:5,left:5,),
  height: 30,
  child: Icon(Icons.arrow_right),
);

Widget leftBlock = new Container(
  alignment: Alignment.center,
  margin: new EdgeInsets.only(right:5,left:5),
  padding: new EdgeInsets.all(5),
    decoration: BoxDecoration(
    color: Colors.grey,
    borderRadius: BorderRadius.circular(10),
  ),
  height: 30,
  width: 30,
);

class LeftImage extends ViewModelWidget<UploadViewModel> {
  LeftImage({Key key,}) :super(reactive: true);
  @override
  Widget build(BuildContext context, UploadViewModel model) {
    return Container(
      alignment: Alignment.center,
      margin: new EdgeInsets.only(right:5,left:5),
      padding: new EdgeInsets.all(5),
        decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: MemoryImage(model.image.readAsBytesSync()),
          fit: BoxFit.fill,
        ),
      ),
      height: 30,
      width: 30,
    );  
  }
}

class GalleryButton extends ViewModelWidget<UploadViewModel> {
  GalleryButton({Key key,}) :super(reactive: true);
  @override
  Widget build(BuildContext context, UploadViewModel model) {
    return model.valueGallery == false
    ?GestureDetector(
     child: Container(
        margin: new EdgeInsets.only(bottom: 10),
        child: Row(children: <Widget>[
          Expanded(flex:1,child: leftBlock),
          Expanded(flex:5,child: text4("From Gallery",15)),
          Expanded(flex:1,child: rightIcon),
        ],),
      ),
      onTap: () async{
        model.uploadFromGallery();
      },
    )
    :GestureDetector(
      child: Container(
        margin: new EdgeInsets.only(bottom: 10),
        child: Row(children: <Widget>[
          Expanded(flex:1,child: LeftImage()),
          Expanded(flex:5,child: text4("From Gallery",15)),
          Expanded(flex:1,child: rightIcon),
        ],),
      ),
      onTap: () {
        model.uploadFromGallery();
      },
    );
  }
}

class CameraButton extends ViewModelWidget<UploadViewModel> {
  String caption;
  CameraButton({Key key,this.caption}) :super(reactive: true);
  bool changed = false;
  @override
  Widget build(BuildContext context, UploadViewModel model) {
    return model.valueCamera == false
    ?GestureDetector(
     child: Container(
        margin: new EdgeInsets.only(bottom: 10),
        child: Row(children: <Widget>[
          Expanded(flex:1,child: leftBlock),
          Expanded(flex:5,child: text4("From Camera",15)),
          Expanded(flex:1,child: rightIcon),
        ],),
      ),
      onTap: () async{
        model.uploadFromCamera();
      },
    )
    :GestureDetector(
      child: Container(
        margin: new EdgeInsets.only(bottom: 10),
        child: Row(children: <Widget>[
          Expanded(flex:1,child: LeftImage()),
          Expanded(flex:5,child: text4("From Camera",15)),
          Expanded(flex:1,child: rightIcon),
        ],),
      ),
      onTap: () {
        model.uploadFromCamera();
      },
    );
  }
}

class SpoorLocation extends ViewModelWidget<UploadViewModel> {
  SpoorLocation({Key key,}) :super(reactive: true);
  @override
  Widget build(BuildContext context, UploadViewModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(margin: new EdgeInsets.only(left:5),padding:new EdgeInsets.all(0) ,alignment:Alignment.centerLeft,child: text2("Longitude: ",15)),
        Container(margin: new EdgeInsets.only(left:0),padding:new EdgeInsets.all(5) ,alignment:Alignment.centerLeft,child: Longitude()),
        Container(margin: new EdgeInsets.only(left:5),padding:new EdgeInsets.all(0) ,alignment:Alignment.centerLeft,child: text2("Latitude: ",15)),
        Container(margin: new EdgeInsets.only(left:0),padding:new EdgeInsets.all(5) ,alignment:Alignment.centerLeft,child: Latitude()),
      ],);
  }
}

class Longitude extends HookViewModelWidget<UploadViewModel>{
  Longitude({Key key,}) :super(reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, UploadViewModel viewModel) {
    var text = useTextEditingController();
    return TextField(controller: text,onChanged: viewModel.updateLong,
      decoration: InputDecoration(
        hintText: "-24.1245",
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        filled: true,
        fillColor: Colors.grey[100]
      ),
      style: TextStyle(
        fontFamily: 'Helvetica',
        fontWeight: FontWeight.normal,
        color: Colors.grey
      ),
    );
  }
}

class Latitude extends HookViewModelWidget<UploadViewModel>{
  Latitude({Key key,}) :super(reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, UploadViewModel viewModel) {
    var text = useTextEditingController();
    return TextField(controller: text,onChanged: viewModel.updateLat,
      decoration: InputDecoration(
        hintText: "26.1345",
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        filled: true,
        fillColor: Colors.grey[100]
      ),
      style: TextStyle(
        fontFamily: 'Helvetica',
        fontWeight: FontWeight.normal,
        color: Colors.grey
      ),
    );
  }
}

class AnimalSelection extends ViewModelWidget<UploadViewModel> {
  AnimalSelection({Key key,}) :super(reactive: true);
  @override
  Widget build(BuildContext context, UploadViewModel model) {
    return GestureDetector(
     child: Container(
        margin: new EdgeInsets.only(bottom: 10),
        child: Row(children: <Widget>[
          Expanded(flex:1,child: leftBlock),
          Expanded(flex:5,child: text4("Select Animal",15)),
          Expanded(flex:1,child: rightIcon),
        ],),
      ),
      onTap: () async{
        //model.uploadFromGallery();
      },
    );
  }
}

Widget animalInformation = new Container(
  height: 100,
  width: 100,
  padding: EdgeInsets.all(5),
  margin: EdgeInsets.all(15),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.white)
  ),
  child: Column(
    children: <Widget>[
      Expanded(flex:1,child: containerTitle("Animal Information", 13)),
      Expanded(flex:1,child: AnimalSelection()),
    ],
  ),
);

class SpoorLocationInput extends ViewModelWidget<UploadViewModel> { 
  SpoorLocationInput({Key key}) : super(key: key, reactive:true);
  @override
  Widget build(BuildContext context,UploadViewModel model) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white)
      ),
      child: Column(
        children: <Widget>[
          Container(margin: EdgeInsets.only(top:13,bottom:10),child: containerTitle("Spoor Location", 13)),
          SpoorLocation(),
        ],
      ),
    );
  }
}

Widget attachATag = new Container(
  height: 115,
  width: 100,
  padding: EdgeInsets.all(5),
  margin: EdgeInsets.all(15),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.white)
  ),
  child: Column(
    children: <Widget>[
      Expanded(flex:1,child: attachATagButton),
      Expanded(flex:1,child: Tags()),
    ],
  ),
);

Widget attachATagButton = new Container(
    child: Row(children: <Widget>[
      Expanded(flex:1,child: containerTitle("Attach A Tag", 13)),
    ],),
);

class Tags extends ViewModelWidget<UploadViewModel> {
  Tags({Key key}) : super(key: key, reactive:true);

  @override
  Widget build(BuildContext context,UploadViewModel model) {
    int defualtChoiceIndex = model.tagIndex;
    model.setTags();
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: model.tags.length,
      itemBuilder: (BuildContext context, int index) {
        return ChoiceChip(
          avatar: CircleAvatar(
            radius: 10,
            backgroundColor: Colors.black,
            child: Text(model.tags[index][0].toUpperCase())
          ),
          label: text2(model.tags[index], 15),
          backgroundColor: Colors.grey[100],
          selected: defualtChoiceIndex==index,
          selectedColor: Colors.blueGrey,
          elevation: 2,
          onSelected: (bool selected){
            print(index);
            defualtChoiceIndex = selected ? index : null;
            if(defualtChoiceIndex == null){
              model.setTag(null);
              model.setTagIndex(null);                  
            }else{
              model.setTag(model.tags[index]);
              model.setTagIndex(index);
            }
            model.notifyListeners();
          },
        );     
      }
    );
  }
}

class UploadButton extends ViewModelWidget<UploadViewModel> {
  UploadButton({Key key}) :super(reactive: true);

  @override
  Widget build(BuildContext context, UploadViewModel model) {
    return Container(
      margin: EdgeInsets.only(right:15, left: 15, top: 5,bottom: 5,),
      width: 80,
      child: RaisedButton(
        child: text("UPLOAD GEOTAG",15),
        color: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.all(10),
        onPressed: (){
          model.upload();
        }
      ),
    );
  }
}

//================================== TEXT TEMPLATES =============================
Widget header = new Container(
  alignment: Alignment.center,
  padding: EdgeInsets.all(5),
  margin: EdgeInsets.all(15),
  child: Text(
      "Please enter in Spoor Information below",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        fontFamily: 'Helvetica',
        fontWeight: FontWeight.bold,
        color: Colors.grey
      )  
  ),
);

Widget containerTitle(String title, double fontsize){
  return Container(
    margin: EdgeInsets.only(left:7),
    alignment: Alignment.centerLeft,
    child: text2(title,fontsize)
  );
} 

Widget text(String text, double font){
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
    textAlign: TextAlign.center,
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

Widget text5(String text, double font){
  return Text(
    text,
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: font,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.bold,
      color: Colors.grey
    ),
  );
}
//================================== TEXT TEMPLATES =============================