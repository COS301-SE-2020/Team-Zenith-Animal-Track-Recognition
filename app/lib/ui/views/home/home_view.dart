import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:ERP_RANGER/services/util.dart';
import 'package:ERP_RANGER/ui/views/home/home_viewmodel.dart';
import 'package:ERP_RANGER/ui/widgets/bottom_navigation/bottom_nav.dart';
import 'package:flutter/material.dart';
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
            if (snapshot.hasError) {
              return progressIndicator();
            }
            if (snapshot.hasData) {
              return snapshot.hasData
                  ? Scaffold(
                      drawer: NavDrawer(),
                      appBar: AppBar(
                        //automaticallyImplyLeading: true,
                        backgroundColor: Colors.black,
                        title: text18LeftBoldWhite(
                          "Recent Indentifications",
                        ),
                        actions: <Widget>[
                          IconBuilder(icon: Icons.search, type: "search"),
                          IconBuilder(icon: Icons.more_vert, type: "vert")
                        ],
                      ),
                      body: Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.grey[300],
                        child: ListBody(animalList: snapshot.data),
                      ),
                      bottomNavigationBar: BottomNavigation(),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          showOptions(context);
                        },
                        child: Icon(
                          Icons.camera_alt,
                        ),
                        backgroundColor: Colors.black,
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

class IconBuilder extends ViewModelWidget<HomeViewModel> {
  String type;
  IconData icon;
  IconBuilder({Key key, this.icon, this.type}) : super(reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
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

class ListBody extends ViewModelWidget<HomeViewModel> {
  List<HomeModel> animalList;
  ListBody({Key key, this.animalList}) : super(reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return ListView.builder(
        itemCount: animalList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              navigateToIdentification(animalList[index].id);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
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
                                    color: Colors.black,
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
                                //decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(10)),
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

class NavDrawer extends ViewModelWidget<HomeViewModel> {
  //List<HomeModel> animalList;
  NavDrawer({Key key}) : super(reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: text22LeftBoldWhite("Side Menu"),
            decoration: BoxDecoration(
                color: Colors.grey,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/springbok.jpg'))),
          ),
          ListTile(
              leading: Icon(Icons.verified_user),
              title: text16LeftBoldGrey("Profile"),
              onTap: () => {navigateToProfile()}),
          ListTile(
              leading: Icon(Icons.settings),
              title: text16LeftBoldGrey("Settings"),
              onTap: () => {}),
          ListTile(
              leading: Icon(Icons.edit),
              title: text16LeftBoldGrey("Preference"),
              onTap: () => {}),
          ListTile(
              leading: Icon(Icons.exit_to_app),
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
