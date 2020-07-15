import 'package:ERP_RANGER/ui/views/gallery/gallery_viewmodel.dart';
import 'package:ERP_RANGER/ui/widgets/bottom_navigation/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BottomNavigation bottomNavigation = BottomNavigation();
    bottomNavigation.setIndex(1);
    return ViewModelBuilder<GalleryViewModel>.reactive(
      builder: (context, model, child) => FutureBuilder(
        future: model.getSpoor(),
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
                length: snapshot.data.length,
                child: Scaffold(
                  appBar: AppBar(
                    leading: null,
                    backgroundColor: Colors.black,
                    title: text("African Bush Elephant", 22),
                    actions: <Widget>[IconBuilder(icon:Icons.more_vert,type:"vert")],
                    bottom: TabBar(tabs: snapshot.data.tabs,indicatorWeight: 3,),
                  ),
                  body: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.grey[300], 
                    child: TabBarView(children:getBodyWidgets(snapshot.data.length, snapshot.data.animalList),),
                  ),
                  bottomNavigationBar: BottomNavigation(),
                  floatingActionButton: FloatingActionButton(onPressed: model.updateCounter,),                                
                ),
              ),           
            );
          }else{
            return text("Null no Data", 20);
          }
        },
      ),
      viewModelBuilder: () => GalleryViewModel(),
    );
  }
}

//========================== VIEW BODY =======================
List<Widget> getBodyWidgets(int len, var data){
  List<Widget> widget = new List();
  for(int i = 0; i < len; i++){
    widget.add(getWidget(data[i]));
  }
  return widget;
}

Widget getWidget(var animalTabList){
  return GridView.count(
    crossAxisCount: 2,
    children: List.generate(animalTabList.length, (index){
      return Container(
        alignment: Alignment.center,
        margin: new EdgeInsets.only(bottom:10, left:15,right:10,top:10 ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(animalTabList[index]),
            fit: BoxFit.fill,
          ),
          color: Colors.grey,
          borderRadius: BorderRadius.circular(15),
        ),
      );
    }),
  );
}
//========================== VIEW BODY =======================

//========================== APPBAR ICONS =======================
class IconBuilder extends ViewModelWidget<GalleryViewModel> {
  String type;
  IconData icon;
  IconBuilder({Key key,this.icon,this.type}) : super(reactive: true);

  @override
  Widget build(BuildContext context, GalleryViewModel model) {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
       child: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(icon, color: Colors.white),
        onPressed: (){
        }
      ),
    );
  }
}
//========================== APPBAR ICONS =======================


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
//================================== TEXT TEMPLATES =============================

