import 'dart:async';

import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:ERP_RANGER/services/util.dart';
import 'package:ERP_RANGER/ui/views/animals/animal_view.dart';
import 'package:ERP_RANGER/ui/views/identification/identification_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class IdentificationView extends StatelessWidget {
  IdentificationView({@required this.name});
  String name;
  CameraPosition _myLocation = CameraPosition(
    target: LatLng(-25.882171, 28.264653),
    zoom: 15,
  );

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<IdentificationViewModel>.reactive(
      builder: (context, model, child) => FutureBuilder(
          future: model.getResults(name),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return progressIndicator();
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
                      child: Scaffold(
                        body: Stack(
                          children: <Widget>[
                            Container(
                              child: GoogleMap(
                                initialCameraPosition: _myLocation,
                                mapType: MapType.normal,
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                              ),
                            ),
                            backButton(context),
                            SpoorListBody(),
                          ],
                        ),
                      ),
                    )
                  : progressIndicator();
            } else {
              return progressIndicator();
            }
          }),
      viewModelBuilder: () => IdentificationViewModel(),
    );
  }
}

class SpoorListBody extends ViewModelWidget<IdentificationViewModel> {
  SpoorListBody({
    Key key,
  }) : super(reactive: true);

  @override
  Widget build(BuildContext context, IdentificationViewModel model) {
    return DraggableScrollableSheet(
      initialChildSize: 0.10,
      minChildSize: 0.10,
      maxChildSize: 0.99,
      builder: (BuildContext context, ScrollController myscrollController) {
        return Container(
          padding: new EdgeInsets.all(0.0),
          margin: new EdgeInsets.all(0.0),
          decoration: BoxDecoration(color: Colors.white),
          child: ListView(
            padding: new EdgeInsets.only(top: 0.0),
            controller: myscrollController,
            children: <Widget>[
              Container(
                  color: Colors.grey[850],
                  child: Row(
                    children: <Widget>[
                      Expanded(flex: 1, child: icon),
                      SizedBox(height: 1.0),
                      Expanded(
                          flex: 4, child: text(model.confident.name, context)),
                    ],
                  )),
              SizedBox(height: 10),
              BarInfo(),
              Divider(thickness: 2),
              Column(
                children: <Widget>[
                  identifyText(context),
                  Row(children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: confidentImageBlock(model.confident.pic)),
                    Expanded(flex: 1, child: ConfidentAnimalIdentiication()),
                  ])
                ],
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child:
                              OtherMatches(list: model.recentIdentifications))
                    ],
                  )
                ],
              ),
              Column(children: <Widget>[
                similarSpoors(context),
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1, child: similarSpoor(model.similarSpoorModel))
                  ],
                )
              ]),
              Divider(thickness: 2),
              Column(
                children: <Widget>[
                  attachATag(context),
                ],
              ),
              Divider(thickness: 2),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: <Widget>[
                    // Expanded(flex: 1, child: EditSpoorFunctionality(title:"Edit Spoor",)),
                    // SizedBox(height: 1.0),
                    Expanded(
                        flex: 1,
                        child: ViewInfoFunctionality(
                          title: "View Animal Info",
                        )),
                    SizedBox(height: 1.0),
                    Expanded(
                        flex: 1,
                        child: DownloadFunctionality(
                          title: "Download Image",
                        )),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class OtherMatches extends ViewModelWidget<IdentificationViewModel> {
  List<SpoorModel> list;
  OtherMatches({this.list});

  @override
  Widget build(BuildContext context, IdentificationViewModel model) {
    return ExpansionTile(
        title: text18LeftBoldBlack("Other Possible Matches"),
        children: <Widget>[
          Container(
            height: 250,
            color: Colors.white,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ChildPopup(
                      pic: list[index].pic,
                      aname: list[index].name,
                      species: list[index].species,
                      score: list[index].score,
                      index: index);
                }),
          )
        ]);
  }
}

