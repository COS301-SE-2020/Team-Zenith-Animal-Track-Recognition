import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:ERP_RANGER/services/util.dart';
import 'package:ERP_RANGER/ui/views/profile/profile_viewmodel.dart';
import 'package:ERP_RANGER/ui/widgets/bottom_navigation/bottom_nav.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      builder: (context, model, child) => FutureBuilder(
          future: model.getRecentIdentifications(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              int userLevel = model.userlevel;
              BottomNavigation bottomNavigation = BottomNavigation();
              if (userLevel == 1) {
                bottomNavigation.setIndex(2);
              } else {
                bottomNavigation.setIndex(3);
              }
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
                bottomNavigationBar: BottomNavigation(),
              );
            }
            if (snapshot.hasData) {
              int userLevel = snapshot.data.userLevel;
              BottomNavigation bottomNavigation = BottomNavigation();
              if (userLevel == 1) {
                bottomNavigation.setIndex(2);
              } else {
                bottomNavigation.setIndex(3);
              }
              return snapshot.hasData
                  ? WillPopScope(
                      onWillPop: () async {
                        if (Navigator.canPop(context)) {
                          navigateToHomeView(context);
                        }
                        return;
                      },
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
                        ),
                        body: snapshot.data.animalList == null
                            ? Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    profileinfo(snapshot.data.infoModel),
                                    Center(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                4),
                                        color: Colors.white,
                                        child: text18CenterNormalGrey(
                                            "[No Identifications Found]"),
                                      ),
                                    )
                                  ],
                                ))
                            : Container(
                                color: Colors.grey[100],
                                child: ProfileViewList(
                                  tempObject: snapshot.data,
                                )),
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
                    )
                  : progressIndicator();
            } else {
              return progressIndicator();
            }
          }),
      viewModelBuilder: () => ProfileViewModel(),
    );
  }
}

// ignore: must_be_immutable
class IconButtons extends ViewModelWidget<ProfileViewModel> {
  IconData iconData;
  String subTitle;
  int index;
  IconButtons({Key key, this.iconData, this.subTitle, this.index})
      : super(key: key, reactive: true);

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
              icon: Icon(
                iconData,
                size: 20,
              ),
              onPressed: () {},
            ),
          ),
          text12CenterBoldBlack(subTitle)
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class IconBuilder extends ViewModelWidget<ProfileViewModel> {
  String type;
  IconData icon;
  IconBuilder({Key key, this.icon, this.type}) : super(reactive: true);

  @override
  Widget build(BuildContext context, ProfileViewModel model) {
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
// ignore: must_be_immutable
class ProfileViewList extends ViewModelWidget<ProfileViewModel> {
  TempObject tempObject;
  List<ProfileModel> animalList;
  ProfileViewList({Key key, this.tempObject}) : super(reactive: true);
  @override
  Widget build(BuildContext context, ProfileViewModel viewModel) {
    animalList = tempObject.animalList;

    return CustomScrollView(
      key: Key('ProfileList'),
      slivers: <Widget>[
        SliverPersistentHeader(
          pinned: true,
          floating: false,
          delegate: ProfileViewDelegate(
              minExtent: 120, maxExtent: 120, tempObject: tempObject),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return GestureDetector(
            onTap: () {
              navigateToIdentification(animalList[index].id);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 0,
              margin:
                  new EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
              child: Container(
                //margin: new EdgeInsets.all(10),
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
                                          Color.fromRGBO(58, 119, 168, 1),
                                          Color.fromRGBO(77, 151, 203, 1)
                                        ]),
                                    borderRadius: BorderRadius.circular(10)),
                                child:
                                    text12LeftBoldWhite(animalList[index].tag),
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
        }, childCount: animalList.length))
      ],
    );
  }
}

class ProfileViewDelegate implements SliverPersistentHeaderDelegate {
  final double maxExtent;
  final double minExtent;
  final TempObject tempObject;
  ProfileViewDelegate(
      {@required this.minExtent,
      @required this.maxExtent,
      @required this.tempObject});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(child: profileinfo(tempObject.infoModel));
  }

  @override
  // ignore: override_on_non_overriding_member
  Future<bool> shouldRed(BuildContext context, legate) async {
    return true;
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  @override
  // ignore: todo
  // TODO: implement snapConfiguration
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  // ignore: todo
  // TODO: implement stretchConfiguration
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;
}

