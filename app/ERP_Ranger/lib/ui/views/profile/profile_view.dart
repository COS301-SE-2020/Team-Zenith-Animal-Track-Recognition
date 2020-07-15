import 'package:ERP_Ranger/ui/views/confirm/confirm_view.dart';
import 'package:ERP_Ranger/ui/views/confirm/unconfirmed_view.dart';
import 'package:flutter/material.dart';
import '../../../core/viewmodels/profile_viewmodel.dart';
import '../../widgets/bottom_nav.dart';
import '../base_view.dart';
import '../../../core/services/user.dart';

class ProfileView extends StatefulWidget {
  ProfileView({Key key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
   int _currentTabIndex = 3;
  @override
  Widget build(BuildContext context) {
    BottomNavigation bottomNavigation = new BottomNavigation();
    bottomNavigation.setIndex(_currentTabIndex);
    return BaseView<ProfileModel>(
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async { 
          if(Navigator.canPop(context)){
            Navigator.of(context).popUntil((route) => route.isFirst);
          }else{
            print("noo");
          }
        },
        child: Scaffold(
          appBar:AppBar(
            backgroundColor: Colors.black,
            leading: LeftMenu(),
            title: textTitle,
            actions: <Widget>[
              SearchButton(),
              MenuVert(),
            ],
          ),
          body: null,
          bottomNavigationBar: BottomNavigation(),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add_a_photo),
            backgroundColor: Color(0xFFF2929C),
            tooltip: 'Pick Image',
            onPressed:()async{
              List<User> animals = await model.imagePicker();
              if(animals == null){
                Navigator.push(context, 
                  new MaterialPageRoute(builder: (context) => UnConfirmView())
                ); 
              }else{
                Navigator.push(context, 
                  new MaterialPageRoute(builder: (context) => ConfirmView(animal: animals,))
                ); 
              }
            } 
          ),        
        ),
      )
    );
  }
}

//==============================================

class LeftMenu extends StatefulWidget {
  LeftMenu({Key key}) : super(key: key);

  @override
  _LeftMenu createState() => _LeftMenu();
}

class _LeftMenu extends State<LeftMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
       child: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(Icons.menu,color: Colors.white,),
        onPressed: null
      ),
    );
  }
}

class SearchButton extends StatefulWidget {
  SearchButton({Key key}) : super(key: key);

  @override
  _SearchButton createState() => _SearchButton();
}

class _SearchButton extends State<SearchButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
       child: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(Icons.search, color: Colors.white,),
        onPressed: null
      ),
    );
  }
}

class MenuVert extends StatefulWidget {
  MenuVert({Key key}) : super(key: key);

  @override
  _MenuVert createState() => _MenuVert();
}

class _MenuVert extends State<MenuVert> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
       child: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(Icons.more_vert,color: Colors.white),
        onPressed: null
      ),
    );
  }
}

Widget textTitle = new Text(
  "Profile",
  textAlign: TextAlign.center,
  style: TextStyle(
    fontSize: 22,
    fontFamily: 'Arciform',
    fontWeight: FontWeight.bold,
    color: Colors.white
  )
);