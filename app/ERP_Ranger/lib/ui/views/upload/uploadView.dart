import 'package:ERP_Ranger/ui/views/confirm/confirm_view.dart';
import 'package:ERP_Ranger/ui/views/confirm/unconfirmed_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../core/services/user.dart';
import '../../../core/viewmodels/upload_viewmodel.dart';
import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';
import '../base_view.dart';


class UploadView extends StatefulWidget {
  UploadView({Key key}) : super(key: key);

  @override
  _UploadView createState() => _UploadView();
}

class _UploadView extends State<UploadView> {
  int _currentTabIndex = 2;

  @override
  Widget build(BuildContext context) {
    BottomNavigation bottomNavigation = new BottomNavigation();
    bottomNavigation.setIndex(_currentTabIndex);

    return BaseView<UploadModel>(
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async { 
          if(Navigator.canPop(context)){
            Navigator.of(context).popUntil((route) => route.isFirst);
          }else{
            print("noo");
          }
        },
        child: Scaffold(
          body: Container(
            color: Colors.grey[300],
            child: SliverPage(),
          ),
          bottomNavigationBar: BottomNavigation(),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add_a_photo),
            backgroundColor: Color(0xFFF2929C),
            tooltip: 'Pick Image',
            onPressed:()async{
              List<User> animals = await model.imageID();
              if(animals == null){
                Navigator.push(context, 
                  new MaterialPageRoute(builder: (context) => UnConfirmView())
                ); 
              }else{
                Navigator.push(context, 
                  new MaterialPageRoute(builder: (context) => ConfirmView(animal: animals,))
                ); 
              }
            } 
          )
        ),
      ), 
    );
  }
}

Widget textTitle = new Container(
   // alignment: Alignment.center,
    margin: EdgeInsets.only(left:16),
    child:Text(
      "UPLOAD SPOOR GEOTAG",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        fontFamily: 'Arciform',
        fontWeight: FontWeight.bold,
        color: Colors.white
      )
    )
);

class SliverPage extends StatefulWidget {
  SliverPage({Key key}) : super(key: key);

  @override
  _SliverPage createState() => _SliverPage();
}

class _SliverPage extends State<SliverPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          leading: null,
          backgroundColor: Colors.black,
          floating: false,
          pinned: true,
          title: textTitle,
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              header,
              spoorImageBlock,
              animalInformation,
              spoorLocation,
              attachATag,
              viewMoreButton(context)
            ],
          ),
        )
      ],
    );
  }
}

Widget header = new Container(
  alignment: Alignment.center,
  padding: EdgeInsets.all(5),
  margin: EdgeInsets.all(15),
  child: Text(
      "Please enter in Spoor Information below",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        fontFamily: 'Helvetica',
        fontWeight: FontWeight.bold,
        color: Colors.grey
      )  
  ),
);

Widget leftBlock = new Container(
  alignment: Alignment.center,
  margin: new EdgeInsets.only(right:5,left:5),
  padding: new EdgeInsets.all(5),
    decoration: BoxDecoration(
    color: Colors.grey,
    borderRadius: BorderRadius.circular(10),
  ),
  height: 30,
  width: 30,
);

Widget rightIcon = new Container(
  margin: new EdgeInsets.only(right:5,left:5,),
  height: 30,
  child: Icon(Icons.arrow_right),
);

Widget spoorImageBlock = new Container(
  height: 150,
  width: 100,
  padding: EdgeInsets.all(5),
  margin: EdgeInsets.all(15),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.white)
  ),
  child: Column(
    children: <Widget>[
      Expanded(flex:1,child: spoorImageTitle),
      Expanded(flex:1,child: photoButton),
      Expanded(flex:1,child: cameraButton),
    ],
  ),
);

Widget spoorImageTitle = new Container(
  margin: EdgeInsets.only(left:7),
  alignment: Alignment.centerLeft,
  child: Text(
    "Spoor Image",
    textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 13,
        fontFamily: 'Helvetica',
        fontWeight: FontWeight.bold,
        color: Colors.grey
      )  
  )
);

