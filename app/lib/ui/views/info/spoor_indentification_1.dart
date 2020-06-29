
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Completer<GoogleMapController> _controller = Completer();

final CameraPosition _myLocation = CameraPosition(target: LatLng(0,0),);

class spoor_identification_1 extends StatefulWidget {
  @override
  _spoor_identification_1State createState() => _spoor_identification_1State();
}

class _spoor_identification_1State extends State<spoor_identification_1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(40.688841, -74.044015),
              zoom: 20,
            ),

            mapType: MapType.normal,

            onMapCreated: (GoogleMapController controller){_controller.complete(controller);},
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.30,
            minChildSize: 0.15,
            builder: (BuildContext context, ScrollController scrollController){
              return ListView(
                scrollDirection: Axis.vertical,
                controller: scrollController,
                  children: <Widget>[
                  Container(
                    color: Colors.grey[850],
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.white,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Elephant Spoor Identified',
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                            Container(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Swipe up for more information',
                                    style: TextStyle(color: Colors.white, fontSize: 15),
                                  ),
                                )
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                    Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.location_on,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Spoor Location'
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                ]
              );
              })
            ];
            },
          )
        ],
      ),
    );
  }
}
