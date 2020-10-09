import 'package:ERP_RANGER/services/util.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

import 'achievements_viewmodel.dart';

class AchievementsView extends StatelessWidget {
  AchievementsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AchievementsViewModel>.reactive(
      builder: (context, model, child) => FutureBuilder(
          future: model.getModel(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                drawer: NavDrawer(),
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  title: text22LeftBoldWhite(
                    "ERP RANGER",
                  ),
                  actions: <Widget>[
                    IconBuilder(icon: Icons.search, type: "search"),
                  ],
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                          Color.fromRGBO(33, 78, 125, 1),
                          Color.fromRGBO(80, 156, 208, 1)
                        ])),
                  ),
                ),
                body: internetError(snapshot.error.toString()),
              );
            }
            if (snapshot.hasData) {
              return snapshot.hasData
                  ? WillPopScope(
                      onWillPop: () async {
                        if (Navigator.canPop(context)) {
                          navigate(context);
                        }
                        return;
                      },
                      child: Scaffold(
                        drawer: NavDrawer(),
                        appBar: AppBar(
                          backgroundColor: Colors.black,
                          title: text22LeftBoldWhite(
                            "ERP RANGER",
                          ),
                          actions: [
                            IconBuilder(icon: Icons.search, type: "search")
                          ],
                          flexibleSpace: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: <Color>[
                                  Color.fromRGBO(33, 78, 125, 1),
                                  Color.fromRGBO(80, 156, 208, 1)
                                ])),
                          ),
                        ),
                        body: Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.grey[100],
                          child: Center(
                              child: ListBody(
                            trophies: snapshot.data,
                          )),
                        ),
                      ))
                  : progressIndicator();
            } else {
              return progressIndicator();
            }
          }),
      viewModelBuilder: () => AchievementsViewModel(),
    );
  }
}

// ignore: must_be_immutable
class ListBody extends ViewModelWidget<AchievementsViewModel> {
  List<TrophyModel> trophies;
  ListBody({Key key, this.trophies}) : super(reactive: true);

  @override
  Widget build(BuildContext context, AchievementsViewModel viewModel) {
    return ListView.builder(
        itemCount: trophies.length,
        itemBuilder: (context, index) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            elevation: 0,
            child: ListTile(
              leading: trophyBlock(trophies[index].image),
              title: Text(trophies[index].title),
              subtitle: Text(trophies[index].descrption),
              dense: true,
            ),
          );
        });
  }
}

Widget trophyBlock(String imageLink) {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(imageLink),
        fit: BoxFit.fill,
      ),
      color: Colors.white,
      borderRadius: BorderRadius.circular(11),
    ),
    height: 50,
    width: 50,
  );
}

class NavDrawer extends ViewModelWidget<AchievementsViewModel> {
  //List<HomeModel> animalList;
  NavDrawer({Key key}) : super(reactive: true);

  @override
  @override
  Widget build(BuildContext context, AchievementsViewModel model) {
    return Container(
      width: 200,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0),
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/ERP_Tech.png'))),
              child: null,
            ),
            ListTile(
                leading: Icon(Icons.home, color: Colors.black87),
                title: text16LeftNormBlack("Home"),
                dense: true,
                onTap: () => {navigateToHomeView(context)}),
            ListTile(
                leading: Icon(Icons.account_circle, color: Colors.black87),
                title: text16LeftNormBlack("Profile"),
                dense: true,
                onTap: () => {navigateToProfile(context)}),
            ListTile(
                leading: Icon(Icons.verified_user, color: Colors.black87),
                title: text16LeftNormBlack("Achievements"),
                dense: true,
                onTap: () => {
                      Fluttertoast.showToast(
                          msg: "Already on achievements page",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.grey[200],
                          textColor: Colors.black,
                          fontSize: 16.0)
                    }),
            ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.black87),
                dense: true,
                title: text16LeftNormBlack("Logout"),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool("loggedIn", false);
                  prefs.setInt("accessLevel", null);
                  prefs.setString("token", null);
                  prefs.setString("rangerID", null);
                  navigateToLogin(context);
                }),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class IconBuilder extends ViewModelWidget<AchievementsViewModel> {
  String type;
  IconData icon;
  IconBuilder({Key key, this.icon, this.type}) : super(reactive: true);

  @override
  Widget build(BuildContext context, AchievementsViewModel model) {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
      child: IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(icon, color: Colors.white),
          onPressed: () {
            if (type == "search") {
              navigateToSearchView();
            }
          }),
    );
  }
}