Widget photoButton = new GestureDetector(
  child: Container(
    margin: new EdgeInsets.only(bottom: 10),
    child: Row(children: <Widget>[
      Expanded(flex:1,child: leftBlock),
      Expanded(flex:5,child: photoButtonText),
      Expanded(flex:1,child: rightIcon),
    ],),
  ),
);

Widget photoButtonText = Container(
  margin: new EdgeInsets.only(right:5,left:5,),
  padding: new EdgeInsets.only(top: 5,left:5),
  height: 30,
  child: Text(
  "From Photos",
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 15,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.bold,
      color: Colors.grey
    )  
  )
) ;

Widget cameraButton = new GestureDetector(
  child: Container(
    child: Row(children: <Widget>[
      Expanded(flex:1,child: leftBlock),
      Expanded(flex:5,child: cameraButtonText),
      Expanded(flex:1,child: cameraButtonIcon),
      
    ],),
  ), 
);

Widget cameraButtonText = Container(
  margin: new EdgeInsets.only(right:5,left:5,),
  padding: new EdgeInsets.only(top: 5,left:5),
  height: 30,
  child: Text(
  "From Camera",
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 15,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.bold,
      color: Colors.grey
    )  
  )
) ;

Widget cameraButtonIcon = new Container(
  margin: new EdgeInsets.only(right:5,left:5,),
  height: 30,
  child: Icon(Icons.arrow_right),
);

//============================

Widget animalInformation = new Container(
  height: 100,
  width: 100,
  padding: EdgeInsets.all(5),
  margin: EdgeInsets.all(15),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.white)
  ),
  child: Column(
    children: <Widget>[
      Expanded(flex:1,child: animalImageTitle),
      Expanded(flex:1,child: selectAnimalButton),
    ],
  ),
);

Widget animalImageTitle = new Container(
  margin: EdgeInsets.only(left:7),
  alignment: Alignment.centerLeft,
  child: Text(
    "Animal Information",
    textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 13,
        fontFamily: 'Helvetica',
        fontWeight: FontWeight.bold,
        color: Colors.grey
      )  
  )
);

Widget selectAnimalButton = new GestureDetector(
  child: Container(
    margin: new EdgeInsets.only(bottom: 10),
    child: Row(children: <Widget>[
      Expanded(flex:1,child: leftBlock),
      Expanded(flex:5,child: selectAnimalText),
      Expanded(flex:1,child: rightIcon),
    ],),
  ),
);

Widget selectAnimalText = Container(
  margin: new EdgeInsets.only(right:5,left:5,),
  padding: new EdgeInsets.only(top: 5,left:5),
  height: 30,
  child: Text(
  "Select An Animal",
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 15,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.bold,
      color: Colors.grey
    )  
  )
) ;

//=============================

Widget spoorLocation = new Container(
  height: 100,
  width: 100,
  padding: EdgeInsets.all(5),
  margin: EdgeInsets.all(15),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.white)
  ),
  child: Column(
    children: <Widget>[
      Expanded(flex:1,child: spoorLocationTitle),
      Expanded(flex:1,child: spoorLocationButton),
    ],
  ),
);

Widget spoorLocationTitle = new Container(
  margin: EdgeInsets.only(left:7),
  alignment: Alignment.centerLeft,
  child: Text(
    "Spoor Location",
    textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 13,
        fontFamily: 'Helvetica',
        fontWeight: FontWeight.bold,
        color: Colors.grey
      )  
  )
);

Widget spoorLocationButton = new GestureDetector(
  child: Container(
    margin: new EdgeInsets.only(bottom: 10),
    child: Row(children: <Widget>[
      Expanded(flex:1,child: leftBlock),
      Expanded(flex:5,child: spoorLocationText),
      Expanded(flex:1,child: rightIcon),
    ],),
  ),
);

Widget spoorLocationText = Container(
  margin: new EdgeInsets.only(right:5,left:5,),
  padding: new EdgeInsets.only(top: 5,left:5),
  height: 30,
  child: Text(
  "Use Current Location",
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 15,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.bold,
      color: Colors.grey
    )  
  )
) ;

