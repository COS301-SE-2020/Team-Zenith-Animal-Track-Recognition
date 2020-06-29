import 'dart:ui';

import 'package:ERP_Ranger/core/services/api.dart';
import 'package:ERP_Ranger/core/services/mock_api.dart';
import 'package:ERP_Ranger/ui/views/confirm/confirm_view.dart';
import 'package:ERP_Ranger/ui/views/home/animal_infoview.dart';
import 'package:ERP_Ranger/ui/views/info/spoor_indentification_1.dart';
import '../../../core/viewmodels/home_viewmodel.dart';
import '../../../core/services/user.dart';
import 'package:flutter/material.dart';
import '../../../locator.dart';
import '../../widgets/bottom_nav.dart';
import '../base_view.dart';
//import 'package:provider_assist/provider_assist.dart';

var data = MockApi.getData;

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('     Recent Identifications', style: TextStyle(color: Colors.black),),
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
            )
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.more_vert,
                  color: Colors.black,
              ),
            )
          )
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
    backgroundColor: Colors.grey,
    );
  }
}