class Tags extends ViewModelWidget<IdentificationViewModel> {
  Tags({Key key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, IdentificationViewModel model) {
    model.setTags();
    return ListView.builder(
        padding: new EdgeInsets.all(0),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: model.tags.length,
        itemBuilder: (BuildContext context, int index) {
          return Chip(
            avatar: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.grey.shade600,
                child: text12LeftNormBlack(model.tags[index][0].toUpperCase())),
            label: text12LeftNormBlack(model.tags[index]),
            backgroundColor: Colors.grey[100],
          );
        });
  }
}

class ChildPopup extends ViewModelWidget<IdentificationViewModel> {
  String pic;
  String aname;
  String species;
  String score;
  int index;
  var models;

  ChildPopup(
      {this.aname, this.index, this.pic, this.score, this.species, this.models})
      : super(reactive: true);

  @override
  Widget build(BuildContext context, IdentificationViewModel model) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: text14LeftNormBlack('Reclassify'),
        ),
        PopupMenuItem(
          value: 2,
          child: text14LeftNormBlack('View Info'),
        ),
        PopupMenuItem(
          value: 3,
          child: text14LeftNormBlack('View Photos'),
        ),
      ],
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 110,
        width: 150,
        child: Column(
          children: <Widget>[
            Expanded(child: innerImageBlock(pic), flex: 4),
            Expanded(child: name(aname, context), flex: 1),
            Expanded(child: animalSpecies(species, context), flex: 1),
            Expanded(child: accuracyScore(score, context), flex: 1),
          ],
        ),
      ),
      onSelected: (value) {
        if (value == 1) {
          model.reclassify(index);
        } else if (value == 2) {
          navigateToInfo(aname.toLowerCase());
        } else {
          navigateToGallery(aname.toLowerCase());
        }
        //different fuctionality insert here
      },
      offset: Offset(120, 40),
      color: Colors.white,
    );
  }
}

class EditSpoorFunctionality extends ViewModelWidget<IdentificationViewModel> {
  String title;
  EditSpoorFunctionality({Key key, this.title})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, IdentificationViewModel model) {
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
              icon: Icon(Icons.sync_problem),
              onPressed: () {
                //model.setEditSpoor();
              },
            ),
          ),
          text14LeftBoldGrey("$title"),
        ],
      ),
    );
  }
}

class ViewInfoFunctionality extends ViewModelWidget<IdentificationViewModel> {
  String title;
  ViewInfoFunctionality({Key key, this.title})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, IdentificationViewModel model) {
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
              icon: Icon(Icons.pets),
              onPressed: () {
                navigateToInfo(model.confident.name.toLowerCase());
              },
            ),
          ),
          text14LeftBoldGrey("$title"),
        ],
      ),
    );
  }
}

class DownloadFunctionality extends ViewModelWidget<IdentificationViewModel> {
  String title;
  DownloadFunctionality({Key key, this.title})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, IdentificationViewModel model) {
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
              icon: Icon(Icons.share),
              onPressed: () async {
                model.shareImage();
              },
            ),
          ),
          text14LeftBoldGrey("$title"),
        ],
      ),
    );
  }
}

class SaveFunvtionality extends ViewModelWidget<IdentificationViewModel> {
  SaveFunvtionality({Key key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, IdentificationViewModel model) {
    return Container(
      margin: new EdgeInsets.only(bottom: 0, left: 3, right: 3),
      padding: new EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            //model.setEditSpoor();
          },
        ),
      ),
    );
  }
}

class DiscardFunctionality extends ViewModelWidget<IdentificationViewModel> {
  DiscardFunctionality({Key key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, IdentificationViewModel model) {
    return Container(
      margin: new EdgeInsets.only(bottom: 0, left: 3, right: 3),
      padding: new EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {
            // model.setEditSpoor();
          },
        ),
      ),
    );
  }
}

