import 'dart:io';

import 'package:ERP_RANGER/services/util.dart';
import 'package:ERP_RANGER/ui/views/notconfirmed/notconfirmed_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class NotConfirmedView extends StatelessWidget {
  File image;
  NotConfirmedView({this.image, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotConfirmedViewModel>.reactive(
      builder: (context, model, child) => FutureBuilder(
        future: model.imagePicker(image),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: text18LeftBoldWhite(
                  "Image Confirmation",
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
                        navigate(context);
                      }
                      return;
                    },
                    child: Scaffold(
                      body: Stack(
                        children: <Widget>[
                          imageBlock(image),
                          BackButton(),
                          Scroll()
                        ],
                      ),
                    ))
                : progressIndicator();
          } else {
            return progressIndicator();
          }
        },
      ),
      viewModelBuilder: () => NotConfirmedViewModel(),
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

class BackButton extends ViewModelWidget<NotConfirmedViewModel> {
  BackButton({Key key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, NotConfirmedViewModel model) {
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
            navigate(context);
          },
          child: Center(
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
        ));
  }
}

class IconButtons extends ViewModelWidget<NotConfirmedViewModel> {
  IconData iconData;
  String subTitle;
  int index;
  IconButtons({Key key, this.iconData, this.subTitle, this.index})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, NotConfirmedViewModel model) {
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
                } else if (index == 1) {
                  showOptions(context);
                } else if (index == 2) {
                  model.shareImage();
                }
              },
            ),
          ),
          text12LeftNormGrey(subTitle)
        ],
      ),
    );
  }
}

class LeadingIcon extends ViewModelWidget<NotConfirmedViewModel> {
  LeadingIcon({
    Key key,
  }) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, NotConfirmedViewModel model) {
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

class Scroll extends ViewModelWidget<NotConfirmedViewModel> {
  const Scroll({Key key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, NotConfirmedViewModel model) {
    return DraggableScrollableSheet(
        key: Key('NotConScroll'),
        initialChildSize: 0.12,
        minChildSize: 0.12,
        maxChildSize: 0.250,
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
                        child: textDisplay(context),
                      ),
                      SizedBox(
                        height: 1.0,
                      ),
                      Expanded(flex: 1, child: blocks),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
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
              ));
        });
  }
}

Widget blocks = new Container(
  alignment: Alignment(0.0, 0.0),
  margin: new EdgeInsets.only(bottom: 3, left: 3, right: 3),
  decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey)),
  width: 10,
  height: 50,
);

Widget textDisplay(var context) {
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
                  child: text18LeftBoldBlack("Track could not be identified"))),
          Expanded(
              flex: 1,
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: text14LeftBoldGrey("Swipe up for more options")))
        ],
      ));
}
