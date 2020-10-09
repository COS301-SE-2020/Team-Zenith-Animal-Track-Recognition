import 'dart:core';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:ERP_RANGER/services/util.dart';
import 'package:ERP_RANGER/ui/views/information/information_viewmodel.dart';
import 'package:ERP_RANGER/ui/widgets/bottom_navigation/bottom_nav.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

final List<String> imgList = new List();

// ignore: must_be_immutable
class InformationView extends StatelessWidget {
  InfoModel animalInfo;
  InformationView({this.animalInfo});

  @override
  Widget build(BuildContext context) {
    BottomNavigation bottomNavigation = BottomNavigation();
    bottomNavigation.setIndex(1);
    return ViewModelBuilder<InformationViewModel>.reactive(
      builder: (context, model, child) => FutureBuilder(
        future: model.getInfo(animalInfo.commonName),
        builder: (context, snapshot) {
          model.getInfo(animalInfo.commonName);
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
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
            imgList.clear();
            imgList.addAll(animalInfo.carouselImages);
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
                          InfoListBody(),
                          Scroll(
                            infomodel: animalInfo,
                          ),
                          backButton(context),
                        ],
                      ),
                    ),
                  )
                : progressIndicator();
          } else {
            return progressIndicator();
          }
        },
      ),
      viewModelBuilder: () => InformationViewModel(),
    );
  }
}

class InfoListBody extends ViewModelWidget<InformationViewModel> {
  InfoListBody({Key key}) : super(reactive: true);

  @override
  Widget build(BuildContext context, InformationViewModel viewModel) {
    return CustomScrollView(
      key: Key('Carousel'),
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: SizedBox(height: 350, child: CarouselWithIndicator()),
        )
      ],
    );
  }
}

class CarouselWithIndicator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  child: CarouselSlider(
                    items: getCarousel(),
                    options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        pauseAutoPlayOnTouch: true,
                        height: 310,
                        aspectRatio: 16 / 9,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "VIEW",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'MavenPro',
                        ),
                      ),
                      Text(
                        "GALLERY",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'MavenPro',
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.map((url) {
              int index = imgList.indexOf(url);
              return Container(
                width: 10.0,
                height: 10.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          ),
        ]),
      ),
    );
  }
}

// ignore: must_be_immutable
class Scroll extends ViewModelWidget<InformationViewModel> {
  InfoModel infomodel;
  Scroll({this.infomodel}) : super(reactive: true);

  @override
  Widget build(BuildContext context, InformationViewModel model) {
    return DraggableScrollableSheet(
        key: Key('InfoScroll'),
        initialChildSize: 0.59,
        minChildSize: 0.59,
        maxChildSize: 0.99,
        builder: (BuildContext context, ScrollController myscrollController) {
          return Container(
            padding: new EdgeInsets.all(0.0),
            margin: new EdgeInsets.all(0.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView(
              padding: new EdgeInsets.only(top: 10.0),
              controller: myscrollController,
              children: <Widget>[
                name(infomodel.commonName, infomodel.species),
                SizedBox(height: 10),
                animalDetails(
                    infomodel.heightF,
                    infomodel.heightM,
                    infomodel.weightF,
                    infomodel.weightM,
                    infomodel.gestation,
                    infomodel.diet),
                SizedBox(height: 10),
                overview(infomodel.overview),
                SizedBox(height: 35),
                ListTileTheme(
                  dense: true,
                  child: ViewButton(
                    name: infomodel.commonName,
                  ),
                ),
                SizedBox(height: 35),
                Tabz(
                  infoModel: infomodel,
                ),
              ],
            ),
          );
        });
  }
}

// ignore: must_be_immutable
class Tabz extends ViewModelWidget<InformationViewModel> {
  InfoModel infoModel;
  Tabz({this.infoModel}) : super(reactive: true);

