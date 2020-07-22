import 'package:ERP_RANGER/ui/views/upload/upload_viewmodel.dart';
import 'package:ERP_RANGER/ui/widgets/bottom_navigation/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

String imageLink = "https://images.unsplash.com/photo-1576313966078-951c6cdd8866?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80";
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
            model.navigate(context);
          }
          return;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            title: text("Upload Spoor Geotag", 22),
          ),
          body:Container(
            padding: EdgeInsets.all(10),
            color: Colors.grey[300], 
            child: SliverBody(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              model.captureImage();
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
              animalInformation,
              spoorLocation,
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
      Expanded(flex:1,child: GalleryButton(caption: "From Photos",)),
      Expanded(flex:1,child: GalleryButton(caption: "From Camera",)),
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

Widget leftImage = new Container(
  alignment: Alignment.center,
  margin: new EdgeInsets.only(right:5,left:5),
  padding: new EdgeInsets.all(5),
    decoration: BoxDecoration(
    color: Colors.grey,
    borderRadius: BorderRadius.circular(10),
    image: DecorationImage(
      image: NetworkImage(imageLink),
      fit: BoxFit.fill,
    ),
  ),
  height: 30,
  width: 30,
);

class GalleryButton extends ViewModelWidget<UploadViewModel> {
  String caption;
  GalleryButton({Key key,this.caption}) :super(reactive: true);
  bool changed = false;
  @override
  Widget build(BuildContext context, UploadViewModel model) {
    return changed == false
    ?GestureDetector(
     child: Container(
        margin: new EdgeInsets.only(bottom: 10),
        child: Row(children: <Widget>[
          Expanded(flex:1,child: leftBlock),
          Expanded(flex:5,child: text4(caption,15)),
          Expanded(flex:1,child: rightIcon),
        ],),
      ),
      onTap: () async{
        if(caption == "From Photos"){
          model.uploadFromGallery();
        }else{
          model.uploadFromCamera();
        }
        changed = model.value;
        model.notifyListeners();
      },
    )
    :GestureDetector(
      child: Container(
        margin: new EdgeInsets.only(bottom: 10),
        child: Row(children: <Widget>[
          Expanded(flex:1,child: leftImage),
          Expanded(flex:5,child: text4(caption,15)),
          Expanded(flex:1,child: rightIcon),
        ],),
      ),
      onTap: () {
        if(caption == "From Photos"){
          model.uploadFromGallery();
        }else{
          model.uploadFromCamera();
        }
        changed = model.value;
        model.notifyListeners();
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
      Expanded(flex:1,child: GalleryButton(caption:"Select An Animal")),
    ],
  ),
);

Widget spoorLocation = new Container(
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
      Expanded(flex:1,child: containerTitle("Spoor Location", 13)),
      Expanded(flex:1,child: GalleryButton(caption:"Spoor Location")),
    ],
  ),
);

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
    List<String> tags = new List<String>();
    tags.add("Tag 1");
    tags.add("Tag 2");
    tags.add("Tag 3");
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      spacing: 3.0,
      runSpacing: 3.0,
      children: List<Widget>.generate(tags.length, (index){
        return ChoiceChip(
          avatar: CircleAvatar(
            radius: 10,
            backgroundColor: Colors.grey.shade600,
            child: Text(tags[index][0].toUpperCase())
          ),
          label: text2(tags[index], 15),
          backgroundColor: Colors.grey[100],
          selected: defualtChoiceIndex==index,
          selectedColor: Colors.blue[200],
          elevation: 2,
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
          //model.navigateTo()
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