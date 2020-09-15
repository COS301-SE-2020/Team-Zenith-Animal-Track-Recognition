import 'package:ERP_RANGER/services/util.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:ERP_RANGER/ui/views/userconfirmed/user_confirmed_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'dart:io';

// ignore: must_be_immutable
class UserConfirmedView extends StatelessWidget {
  ConfirmModel confirmedAnimal;
  File image;
  List<String> tags;
  UserConfirmedView({this.confirmedAnimal, this.image, this.tags});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserConfirmedViewModel>.reactive(
      builder: (context, model, child) => FutureBuilder(
        future: model.getConfirm(this.tags),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: text18LeftBoldWhite(
                  "User Confirmation",
                ),
              ),
              body: internetError(snapshot.error.toString()),
            );
          }
          if (snapshot.hasData) {
            if (model.loaded == false) {
              model.setConfidentAnimal(confirmedAnimal);
              model.setLoaded(true);
            }
            return WillPopScope(
              onWillPop: () async {
                if (Navigator.canPop(context)) {
                  navigate(context);
                }
                return;
              },
              child: Scaffold(
                body: Stack(
                  children: <Widget>[
                    imageBlock(image),
                    BackButton(),
                    Scroll(finalObject: snapshot.data)
                  ],
                ),
              ),
            );
          } else {
            return progressIndicator();
          }
        },
      ),
      viewModelBuilder: () => UserConfirmedViewModel(),
    );
  }
}

Widget imageBlock(File imageLink) {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: MemoryImage(imageLink.readAsBytesSync()),
        fit: BoxFit.cover,
      ),
    ),
  );
}

class BackButton extends ViewModelWidget<UserConfirmedViewModel> {
  BackButton({Key key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, UserConfirmedViewModel model) {
    return Container(
        padding: new EdgeInsets.all(0.0),
        height: 50,
        width: 50,
        alignment: Alignment(0.0, 0.0),
        margin: new EdgeInsets.only(
          top: 10,
          left: 10,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: Colors.white)),
        child: GestureDetector(
          onTap: () {
            navigateBack(context);
          },
          child: Center(
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
        ));
  }
}

class Scroll extends ViewModelWidget<UserConfirmedViewModel> {
  FinalObject finalObject;
  ConfirmModel confidentAnimal;
  Scroll({Key key, this.finalObject}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, UserConfirmedViewModel model) {
    confidentAnimal = model.confidentAnimal;

    return DraggableScrollableSheet(
        initialChildSize: 0.12,
        minChildSize: 0.12,
        maxChildSize: 0.99,
        builder: (BuildContext context, ScrollController myscrollController) {
          return Container(
            padding: new EdgeInsets.all(0.0),
            margin: new EdgeInsets.all(0.0),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ListView(
              padding: new EdgeInsets.only(top: 10.0),
              controller: myscrollController,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(flex: 1, child: LeadingIcon()),
                    SizedBox(
                      height: 1.0,
                    ),
                    Expanded(
                        flex: 4,
                        child: textDisplay(
                            model.confidentAnimal.animalName, context)),
                    SizedBox(
                      height: 1.0,
                    ),
                    Expanded(
                        flex: 1,
                        child: blocks(model.confidentAnimal.accuracyScore)),
                  ],
                ),
                Divider(),
                Column(
                  children: <Widget>[
                    identifyText(context),
                    SpoorIdentification(),
                  ],
                ),
                Divider(),
                Column(
                  children: <Widget>[
                    tagText(context),
                    Tags(tags: finalObject.tags)
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: IconButtons(
                            iconData: Icons.check,
                            subTitle: "CONFIRM SPOOR",
                            index: 0)),
                    Expanded(
                        flex: 1,
                        child: IconButtons(
                          iconData: Icons.autorenew,
                          subTitle: "CLASSIFY TRACK",
                          index: 0,
                        )),
                    Expanded(
                        flex: 1,
                        child: IconButtons(
                            iconData: Icons.camera_alt,
                            subTitle: "RECAPTURE TRACK",
                            index: 1)),
                    Expanded(
                        flex: 1,
                        child: IconButtons(
                            iconData: Icons.share,
                            subTitle: "SHARE IMAGE",
                            index: 2)),
                  ],
                )
              ],
            ),
          );
        });
  }
}

class SpoorIdentification extends ViewModelWidget<UserConfirmedViewModel> {
  SpoorIdentification({Key key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, UserConfirmedViewModel model) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1, child: confidentImageBlock(model.confidentAnimal.image)),
          Expanded(
              flex: 1,
              child: confidentImageDetails(
                  model.confidentAnimal.type,
                  model.confidentAnimal.animalName,
                  model.confidentAnimal.species,
                  model.confidentAnimal.accuracyScore,
                  context))
        ],
      ),
    );
  }
}

class IconButtons extends ViewModelWidget<UserConfirmedViewModel> {
  IconData iconData;
  String subTitle;
  int index;
  IconButtons({Key key, this.iconData, this.subTitle, this.index})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, UserConfirmedViewModel model) {
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: Icon(iconData),
              onPressed: () {
                if (index == 0) {
                  model.confirm(context);
                } else if (index == 1) {
                } else if (index == 2) {
                  recapture(context);
                } else if (index == 3) {}
              },
            ),
          ),
          text12LeftNormGrey(subTitle)
        ],
      ),
    );
  }
}

