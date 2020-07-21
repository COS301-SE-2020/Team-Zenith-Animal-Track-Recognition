import 'dart:core';

import 'package:ERP_RANGER/ui/views/information/information_viewmodel.dart';
import 'package:ERP_RANGER/ui/widgets/bottom_navigation/bottom_nav.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

final List<String> imgList = [
  'assets/images/E1.jpg',
  'assets/images/E2.jpg',
  'assets/images/E3.jpg',
  'assets/images/E4.jpg',
  'assets/images/E5.jpg'
];

class InformationView extends StatelessWidget {
  const InformationView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BottomNavigation bottomNavigation = BottomNavigation();
    bottomNavigation.setIndex(1);
    return ViewModelBuilder<InformationViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Stack(
          children: <Widget>[
            InfoListBody(),
            Scroll(),
            backButton(context),
          ],
        ),
        bottomNavigationBar: BottomNavigation(),
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
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: SizedBox(
            height: 500,
              child: CarouselWithIndicator()),
        )
      ],
    );
  }
}

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    //Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    Image.asset(item,fit: BoxFit.cover, width: 1000.0 ,height: 500,),
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
          CarouselSlider(
            items: imageSliders,
            options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16/12,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
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
  Scroll({Key key}) : super(key: key, reactive: true);




  @override
  Widget build(BuildContext context, InformationViewModel model) {
    return DraggableScrollableSheet(
        initialChildSize: 0.59,
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
                name("Elephant", "African Bush Elephant"),
                SizedBox(height: 10),
                animalDetails(),
                SizedBox(height: 10),
                overview("African Bush Elephants, also known as the African Savanna elephant, is the larget living terrestial animal. Both sexes have tusks, which erupt when they are 1-3 years old and grow throughout life."),
                SizedBox(height: 35),
                ListTileTheme(
                  dense: true,
                  child: ViewButton(),
                ),
                SizedBox(height: 35),
                tabs(),
              ],
            ),

          );
        });
  }
}

Widget name(String name, String species)
{
  return Container(
    height: 55,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('$species',style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),),
        ),
        Expanded(
          flex: 1,
          child: Text('$name',style: TextStyle(color: Colors.black, fontSize: 20),),
        )
      ],
    ),
  );
}

Widget height(String female, String male)
{
  return Expanded(
    flex: 1,
    child: Container(
      decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.grey))
      ),
      child: Column(
        children: <Widget>[
          Text('Avg. Height', style: TextStyle(color: Colors.grey)),
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
                  flex: 3,
                  child: Container(
                      child: Text(female)
                  )),
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
                  flex: 3,
                  child: Container(
                      child: Text(male)
                  )),
            ],
          )
        ],
      ),
    ),
  );
}

Widget weight(String female, String male)
{
  return Expanded(
    flex: 1,
    child: Container(
      decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.grey))
      ),
      child: Column(
        children: <Widget>[
          Text('Avg. Height', style: TextStyle(color: Colors.grey)),
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
                  flex: 3,
                  child: Container(
                      child: Text(female)
                  )),
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
                  flex: 3,
                  child: Container(
                      child: Text(male)
                  )),
            ],
          )
        ],
      ),
    ),
  );
}

Widget gestation(String period)
{
  return Expanded(
    flex: 1,
    child: Container(
      decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.grey))
      ),
      padding: EdgeInsets.only(left: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Gestation Period', style: TextStyle(color: Colors.grey),),
          Row(
            children: <Widget>[

              Expanded(
                  flex: 2,
                  child: Container(
                      child: Text(period)
                  )),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                  )),
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

Widget diet(String diet)
{
  return Expanded(
    flex: 1,
    child: Container(
      padding: EdgeInsets.only(left: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Diet', style: TextStyle(color: Colors.grey)),
          Row(
            children: <Widget>[

              Expanded(
                  flex: 2,
                  child: Container(
                      child: Text(diet)
                  )),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                  )),
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


Widget animalDetails()
{
  return Container(
    child: Row(
      children: <Widget>[
        height("2.2 - 2.6 m", "3.2 - 4.0 m"),
        weight("2.1 - 3.2 t", "4.7 - 6.4 t"),
        gestation("22 Months"),
        diet("Herbivore")
      ],
    ),

  );
}

Widget overview(String text)
{
  return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Overview', style: TextStyle(fontSize: 16),),
          SizedBox(height: 5),
          Text(text)
        ],
      ),
    );
}


class ViewButton extends ViewModelWidget<InformationViewModel> {
  const ViewButton({Key key}) : super(key: key, reactive: true);
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
            horizontal: MediaQuery.of(context).size.width/4,
          ),
          child: Text('VIEW GALLERY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
          onPressed: () {
            model.navigateToGalleryView();
          },
        )
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }
}



class tabs extends StatefulWidget {
const tabs({Key key}) : super(key: key);

@override
_tabs createState() => _tabs();
}

class _tabs extends State<tabs> with SingleTickerProviderStateMixin {
  TabController tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    tabController = TabController(
      initialIndex: selectedIndex,
      length: 4,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return ViewModelBuilder<InformationViewModel>.reactive(
        builder: (context, model, child) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TabBar(
              controller: tabController,
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
              height: screenHeight*0.70,
              margin: EdgeInsets.only(left: 16.0,right: 16.0),
              child: TabBarView(
                controller: tabController,
                children: <Widget>[
                  tabtext("text"),
                  tabtext("text"),
                  tabtext("text"),
                  tabtext("text"),
                ],
              ),
            )
          ],
        )

    );
  }
}

Widget tabtext(String text){
  return Container(
    child: Text(text),
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
