import 'package:ERP_RANGER/services/util.dart';
import 'package:ERP_RANGER/ui/views/upload/upload_viewmodel.dart';
import 'package:ERP_RANGER/ui/widgets/bottom_navigation/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                    Color.fromRGBO(33, 78, 125, 1),
                    Color.fromRGBO(80, 156, 208, 1)
                  ])),
            ),
            title: text22LeftBoldWhite(
              "ERP RANGER",
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            color: Colors.grey[300],
            child: SliverBody(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              captureImage();
            },
            child: Icon(
              Icons.camera_alt,
            ),
            backgroundColor: Color.fromRGBO(205, 21, 67, 1),
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
        color: Colors.white,
        width: 225,
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
                leading: Icon(Icons.account_circle),
                title: text16LeftBoldGrey("Profile"),
                dense: true,
                onTap: () => {navigateToProfile()}),
            ListTile(
                leading: model.newNotifications == false
                    ? Icon(Icons.verified_user)
                    : badge,
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
        )));
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
        color: Colors.grey,
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
                        Expanded(flex: 1, child: leftBlock),
                        Expanded(
                            flex: 5, child: text14LeftBoldGrey("From Gallery")),
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
                                  child: text14LeftBoldGrey("From Gallery"),
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
                            flex: 5, child: text14LeftBoldGrey("From Camera")),
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
                  Expanded(flex: 5, child: text14LeftBoldGrey("From Camera")),
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

class TagBox extends HookViewModelWidget<UploadViewModel> {
  TagBox({
    Key key,
  }) : super(reactive: true);
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget buildViewModelWidget(BuildContext context, UploadViewModel viewModel) {
    final TextEditingController _typeAheadController = TextEditingController();
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
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
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
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

class Latitude extends HookViewModelWidget<UploadViewModel> {
  Latitude({
    Key key,
  }) : super(reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, UploadViewModel viewModel) {
    var text = useTextEditingController();
    return TextField(
      key: Key('Latitude'),
      controller: text,
      onChanged: viewModel.updateLat,
      decoration: InputDecoration(
          hintText: "Enter latitude coordintates",
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
          errorText:
              viewModel.showLatError == false ? null : viewModel.latErrorString,
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
      style: TextStyle(
          fontFamily: 'MavenPro',
          fontWeight: FontWeight.normal,
          color: Colors.grey),
    );
  }
}

class Longitude extends HookViewModelWidget<UploadViewModel> {
  Longitude({
    Key key,
  }) : super(reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, UploadViewModel viewModel) {
    var text = useTextEditingController();
    return TextField(
      key: Key('Longitude'),
      controller: text,
      onChanged: viewModel.updateLong,
      onSubmitted: (value) => null,
      decoration: InputDecoration(
          hintText: "Enter longitude coordintates",
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
          errorText: viewModel.showLongError == false
              ? null
              : viewModel.longErrorString,
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
      style: TextStyle(
          fontFamily: 'MavenPro',
          fontWeight: FontWeight.normal,
          color: Colors.grey),
    );
  }
}

class SpoorLocationInput extends ViewModelWidget<UploadViewModel> {
  SpoorLocationInput({Key key}) : super(key: key, reactive: true);
  @override
  Widget build(BuildContext context, UploadViewModel model) {
    return Container(
      key: Key('SpoorLocationInput'),
      width: 100,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white)),
      child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 13, bottom: 10),
              child: containerTitle("Track Location")),
          SpoorLocation(),
        ],
      ),
    );
  }
}

class SpoorLocation extends ViewModelWidget<UploadViewModel> {
  SpoorLocation({
    Key key,
  }) : super(reactive: true);
  @override
  Widget build(BuildContext context, UploadViewModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: new EdgeInsets.only(left: 5),
            padding: new EdgeInsets.all(0),
            alignment: Alignment.centerLeft,
            child: text14LeftBoldGrey("Latitude: ")),
        Container(
            margin: new EdgeInsets.only(left: 0),
            padding: new EdgeInsets.all(5),
            alignment: Alignment.centerLeft,
            child: Latitude()),
        Container(
            margin: new EdgeInsets.only(left: 5),
            padding: new EdgeInsets.all(0),
            alignment: Alignment.centerLeft,
            child: text14LeftBoldGrey("Longitude: ")),
        Container(
            margin: new EdgeInsets.only(left: 0),
            padding: new EdgeInsets.all(5),
            alignment: Alignment.centerLeft,
            child: Longitude()),
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
          color: Color.fromRGBO(33, 78, 125, 1),
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
      child: text12LeftBoldGrey(title));
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
  padding: new EdgeInsets.all(5),
  decoration: BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color.fromRGBO(33, 78, 125, 1),
          Color.fromRGBO(80, 156, 208, 1)
        ]),
    borderRadius: BorderRadius.circular(10),
  ),
  height: 30,
  width: 30,
);
//================================== TEXT TEMPLATES =============================