//================================== TEXT TEMPLATES =============================
class LeadingIcon extends ViewModelWidget<UserConfirmedViewModel> {
  LeadingIcon({
    Key key,
  }) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, UserConfirmedViewModel model) {
    return Container(
        alignment: Alignment(0.0, 0.0),
        margin: new EdgeInsets.only(bottom: 3, left: 3, right: 3),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white)),
        child: Center(
          child: IconButton(
            alignment: Alignment(0.0, 0.0),
            icon: Icon(Icons.keyboard_arrow_up, color: Colors.black),
            onPressed: () {},
          ),
        ));
  }
}

Widget confidentImageBlock(String image) {
  return Container(
    alignment: Alignment.center,
    margin: new EdgeInsets.only(bottom: 10, left: 15, right: 10, top: 10),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(image),
        fit: BoxFit.fill,
      ),
      color: Colors.grey,
      borderRadius: BorderRadius.circular(15),
    ),
    height: 130,
    width: 130,
  );
}

Widget confidentImageDetails(
    String type, String name, String species, double score, var context) {
  return Container(
    alignment: Alignment.center,
    margin: new EdgeInsets.all(10),
    padding: new EdgeInsets.only(left: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    height: 130,
    child: Column(children: <Widget>[
      Expanded(
          flex: 1,
          child: Row(children: <Widget>[
            Expanded(
                flex: 1,
                child: text12LeftNormBlack(
                  "Type: ",
                )),
            Expanded(flex: 1, child: text12RighttNormGrey(type))
          ])),
      Expanded(
          flex: 1,
          child: Row(children: <Widget>[
            Expanded(flex: 1, child: text12LeftNormBlack("Animal: ")),
            Expanded(flex: 1, child: text12RighttNormGrey(name))
          ])),
      Expanded(
          flex: 1,
          child: Row(children: <Widget>[
            Expanded(flex: 1, child: text12LeftNormBlack("Species: ")),
            Expanded(flex: 1, child: text12RighttNormGrey(species))
          ])),
      Expanded(
          flex: 1,
          child: Container(
              alignment: Alignment.centerLeft,
              child: text12LeftNormBlack("Ranger Identified Track"))),
    ]),
  );
}

Widget otherMatches(var context) {
  return Container(
    alignment: Alignment.centerLeft,
    margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
    padding: new EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    //height: 0,
    child: text18LeftBoldBlack("Other Possible Matches"),
  );
}

Widget tagText(var context) {
  return Container(
    alignment: Alignment.centerLeft,
    margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
    padding: new EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    //height: 0,
    child: text18LeftBoldBlack("Tags"),
  );
}

Widget innerImageBlock(String link) {
  return new Container(
    alignment: Alignment.center,
    margin: new EdgeInsets.all(5),
    padding: new EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(10),
      image: DecorationImage(
        image: NetworkImage(link),
        fit: BoxFit.fill,
      ),
    ),
    height: 115,
    // width: 75,
  );
}

Widget blocks(double percentage) {
  return Container(
      alignment: Alignment(0.0, 0.0),
      margin: new EdgeInsets.only(bottom: 3, left: 3, right: 3),
      padding: new EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 10,
      height: 50,
      child: Column(
        children: <Widget>[
          Expanded(flex: 2, child: percentageText("UD", 30)),
          Expanded(flex: 1, child: percentageText("TRACK", 15)),
        ],
      ));
}

Widget textDisplay(String name, var context) {
  return Container(
      alignment: Alignment(0.0, 0.0),
      margin: new EdgeInsets.only(bottom: 3, left: 3, right: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: text18LeftBoldBlack(name))),
          Expanded(
              flex: 1,
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: text14LeftBoldGrey("Swipe up for more options")))
        ],
      ));
}

Widget identifyText(var context) {
  return Container(
    alignment: Alignment.centerLeft,
    margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
    padding: new EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: text18LeftBoldBlack("Spoor Identification Results"),
  );
}

// ignore: must_be_immutable
class Tags extends ViewModelWidget<UserConfirmedViewModel> {
  List<String> tags;

  Tags({Key key, this.tags}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, UserConfirmedViewModel model) {
    int defualtChoiceIndex = model.tagIndex;
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: List<Widget>.generate(tags.length, (index) {
        return ChoiceChip(
          avatar: CircleAvatar(
              backgroundColor: Colors.grey.shade600,
              child: text12LeftNormBlack(tags[index][0].toUpperCase())),
          label: text12LeftNormBlack(tags[index]),
          backgroundColor: Colors.grey[100],
          selected: defualtChoiceIndex == index,
          selectedColor: Colors.grey.shade600,
          onSelected: (bool selected) {
            defualtChoiceIndex = selected ? index : null;
            if (defualtChoiceIndex == null) {
              model.setTag(null);
              model.setTagIndex(null);
            } else {
              model.setTag(tags[index]);
              model.setTagIndex(index);
            }
            model.notifyListeners();
          },
        );
      }),
    );
  }
}
