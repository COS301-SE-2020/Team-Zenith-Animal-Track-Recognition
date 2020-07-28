import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:ERP_RANGER/services/util.dart';
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
             return progressIndicator();
          }
          if(snapshot.hasData){
            return snapshot.hasData ? Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.black,
                title: appBarTitle("Recent Indentifications", context),
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
                  captureImage();
                },
                child: Icon(Icons.camera_alt,),
                backgroundColor: Colors.black,
              ),
            )
            : progressIndicator();
          }
          else{
            return progressIndicator();
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
            navigateToSearchView();
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
            navigateToIdentification(animalList[index].name.toLowerCase());
          },
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 0,
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
                    Expanded(flex:2,child: textColumn(animalList[index].name, animalList[index].time, animalList[index].species, animalList[index].location, animalList[index].captured,context))
                  ],)),
                  Divider(),
                  Expanded(flex:1,child: Row(
                    children: <Widget>[
                      Expanded(flex: 1,child: Container(
                        alignment: Alignment.center, margin: new EdgeInsets.only(left:15,right:10,bottom: 6),
                        decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(10)),
                        child: tagText(animalList[index].tag, context),
                      ),),
                      Expanded(flex: 2,child: Container(
                        alignment: Alignment.center, margin: new EdgeInsets.only(right:10,bottom: 6),
                        //decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(10)),
                        child: textRow(animalList[index].score,context),
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

Widget textColumn(String name, String time, String species, String location, String capturedBy, var context){
  return Container(
    height: 75,
    margin: new EdgeInsets.only(right:10,),
    child: Column(
      children: <Widget>[
        Expanded(flex:1,child:Row(children: <Widget>[
          Expanded(flex:1,child: Container(color: Colors.white,child: cardTitle(name, context),)),
          Expanded(flex:1,child: Container(color: Colors.white,child: cardTextRight(time, context),)),
        ],)),
        Expanded(flex:1,child:Row(children: <Widget>[
          Expanded(flex:1,child: Container(color: Colors.white,child: cardTextLeft("Species: ", context),)),
          Expanded(flex:2,child: Container(color: Colors.white,child: cardTextValue(species, context),)),
        ],)),      
        Expanded(flex:1,child:Row(children: <Widget>[
          Expanded(flex:1,child: Container(color: Colors.white,child: cardTextLeft("Location: ", context),)),
          Expanded(flex:2,child: Container(color: Colors.white,child: cardTextValue(location, context),)),
        ],)),
        Expanded(flex:1,child:Row(children: <Widget>[
          Expanded(flex:1,child: Container(color: Colors.white,child: cardTextLeft("Captured by: ", context),)),
          Expanded(flex:2,child: Container(color: Colors.white,child: cardTextValue(capturedBy, context),)),
        ],)),    ],
    ),
  );
}

Widget textRow(String accuracy,var context){
  return Row(children: <Widget>[
    Expanded(flex: 2,child: homeViewAccuracyScoreLeft("ACCURACY SCORE", context),),
    Expanded(flex: 1,child: homeViewAccuracyScoreRight(accuracy, context),),
  ],);
}
