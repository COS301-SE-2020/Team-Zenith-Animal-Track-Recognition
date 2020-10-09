import 'package:ERP_RANGER/services/util.dart';
import 'package:ERP_RANGER/ui/views/upload/upload_viewmodel.dart';
import 'package:ERP_RANGER/ui/widgets/bottom_navigation/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_icons/flutter_icons.dart';

class UploadView extends StatelessWidget {
  const UploadView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BottomNavigation bottomNavigation = BottomNavigation();
    bottomNavigation.setIndex(2);

    return ViewModelBuilder<UploadViewModel>.reactive(
      onModelReady: (model) => model.notify(),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          if (Navigator.canPop(context)) {
            navigate(context);
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
            title: text22LeftBoldWhite(
              "ERP RANGER",
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            color: Colors.grey[100],
            child: SliverBody(),
          ),
          bottomNavigationBar: BottomNavigation(),
          backgroundColor: Colors.grey,
        ),
      ),
      viewModelBuilder: () => UploadViewModel(),
    );
  }
}

class SliverBody extends ViewModelWidget<UploadViewModel> {
  SliverBody({Key key}) : super(reactive: true);

  @override
  Widget build(BuildContext context, UploadViewModel model) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            header,
            spoorImageBlock,
            attachAnimal,
            attachATag,
            UploadButton()
          ]),
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class IconBuilder extends ViewModelWidget<UploadViewModel> {
  String type;
  IconData icon;
  IconBuilder({Key key, this.icon, this.type}) : super(reactive: true);

  @override
  Widget build(BuildContext context, UploadViewModel model) {
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

class NavDrawer extends ViewModelWidget<UploadViewModel> {
  //List<HomeModel> animalList;
  NavDrawer({Key key}) : super(reactive: true);

  @override
  Widget build(BuildContext context, UploadViewModel model) {
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

class LeftImage extends ViewModelWidget<UploadViewModel> {
  LeftImage({
    Key key,
  }) : super(reactive: true);
  @override
  Widget build(BuildContext context, UploadViewModel model) {
    return Container(
      alignment: Alignment.center,
      margin: new EdgeInsets.only(right: 5, left: 5),
      padding: new EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: MemoryImage(model.image.readAsBytesSync()),
          fit: BoxFit.fill,
        ),
      ),
      height: 30,
      width: 30,
    );
  }
}

class GalleryButton extends ViewModelWidget<UploadViewModel> {
  GalleryButton({
    Key key,
  }) : super(reactive: true);
  @override
  Widget build(BuildContext context, UploadViewModel model) {
    return model.valueGallery == false
        ? GestureDetector(
            child: model.showGalleryError == false
                ? Container(
                    margin: new EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(flex: 1, child: leftBlock2),
                        Expanded(
                            flex: 5, child: text14LeftNormGrey("From Gallery")),
                        Expanded(flex: 1, child: rightIcon),
                      ],
                    ),
                  )
                : Container(
                    margin: new EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(flex: 1, child: leftBlock),
                        Expanded(
                            flex: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: text14LeftNormGrey("From Gallery"),
                                ),
                                Expanded(
                                    child: Text(
                                  "Either Gallery or Camera must contain an image",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.red,
                                    fontFamily: 'MavenPro',
                                  ),
                                )),
                              ],
                            )),
                        Expanded(flex: 1, child: rightIcon),
                      ],
                    ),
                  ),
            onTap: () async {
              model.uploadFromGallery();
            },
          )
        : GestureDetector(
            child: Container(
              margin: new EdgeInsets.only(bottom: 10),
              child: Row(
                children: <Widget>[
                  Expanded(flex: 1, child: LeftImage()),
                  Expanded(flex: 5, child: text14LeftBoldGrey("From Gallery")),
                  Expanded(flex: 1, child: rightIcon),
                ],
              ),
            ),
            onTap: () {
              model.uploadFromGallery();
            },
          );
  }
}

// ignore: must_be_immutable
class CameraButton extends ViewModelWidget<UploadViewModel> {
  String caption;
  CameraButton({Key key, this.caption}) : super(reactive: true);
  bool changed = false;
  @override
  Widget build(BuildContext context, UploadViewModel model) {
    return model.valueCamera == false
        ? GestureDetector(
            child: model.showCameraError == false
                ? Container(
                    margin: new EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(flex: 1, child: leftBlock),
                        Expanded(
                            flex: 5, child: text14LeftNormGrey("From Camera")),
                        Expanded(flex: 1, child: rightIcon),
                      ],
                    ),
                  )
                : Container(
                    margin: new EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(flex: 1, child: leftBlock),
                        Expanded(
                            flex: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: text14LeftBoldGrey("From Canera"),
                                ),
                                Expanded(
                                    child: Text(
                                  "Either Camera or Gallery must contain an image",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.red,
                                    fontFamily: 'MavenPro',
                                  ),
                                )),
                              ],
                            )),
                        Expanded(flex: 1, child: rightIcon),
                      ],
                    ),
                  ),
            onTap: () async {
              model.uploadFromCamera();
            },
          )
        : GestureDetector(
            child: Container(
              margin: new EdgeInsets.only(bottom: 10),
              child: Row(
                children: <Widget>[
                  Expanded(flex: 1, child: LeftImage()),
                  Expanded(flex: 5, child: text14LeftNormGrey("From Camera")),
                  Expanded(flex: 1, child: rightIcon),
                ],
              ),
            ),
            onTap: () {
              model.uploadFromCamera();
            },
          );
  }
}