class NavDrawer extends ViewModelWidget<ProfileViewModel> {
  //List<HomeModel> animalList;
  NavDrawer({Key key}) : super(reactive: true);

  @override
  Widget build(BuildContext context, ProfileViewModel model) {
    return Container(
      width: 180,
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
                onTap: () => {
                      Fluttertoast.showToast(
                          msg: "Already on profile page",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.grey[200],
                          textColor: Colors.black,
                          fontSize: 16.0)
                    }),
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

Widget profileinfo(ProfileInfoModel profileInfo) {
  String pic = profileInfo.picture;
  return Container(
    key: Key('profileinfo'),
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: new EdgeInsets.all(0),
          //color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(flex: 1, child: profilepic(pic)),
              Expanded(flex: 3, child: profiletext(profileInfo))
            ],
          ),
        ),
        Container(
            padding: new EdgeInsets.all(0),
            color: Colors.white,
            child: summary(profileInfo)), //ListBody(animalList: animalList,)
      ],
    ),
  );
}

Widget profiletext(ProfileInfoModel profileInfo) {
  String name = profileInfo.name;
  String mail = profileInfo.email;
  String numb = profileInfo.number;
  return Container(
    color: Colors.white,
    alignment: Alignment.center,
    margin: new EdgeInsets.only(bottom: 5, right: 10, top: 5),
    height: 70,
    child: Column(children: <Widget>[
      Expanded(
          flex: 1,
          child: Container(
              alignment: Alignment.centerLeft,
              child: text20LeftBoldBlack("$name"))),
      Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.email,
                        size: 15,
                        color: Colors.black,
                      ))),
              Expanded(
                  flex: 10,
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: text14LeftNormGrey("$mail"))),
            ],
          )),
      Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.phone, size: 15, color: Colors.black))),
              Expanded(
                  flex: 10,
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: text14LeftNormGrey("$numb"))),
            ],
          )),
    ]),
  );
}

Widget summary(ProfileInfoModel profileInfo) {
  String spoorIdentified = profileInfo.spoorIdentified;
  String animalsTracked = profileInfo.animalsTracked;
  String speciesTracked = profileInfo.speciesTracked;
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
              Expanded(
                  flex: 1,
                  child: Container(
                    margin: new EdgeInsets.all(0),
                    color: Colors.white,
                    height: 30,
                    width: 30,
                    child: Column(children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                              alignment: Alignment.bottomRight,
                              child: text12LeftNormGrey("Tracks"))),
                      Expanded(
                          flex: 1,
                          child: Container(
                              alignment: Alignment.topRight,
                              child: text12LeftNormGrey("Identified")))
                    ]),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.white,
                    height: 30,
                    width: 30,
                    child:
                        Center(child: text20LeftBoldBlack("$spoorIdentified")),
                  )),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    margin: new EdgeInsets.all(0),
                    color: Colors.white,
                    height: 30,
                    width: 30,
                    child: Column(children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                              alignment: Alignment.bottomRight,
                              child: text12LeftNormGrey("Animals"))),
                      Expanded(
                          flex: 1,
                          child: Container(
                              alignment: Alignment.topRight,
                              child: text12LeftNormGrey("Tracked")))
                    ]),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.white,
                      height: 30,
                      width: 30,
                      child: Center(
                          child: text20LeftBoldBlack("$animalsTracked")))),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    margin: new EdgeInsets.all(0),
                    color: Colors.white,
                    height: 30,
                    width: 30,
                    child: Column(children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                              alignment: Alignment.bottomRight,
                              child: text12LeftNormGrey("Access"))),
                      Expanded(
                          flex: 1,
                          child: Container(
                              alignment: Alignment.topRight,
                              child: text12LeftNormGrey("Level")))
                    ]),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.white,
                      height: 30,
                      width: 30,
                      child: Center(
                          child: text20LeftBoldBlack("$speciesTracked")))),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget profilepic(String profilePicture) {
  return profilePicture == "N/A"
      ? Container(
          alignment: Alignment.center,
          margin: new EdgeInsets.only(bottom: 5, right: 10, top: 5, left: 5),
          padding: new EdgeInsets.all(5),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/circle.png"),
              fit: BoxFit.fill,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
          ),
          height: 70,
        )
      : Container(
          alignment: Alignment.center,
          margin: new EdgeInsets.only(bottom: 5, right: 10, top: 5, left: 5),
          padding: new EdgeInsets.all(5),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(profilePicture),
              fit: BoxFit.fill,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
          ),
          height: 70,
        );
}
