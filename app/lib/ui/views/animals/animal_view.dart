import 'package:ERP_RANGER/ui/views/animals/animal_viewmodel.dart';
import 'package:ERP_RANGER/ui/widgets/bottom_navigation/bottom_nav.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AnimalView extends StatelessWidget {
  AnimalView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BottomNavigation bottomNavigation = BottomNavigation();
    bottomNavigation.setIndex(1);

    return ViewModelBuilder<AnimalViewModel>.reactive(
      builder: (context, model, child) => FutureBuilder(
        future: model.getCategories(),
        // ignore: missing_return
        builder: (context, snapshot){
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
              child: DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar: AppBar(
                    leading: null,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.black,
                    title: text("Animal Information", 22),
                    actions: <Widget>[IconBuilder(icon:Icons.search,type:"search"), IconBuilder(icon:Icons.more_vert,type:"vert")],
                    bottom: TabBar(tabs: snapshot.data.tabs,indicatorWeight: 3,),
                  ),
                  body: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.grey[300], 
                    child: TabBarView(children:getBodyWidgets(3, snapshot.data.animalList),),
                  ),
                  bottomNavigationBar: BottomNavigation(),
                ),
              ), 
            );
          }else{
            return text("Null no Data", 20);
          }
        }
      ),
      viewModelBuilder: () => AnimalViewModel(),
    );
  }
}

//========================== APPBAR ICONS =======================
// ignore: must_be_immutable
class IconBuilder extends ViewModelWidget<AnimalViewModel> {
  String type;
  IconData icon;
  IconBuilder({Key key,this.icon,this.type}) : super(reactive: true);

  @override
  Widget build(BuildContext context, AnimalViewModel model) {
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

//========================== VIEW BODY =======================
List<Widget> getBodyWidgets(int len, var data){
  List<Widget> widget = new List();
  for(int i = 0; i < len; i++){
    widget.add(getWidget(data[i]));
  }
  return widget;
}

Widget getWidget(var animalTabList){
  return ListView.builder(
    itemCount: animalTabList.length,
    itemBuilder: (BuildContext context, int index){
      return Container(
        alignment: Alignment.centerLeft,
        margin: new EdgeInsets.all(15),
        padding: new EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[200] , width: 2,style: BorderStyle.solid)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTileTheme(dense:true,child: Row( children:[
              Expanded(flex:2,child: imageBlock(animalTabList[index].image)),
              Expanded(flex:4,child: cardText(animalTabList[index].animalName, animalTabList[index].sizeM, animalTabList[index].sizeF, 
                animalTabList[index].weightM, animalTabList[index].weightF, animalTabList[index].diet, animalTabList[index].gestation)),
            ])),
            ListTileTheme(dense:true,child: description(animalTabList[index].description)),
            ListTileTheme(dense:true,child: behaviour(animalTabList[index].behaviour)),
            ListTileTheme(dense:true,child: habitats(animalTabList[index].habitats)),
            ListTileTheme(dense:true,child: ViewButton(name:animalTabList[index].animalName)),
          ]
        ),
      );
    }
  );
}
//========================== VIEW BODY =======================

//=============================VIEW BUTTON======================
class ViewButton extends ViewModelWidget<AnimalViewModel> {
  String name;
  ViewButton({this.name,Key key}) : super(key: key, reactive: true);
  @override
  Widget build(BuildContext context, AnimalViewModel model) {
  return ButtonTheme(
      minWidth: 200,
      child: RaisedButton(
      child: text("VIEW INFO",15),
      color: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(10),
      onPressed: (){model.navigateToInfo(name);}
    ),
  );
  }
}
//=============================VIEW BUTTON======================

//=============================IMAGE BLOCK======================
Widget imageBlock (String imageLink) {
    return Container(
    alignment: Alignment.center,
    margin: new EdgeInsets.only(bottom:10, left:15,right:10,top:10 ),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(imageLink),
        fit: BoxFit.fill,
      ),
      color: Colors.grey,
      borderRadius: BorderRadius.circular(15),
    ),
    height: 75,
    width: 75,
  );
}
//=============================IMAGE BLOCK======================

