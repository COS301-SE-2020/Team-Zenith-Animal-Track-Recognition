import 'package:ERP_RANGER/services/objects/id_cards.dart';
import 'package:ERP_RANGER/ui/views/information/spoor_Identification_View.dart';
import 'package:ERP_RANGER/ui/views/profile/profile_viewmodel.dart';
import 'package:ERP_RANGER/ui/widgets/bottom_navigation/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    int userLevel = 2;
    BottomNavigation bottomNavigation = BottomNavigation();
    if(userLevel == 1){
      bottomNavigation.setIndex(2);
    }else{
      bottomNavigation.setIndex(3);
    }

    return ViewModelBuilder<ProfileViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: Text('Profile', style: TextStyle(color: Colors.white)),
            centerTitle: false,
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: Icon(
                Icons.menu,
              ),
              onPressed: () {},
            ),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.search,
                      size: 26.0,
                      color: Colors.white,
                    ),
                  )
              ),
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                  )
              )
            ],
          ),
        body: topbar(),
        bottomNavigationBar: BottomNavigation(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.camera_alt),
            backgroundColor: Colors.grey,
          ),
      ), 
      viewModelBuilder: () => ProfileViewModel(),
    );
  }
}

Widget topbar() {
  return DefaultTabController(
    length: 2,
    child: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: profileinfo,
            ),
          ),
          new SliverPadding(
            padding: new EdgeInsets.all(5.0),
            sliver: new SliverList(
              delegate: new SliverChildListDelegate([
                Container(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {},
                            ),
                            Text('EDIT'),
                            Text('PROFILE')
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.lock),
                              onPressed: () {},
                            ),
                            Text('CHANGE'),
                            Text('PASSWORD')
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.settings),
                              onPressed: () {},
                            ),
                            Text('PREFERENCES'),
                            Text(''),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.power_settings_new),
                              onPressed: () {},
                            ),
                            Text('LOGOUT'),
                            Text(''),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            ),
          )
        ];
      },
      body: Center(child: recentidentifications()),
    ),
  );
}


  Widget recentidentifications() {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      builder: (context, model, child) =>Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 6,
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
                                                          text: model.cards[index]
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
                                                                text: model.cards[index]
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
                                                                text: model.cards[index]
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
                                                                text: model.cards[index]
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
      viewModelBuilder: () => ProfileViewModel(),
    );
  }


  Widget profileinfo = new Container(
    child: Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                profilepic,
                profiletext
              ],
            ),
            summary,
          ],
        ),
      ],
    ),
  );

  Widget profiletext = new Container(
    alignment: Alignment.centerLeft,
    margin: new EdgeInsets.all(10),
    height: 100,
    width: 250,
    child: Column(
        children:<Widget>[
          Expanded(
              flex:1,
              child: Row(
                children: <Widget>[
                  Expanded(flex:1,child: Text('  Kagiso Ndlovu',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                ],
              )
          ),
          Expanded(
              flex:1,
              child: Row(
                children: <Widget>[
                  Expanded(flex:1,child: Icon(Icons.email)),
                  Expanded(flex:5,child: Text('k.ndlovu@email.com')),
                ],
              )
          ),
          Expanded(
              flex:1,
              child: Row(
                children: <Widget>[
                  Expanded(flex:1,child: Icon(Icons.phone)),
                  Expanded(flex:5,child: Text('+27712345567')),
                ],
              )
          ),
        ]
    ),
  );

  Widget summary = new Container(
    alignment: Alignment.center,
    padding: EdgeInsets.all(5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('150',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
              SizedBox(width: 5,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Spoors',textAlign: TextAlign.left,
                  ),
                  Text(
                      'Identified'
                  )
                ],
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('17',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30)),
              SizedBox(width: 5,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      'Animals'
                  ),
                  Text(
                      'Tracked'
                  )
                ],
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              Text('38',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30)),
              SizedBox(width: 5,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      'Species'
                  ),
                  Text(
                      'Tracked'
                  )
                ],
              )
            ],
          ),
        ),
      ],
    ),
  );

  Widget profilepic = new Container(
    alignment: Alignment.center,
    margin: new EdgeInsets.only(bottom:10, left:15,right:10,top:10 ),
    //padding: new EdgeInsets.all(5),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage( "https://images.unsplash.com/photo-1551316679-9c6ae9dec224?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"),
        fit: BoxFit.fill,
      ),
      color: Colors.grey,
      borderRadius: BorderRadius.circular(100),
    ),
    height: 90,
    width: 90,
  );

  Widget dividerGrey = new Container(
    child: Divider(color: Colors.grey, thickness: 1.2,),
    margin: EdgeInsets.only(top: 7, bottom: 7),
  );
