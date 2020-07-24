import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:ERP_RANGER/ui/views/profile/profile_viewmodel.dart';
import 'package:ERP_RANGER/ui/widgets/bottom_navigation/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      builder: (context, model, child) => FutureBuilder(
        future: model.getRecentIdentifications(),
        builder: (context, snapshot){
          if(snapshot.hasError){
             return Center(child: text("Error", 20));
          }
          if(snapshot.hasData){
            int userLevel = snapshot.data.userLevel;
            BottomNavigation bottomNavigation = BottomNavigation();
            if(userLevel == 1){
              bottomNavigation.setIndex(2);
            }else{
              bottomNavigation.setIndex(3);
            }
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                leading: IconBuilder(icon:Icons.menu,type:"search"),
                title: text("Profile", 22),
                actions: <Widget>[IconBuilder(icon:Icons.search,type:"search"), IconBuilder(icon:Icons.more_vert,type:"vert")],
              ),
              body: Container(color:Colors.grey[300] ,child: TopBar(tempObject: snapshot.data,)),
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
      viewModelBuilder: () => ProfileViewModel(),
    );
  }
}

class IconButtons extends ViewModelWidget<ProfileViewModel> {
  IconData iconData;
  String subTitle;
  int index;
  IconButtons({Key key, this.iconData, this.subTitle,this.index}) : super(key: key, reactive:true);

  @override
  Widget build(BuildContext context, ProfileViewModel model) {
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
          child: IconButton(
            icon:Icon(iconData, size: 20,), 
            onPressed: () {
            },
          ),
        ),
        text4(subTitle, 10)
      ],
  ),
    );
  }
}

class IconBuilder extends ViewModelWidget<ProfileViewModel> {
  String type;
  IconData icon;
  IconBuilder({Key key,this.icon,this.type}) : super(reactive: true);

  @override
  Widget build(BuildContext context, ProfileViewModel model) {
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

class ListBody extends ViewModelWidget<ProfileViewModel> {
  List<ProfileModel> animalList;
  ListBody({Key key, this.animalList}) : super(reactive: true);

  @override
  Widget build(BuildContext context, ProfileViewModel model) {
    return ListView.builder(
      itemCount: animalList.length,
      itemBuilder: (context, index){
        return GestureDetector(
          onTap: (){
            model.navigateToInfo();
          },
          child: Container(
            margin: new EdgeInsets.all(10),
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
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: font,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.bold,
      color: Colors.black
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
class TopBar extends ViewModelWidget<ProfileViewModel> {
  TempObject tempObject;
  List<ProfileModel> animalList;
  TopBar({Key key,this.tempObject}) : super(reactive: true);

  @override
  Widget build(BuildContext context, ProfileViewModel model) {
    animalList = tempObject.animalList;
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool isScrolled){
          return [
            SliverAppBar(
              expandedHeight: 180.0,
              automaticallyImplyLeading: false,
              leading: null,
              floating: true,
              pinned: false,
              stretch: false,
              snap: false,
              backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: profileinfo(tempObject.infoModel),
                collapseMode: CollapseMode.pin,
              ),
            ),
          ];
        }, 
        body: ListBody(animalList: animalList,)
    );
  }
}

Widget profileinfo(ProfileInfoModel profileInfo){
  return Container(
    child: Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                padding: new EdgeInsets.all(0),
                //color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[Expanded(flex:1, child: profilepic),Expanded(flex:3, child: profiletext)],
                ),
              ),
            Container(padding: new EdgeInsets.all(0),color:Colors.white,child: summary(profileInfo)),
            Container(
              child: Row(children: <Widget>[
                Expanded(flex:1,child: IconButtons(iconData:Icons.edit,subTitle:"EDIT PROFILE",index:0)),
                Expanded(flex:1,child: IconButtons(iconData:Icons.lock,subTitle:"CHANGE PASSWORD",index:1)),
                Expanded(flex:1,child: IconButtons(iconData:Icons.settings,subTitle:"PREFERENCE",index:2)),
                Expanded(flex:1,child: IconButtons(iconData:Icons.power_settings_new,subTitle:"LOGOUT",index:3)),
              ],),
            ),        //ListBody(animalList: animalList,)

          ],
        ),
      ],
    ),
  );
} 

