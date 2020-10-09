import 'package:ERP_RANGER/services/util.dart';
import 'package:ERP_RANGER/ui/views/animals/animal_viewmodel.dart';
import 'package:ERP_RANGER/ui/widgets/bottom_navigation/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimalView extends StatelessWidget {
  AnimalView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BottomNavigation bottomNavigation = BottomNavigation();
    bottomNavigation.setIndex(1);

    return ViewModelBuilder<AnimalViewModel>.reactive(
      builder: (context, model, child) => FutureBuilder(
          future: model.getCategories(context),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                drawer: NavDrawer(),
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
                    IconBuilder(icon: Icons.search, type: "search"),
                  ],
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                          Color.fromRGBO(58, 119, 168, 1),
                          Color.fromRGBO(77, 151, 203, 1)
                        ])),
                  ),
                ),
                body: internetError(snapshot.error.toString()),
                bottomNavigationBar: BottomNavigation(),
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
                      child: DefaultTabController(
                        key: Key('DynamicTab'),
                        length: snapshot.data.length,
                        child: Scaffold(
                          drawer: NavDrawer(),
                          appBar: AppBar(
                            leading: Builder(
                              builder: (BuildContext context) {
                                return model.newNotifications == false
                                    ? IconButton(
                                        icon: const Icon(Icons.menu),
                                        onPressed: () {
                                          Scaffold.of(context).openDrawer();
                                        },
                                        tooltip:
                                            MaterialLocalizations.of(context)
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
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  constraints: BoxConstraints(
                                                    minWidth: 12,
                                                    minHeight: 12,
                                                  ),
                                                  child: Container(
                                                    height: 5,
                                                    width: 5,
                                                    decoration:
                                                        new BoxDecoration(
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
                                        tooltip:
                                            MaterialLocalizations.of(context)
                                                .openAppDrawerTooltip,
                                      );
                              },
                            ),
                            title: text22LeftBoldWhite("ERP RANGER"),
                            actions: <Widget>[
                              IconBuilder(icon: Icons.search, type: "search"),
                            ],
                            flexibleSpace: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: <Color>[
                                    Color.fromRGBO(58, 119, 168, 1),
                                    Color.fromRGBO(77, 151, 203, 1)
                                  ])),
                            ),
                            bottom: TabBar(
                              isScrollable: true,
                              tabs: snapshot.data.tabs,
                              indicatorWeight: 3,
                            ),
                          ),
                          body: Container(
                            padding: EdgeInsets.all(10),
                            color: Colors.grey[100],
                            child: TabBarView(
                              children: getBodyWidgets(snapshot.data.length,
                                  snapshot.data.animalList, model, context),
                            ),
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
                        ),
                      ),
                    )
                  : progressIndicator();
            } else {
              return progressIndicator();
            }
          }),
      viewModelBuilder: () => AnimalViewModel(),
    );
  }
}

class NavDrawer extends ViewModelWidget<AnimalViewModel> {
  //List<HomeModel> animalList;
  NavDrawer({Key key}) : super(reactive: true);

  @override
  Widget build(BuildContext context, AnimalViewModel model) {
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
                onTap: () => {navigateToAchievements()}),
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

//========================== APPBAR ICONS =======================
// ignore: must_be_immutable
class IconBuilder extends ViewModelWidget<AnimalViewModel> {
  String type;
  IconData icon;
  IconBuilder({Key key, this.icon, this.type}) : super(reactive: true);

  @override
  Widget build(BuildContext context, AnimalViewModel model) {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
      child: IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(icon, color: Colors.white),
          onPressed: () {
            if (type == "search") {
              navigateToSearchView();
            } else {}
          }),
    );
  }
}
//========================== APPBAR ICONS =======================

//========================== VIEW BODY =======================
List<Widget> getBodyWidgets(int len, var data, var model, var context) {
  List<Widget> widget = new List();
  for (int i = 0; i < len; i++) {
    widget.add(getWidget(data[i], model, context));
  }
  return widget;
}

Widget getWidget(var animalTabList, var model, var context) {
  return animalTabList == null
      ? Center(
          child: Container(
            key: Key('List'),
            padding: EdgeInsets.all(10),
            color: Colors.grey[100],
            child: Center(child: text18CenterNormalGrey("[No Animals Found]")),
          ),
        )
      : ListView.builder(
          itemCount: animalTabList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              alignment: Alignment.centerLeft,
              margin: new EdgeInsets.all(10),
              padding: new EdgeInsets.all(0),
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTileTheme(
                        dense: false,
                        child: Row(children: [
                          Expanded(
                              flex: 3,
                              child: imageBlock(animalTabList[index].image)),
                          Expanded(
                              flex: 5,
                              child: cardText(
                                  animalTabList[index].animalName,
                                  animalTabList[index].sizeM,
                                  animalTabList[index].sizeF,
                                  animalTabList[index].weightM,
                                  animalTabList[index].weightF,
                                  animalTabList[index].diet,
                                  animalTabList[index].gestation,
                                  context)),
                        ])),
                    ListTileTheme(
                        dense: false,
                        child: ViewButton(
                            name: animalTabList[index].classification)),
                  ]),
            );
          });
}
//========================== VIEW BODY =======================

