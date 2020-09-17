import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:ERP_RANGER/services/util.dart';
import 'package:ERP_RANGER/ui/views/gallery/gallery_viewmodel.dart';
import 'package:ERP_RANGER/ui/widgets/bottom_navigation/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class GalleryView extends StatelessWidget {
  GalleryModel galleryModel;
  GalleryView(this.galleryModel);

  @override
  Widget build(BuildContext context) {
    BottomNavigation bottomNavigation = BottomNavigation();
    bottomNavigation.setIndex(1);
    return ViewModelBuilder<GalleryViewModel>.reactive(
      builder: (context, model, child) => FutureBuilder(
        future: model.getSpoor(context),
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
                                        borderRadius: BorderRadius.circular(6),
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
                title: text18LeftBoldWhite(
                  "ERP RANGER",
                ),
                actions: <Widget>[IconBuilder(icon: Icons.search)],
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
                        navigateBack(context);
                      }
                      return;
                    },
                    child: DefaultTabController(
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
                          backgroundColor: Colors.black,
                          title: appBarTitle(galleryModel.name, context),
                          actions: <Widget>[IconBuilder(icon: Icons.search)],
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
                            tabs: snapshot.data.tabs,
                            indicatorWeight: 3,
                          ),
                        ),
                        body: Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.grey[300],
                          child: TabBarView(
                            children: getBodyWidgets(
                                snapshot.data.length, galleryModel.galleryList),
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
        },
      ),
      viewModelBuilder: () => GalleryViewModel(),
    );
  }
}

//========================== VIEW BODY =======================
List<Widget> getBodyWidgets(int len, var data) {
  List<Widget> widget = new List();
  for (int i = 0; i < len; i++) {
    widget.add(getWidget(data[i]));
  }
  return widget;
}

Widget getWidget(var animalTabList) {
  return GridView.count(
    crossAxisCount: 2,
    children: List.generate(animalTabList.length, (index) {
      return Container(
        alignment: Alignment.center,
        margin: new EdgeInsets.all(5),
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
  IconData icon;
  IconBuilder({Key key, this.icon}) : super(reactive: true);

  @override
  Widget build(BuildContext context, GalleryViewModel model) {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
      child: IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(icon, color: Colors.white),
          onPressed: () {
            navigateToSearchView();
          }),
    );
  }
}

//========================== APPBAR ICONS =======================
class NavDrawer extends ViewModelWidget<GalleryViewModel> {
  NavDrawer({Key key}) : super(reactive: true);

  @override
  Widget build(BuildContext context, GalleryViewModel model) {
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
                onTap: () => {navigateToHomeView(context)}),
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
