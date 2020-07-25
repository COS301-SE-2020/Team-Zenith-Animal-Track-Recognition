import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:ERP_RANGER/ui/views/home/home_viewmodel.dart';
import 'package:ERP_RANGER/ui/widgets/bottom_navigation/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BottomNavigation bottomNavigation = BottomNavigation();
    bottomNavigation.setIndex(0);

    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => FutureBuilder(
        future: model.getRecentIdentifications(),
        builder: (context, snapshot){
          if(snapshot.hasError){
             return Center(child: text("Error", 20));
          }
          if(snapshot.hasData){
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.black,
                title: text("Recent Indentifications", 20),
                actions: <Widget>[IconBuilder(icon:Icons.search,type:"search"), IconBuilder(icon:Icons.more_vert,type:"vert")],
              ),
              body: Container(
                padding: EdgeInsets.all(10),
                color: Colors.grey[300],
                child: ListBody(animalList: snapshot.data),
              ),
              bottomNavigationBar: BottomNavigation(),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  model.captureImage();
                },
                child: Icon(Icons.camera_alt,),
                backgroundColor: Colors.black,
              ),
            );
          }
          else{
            return Center(child: text("Null no Data", 20));
          }
        }
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}

class IconBuilder extends ViewModelWidget<HomeViewModel> {
  String type;
  IconData icon;
  IconBuilder({Key key,this.icon,this.type}) : super(reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
       child: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(icon, color: Colors.white),
        onPressed: (){
          if(type == "search"){
            model.navigateToSearchView();
          }else{
          }
        }
      ),
    );
  }
}
//========================== APPBAR ICONS =======================

class ListBody extends ViewModelWidget<HomeViewModel> {
  List<HomeModel> animalList;
  ListBody({Key key, this.animalList}) : super(reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return ListView.builder(
      itemCount: animalList.length,
      itemBuilder: (context, index){
        return GestureDetector(
          onTap: (){
            model.navigateToIdentification(animalList[index].name.toLowerCase());
          },
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            margin: new EdgeInsets.all(10),
            child: Container(
              padding: new EdgeInsets.all(0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              height: 150,
              child: Column(
                children: <Widget>[
                  Expanded(flex:4,child: Row(children: <Widget>[
                    Expanded(flex:1,child: imageBlock(animalList[index].pic)),
                    Expanded(flex:2,child: textColumn(animalList[index].name, animalList[index].time, animalList[index].species, animalList[index].location, animalList[index].captured))
                  ],)),
                  Divider(),
                  Expanded(flex:1,child: Row(
                    children: <Widget>[
                      Expanded(flex: 1,child: Container(
                        alignment: Alignment.center, margin: new EdgeInsets.only(left:15,right:10,bottom: 6),
                        decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(10)),
                        child: text(animalList[index].tag, 13),
                      ),),
                      Expanded(flex: 2,child: Container(
                        alignment: Alignment.center, margin: new EdgeInsets.only(right:10,bottom: 6),
                        //decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(10)),
                        child: textRow(animalList[index].score),
                      ),),
                    ],
                  )),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}

Widget imageBlock (String imageLink) {
    return Container(
    alignment: Alignment.center,
    margin: new EdgeInsets.only(left:15,right:10,),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(imageLink),
        fit: BoxFit.fill,
      ),
      color: Colors.grey,
      borderRadius: BorderRadius.circular(15),
    ),
    height: 75,
  );
}

Widget textColumn(String name, String time, String species, String location, String capturedBy){
  return Container(
    height: 75,
    margin: new EdgeInsets.only(right:10,),
    child: Column(
      children: <Widget>[
        Expanded(flex:1,child:Row(children: <Widget>[
          Expanded(flex:1,child: Container(color: Colors.white,child: text2(name, 18),)),
          Expanded(flex:1,child: Container(color: Colors.white,child: text5(time, 13),)),
        ],)),
        Expanded(flex:1,child:Row(children: <Widget>[
          Expanded(flex:1,child: Container(color: Colors.white,child: text2("Species: ", 12),)),
          Expanded(flex:2,child: Container(color: Colors.white,child: text3(species, 12),)),
        ],)),      
        Expanded(flex:1,child:Row(children: <Widget>[
          Expanded(flex:1,child: Container(color: Colors.white,child: text2("Location: ", 12),)),
          Expanded(flex:2,child: Container(color: Colors.white,child: text3(location, 12),)),
        ],)),
        Expanded(flex:1,child:Row(children: <Widget>[
          Expanded(flex:1,child: Container(color: Colors.white,child: text2("Captured by: ", 12),)),
          Expanded(flex:2,child: Container(color: Colors.white,child: text3(capturedBy, 12),)),
        ],)),    ],
    ),
  );
}

Widget textRow(String accuracy){
  return Row(children: <Widget>[
    Expanded(flex: 2,child: text3("ACCURACY SCORE", 14),),
    Expanded(flex: 1,child: text6(accuracy, 14),),
  ],);
}
//================================== TEXT TEMPLATES =============================
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
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: font,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.bold,
      color: Colors.black
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
      color: Colors.grey
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
      fontWeight: FontWeight.normal,
      color: Colors.grey
    ),
  );
}

Widget text6(String text, double font){
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