  @override
  Widget build(BuildContext context, InformationViewModel model) {
    double screenHeight = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TabBar(
            indicatorColor: Color.fromRGBO(33, 78, 125, 1),
            labelColor: Color.fromRGBO(33, 78, 125, 1),
            unselectedLabelColor: Colors.black,
            isScrollable: true,
            labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            tabs: <Widget>[
              Tab(text: 'Description'),
              Tab(text: 'Behaviour'),
              Tab(text: 'Habitat'),
              Tab(text: 'Threat'),
            ],
          ),
          Container(
            height: screenHeight * 0.70,
            margin: EdgeInsets.only(left: 12.0, right: 12.0),
            child: TabBarView(
              children: <Widget>[
                tabtext(infoModel.description),
                tabtext(infoModel.behaviour),
                tabtext(infoModel.habitat),
                tabtext(infoModel.threat),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ViewButton extends ViewModelWidget<InformationViewModel> {
  String name;
  ViewButton({Key key, this.name}) : super(key: key, reactive: true);
  @override
  Widget build(BuildContext context, InformationViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Color.fromRGBO(61, 122, 172, 1),
          padding: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: MediaQuery.of(context).size.width / 4,
          ),
          child: text18CenterBoldWhite('VIEW GALLERY'),
          onPressed: () {
            navigateToGallery(name);
          },
        )
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }
}

Widget name(String name, String species) {
  return Container(
    height: 55,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(flex: 1, child: text22CenterBoldBlack('$species')),
        Expanded(flex: 1, child: text20CenterNormBlack('$name'))
      ],
    ),
  );
}

Widget height(String female, String male) {
  return Container(
    padding: EdgeInsets.only(left: 7, bottom: 7),
    decoration:
        BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
    child: Row(
      children: <Widget>[
        Expanded(
            flex: 3,
            child: Container(child: text14LeftBoldBlack('Avg. Height: '))),
        Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Icon(
                    Icons.person_pin,
                    color: Colors.pink[200],
                    size: 13,
                  ),
                ),
                Container(child: text14RightNormBlack(female)),
              ],
            )),
        Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    right: 5.0,
                  ),
                  child: Icon(
                    Icons.person_pin,
                    color: Colors.blue[200],
                    size: 13,
                  ),
                ),
                Container(child: text14RightNormBlack(male)),
              ],
            )),
      ],
    ),
  );
}

Widget weight(String female, String male) {
  return Container(
    padding: EdgeInsets.only(left: 7, bottom: 7),
    decoration:
        BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
    child: Row(
      children: <Widget>[
        Expanded(
            flex: 3,
            child: Container(child: text14LeftBoldBlack('Avg. Weight: '))),
        Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Icon(
                    Icons.person_pin,
                    color: Colors.pink[200],
                    size: 13,
                  ),
                ),
                Container(child: text14RightNormBlack(female)),
              ],
            )),
        Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    right: 5.0,
                  ),
                  child: Icon(
                    Icons.person_pin,
                    color: Colors.blue[200],
                    size: 13,
                  ),
                ),
                Container(child: text14RightNormBlack(male)),
              ],
            )),
      ],
    ),
  );
}

Widget gestation(String period) {
  return Container(
    alignment: Alignment.topLeft,
    decoration:
        BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
    padding: EdgeInsets.only(left: 7.0, bottom: 7),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(flex: 1, child: text14LeftBoldBlack('Gestation: ')),
        Expanded(flex: 2, child: Container(child: text14LeftNormBlack(period))),
      ],
    ),
  );
}

Widget diet(String diet) {
  return Container(
    padding: EdgeInsets.only(left: 7.0, bottom: 7),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(flex: 3, child: text14LeftBoldBlack('Diet: ')),
        Expanded(flex: 6, child: Container(child: text14LeftNormBlack(diet))),
      ],
    ),
  );
}

Widget animalDetails(String heightF, String heightM, String weightF,
    String weightM, String gestations, String diets) {
  return Container(
    child: Column(
      children: <Widget>[
        height("$heightF", "$heightM"),
        weight("$weightF", "$weightM"),
        gestation(gestations),
        diet(diets)
      ],
    ),
  );
}

Widget overview(String text) {
  return Container(
    padding: EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        text16LeftBoldBlack('Overview: '),
        SizedBox(height: 5),
        text14LeftNormGrey(text)
      ],
    ),
  );
}

Widget tabtext(String text) {
  return Container(
    child: text14LeftNormGrey(text),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ));
}

List<Widget> getCarousel() {
  return imgList
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(1.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: 500.0,
                        height: 500,
                        child: Image.network(
                          item,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();
}
