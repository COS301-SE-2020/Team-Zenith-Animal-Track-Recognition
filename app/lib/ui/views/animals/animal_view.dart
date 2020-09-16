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
                                    Color.fromRGBO(33, 78, 125, 1),
                                    Color.fromRGBO(80, 156, 208, 1)
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
                            color: Colors.grey[300],
                            child: TabBarView(
                              children: getBodyWidgets(snapshot.data.length,
                                  snapshot.data.animalList),
                            ),
                          ),
                          bottomNavigationBar: BottomNavigation(),
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
      width: 250,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.grey,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/E1.jpg'))),
              child: null,
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
                leading: Icon(Icons.exit_to_app),
                dense: true,
                title: text16LeftBoldGrey("Logout"),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool("loggedIn", false);
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
List<Widget> getBodyWidgets(int len, var data) {
  List<Widget> widget = new List();
  for (int i = 0; i < len; i++) {
    widget.add(getWidget(data[i]));
  }
  return widget;
}

Widget getWidget(var animalTabList) {
  return ListView.builder(
      itemCount: animalTabList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          alignment: Alignment.centerLeft,
          margin: new EdgeInsets.all(10),
          padding: new EdgeInsets.all(0),
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
                    dense: true,
                    child: Row(children: [
                      Expanded(
                          flex: 2,
                          child: imageBlock(animalTabList[index].image)),
                      Expanded(
                          flex: 4,
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
                    dense: true,
                    child:
                        ViewButton(name: animalTabList[index].classification)),
              ]),
        );
      });
}
//========================== VIEW BODY =======================

//=============================VIEW BUTTON======================
class ViewButton extends ViewModelWidget<AnimalViewModel> {
  String name;
  ViewButton({this.name, Key key}) : super(key: key, reactive: true);
  @override
  Widget build(BuildContext context, AnimalViewModel model) {
    return ButtonTheme(
      key: Key('ViewInfoButton'),
      minWidth: 200,
      child: RaisedButton(
          child: text12CenterBoldWhite("VIEW INFO"),
          color: Color.fromRGBO(33, 78, 125, 1),
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
    margin: new EdgeInsets.only(bottom: 10, left: 15, right: 10, top: 10),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(imageLink),
        //image: AssetImage(imageLink),
        fit: BoxFit.fill,
      ),
      color: Colors.grey,
      borderRadius: BorderRadius.circular(15),
    ),
    height: 90,
    width: 80,
  );
}
//=============================IMAGE BLOCK======================

//=============================ANIMAL DETAILS===================
Widget cardText(String name, String sizeM, String sizeF, String weightM,
    String weightF, String diet, String gestation, context) {
  return Container(
      margin: EdgeInsets.all(0),
      alignment: Alignment.center,
      height: 105,
      width: 75,
      child: Column(children: <Widget>[
        Expanded(
            flex: 1,
            child: Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                child: text14RightBoldGrey(name))),
        Expanded(
            flex: 1,
            child: Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                child: middleRow(sizeM, sizeF, weightM, weightF, context))),
        Expanded(
            flex: 1,
            child: Container(
                margin: EdgeInsets.all(0),
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
                    child: text12LeftNormGrey("Size:"),
                  )),
              Expanded(
                  flex: 2,
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
                    child: text12LeftNormGrey("Weight:"),
                  )),
              Expanded(
                  flex: 3,
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
            Container(
              child: text12RighttNormGrey('$metricF kg'),
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
            Container(
              child: text12RighttNormGrey('$metricM kg'),
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
        //flex: 1,
        child: Row(
          children: <Widget>[
            Container(
              child: text12RighttNormGrey('$metricF m'),
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
        //flex: 1,
        child: Row(
          children: <Widget>[
            Container(
              child: text12RighttNormGrey('$metricM m'),
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
              Expanded(flex: 1, child: text12LeftNormGrey("Diet: ")),
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
              Expanded(flex: 1, child: text12LeftNormGrey("Gestation: ")),
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
