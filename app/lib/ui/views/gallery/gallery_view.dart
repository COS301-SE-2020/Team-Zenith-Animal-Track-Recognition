import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:ERP_RANGER/services/util.dart';
import 'package:ERP_RANGER/ui/views/gallery/gallery_viewmodel.dart';
import 'package:ERP_RANGER/ui/widgets/bottom_navigation/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

// ignore: must_be_immutable
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
                        Color.fromRGBO(58, 119, 168, 1),
                        Color.fromRGBO(77, 151, 203, 1)
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
                                  Color.fromRGBO(58, 119, 168, 1),
                                  Color.fromRGBO(77, 151, 203, 1)
                                ])),
                          ),
                          bottom: TabBar(
                            tabs: snapshot.data.tabs,
                            indicatorWeight: 3,
                          ),
                        ),
                        body: model.selected
                            ? GestureDetector(
                                onTap: () {
                                  model.selectedVal(!model.selected, null);
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      color: Colors.grey[100],
                                      child: TabBarView(
                                        children: getBodyWidgets(
                                            snapshot.data.length,
                                            galleryModel.galleryList),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin: new EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(model.image),
                                            fit: BoxFit.fill,
                                          ),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        height: 330,
                                        width: 330,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.all(10),
                                color: Colors.grey[100],
                                child: TabBarView(
                                  children: getBodyWidgets(snapshot.data.length,
                                      galleryModel.galleryList),
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
    if (data[i] == null || data[i].length == 0) {
      if (i == 0) {
        widget.add(Center(
          child: Container(
            key: Key('List'),
            padding: EdgeInsets.all(10),
            color: Colors.grey[100],
            child: text18CenterNormalGrey("[No Appearance Pictures Found]"),
          ),
        ));
      } else {
        widget.add(Center(
          child: Container(
            key: Key('List'),
            padding: EdgeInsets.all(10),
            color: Colors.grey[100],
            child: text18CenterNormalGrey("[No Tracks Found]"),
          ),
        ));
      }
    } else {
      widget.add(GridItem(
        animalTabList: data[i],
      ));
    }
  }
  return widget;
}

// ignore: must_be_immutable
class GridItem extends ViewModelWidget<GalleryViewModel> {
  var animalTabList;
  GridItem({this.animalTabList}) : super(reactive: true);
  @override
  Widget build(BuildContext context, GalleryViewModel model) {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(animalTabList.length, (index) {
        return GestureDetector(
          onTap: () {
            model.selectedVal(!model.selected, animalTabList[index]);
          },
          child: Container(
            alignment: Alignment.center,
            margin: new EdgeInsets.all(5),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(animalTabList[index]),
                fit: BoxFit.fill,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      }),
    );
  }
}

//========================== VIEW BODY =======================

//========================== APPBAR ICONS =======================
// ignore: must_be_immutable
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
  @override
  Widget build(BuildContext context, GalleryViewModel model) {
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
