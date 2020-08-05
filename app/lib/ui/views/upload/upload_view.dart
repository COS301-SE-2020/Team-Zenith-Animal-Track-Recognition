import 'package:ERP_RANGER/services/util.dart';
import 'package:ERP_RANGER/ui/views/upload/upload_viewmodel.dart';
import 'package:ERP_RANGER/ui/widgets/bottom_navigation/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          drawer: NavDrawer(),
          appBar: AppBar(
            backgroundColor: Colors.black,
            actions: <Widget>[IconBuilder(icon:Icons.search,type:"search"), IconBuilder(icon:Icons.more_vert,type:"vert")],
            title: text18LeftBoldWhite("Upload Spoor Geotag",),
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

class IconBuilder extends ViewModelWidget<UploadViewModel> {
  String type;
  IconData icon;
  IconBuilder({Key key,this.icon,this.type}) : super(reactive: true);

  @override
  Widget build(BuildContext context, UploadViewModel model) {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
       child: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(icon, color: Colors.white),
        onPressed: (){
          if(type == "search"){
            navigateToSearchView();
          }else{

          }
        }
      ),
    );
  }
}

class NavDrawer extends ViewModelWidget<UploadViewModel> {
  //List<HomeModel> animalList;
  NavDrawer({Key key}) : super(reactive: true);

  @override
  Widget build(BuildContext context, UploadViewModel model) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: text22LeftBoldWhite("Side Menu"),
            decoration: BoxDecoration(
              color: Colors.grey,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/springbok.jpg')
              )
            ),
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: text16LeftBoldGrey("Profile"),
            onTap: () =>{
              navigateToProfile()
            }
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: text16LeftBoldGrey("Settings"),
            onTap: () =>{}
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: text16LeftBoldGrey("Preference"),
            onTap: () =>{}
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: text16LeftBoldGrey("Logout"),
            onTap: ()async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("loggedIn", false);
              navigateToLogin(context);
            }
          ),
        ],
      ),
    );
  }
}

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
          Expanded(flex:5,child: text14LeftBoldGrey("From Gallery")),
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
          Expanded(flex:5,child: text14LeftBoldGrey("From Gallery")),
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
          Expanded(flex:5,child: text14LeftBoldGrey("From Camera")),
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
          Expanded(flex:5,child: text14LeftBoldGrey("From Camera")),
          Expanded(flex:1,child: rightIcon),
        ],),
      ),
      onTap: () {
        model.uploadFromCamera();
      },
    );
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
        fontFamily: 'MavenPro',
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
        fontFamily: 'MavenPro',
        fontWeight: FontWeight.normal,
        color: Colors.grey
      ),
    );
  }
}

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
          Container(margin: EdgeInsets.only(top:13,bottom:10),child: containerTitle("Spoor Location")),
          SpoorLocation(),
        ],
      ),
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
        Container(margin: new EdgeInsets.only(left:5),padding:new EdgeInsets.all(0) ,alignment:Alignment.centerLeft,child: text14LeftBoldGrey("Longitude: ")),
        Container(margin: new EdgeInsets.only(left:0),padding:new EdgeInsets.all(5) ,alignment:Alignment.centerLeft,child: Longitude()),
        Container(margin: new EdgeInsets.only(left:5),padding:new EdgeInsets.all(0) ,alignment:Alignment.centerLeft,child: text14LeftBoldGrey("Latitude: ")),
        Container(margin: new EdgeInsets.only(left:0),padding:new EdgeInsets.all(5) ,alignment:Alignment.centerLeft,child: Latitude()),
      ],);
  }
}

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
        return Container(
          margin: new EdgeInsets.only(right:5),
          child: ChoiceChip(
            avatar: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.black,
              child: text14CenterNormWhite(model.tags[index][0].toUpperCase())
            ),
            label: text14CenterBoldGrey(model.tags[index]),
            backgroundColor: Colors.grey[100],
            selected: defualtChoiceIndex==index,
            selectedColor: Colors.blue.shade100,
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
          ),
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
        child: text16CenterBoldWhite("UPLOAD GEOTAG"),
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
  child: text18CenterBoldGrey("Please enter in Spoor Information below"),
);

Widget containerTitle(String title){
  return Container(
    margin: EdgeInsets.only(left:7),
    alignment: Alignment.centerLeft,
    child: text12LeftBoldGrey(title)
  );
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
      Expanded(flex:1,child: containerTitle("Attach A Tag")),
    ],),
);

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
      Expanded(flex:1,child: containerTitle("Spoor Image")),
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
//================================== TEXT TEMPLATES =============================