//=============================ANIMAL DETAILS===================
Widget cardText(String name, double sizeM, double sizeF, int weightM, int weightF,String diet, String gestation ){
  return Container(
    margin: EdgeInsets.all(0),
    alignment: Alignment.center,
    height: 75,
    width: 75,
    child: Column(
      children:<Widget>[
        Expanded(flex:1,child: Container(alignment: Alignment.centerLeft,margin: EdgeInsets.all(0),padding: EdgeInsets.all(0),child: text4(name,16))),
        Expanded(flex:2,child: Container(margin: EdgeInsets.all(0),padding: EdgeInsets.all(0),child: middleRow(sizeM, sizeF, weightM, weightF))),
        Expanded(flex:1,child: Container(margin: EdgeInsets.all(0),padding: EdgeInsets.all(0),child: bottomRow(diet, gestation))),
      ]
    )
  );
}

Widget middleRow(double sizeM, double sizeF, int weightM, int weightF){
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Expanded(flex: 1, 
        child: Container(
          margin: EdgeInsets.only(right:10),
          child: Row(children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                child: text4("Size:", 10),
              )
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: column2(sizeF, sizeM),
              )
            ),
          ],),
        ),
      ),
      Expanded(flex: 1, 
        child: Container(
          margin: EdgeInsets.only(right:10),
          child: Row(children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                child: text4("Weight:", 10),
              )
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: column(weightF, weightM),
              )
            ), 
          ],),
        ),
      ),
    ],
  );
}

Widget column(int metricF, int metricM){
  return Column(
    children: <Widget>[
      Expanded(
        flex: 1,
          child: Row(children: <Widget>[
            Expanded(flex:2,child: Container(child: text3('$metricF kg', 12),)),
            Expanded(flex:1,child: Container(child: Icon(Icons.person_pin,color: Colors.pink[200],size: 13,),)),
          ],
        ),
      ),
      Expanded(
        flex: 1,
          child: Row(children: <Widget>[
            Expanded(flex:2,child: Container(child: text3('$metricM kg', 12),)),
            Expanded(flex:1,child: Container(child: Icon(Icons.person_pin,color: Colors.blue,size: 13,),)),
          ],
        ),
      )
    ],
  );
}

Widget column2(double metricF, double metricM){
  return Column(
    children: <Widget>[
      Expanded(
        flex: 1,
          child: Row(children: <Widget>[
            Expanded(flex:2,child: Container(child: text3('$metricF m', 14),)),
            Expanded(flex:1,child: Container(child: Icon(Icons.person_pin,color: Colors.pink[200],size: 14,),)),
          ],
        ),
      ),
      Expanded(
        flex: 1,
          child: Row(children: <Widget>[
            Expanded(flex:2,child: Container(child: text3('$metricM m', 14),)),
            Expanded(flex:1,child: Container(child: Icon(Icons.person_pin,color: Colors.blue,size: 14,),)),
          ],
        ),
      )
    ],
  );
}

Widget bottomRow(String diet, String gestation){
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Expanded(flex: 3,
        child: Container(
          margin: EdgeInsets.only(right:10),
          child: Row(children: <Widget>[
            Expanded(flex: 1,child: text4("Diet:",12),),
            Expanded(flex: 2,child: text3(diet, 12),),
          ],),
        ),
      ),
      Expanded(
        flex: 4,
        child: Container(
          margin: EdgeInsets.only(right:10),
          child: Row(children: <Widget>[
            Expanded(flex: 1,child: text4("Gestation:",12),),
            Expanded(flex: 1,child: text3(gestation, 12),),
          ],),
        ),
      ),
    ],
  );
}
//=============================ANIMAL DETAILS===================
//=============================EXPANSION TILE===================
Widget description (String bodyText){
  return ExpansionTile(
    title: text4("Description", 15),
    children: <Widget>[expansionTileBodyTemplate(text4(bodyText,11))],
  );
}

Widget behaviour (String bodyText){
  return ExpansionTile(
    title: text4("Behaviour", 15),
    children: <Widget>[expansionTileBodyTemplate(text4(bodyText,11))],
  );
}

Widget habitats (String bodyText){
  return ExpansionTile(
    title: text4("Habitats", 15),
    children: <Widget>[expansionTileBodyTemplate(text4(bodyText,11))],
  );
}
//=============================EXPANSION TILE===================

//============================================TEMPLATES================================================

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
    textAlign: TextAlign.right,
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
      fontWeight: FontWeight.bold,
      color: Colors.grey
    ),
  );
}
//================================== TEXT TEMPLATES =============================

//================================== EXPANSION TILE TEMPLATES =============================
Widget expansionTileBodyTemplate(Widget body){
  return Container(
    alignment: Alignment.centerLeft,
    margin: EdgeInsets.only(left:17, bottom:15),
    child: body
  );
} 
//================================== EXPANSION TILE TEMPLATES =============================

//============================================TEMPLATES================================================