class ConfidentAnimalIdentiication
    extends ViewModelWidget<IdentificationViewModel> {
  ConfidentAnimalIdentiication({Key key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, IdentificationViewModel model) {
    return Container(
      alignment: Alignment.center,
      margin: new EdgeInsets.all(10),
      padding: new EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      height: 170,
      width: 130,
      child: Column(children: <Widget>[
        Expanded(
            flex: 1,
            child: GestureDetector(
              onLongPress: () {
                model.setEditSpoorName();
              },
              child: Row(
                children: <Widget>[
                  Expanded(flex: 1, child: animal(context)),
                  Expanded(
                      flex: 2,
                      child: GestureDetector(
                          onLongPress: () {
                            model.setEditSpoorName();
                          },
                          child: model.editSpoorNameBool
                              ? TextInputField(indexIdentifier: 3)
                              : animalVal(model.confident.name, context))),
                ],
              ),
            )),
        Expanded(
            flex: 1,
            child: GestureDetector(
              onLongPress: () {
                model.setEditSpoorSpecies();
              },
              child: Row(
                children: <Widget>[
                  Expanded(flex: 1, child: species(context)),
                  Expanded(
                      flex: 2,
                      child: GestureDetector(
                          onLongPress: () {
                            model.setEditSpoorSpecies();
                          },
                          child: model.editSpoorSpeciesBool
                              ? TextInputField(indexIdentifier: 4)
                              : speciesVal(model.confident.species, context))),
                ],
              ),
            )),
        Expanded(flex: 1, child: accuracy(context)),
        Expanded(flex: 2, child: score(model.confident.score)),
      ]),
    );
  }
}

class BarInfo extends ViewModelWidget<IdentificationViewModel> {
  BarInfo({Key key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, IdentificationViewModel model) {
    return Container(
      alignment: Alignment(0, 0),
      margin: new EdgeInsets.only(bottom: 3, left: 10, right: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Container(
                      padding: new EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.black,
                      ),
                    )),
                Expanded(flex: 8, child: text12LeftNormGrey("Spoor Location")),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
            padding: new EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: text12LeftNormGrey('Kruger National Park'),
                )
              ],
            ),
          ),
          GestureDetector(
            onLongPress: () {
              model.setEditDate();
            },
            child: Container(
              alignment: Alignment.centerLeft,
              margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
              padding: new EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: text12LeftNormGrey('Date: '),
                  ),
                  Expanded(
                      flex: 3,
                      child: model.editDateBool
                          ? TextInputField(
                              indexIdentifier: 0,
                            )
                          : text12LeftNormBlack(model.getDate))
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
            padding: new EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: text12LeftNormGrey('Coordinates: '),
                ),
                Expanded(
                    flex: 3,
                    child: Row(children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onLongPress: () {
                            model.setEditSpoorCoordLat();
                          },
                          child: Container(
                              margin: new EdgeInsets.only(right: 2),
                              child: model.editSpoorCoordLat
                                  ? TextInputField(indexIdentifier: 1)
                                  : text12LeftNormBlack(
                                      "Latitude: " + model.getCoordLat)),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onLongPress: () {
                            model.setEditSpoorCoordLong();
                          },
                          child: Container(
                              margin: new EdgeInsets.only(left: 2),
                              child: model.editSpoorCoordLong
                                  ? TextInputField(indexIdentifier: 2)
                                  : text12LeftNormBlack(
                                      "Longitude: " + model.getCoordLong)),
                        ),
                      ),
                    ]))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TextInputField extends HookViewModelWidget<IdentificationViewModel> {
  int indexIdentifier;
  TextInputField({Key key, this.indexIdentifier}) : super(reactive: true);

  @override
  Widget buildViewModelWidget(
      BuildContext context, IdentificationViewModel model) {
    var text = useTextEditingController();
    if (indexIdentifier == 0) {
      return Container(
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: text,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
              isDense: true,
              focusColor: Colors.blue,
              hoverColor: Colors.blue,
              errorText: model.isDateValid ? null : model.userDateErrorString,
              errorStyle: TextStyle(
                  fontFamily: 'MavenPro',
                  fontWeight: FontWeight.normal,
                  color: Colors.red),
              hintText: model.date,
              filled: true,
              fillColor: Colors.grey[50]),
          onSubmitted: (value) => {model.setDate(value)},
          style: TextStyle(
              fontFamily: 'MavenPro',
              fontWeight: FontWeight.normal,
              color: Colors.black),
        ),
      );
    } else if (indexIdentifier == 1) {
      return Container(
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: text,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
              isDense: true,
              focusColor: Colors.blue,
              hoverColor: Colors.blue,
              errorText: model.isLatValid ? null : model.userLatErrorString,
              errorStyle: TextStyle(
                  fontFamily: 'MavenPro',
                  fontWeight: FontWeight.normal,
                  color: Colors.red),
              hintText: model.getCoordLat,
              filled: true,
              fillColor: Colors.grey[50]),
          onSubmitted: (value) => {model.setLat(value)},
          style: TextStyle(
              fontFamily: 'MavenPro',
              fontWeight: FontWeight.normal,
              color: Colors.black),
        ),
      );
    } else if (indexIdentifier == 2) {
      return Container(
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: text,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
              isDense: true,
              focusColor: Colors.blue,
              hoverColor: Colors.blue,
              errorText: model.isLongValid ? null : model.userLongErrorString,
              errorStyle: TextStyle(
                  fontFamily: 'MavenPro',
                  fontWeight: FontWeight.normal,
                  color: Colors.red),
              hintText: model.getCoordLong,
              filled: true,
              fillColor: Colors.grey[50]),
          onSubmitted: (value) => {model.setLong(value)},
          style: TextStyle(
              fontFamily: 'MavenPro',
              fontWeight: FontWeight.normal,
              color: Colors.black),
        ),
      );
    } else if (indexIdentifier == 3) {
      return Container(
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: text,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
              isDense: true,
              focusColor: Colors.blue,
              hoverColor: Colors.blue,
              hintText: model.confident.name,
              filled: true,
              fillColor: Colors.grey[50]),
          onSubmitted: (value) => {model.setConfidentName(value)},
          style: TextStyle(
              fontFamily: 'MavenPro',
              fontWeight: FontWeight.normal,
              color: Colors.black),
        ),
      );
    } else if (indexIdentifier == 4) {
      return Container(
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: text,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
              isDense: true,
              focusColor: Colors.blue,
              hoverColor: Colors.blue,
              hintText: model.confident.species,
              filled: true,
              fillColor: Colors.grey[50]),
          onSubmitted: (value) => {model.setConfidentSpecies(value)},
          style: TextStyle(
              fontFamily: 'MavenPro',
              fontWeight: FontWeight.normal,
              color: Colors.black),
        ),
      );
    }
  }
}