Widget profiletext = new Container(
    color: Colors.white
    ,
    alignment: Alignment.center,
    margin: new EdgeInsets.only(bottom:5,right:10,top:5 ),
    height: 70,
    child: Column(
        children:<Widget>[
          Expanded(
              flex:1,
              child: Container(alignment: Alignment.centerLeft ,child: text2("Kagiso Ndlovu",22))
          ),
          Expanded(
              flex:1,
              child: Row(
                children: <Widget>[
                  Expanded(flex:1,child: Container(alignment: Alignment.centerLeft ,child: Icon(Icons.email,size: 15,color: Colors.grey,))),
                  Expanded(flex:10,child: Container(alignment: Alignment.centerLeft ,child: text5('k.ndlovu@email.com',15))),
                ],
              )
          ),
          Expanded(
              flex:1,
              child: Row(
                children: <Widget>[
                  Expanded(flex:1,child: Container(alignment: Alignment.centerLeft , child: Icon(Icons.phone,size: 15,color: Colors.grey))),
                  Expanded(flex:10,child: Container(alignment: Alignment.centerLeft ,child: text5('+27712345567',15))),
                ],
              )
          ),
        ]
    ),
  );

Widget summary(ProfileInfoModel profileInfo){
  int spoorIdentified =profileInfo.spoorIdentified ;
  int animalsTracked = profileInfo.animalsTracked;
  int speciesTracked = profileInfo.speciesTracked;
  return Container(
      alignment: Alignment.center,
      // padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(flex:1,child: Container(alignment:Alignment.centerRight,color: Colors.white,height: 30,width: 30,child: Center(child: text2("$spoorIdentified", 20)),)),
                Expanded(flex:1,child: Container(margin: new EdgeInsets.all(0),color: Colors.white,height: 30,width: 30,child: Column(children:[
                  Expanded(flex:1,child: Container(alignment:Alignment.bottomLeft,child: text3("Spoors",10))),
                  Expanded(flex:1,child: Container(alignment: Alignment.topLeft,child: text3("Identified",10)))
                ]),)),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(flex:1,child: Container(alignment:Alignment.centerRight,color: Colors.white,height: 30,width: 30,child: Center(child: text2("$animalsTracked", 20)))),
                Expanded(flex:1,child: Container(margin: new EdgeInsets.all(0),color: Colors.white,height: 30,width: 30,child: Column(children:[
                  Expanded(flex:1,child: Container(alignment:Alignment.bottomLeft,child: text3("Animals",10))),
                  Expanded(flex:1,child: Container(alignment: Alignment.topLeft,child: text3("Tracked",10)))
                ]),)),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Expanded(flex:1,child: Container(alignment:Alignment.centerRight,color: Colors.white,height: 30,width: 30,child: Center(child: text2("$speciesTracked", 20)))),
                Expanded(flex:1,child: Container(margin: new EdgeInsets.all(0),color: Colors.white,height: 30,width: 30,child: Column(children:[
                  Expanded(flex:1,child: Container(alignment:Alignment.bottomLeft,child: text3("Species",10))),
                  Expanded(flex:1,child: Container(alignment: Alignment.topLeft,child: text3("Tracked",10)))
                ]),)),
              ],
            ),
          ),
        ],
      ),
    );
  } 

Widget profilepic = new Container(
    alignment: Alignment.center,
    margin: new EdgeInsets.only(bottom:5,right:10,top:5,left:5 ),
    padding: new EdgeInsets.all(5),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage( "assets/images/profile.png"),
        fit: BoxFit.fill,
      ),
      color: Colors.white,
      borderRadius: BorderRadius.circular(100),
    ),
    height: 70,
  );