// ignore: must_be_immutable
class TagBox extends HookViewModelWidget<UploadViewModel> {
  TagBox({
    Key key,
  }) : super(reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, UploadViewModel viewModel) {
    final TextEditingController _typeAheadController = TextEditingController();
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(flex: 1, child: Icon(AntDesign.tag)),
        Expanded(
          flex: 8,
          child: TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
                controller: _typeAheadController,
                decoration: InputDecoration(
                    hintText: "Enter animal tag",
                    hintStyle: TextStyle(
                        fontFamily: 'MavenPro',
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    errorText: viewModel.showTagError == false
                        ? null
                        : viewModel.tagErrorString,
                    errorStyle: TextStyle(
                        fontFamily: 'MavenPro',
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.red),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        gapPadding: 0),
                    filled: true,
                    fillColor: Colors.grey[100]),
                onChanged: (value) => viewModel.tag = value,
                onSubmitted: (value) => null),
            suggestionsCallback: (pattern) {
              return viewModel.getTagSuggestions(pattern);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (suggestion) {
              _typeAheadController.text = suggestion;
              viewModel.setTag(suggestion);
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a tag';
              } else {
                return value;
              }
            },
            onSaved: (value) => viewModel.setTag(value),
          ),
        ),
      ],
    );
  }
}

class AnimalBox extends HookViewModelWidget<UploadViewModel> {
  AnimalBox({
    Key key,
  }) : super(reactive: true);
  @override
  Widget buildViewModelWidget(BuildContext context, UploadViewModel viewModel) {
    final TextEditingController _typeAheadController = TextEditingController();
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(flex: 1, child: Icon(Zocial.evernote)),
        Expanded(
          flex: 8,
          child: TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
                controller: _typeAheadController,
                decoration: InputDecoration(
                    hintText: "Enter animal name",
                    hintStyle: TextStyle(
                        fontFamily: 'MavenPro',
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    errorText: viewModel.showAnimalError == false
                        ? null
                        : viewModel.animalErrorString,
                    errorStyle: TextStyle(
                        fontFamily: 'MavenPro',
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.red),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        gapPadding: 0),
                    filled: true,
                    fillColor: Colors.grey[100]),
                onChanged: (value) => viewModel.chosenAnimal = value,
                onSubmitted: (value) => null),
            suggestionsCallback: (pattern) {
              return viewModel.getSuggestions(pattern);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (suggestion) {
              _typeAheadController.text = suggestion;
              viewModel.setChosenAnimal(suggestion);
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please select an animal';
              } else {
                return value;
              }
            },
          ),
        ),
      ],
    );
  }
}

class UploadButton extends ViewModelWidget<UploadViewModel> {
  UploadButton({Key key}) : super(reactive: true);

  @override
  Widget build(BuildContext context, UploadViewModel model) {
    return Container(
      margin: EdgeInsets.only(
        right: 15,
        left: 15,
        top: 5,
        bottom: 5,
      ),
      width: 80,
      child: RaisedButton(
          child: text16CenterBoldWhite("UPLOAD TRACK"),
          color: Color.fromRGBO(61, 122, 172, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(10),
          onPressed: () {
            model.upload();
          }),
    );
  }
}

//================================== TEXT TEMPLATES =============================
Widget header = new Container(
  alignment: Alignment.center,
  padding: EdgeInsets.all(5),
  margin: EdgeInsets.all(15),
  child: text18CenterBoldGrey("Please enter in Track Information below"),
);

Widget containerTitle(String title) {
  return Container(
      margin: EdgeInsets.only(left: 7),
      alignment: Alignment.centerLeft,
      child: text12LeftBoldBlack(title));
}

Widget attachAnimal = new Container(
  key: Key('attachAnimal'),
  height: 115,
  width: 100,
  padding: EdgeInsets.all(5),
  margin: EdgeInsets.all(15),
  decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.white)),
  child: Column(
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      Expanded(flex: 1, child: attachAnimalButton),
      Expanded(flex: 1, child: AnimalBox()),
    ],
  ),
);

Widget attachAnimalButton = new Container(
  child: Row(
    children: <Widget>[
      Expanded(flex: 1, child: containerTitle("Animal Name")),
    ],
  ),
);

Widget attachATagButton = new Container(
  child: Row(
    children: <Widget>[
      Expanded(flex: 1, child: containerTitle("Tag")),
    ],
  ),
);

Widget attachATag = new Container(
  key: Key('attachATag'),
  height: 115,
  width: 100,
  padding: EdgeInsets.all(5),
  margin: EdgeInsets.all(15),
  decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.white)),
  child: Column(
    children: <Widget>[
      Expanded(flex: 1, child: attachATagButton),
      Expanded(flex: 1, child: TagBox()),
    ],
  ),
);

Widget spoorImageBlock = new Container(
  height: 150,
  width: 100,
  padding: EdgeInsets.all(5),
  margin: EdgeInsets.all(15),
  decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.white)),
  child: Column(
    children: <Widget>[
      Expanded(flex: 1, child: containerTitle("Track Image")),
      Expanded(flex: 1, child: CameraButton()),
      Expanded(flex: 1, child: GalleryButton()),
    ],
  ),
);

Widget rightIcon = new Container(
  margin: new EdgeInsets.only(
    right: 5,
    left: 5,
  ),
  height: 30,
  child: Icon(Icons.arrow_right),
);

Widget leftBlock = new Container(
  alignment: Alignment.center,
  margin: new EdgeInsets.only(right: 5, left: 5),
  // height: 20,
  // width: 10,
  child: Icon(Icons.add_a_photo),
);

Widget leftBlock2 = new Container(
  alignment: Alignment.center,
  margin: new EdgeInsets.only(right: 5, left: 5),
  child: Icon(MaterialIcons.photo_library),
);
//================================== TEXT TEMPLATES =============================
