import 'package:ERP_RANGER/ui/views/home/home_viewmodel.dart';
import 'package:ERP_RANGER/ui/views/information/spoor_Identification_View.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            '     Recent Identifications',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: false,
          backgroundColor: Colors.white,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.search,
                    size: 26.0,
                    color: Colors.black,
                  ),
                )),
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                ))
          ],
        ),
        body: Center(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: model.cardLength,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          height: 220,
                          width: double.maxFinite,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SpoorIdentificationView()),
                              );
                            },
                            child: Card(
                                elevation: 5,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        model.cards[index].pic),
                                                    fit: BoxFit.fill),
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              height: 100,
                                              width: 130,
                                            ), //contains image
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  RichText(
                                                      textAlign: TextAlign.left,
                                                      text: TextSpan(
                                                          text: model
                                                              .cards[index]
                                                              .name,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 19.0))),
                                                  SizedBox(height: 8),
                                                  RichText(
                                                      text: TextSpan(
                                                          text: 'Species: ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          children: <TextSpan>[
                                                        TextSpan(
                                                            text: model
                                                                .cards[index]
                                                                .species,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey))
                                                      ])),
                                                  SizedBox(height: 8),
                                                  RichText(
                                                      text: TextSpan(
                                                          text: 'Location: ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          children: <TextSpan>[
                                                        TextSpan(
                                                            text: model
                                                                .cards[index]
                                                                .location,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey))
                                                      ])),
                                                  SizedBox(height: 8),
                                                  RichText(
                                                      text: TextSpan(
                                                          text: 'Captured by: ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          children: <TextSpan>[
                                                        TextSpan(
                                                            text: model
                                                                .cards[index]
                                                                .captured,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey))
                                                      ]))
                                                ],
                                              )),
                                            ), //contains the information
                                            Expanded(
                                              child: Container(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  height: 105,
                                                  child: Text(
                                                    model.cards[index].time,
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  )),
                                            )
                                          ],
                                        ),
                                      ),
                                    ), //top part of card
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border(top: BorderSide())),
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Chip(
                                              backgroundColor: Colors.grey,
                                              label: Text(
                                                model.cards[index].tag,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0),
                                              ),
                                              visualDensity:
                                                  VisualDensity.compact,
                                            ),
                                            Text(
                                              'ACCURACY SCORE: ',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              model.cards[index].score,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                    ) //bottom part of card
                                  ],
                                )),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.camera_alt),
          backgroundColor: Colors.grey,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.grey),
                title: Text('Home', style: TextStyle(color: Colors.grey)),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.pets, color: Colors.grey),
                title: Text('Animals', style: TextStyle(color: Colors.grey)),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.file_upload, color: Colors.grey),
                title: Text('Upload', style: TextStyle(color: Colors.grey)),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle, color: Colors.grey),
                title: Text('Profile', style: TextStyle(color: Colors.grey)),
              )
            ]),
        backgroundColor: Colors.grey,
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