//=============================VIEW BUTTON======================
// ignore: must_be_immutable
class ViewButton extends ViewModelWidget<AnimalViewModel> {
  String name;
  ViewButton({this.name, Key key}) : super(key: key, reactive: true);
  @override
  Widget build(BuildContext context, AnimalViewModel model) {
    return ButtonTheme(
      key: Key('ViewInfoButton'),
      minWidth: 280,
      child: RaisedButton(
          child: text14CenterBoldWhite("View Information"),
          color: Color.fromRGBO(61, 122, 172, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(10),
          onPressed: () {
            navigateToInfo(name);
          }),
    );
  }
}
//=============================VIEW BUTTON======================

//=============================IMAGE BLOCK======================
Widget imageBlock(String imageLink) {
  return Container(
    alignment: Alignment.center,
    margin: new EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(imageLink),
        //image: AssetImage(imageLink),
        fit: BoxFit.fill,
      ),
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    height: 100,
  );
}
//=============================IMAGE BLOCK======================

//=============================ANIMAL DETAILS===================
Widget cardText(String name, String sizeM, String sizeF, String weightM,
    String weightF, String diet, String gestation, context) {
  return Container(
      margin: EdgeInsets.all(0),
      alignment: Alignment.center,
      height: 110,
      child: Column(children: <Widget>[
        Expanded(
            flex: 1,
            child: Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                child: text18RightBoldBlack(name))),
        Expanded(
            flex: 1,
            child: Container(
                margin: EdgeInsets.only(bottom: 4),
                padding: EdgeInsets.all(0),
                child: middleRow(sizeM, sizeF, weightM, weightF, context))),
        Expanded(
            flex: 1,
            child: Container(
                margin: EdgeInsets.only(bottom: 2),
                padding: EdgeInsets.all(0),
                child: bottomRow(diet, gestation, context))),
      ]));
}

Widget middleRow(
    String sizeM, String sizeF, String weightM, String weightF, var context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Expanded(
        flex: 1,
        child: Container(
          margin: EdgeInsets.only(right: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    child: text12LeftNormBlack("Size:"),
                  )),
              Expanded(
                  flex: 4,
                  child: Container(
                    child: column2(sizeF, sizeM, context),
                  )),
            ],
          ),
        ),
      ),
      Expanded(
        flex: 1,
        child: Container(
          margin: EdgeInsets.only(right: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    child: text12LeftNormBlack("Weight:"),
                  )),
              Expanded(
                  flex: 4,
                  child: Container(
                    child: column(weightF, weightM, context),
                  )),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget column(String metricF, String metricM, var context) {
  return Row(
    children: <Widget>[
      Expanded(
        // flex: 1,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                child: text12RighttNormGrey('$metricF'),
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  child: Icon(
                    Icons.person_pin,
                    color: Colors.pink[200],
                    size: 13,
                  ),
                )),
          ],
        ),
      ),
      Expanded(
        //flex: 1,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                child: text12RighttNormGrey('$metricM'),
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  child: Icon(
                    Icons.person_pin,
                    color: Colors.blue,
                    size: 13,
                  ),
                )),
          ],
        ),
      )
    ],
  );
}

Widget column2(String metricF, String metricM, var context) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                child: text12RighttNormGrey('$metricF cm'),
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  child: Icon(
                    Icons.person_pin,
                    color: Colors.pink[200],
                    size: 14,
                  ),
                )),
          ],
        ),
      ),
      Expanded(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                child: text12RighttNormGrey('$metricM cm'),
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  child: Icon(
                    Icons.person_pin,
                    color: Colors.blue,
                    size: 14,
                  ),
                )),
          ],
        ),
      )
    ],
  );
}

Widget bottomRow(String diet, String gestation, var context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Expanded(
        flex: 3,
        child: Container(
          margin: EdgeInsets.only(right: 10),
          child: Row(
            children: <Widget>[
              Expanded(flex: 1, child: text12LeftNormBlack("Diet: ")),
              Expanded(
                flex: 2,
                child: text12RighttNormGrey(diet),
              ),
            ],
          ),
        ),
      ),
      Expanded(
        flex: 4,
        child: Container(
          margin: EdgeInsets.only(right: 10),
          child: Row(
            children: <Widget>[
              Expanded(flex: 1, child: text12LeftNormBlack("Gestation: ")),
              Expanded(
                flex: 1,
                child: text12RighttNormGrey(gestation),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
//=============================ANIMAL DETAILS===================

//=============================EXPANSION TILE===================
Widget description(String bodyText, var context) {
  return ExpansionTile(
    title: text14LeftBoldGrey("Description"),
    children: <Widget>[expansionTileBodyTemplate(text12LeftNormGrey(bodyText))],
  );
}

Widget behaviour(String bodyText, var context) {
  return ExpansionTile(
    title: text14LeftBoldGrey(
      "Behaviour",
    ),
    children: <Widget>[expansionTileBodyTemplate(text12LeftNormGrey(bodyText))],
  );
}

Widget habitats(String bodyText, var context) {
  return ExpansionTile(
    title: text14LeftBoldGrey("Habitats"),
    children: <Widget>[expansionTileBodyTemplate(text12LeftNormGrey(bodyText))],
  );
}
//=============================EXPANSION TILE===================

//================================== EXPANSION TILE TEMPLATES =============================
Widget expansionTileBodyTemplate(Widget body) {
  return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 17, bottom: 15),
      child: body);
}
//================================== EXPANSION TILE TEMPLATES =============================
