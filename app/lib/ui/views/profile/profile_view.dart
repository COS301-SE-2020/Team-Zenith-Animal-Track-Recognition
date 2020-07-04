import 'package:ERP_Ranger/core/services/mock_api.dart';
import 'package:ERP_Ranger/ui/views/info/spoor_indentification_1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var data = MockApi.getData;

class profile_View extends StatefulWidget {
  @override
  _profile_ViewState createState() => _profile_ViewState();
}

class _profile_ViewState extends State<profile_View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
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
          body: Center(child: recentidentifications),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.camera_alt),
        backgroundColor: Colors.grey,
      ),
      bottomNavigationBar: BottomNavigationBar(
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
          ]
      ),
      );

  }
}
Widget recentidentifications = new Container(
  child: Column(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Expanded(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: data.length,
            itemBuilder: (context,index) {
              return Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                height: 220,
                width: double.maxFinite,
                child: InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => spoor_identification_1()),
                    );
                  },
                  child: Card(
                      elevation: 5,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Image(
                                      image: AssetImage(
                                          data[index]['pic']),
                                      height: 120.0,
                                      width: 120.0,
                                    ),
                                  ), //contains image
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: <Widget>[
                                            RichText(
                                                textAlign: TextAlign.left,
                                                text: TextSpan(
                                                    text: data[index]['name'],
                                                    style: TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        color: Colors
                                                            .black,
                                                        fontSize: 19.0)
                                                )
                                            ),
                                            SizedBox(height: 8),
                                            RichText(
                                                text: TextSpan(
                                                    text: 'Species: ',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: data[index]['species'],
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey))
                                                    ]
                                                )
                                            ),
                                            SizedBox(height: 8),
                                            RichText(
                                                text: TextSpan(
                                                    text: 'Location: ',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: data[index]['location'],
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey))
                                                    ]
                                                )
                                            ),
                                            SizedBox(height: 8),
                                            RichText(
                                                text: TextSpan(
                                                    text: 'Captured by: ',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: data[index]['captured'],
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey))
                                                    ]
                                                )
                                            )
                                          ],
                                        )
                                    ),
                                  ), //contains the information
                                  Expanded(
                                    child: Container(
                                        alignment: Alignment.topCenter,
                                        height: 105,
                                        child: Text(
                                          data[index]['time'], style: TextStyle(
                                            color: Colors.grey),
                                        )
                                    ),
                                  )
                                ],
                              ),
                            ),

                          ), //top part of card
                          Container(
                            decoration: BoxDecoration(
                                border: Border(top: BorderSide())
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: <Widget>[
                                  Chip(
                                    backgroundColor: Colors.grey,

                                    label: Text(
                                      data[index]['tag'], style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                    ),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  Text(
                                    'ACCURACY SCORE: ',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    data[index]['score'], style: TextStyle(fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ) //bottom part of carf
                        ],
                      )

                  ),
                ),


              );
            }),
      )
    ],
  ),
);


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