//=====================================================
Widget attachATag(var context) {
  return Container(
    height: 55,
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.all(5),
    margin: EdgeInsets.all(5),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(flex: 1, child: attachATagButton(context)),
        Expanded(flex: 1, child: Tags()),
      ],
    ),
  );
}

Widget attachATagButton(var context) {
  return Container(
      margin: EdgeInsets.only(left: 7),
      alignment: Alignment.centerLeft,
      child: text18LeftBoldBlack("Spoor Tags"));
}

Widget similarSpoor(SimilarSpoorModel similarSpoorModel) {
  return Container(
    height: 150,
    color: Colors.white,
    child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: similarSpoorModel.similarSpoors.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 100,
            width: 150,
            child: Column(
              children: <Widget>[
                Expanded(
                    child:
                        innerImageBlock(similarSpoorModel.similarSpoors[index]),
                    flex: 4),
              ],
            ),
          );
        }),
  );
}

Widget name(String name, var context) {
  return new Container(
      alignment: Alignment.centerLeft,
      padding: new EdgeInsets.all(5),
      margin: new EdgeInsets.only(left: 2),
      child: text14LeftBoldBlack(name));
}

Widget animalSpecies(String species, var context) {
  return Container(
    alignment: Alignment.centerLeft,
    margin: new EdgeInsets.only(left: 2),
    padding: new EdgeInsets.all(5),
    child: text14LeftBoldGrey(species),
  );
}

