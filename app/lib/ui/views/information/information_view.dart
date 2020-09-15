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
            return progressIndicator();
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
          child: SizedBox(height: 500, child: CarouselWithIndicator()),
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
            child: CarouselSlider(
              items: getCarousel(),
              options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 12,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
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
            indicatorColor: Colors.grey,
            labelColor: Colors.grey,
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
          color: Colors.grey,
          padding: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: MediaQuery.of(context).size.width / 4,
          ),
          child: text16CenterBoldWhite('VIEW GALLERY'),
          onPressed: () {
            navigateToGallery(name.toLowerCase());
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
  return Expanded(
    flex: 1,
    child: Container(
      decoration:
          BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
      child: Column(
        children: <Widget>[
          text14LeftBoldBlack('Avg. Height'),
          Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Icon(
                      Icons.person_pin,
                      color: Colors.pink[200],
                      size: 13,
                    ),
                  )),
              Expanded(
                  flex: 3, child: Container(child: text12LeftNormGrey(female))),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Icon(
                      Icons.person_pin,
                      color: Colors.blue[200],
                      size: 13,
                    ),
                  )),
              Expanded(
                  flex: 3, child: Container(child: text12LeftNormGrey(male))),
            ],
          )
        ],
      ),
    ),
  );
}

Widget weight(String female, String male) {
  return Expanded(
    flex: 1,
    child: Container(
      decoration:
          BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
      child: Column(
        children: <Widget>[
          text14LeftBoldBlack('Avg. Weight'),
          Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Icon(
                      Icons.person_pin,
                      color: Colors.pink[200],
                      size: 13,
                    ),
                  )),
              Expanded(
                  flex: 3, child: Container(child: text12LeftNormGrey(female))),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Icon(
                      Icons.person_pin,
                      color: Colors.blue[200],
                      size: 13,
                    ),
                  )),
              Expanded(
                  flex: 3, child: Container(child: text12LeftNormGrey(male))),
            ],
          )
        ],
      ),
    ),
  );
}

Widget gestation(String period) {
  return Expanded(
    flex: 1,
    child: Container(
      decoration:
          BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
      padding: EdgeInsets.only(left: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          text14LeftBoldBlack('Gestation'),
          Row(
            children: <Widget>[
              Expanded(
                  flex: 2, child: Container(child: text12LeftNormGrey(period))),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(flex: 1, child: Container()),
              Expanded(
                  flex: 2,
                  child: Container(
                    child: Text(""),
                  )),
            ],
          )
        ],
      ),
    ),
  );
}

Widget diet(String diet) {
  return Expanded(
    flex: 1,
    child: Container(
      padding: EdgeInsets.only(left: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          text14LeftBoldBlack('Diet'),
          Row(
            children: <Widget>[
              Expanded(
                  flex: 1, child: Container(child: text12LeftNormGrey(diet))),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(flex: 1, child: Container()),
              Expanded(
                  flex: 2,
                  child: Container(
                    child: Text(""),
                  )),
            ],
          )
        ],
      ),
    ),
  );
}

Widget animalDetails(String heightF, String heightM, String weightF,
    String weightM, String gestations, String diets) {
  return Container(
    child: Row(
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
          border: Border.all(color: Colors.white)),
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
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(
                        item,
                        fit: BoxFit.cover,
                        width: 1000.0,
                        height: 500,
                      ),
                      // Image.asset(
                      //   item,
                      //   fit: BoxFit.cover,
                      //   width: 1000.0,
                      //   height: 500,
                      // ),
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
