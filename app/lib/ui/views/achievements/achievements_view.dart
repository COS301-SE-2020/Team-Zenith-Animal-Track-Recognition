import 'package:ERP_RANGER/services/util.dart';
import 'package:ERP_RANGER/ui/views/identification/identification_view.dart';
import 'package:ERP_RANGER/ui/widgets/bottom_navigation/bottom_nav.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:flutter/material.dart';
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
                        ),
                        body: Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.grey[300],
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
      color: Colors.grey,
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
  Widget build(BuildContext context, AchievementsViewModel model) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
                color: Colors.grey,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/E1.jpg'))),
          ),
          ListTile(
              leading: Icon(Icons.account_circle),
              title: text16LeftBoldGrey("Profile"),
              dense: true,
              onTap: () => {navigateToProfile()}),
          ListTile(
              leading: Icon(Icons.verified_user),
              title: text16LeftBoldGrey("Achievements"),
              dense: true,
              onTap: () => {navigateToAchievements()}),
          ListTile(
              leading: Icon(Icons.settings),
              title: text16LeftBoldGrey("Settings"),
              dense: true,
              onTap: () => {}),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              dense: true,
              title: text16LeftBoldGrey("Logout"),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool("loggedIn", false);
                navigateToLogin(context);
              }),
        ],
      ),
    );
  }
}

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