Widget accuracyScore(String score, var context) {
  return new Container(
    alignment: Alignment.centerLeft,
    margin: new EdgeInsets.only(left: 2),
    padding: new EdgeInsets.all(5),
    child: text14LeftBoldGrey(score),
  );
}

Widget similarSpoors(var context) {
  return Container(
    alignment: Alignment.centerLeft,
    margin: new EdgeInsets.only(bottom: 3, left: 10, right: 10),
    padding: new EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    //height: 0,
    child: text18LeftBoldBlack(
      "Similar Spoors",
    ),
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
        image: AssetImage(link),
        fit: BoxFit.fill,
      ),
    ),
    height: 150,
    width: 150,
  );
}

Widget icon = new Container(
  alignment: Alignment(0, 0),
  margin: new EdgeInsets.only(bottom: 3, left: 3, right: 3),
  decoration: BoxDecoration(
      color: Colors.grey[850],
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey[850])),
  child: Center(
    child: IconButton(
      alignment: Alignment(0, 0),
      icon: Icon(
        Icons.keyboard_arrow_up,
        color: Colors.white,
      ),
      onPressed: () {},
    ),
  ),
);

Widget text(String name, var context) {
  return Container(
    alignment: Alignment(0, 0),
    margin: new EdgeInsets.only(bottom: 3, left: 10, right: 3),
    decoration: BoxDecoration(
      color: Colors.grey[850],
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
            child: text22LeftBoldWhite('$name Spoor identified'),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.centerLeft,
            child: text16LeftBoldWhite('Swipe up for more options'),
          ),
        )
      ],
    ),
  );
}

Widget backButton(context) {
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
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.grey[850])),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
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
    //height: 0,
    child: text18LeftBoldBlack("Spoor Identification Results"),
  );
}

Widget confidentImageBlock(String image) {
  return Container(
    alignment: Alignment.center,
    margin: new EdgeInsets.only(bottom: 10, left: 15, right: 10, top: 10),
    //padding: new EdgeInsets.all(5),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(image),
        fit: BoxFit.fill,
      ),
      color: Colors.grey,
      borderRadius: BorderRadius.circular(15),
    ),
    height: 170,
    width: 130,
  );
}

Widget animal(var context) {
  return Container(
    alignment: Alignment.centerLeft,
    padding: new EdgeInsets.all(0),
    child: text14LeftBoldBlack("Animal: "),
  );
}

Widget animalVal(String name, var context) {
  return new Container(
    alignment: Alignment.centerLeft,
    padding: new EdgeInsets.all(0),
    child: text14LeftBoldGrey(name),
  );
}

Widget species(var context) {
  return Container(
      alignment: Alignment.centerLeft,
      padding: new EdgeInsets.all(0),
      child: text14LeftBoldBlack("Species:"));
}

Widget speciesVal(String species, var context) {
  return new Container(
    alignment: Alignment.centerLeft,
    padding: new EdgeInsets.all(0),
    child: text14LeftBoldGrey(species),
  );
}

Widget accuracy(var context) {
  return Container(
      alignment: Alignment.centerLeft,
      padding: new EdgeInsets.all(0),
      child: text14LeftBoldBlack("Accuracy Score:"));
}

Widget score(String score) {
  return Container(
      alignment: Alignment.centerLeft,
      padding: new EdgeInsets.all(0),
      child: percentageText("$score", 45));
}
