import 'package:ERP_Ranger/core/services/api.dart';
import 'package:ERP_Ranger/ui/views/confirm/confirm_view.dart';
import 'package:ERP_Ranger/ui/views/confirm/unconfirmed_view.dart';
import 'package:ERP_Ranger/ui/views/home/animal_infoview.dart';
import '../../../core/viewmodels/home_viewmodel.dart';
import '../../../core/services/user.dart';
import 'package:flutter/material.dart';
import '../../../locator.dart';
import '../../widgets/bottom_nav.dart';
import '../base_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:provider_assist/provider_assist.dart';

List<User> holder = List<User>();
bool loaded = false;

class HomeView extends StatefulWidget {
  List<User> animal;
  HomeView({@required this.animal,});
  @override
  _HomeView createState() => _HomeView(animal: animal);
}

class _HomeView extends State<HomeView> {
  
  List<User> animal;
  _HomeView({@required this.animal,});
  int _currentTabIndex = 0;
  var quer;
  List<User> users = List();
  final Api _api = locator<Api>();
  TextEditingController editingController = TextEditingController();

  @override
  void dispose(){
    editingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    
    super.initState();
    setState(() {
      //getAnimals();
    });

  }

  Future<List<User>>getAnimals() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loaded = prefs.getBool("loaded") ?? false;
   
    if(animal == null && loaded == false){
      holder.clear();
    }
    else if(animal == null && loaded == true){
      users =await _api.getResults();
      holder.clear();
      holder.addAll(users);
    }
    else if(animal != null){
      holder.clear();
      holder.addAll(animal);
    }

