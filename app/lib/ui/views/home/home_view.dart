import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:ERP_RANGER/services/util.dart';
import 'package:ERP_RANGER/ui/views/home/home_viewmodel.dart';
import 'package:ERP_RANGER/ui/widgets/bottom_navigation/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BottomNavigation bottomNavigation = BottomNavigation();
    bottomNavigation.setIndex(0);

    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => FutureBuilder(
          future: model.getRecentIdentifications(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.hasData
                  ? Scaffold(
                      drawer: HomeNavDrawer(),
                      appBar: AppBar(
                        leading: Builder(
                          builder: (BuildContext context) {
                            return model.newNotifications == false
                                ? IconButton(
                                    icon: const Icon(Icons.menu),
                                    onPressed: () {
                                      Scaffold.of(context).openDrawer();
                                    },
                                    tooltip: MaterialLocalizations.of(context)
                                        .openAppDrawerTooltip,
                                  )
                                : IconButton(
                                    icon: new Stack(
                                      children: [
                                        new Icon(Icons.menu),
                                        new Positioned(
                                          right: 0,
                                          child: new Container(
                                              padding: EdgeInsets.all(1),
                                              decoration: new BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              constraints: BoxConstraints(
                                                minWidth: 12,
                                                minHeight: 12,
                                              ),
                                              child: Container(
                                                height: 5,
                                                width: 5,
                                                decoration: new BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                              )),
                                        )
                                      ],
                                    ),
                                    onPressed: () {
                                      Scaffold.of(context).openDrawer();
                                    },
                                    tooltip: MaterialLocalizations.of(context)
                                        .openAppDrawerTooltip,
                                  );
                          },
                        ),
                        title: text22LeftBoldWhite(
                          "ERP RANGER",
                        ),
                        actions: <Widget>[
                          IconBuilder(icon: Icons.search),
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
                        key: Key('List'),
                        padding: EdgeInsets.all(10),
                        color: Colors.grey[300],
                        child: HomeListBody(animalList: model.animals),
                      ),
                      bottomNavigationBar: BottomNavigation(),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          showOptions(context);
                        },
                        child: Icon(
                          Icons.camera_alt,
                        ),
                        backgroundColor: Color.fromRGBO(205, 21, 67, 1),
                      ),
                    )
                  : progressIndicator();
            } else {
              return progressIndicator();
            }
          }),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}

// ignore: must_be_immutable
class IconBuilder extends ViewModelWidget<HomeViewModel> {
  IconData icon;
  IconBuilder({Key key, this.icon}) : super(reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
      child: IconButton(
          key: Key('Search'),
          padding: EdgeInsets.all(0),
          icon: Icon(icon, color: Colors.white),
          onPressed: () {
            navigateToSearchView();
          }),
    );
  }
}
//========================== APPBAR ICONS =======================

// ignore: must_be_immutable
class HomeListBody extends ViewModelWidget<HomeViewModel> {
  List<HomeModel> animalList;
  HomeListBody({Key key, this.animalList}) : super(reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    model.getRecentIdentifications();
    return ListView.builder(
        key: Key('HomeListBody'),
        itemCount: animalList.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            key: Key('TrackID'),
            onTap: () {
              navigateToIdentification(animalList[index].id);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
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
                    Expanded(
                        flex: 4,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: imageBlock(animalList[index].pic)),
                            Expanded(
                                flex: 2,
                                child: textColumn(
                                    animalList[index].name,
                                    animalList[index].time,
                                    animalList[index].species,
                                    animalList[index].location,
                                    animalList[index].captured))
                          ],
                        )),
                    Divider(),
                    Expanded(
                        flex: 1,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.center,
                                margin: new EdgeInsets.only(
                                    left: 15, right: 10, bottom: 6),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: <Color>[
                                          Color.fromRGBO(33, 78, 125, 1),
                                          Color.fromRGBO(80, 156, 208, 1)
                                        ]),
                                    borderRadius: BorderRadius.circular(10)),
                                child: text12LeftBoldWhite(
                                  animalList[index].tag,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.center,
                                margin:
                                    new EdgeInsets.only(right: 10, bottom: 6),
                                child: textRow(animalList[index].score),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class HomeNavDrawer extends ViewModelWidget<HomeViewModel> {
  HomeNavDrawer({Key key}) : super(reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return Container(
      width: 250,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/ERP_Tech.png'))),
              child: null,
            ),
            ListTile(
                leading: Icon(Icons.home),
                title: text16LeftBoldGrey("Home"),
                dense: true,
                onTap: () => {
                      Fluttertoast.showToast(
                          msg: "Already on home page",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.grey[200],
                          textColor: Colors.black,
                          fontSize: 16.0)
                    }),
            ListTile(
                leading: Icon(Icons.account_circle),
                title: text16LeftBoldGrey("Profile"),
                dense: true,
                onTap: () => {navigateToProfile(context)}),
            ListTile(
                leading: Icon(Icons.verified_user),
                title: text16LeftBoldGrey("Achievements"),
                dense: true,
                onTap: () => {navigateToAchievements()}),
            ListTile(
                leading: Icon(Icons.exit_to_app),
                dense: true,
                title: text16LeftBoldGrey("Logout"),
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
