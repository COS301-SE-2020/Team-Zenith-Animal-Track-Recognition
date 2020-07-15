import 'package:ERP_Ranger/ui/views/info/info_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import '../../../core/viewmodels/home_viewmodel.dart';
import '../base_view.dart';
import '../../../core/services/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class AnimalView extends StatefulWidget {

  User animal;
  AnimalView(this.animal);
  

  @override
  _AnimalView createState() => _AnimalView(animal);
}

class _AnimalView extends State<AnimalView> {

  User animal;
  _AnimalView(this.animal);
    Future<bool> _onBackPressed() async{
      if(Navigator.canPop(context)){
        Navigator.of(context).popUntil((route) => route.isFirst);
      }else{
          print("nooooo");
      }
    }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
        builder: (context, model, child) => Scaffold(
          body: WillPopScope(
            onWillPop: _onBackPressed,
            child: Scaffold(
              body: FireMap(animal),
            ),
          )
        ),
    );
  }
}

class FireMap extends StatefulWidget {
  User animal;
  FireMap(this.animal);
  @override
  State createState() => FireMapState(animal);
}

class FireMapState extends State<FireMap> {
  User animal;
  FireMapState(this.animal);
  GoogleMapController mapController;
  Position position;
  Widget _child;
 build(BuildContext context) {
    return Stack(
    children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(-26.097740173,28.233989716),
            zoom: 15
          ),
          onMapCreated: (GoogleMapController controller){
              setState(() {
                mapController = controller;
              });
          },
          myLocationEnabled: true,
          mapType: MapType.normal,
          compassEnabled: true,
        ),
        Scroll(animal),
    ]);
  }
}

class Scroll extends StatefulWidget {
  User animal;
  Scroll(this.animal);
  @override
  _Scroll createState() => _Scroll(animal);
}

class _Scroll extends State<Scroll> {
  User animal;
  _Scroll(this.animal);
    int count = 0;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.40,
      minChildSize: 0.40,
      maxChildSize: 0.90,
      builder: (BuildContext context, ScrollController myscrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )
          ),
          child: ListView( 
            controller: myscrollController,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top:8.0,left: 11.0,),
                child: Center(
                  child: Text(animal.name+" Spoor Identified",
                    style: TextStyle(fontSize: 30,
                      fontFamily: 'Arciform',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey
                    ),                            
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top:8.0,left: 1.0,),
                      child: Row(children: <Widget>[
                        Icon(Icons.location_on),
                        Text("Spoor Location",
                              style: TextStyle(fontSize: 15,
                              fontFamily: 'Arciform',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey    
                            )                           
                         ),
                      ],),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:8.0,left: 23.0,),
                      child: Row(
                        children: <Widget>[
                          Text("Kruger National Park",
                          style: TextStyle(fontSize: 15,
                              fontFamily: 'Arciform',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey    
                            )               
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:8.0,left: 23.0,),
                      child: Row(
                        children: <Widget>[
                          Text("Date: 09/09/2020",
                          style: TextStyle(fontSize: 15,
                              fontFamily: 'Arciform',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey    
                            )               
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:8.0,left: 23.0,),
                      child: Row(
                        children: <Widget>[
                          Text("Coordinates: -24.019097, 31.559270",
                          style: TextStyle(fontSize: 15,
                              fontFamily: 'Arciform',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey    
                            )               
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),         
              Padding(
                padding: const EdgeInsets.only(top:8.0,left: 27.0,),
                child: Text("Spoors Information",
                  style: TextStyle(fontSize: 20,
                    fontFamily: 'Arciform',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey
                  ),                            
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                         padding: const EdgeInsets.only(top:8.0,left: 23.0,),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black,
                            ),  
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image(
                                image: NetworkImage(animal.picture[0]),
                                fit: BoxFit.fill,
                              ),
                            )
                          ),
                        )
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top:8.0,left: 8.0,),
                          child: Container(
                            height: 190,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),                             
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Column(
                                children: [
                                  Expanded(
                                    flex:1,
                                      child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        alignment: Alignment.bottomLeft,
                                        child: Text("Type: Track" ,
                                          style: TextStyle(fontSize: 19,
                                          fontFamily: 'Arciform',
                                          fontWeight: FontWeight.bold)
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex:1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        alignment: Alignment.bottomLeft,
                                        child: Text("Animal: "+animal.name,
                                          style: TextStyle(fontSize: 19,
                                          fontFamily: 'Arciform',
                                          fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex:1,
                                      child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                         alignment: Alignment.bottomLeft,
                                        child: Text("Accuracy Score:",
                                          style: TextStyle(fontSize: 19,
                                          fontFamily: 'Arciform',
                                          fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex:2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(animal.confidence+"%",
                                          style: TextStyle(fontSize: 60,
                                          fontFamily: 'Arciform',
                                          fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                ]
                              ),
                            )
                          ),
                        )
                      ),
                    ],
                )
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0,left: 23.0,),
                child: Text("Similar Spoors",
                  style: TextStyle(fontSize: 20,
                    fontFamily: 'Arciform',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey
                  ),                            
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0,left: 23.0,),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical:5),
                  height: 100,
                  width: 100,
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder:(BuildContext context, int index){
                           return Padding(
                             padding: const EdgeInsets.all(3.0),
                             child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black,
                              ),  
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image(
                                  image: NetworkImage(animal.picture[count]),
                                  fit: BoxFit.contain,
                                ),
                                
                              )
                             ),

                           );

                    },
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
              Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Container(
                    height: 50,
                    width: 325,
                    margin: const EdgeInsets.only(top: 10.0, bottom: 70),
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0), 
                      ),
                      color: Colors.grey,
                      splashColor: Colors.grey,
                      textColor: Colors.white,
                      child: Text(
                        'View Animal Information',
                        style: TextStyle(fontSize: 17,
                        fontFamily: 'Arciform'),
                      ),
                      onPressed: () async{   
                        Navigator.push(context, PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) => InfoView(),
                        ),);
                      }
                    ),
                  ),
               ),  
            ],
          ),
        );
      },
    );
  }
}