    return holder;
  }

  void filterSearch(String query){
    List<User> dummySearchList = List<User>();
    dummySearchList.addAll(users);
    if(query.isNotEmpty){
      List<User> dummyListData = List<User>();
      dummySearchList.forEach((element) {
        if(element.name.toLowerCase().substring(0,query.length).contains(query.toLowerCase())){
          dummyListData.add(element);
        }
      });
      setState(() {
        holder.clear();
        holder.addAll(dummyListData);
      });
      return;
    }else{
      setState(() {
        holder.clear();
        holder.addAll(users);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigation bottomNavigation = new BottomNavigation();
    bottomNavigation.setIndex(_currentTabIndex);


    return BaseView<HomeModel>(
        builder: (context, model, child) => Scaffold(
            body: Column(
                children: <Widget>[
                      Expanded(
                        flex: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  margin: new EdgeInsets.only(top:20),
                                  height: 20,
                                  child: Text("Recent Identifications",
                                  style: TextStyle(fontSize: 25,
                                  fontFamily: 'Arciform',
                                  fontWeight: FontWeight.bold)
                                  )
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  onChanged: (value){
                                    filterSearch(value);
                                  },
                                  controller: editingController,
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    prefixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))
                                  ),

                                ),
                              ),              
                            ],
                          ),
                        ),
                      Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: loaded ? ListView.builder(
                              itemCount: holder.length,
                              itemBuilder: (BuildContext context, int index){
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(color: Colors.grey[200], width:4),
                                  ),
                                  elevation: 10,
                                  margin: EdgeInsets.all(10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, PageRouteBuilder(
                                          pageBuilder: (context, animation1, animation2) => AnimalView(holder[index]),
                                        ),);                                  
                                      },
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                              child: Container(
                                               decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),                                          
                                              child:ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Image(
                                                  image: NetworkImage(holder[index].picture[0]),
                                                  fit: BoxFit.fill,
                                                )
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: Column(
                                                    children: <Widget>[
                                                      
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:5,top:1,bottom:1,),
                                                        child: Align(alignment: Alignment.centerLeft,
                                                          child: Text(holder[index].name,
                                                            style: TextStyle(fontSize: 13,
                                                              fontFamily: 'Arciform',
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.grey
                                                            ),                                                       
                                                          ),
                                                        ),
                                                      ),                                               
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:5,top:1,bottom:1,),
                                                        child: Align(alignment: Alignment.centerLeft,
                                                          child: Text("Date: 09/09/2020",
                                                            style: TextStyle(fontSize: 13,
                                                              fontFamily: 'Arciform'
                                                            ),                                                       
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:5,top:1,bottom:1,),
                                                        child: Align(alignment: Alignment.centerLeft,
                                                          child: Text("Location: Kruger Park",
                                                            style: TextStyle(fontSize: 13,
                                                              fontFamily: 'Arciform'
                                                            ),                                                      
                                                          ),
                                                        ),
                                                      ),                                               
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:5,top:1,bottom:1,),
                                                        child: Align(alignment: Alignment.centerLeft,
                                                          child: Text("-24.019097, 31.559270",
                                                            style: TextStyle(fontSize: 13,
                                                              fontFamily: 'Arciform'
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      
                                                      
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                              child:Card(
                                                color: Colors.grey[50],
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(color: Colors.grey[100], width:3),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),                                
                                                child: Column(
                                                  children: [
                                                    Center(child: Padding(
                                                      padding: const EdgeInsets.only(right:6,left:6,top:3,bottom:1,),
                                                      child: Text(holder[index].confidence,
                                                        style: TextStyle(fontSize: 22,
                                                          fontFamily: 'Arciform'
                                                        ),                                             
                                                      ),
                                                    )),
                                                    Center(child: Padding(
                                                      padding: const EdgeInsets.only(right:6,left:6,top:3),
                                                      child: Text("Accuracy",
                                                        style: TextStyle(fontSize: 12,
                                                          fontFamily: 'Arciform'
                                                        ),                                                    
                                                      ),
                                                    )),
                                                    Center(child: Padding(
                                                      padding: const EdgeInsets.only(right:6,left:6,bottom:3,),
                                                      child: Text("Score",
                                                        style: TextStyle(fontSize: 12,
                                                          fontFamily: 'Arciform'
                                                        ),                                                   
                                                      ),
                                                    ))                                                 
                                                  ]
                                                )
                                              ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            ): FutureBuilder(
                              future: getAnimals(),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                //loaded = true;
                                return ListView.builder( 
                                  itemCount: holder.length,
                                  itemBuilder: (BuildContext context, int index){
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: BorderSide(color: Colors.grey[200], width:4),
                                      ),
                                      elevation: 10,
                                      margin: EdgeInsets.all(10),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, PageRouteBuilder(
                                              pageBuilder: (context, animation1, animation2) => AnimalView(holder[index]),
                                            ),);                                  
                                          },
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                flex: 2,
                                                  child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),                                          
                                                  child:ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: Image(
                                                      image: NetworkImage(holder[index].picture[0]),
                                                      fit: BoxFit.fill,
                                                    )
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      child: Column(
                                                        children: <Widget>[
                                                          
                                                          Padding(
                                                            padding: const EdgeInsets.only(left:5,top:1,bottom:1,),
                                                            child: Align(alignment: Alignment.centerLeft,
                                                              child: Text(holder[index].name,
                                                                style: TextStyle(fontSize: 13,
                                                                  fontFamily: 'Arciform',
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.grey
                                                                ),                                                       
                                                              ),
                                                            ),
                                                          ),                                               
                                                          Padding(
                                                            padding: const EdgeInsets.only(left:5,top:1,bottom:1,),
                                                            child: Align(alignment: Alignment.centerLeft,
                                                              child: Text("Date: 09/09/2020",
                                                                style: TextStyle(fontSize: 13,
                                                                  fontFamily: 'Arciform'
                                                                ),                                                       
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left:5,top:1,bottom:1,),
                                                            child: Align(alignment: Alignment.centerLeft,
                                                              child: Text("Location: Kruger Park",
                                                                style: TextStyle(fontSize: 13,
                                                                  fontFamily: 'Arciform'
                                                                ),                                                      
                                                              ),
                                                            ),
                                                          ),                                               
                                                          Padding(
                                                            padding: const EdgeInsets.only(left:5,top:1,bottom:1,),
                                                            child: Align(alignment: Alignment.centerLeft,
                                                              child: Text("-24.019097, 31.559270",
                                                                style: TextStyle(fontSize: 13,
                                                                  fontFamily: 'Arciform'
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          
                                                          
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                  child:Card(
                                                    color: Colors.grey[50],
                                                    shape: RoundedRectangleBorder(
                                                      side: BorderSide(color: Colors.grey[100], width:3),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),                                
                                                    child: Column(
                                                      children: [
                                                        Center(child: Padding(
                                                          padding: const EdgeInsets.only(right:6,left:6,top:3,bottom:1,),
                                                          child: Text(holder[index].confidence,
                                                            style: TextStyle(fontSize: 22,
                                                              fontFamily: 'Arciform'
                                                            ),                                             
                                                          ),
                                                        )),
                                                        Center(child: Padding(
                                                          padding: const EdgeInsets.only(right:6,left:6,top:3),
                                                          child: Text("Accuracy",
                                                            style: TextStyle(fontSize: 12,
                                                              fontFamily: 'Arciform'
                                                            ),                                                    
                                                          ),
                                                        )),
                                                        Center(child: Padding(
                                                          padding: const EdgeInsets.only(right:6,left:6,bottom:3,),
                                                          child: Text("Score",
                                                            style: TextStyle(fontSize: 12,
                                                              fontFamily: 'Arciform'
                                                            ),                                                   
                                                          ),
                                                        ))                                                 
                                                      ]
                                                    )
                                                  ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                );
                              },
                            ),
                          ),
                      )
                ],
            ),
            bottomNavigationBar: BottomNavigation(),
            floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add_a_photo),
            backgroundColor: Color(0xFFF2929C),
            tooltip: 'Pick Image',
            onPressed:()async{
                List<User> animals = await model.imagePicker();
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
          ),
        )
    );
  }

}