//=============================

Widget attachATag = new Container(
  height: 105,
  width: 100,
  padding: EdgeInsets.all(5),
  margin: EdgeInsets.all(15),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.white)
  ),
  child: Column(
    children: <Widget>[
      Expanded(flex:1,child: attachATagButton),
      Expanded(flex:1,child: ToggleButton()),
    ],
  ),
);

Widget attachATagButton = new GestureDetector(
  child: Container(
    margin: new EdgeInsets.only(bottom: 10),
    child: Row(children: <Widget>[
      Expanded(flex:1,child: leftBlock),
      Expanded(flex:6,child: attachATagText),
    ],),
  ),
);

Widget attachATagText = Container(
  margin: new EdgeInsets.only(right:5,left:5,),
  padding: new EdgeInsets.only(top: 5,left:5),
  height: 30,
  child: Text(
  "Attach A Tag",
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 15,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.bold,
      color: Colors.grey
    )  
  )
) ;

class ToggleButton extends StatefulWidget {
  ToggleButton({Key key, List<Widget> children}) : super(key: key);

  @override
  _ToggleButtons createState() => _ToggleButtons();
}

class _ToggleButtons extends State<ToggleButton> {
  List<bool> _selection = List.generate(7, (index) => false);
  FocusNode focusButton1 = FocusNode();
  FocusNode focusButton2 = FocusNode();
  FocusNode focusButton3 = FocusNode();
  FocusNode focusButton4 = FocusNode();
  FocusNode focusButton5 = FocusNode();
  FocusNode focusButton6 = FocusNode();
  FocusNode focusButton7 = FocusNode();
  List<FocusNode> focusToggle;

  @override
  void initState() { 
    super.initState();
    focusToggle = [focusButton1,focusButton2,focusButton3,focusButton4,focusButton5,focusButton6,focusButton7];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    focusButton1.dispose();
    focusButton2.dispose();
    focusButton3.dispose();
    focusButton4.dispose();
    focusButton5.dispose();
    focusButton6.dispose();
    focusButton7.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.only(bottom:5),
      child:ToggleButtons(
          children: [
            Expanded(flex:1,child: track),
            Expanded(flex:1,child: blood),
            Expanded(flex:1,child: stool),
            Expanded(flex:1,child: fur),
            Expanded(flex:1,child: hoof),
            Expanded(flex:1,child: tusk),
            Expanded(flex:1,child: horn),
          ], 
          constraints: BoxConstraints(
            minWidth: 43
          ),
          isSelected: _selection, 
          focusNodes: focusToggle,
          onPressed: (int index){
            setState(() {
              for(int indexBtn=0; indexBtn<_selection.length;indexBtn++){
                if(indexBtn == index){
                   _selection[indexBtn] = true;
                }else{
                  _selection[indexBtn] = false;
                }
              }
            });
          },
          color: Colors.grey,
          selectedColor: Colors.white,
          selectedBorderColor: Colors.grey,
          fillColor: Colors.grey,
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize:10,
            fontFamily: 'Arciform',
          ),
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderWidth: 1,
          borderColor: Colors.grey,
        ),
    );
  }
}

Widget track = new Container(
  padding: EdgeInsets.all(0),
  margin: EdgeInsets.all(0),
  child: Text(
    "Track",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:10,
      fontFamily: 'Arciform',
    ),
  ),
);

Widget blood = new Container(
  padding: EdgeInsets.all(0),
  margin: EdgeInsets.all(0),
  child: Text(
    "Blood",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:10,
      fontFamily: 'Arciform',
    ),
  ),
);

Widget stool = new Container(
  padding: EdgeInsets.all(0),
  margin: EdgeInsets.all(0),
  child: Text(
    "Stool",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:10,
      fontFamily: 'Arciform',
    ),
  ),
);

Widget hoof = new Container(
  padding: EdgeInsets.all(0),
  margin: EdgeInsets.all(0),
  child: Text(
    "Hoof",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:10,
      fontFamily: 'Arciform',
    ),
  ),
);

Widget tusk = new Container(
  padding: EdgeInsets.all(0),
  margin: EdgeInsets.all(0),
  child: Text(
    "Tusk",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:10,
      fontFamily: 'Arciform',
    ),
  ),
);

Widget horn = new Container(
  padding: EdgeInsets.all(0),
  margin: EdgeInsets.all(0),
  child: Text(
    "Horn",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:10,
      fontFamily: 'Arciform',
    ),
  ),
);

Widget fur = new Container(
  padding: EdgeInsets.all(0),
  margin: EdgeInsets.all(0),
  child: Text(
    "Fur",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:10,
      fontFamily: 'Arciform',
    ),
  ),
);

//=============================

Widget viewMoreButton(var context)  {
  return Container(
    margin: EdgeInsets.only(right:15, left: 15, top: 5,bottom: 5,),
    width: 80,
    child: RaisedButton(
      child: buttonName,
      color: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(10),
      onPressed: (){
        // Navigator.push(context, 
        //   new MaterialPageRoute(builder: (context) => ImageView(animals: null,))
        // );
      }
    ),
  );
}

Widget buttonName = new Text(
    "UPLOAD GEOTAG",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:15,
      fontFamily: 'Arciform',
      color: Colors.white
    ),
  );









        // String addImage = """ 
        //   mutation addImg(\$class: String!, \$image: String!){
        //     AddIMG(Classification: \$class, img: \$image){
        //       Kind_Of_Picture
        //       ID
        //       URL
        //     }
        //   }
        // """;
                                  // Mutation(
                                  //   options: MutationOptions(
                                  //     documentNode: gql(addImage),
                                  //     onCompleted: (dynamic resultData){
                                  //       print(resultData.data["AddIMG"]["ID"]);
                                  //         Fluttertoast.showToast(
                                  //           msg: "Upload to Cloud Complete",
                                  //           toastLength: Toast.LENGTH_SHORT,
                                  //           gravity: ToastGravity.CENTER,
                                  //           timeInSecForIosWeb: 1,
                                  //           backgroundColor: Colors.white,
                                  //           textColor: Colors.black,
                                  //           fontSize: 16.0
                                  //         );
                                  //     }
                                  //   ),
                                  //   builder: (RunMutation runMutation,QueryResult result) {
                                  //     return IconButton(
                                  //       icon: Icon(Icons.cloud_upload),
                                  //       iconSize: 40,
                                  //       onPressed: () async{
                                  //         String url = await model.imagePicker();
                                  //         print(url);
                                  //         runMutation({
                                  //           'class':"",
                                  //           'image': url,
                                  //         });
                                  //       },
                                  //     );
                                  //   },
                                  // ),

// class FireMap extends StatefulWidget {

//   @override
//   State createState() => FireMapState();
// }

// class FireMapState extends State<FireMap> {
//   GoogleMapController mapController;
//   Position position;
//   Widget _child;

//  build(BuildContext context) {
//     return Stack(
//     children: [
//         GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: LatLng(-26.097740173,28.233989716),
//             zoom: 15
//           ),
//           onMapCreated: (GoogleMapController controller){
//               setState(() {
//                 mapController = controller;
//               });
//           },
//           myLocationEnabled: true,
//           mapType: MapType.satellite,
//           compassEnabled: true,
//         ),
//         Positioned(
//             bottom: 50,
//             left: 10,
//             child: FlatButton(
//                 child: Icon(Icons.pin_drop, color: Colors.white,),
//                 color: Colors.green,
//                 onPressed: (){
//                     var marker = Marker(
//                       icon: BitmapDescriptor.defaultMarker,
//                       infoWindow: InfoWindow(
//                         title:"Magic Marker" 
//                       ), markerId: null,
//                         //position: mapController.getScreenCoordinate(latLng)
//                     );
                  
//                 },
//             ),
//         )
//     ]);
//   }