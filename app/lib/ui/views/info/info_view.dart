import 'package:ERP_Ranger/ui/views/home/home_view.dart';
import 'package:ERP_Ranger/ui/views/confirm/confirm_view.dart';
import 'images.dart';
import 'package:flutter/material.dart';
import '../../../core/viewmodels/info_viewmodel.dart';
import '../../widgets/bottom_nav.dart';
import '../base_view.dart';
import '../../../locator.dart';
import '../../../core/services/user.dart';
import 'package:ERP_Ranger/core/services/api.dart';
import 'dart:io';

List<User> bigFive = List<User>();
List<User> bigCats = List<User>();
List<User> bigGame = List<User>();
List<User> localList = List<User>();
List<User> localList1 = List<User>();
List<User> localList2= List<User>();
bool loaded = false;
bool loaded1 = false;
bool loaded2 = false;
  
class InfoView extends StatefulWidget {
  InfoView({Key key}) : super(key: key);

  @override
  _InfoView createState() => _InfoView();
}

class _InfoView extends State<InfoView> with SingleTickerProviderStateMixin{
  int _currentTabIndex = 1;

  List<User> users = List();
  final Api _api = locator<Api>();
  TextEditingController editingController = TextEditingController();
  TabController _controller;
  int index = 0;

  
  @override
  void dispose(){
    editingController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(vsync: this, length: 3);
    _controller.addListener(_handleTabSelection);

    setState(() {
    });

  }

  Future<List<User>> setAnimals()async{
      users = await _api.getResults();
      bigFive.clear();
      bigCats.clear();
      bigGame.clear();
      localList.clear();
      localList1.clear();
      localList2.clear();
      users.forEach((element) {
          if(element.name =="Leopard" || element.name =="Elephant" || element.name =="Lion" || element.name =="Black Rhinoceros" || element.name =="Buffalo"){
            bigFive.add(element);
            localList.add(element);
          }
          if(element.name =="Leopard" || element.name =="Lion" || element.name =="Cheetah"){
            bigCats.add(element);
            localList1.add(element);
          }
          if(element.name =="Impala"){
            bigGame.add(element);
            localList2.add(element);
          }
      });
      return bigFive;
  }

  void filterSearch(String query){
    if(index == 0){
      List<User> bfSearchUser = List<User>();
      bfSearchUser.addAll(bigFive);
      if(query.isNotEmpty){
        List<User> dummyListData = List<User>();
        bfSearchUser.forEach((element) {
          if(element.name.toLowerCase().substring(0,query.length).contains(query.toLowerCase())){
            dummyListData.add(element);
          }
        });
        setState(() {
          localList.clear();
          localList.addAll(dummyListData);
        });
        return;
      }else{
        setState(() {
          localList.clear();
          localList.addAll(bigFive);
        });
      }
    }else if (index == 1){
      List<User> bcSearchUser = List<User>();
      bcSearchUser.addAll(bigCats);
      if(query.isNotEmpty){
        List<User> dummyListData = List<User>();
        bcSearchUser.forEach((element) {
          if(element.name.toLowerCase().substring(0,query.length).contains(query.toLowerCase())){
            dummyListData.add(element);
          }
        });
        setState(() {
          localList1.clear();
          localList1.addAll(dummyListData);
        });
        return;
      }else{
        setState(() {
          localList1.clear();
          localList1.addAll(bigCats);
        });
      }
    }else if (index == 2){
      List<User> bgSearchUser = List<User>();
      bgSearchUser.addAll(bigGame);
      if(query.isNotEmpty){
        List<User> dummyListData = List<User>();
        bgSearchUser.forEach((element) {
          if(element.name.toLowerCase().substring(0,query.length).contains(query.toLowerCase())){
            dummyListData.add(element);
          }
        });
        setState(() {
          localList2.clear();
          localList2.addAll(dummyListData);
        });
        return;
      }else{
        setState(() {
          localList2.clear();
          localList2.addAll(bigGame);
        });
      }
    }
  }

  _handleTabSelection(){
      setState(() {
        index = _controller.index;
      });
    
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigation bottomNavigation = new BottomNavigation();
    bottomNavigation.setIndex(_currentTabIndex);

    Future<bool> _onBackPressed() async{
      Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
    }

      return BaseView<InfoModel>(
        builder: (context, model, child) => DefaultTabController(
          length: 3,
          child: Scaffold(
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
                                  child: Text("Animal infomation",
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
                              TabBar(
                                indicatorColor: Colors.grey,
                                indicatorWeight: 5,
                                controller: _controller,
                                tabs: <Widget>[
                                  Tab(child: Text('Big Five',
                                        style: TextStyle(fontSize: 15,
                                        fontFamily: 'Arciform',
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold  
                                        ),
                                      ),
                                    ),
                                  Tab(child: Text('Big Cats',
                                      style: TextStyle(fontSize: 15,
                                        fontFamily: 'Arciform',
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold  
                                      ),
                                    ),
                                  ),
                                  Tab(child: Text('Big Game',
                                      style: TextStyle(fontSize: 15,
                                        fontFamily: 'Arciform',
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold  
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                            ),
                            child: TabBarView(
                              controller: _controller,
                              children: [
                                new WillPopScope(
                                    onWillPop: _onBackPressed,
                                    child: Scaffold(
                                      body: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                        Expanded(
                                          child: loaded ? ListView.builder(
                                          padding: EdgeInsets.all(10.0),
                                          itemCount:localList.length,
                                          itemBuilder: (BuildContext context, int index){
                                            return Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15.0),
                                                  side: BorderSide(color: Colors.grey[200], width:4),
                                              ),
                                              color: Colors.white,
                                              elevation:10,
                                              child: Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        flex:0,
                                                        child: Container(
                                                          height: 100,
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(10),
                                                            child: Image(
                                                              image: AssetImage('assets/images/logo.jpeg',
                                                            ),
                                                            fit: BoxFit.fill,
                                                            )
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          child: Column(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding: const EdgeInsets.all(4.0),
                                                                child: Text(localList[index].name,
                                                                  style: TextStyle(fontSize: 23,
                                                                    fontFamily: 'Arciform',
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.grey
                                                                  )                                     
                                                                ),
                                                              ),
                                                              Row(children: <Widget>[
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Container(
                                                                        child: Row(
                                                                          children: <Widget>[
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Container(
                                                                                child: Text('Size: ',
                                                                                style: TextStyle(fontSize: 11,
                                                                                    fontFamily: 'Arciform',
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Colors.grey
                                                                                  )  
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 2,
                                                                                child: Container(
                                                                                alignment: Alignment.bottomCenter,
                                                                                child: Column(children: <Widget>[
                                                                                  Row(children: <Widget>[
                                                                                      Text(localList[index].heightF+"m",
                                                                                      style: TextStyle(fontSize: 11,
                                                                                            fontFamily: 'Arciform',
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: Colors.grey
                                                                                          )  
                                                                                        ),
                                                                                      //Icon(Icons.ac_unit)
                                                                                  ],),
                                                                                  Row(children: <Widget>[
                                                                                      Text(localList[index].heightM+"m",
                                                                                      style: TextStyle(fontSize: 11,
                                                                                            fontFamily: 'Arciform',
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: Colors.grey
                                                                                          )  
                                                                                        ),
                                                                                    //Icon(Icons.ac_unit)
                                                                                  ],),
                                                                                ],),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ),  
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Container(
                                                                        child: Row(
                                                                          children: <Widget>[
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Container(
                                                                                child: Text('Weight: ',
                                                                                style: TextStyle(fontSize: 11,
                                                                                    fontFamily: 'Arciform',
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Colors.grey
                                                                                  )  
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 2,
                                                                                child: Container(
                                                                                alignment: Alignment.bottomCenter,
                                                                                child: Column(children: <Widget>[
                                                                                  Row(children: <Widget>[
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left:8.0),
                                                                                        child: Text(localList[index].weightF+"kg",
                                                                                        style: TextStyle(fontSize: 11,
                                                                                              fontFamily: 'Arciform',
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: Colors.grey
                                                                                            )  
                                                                                          ),
                                                                                      ),
                                                                                      //Icon(Icons.ac_unit)
                                                                                  ],),
                                                                                  Row(children: <Widget>[
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left:8.0),
                                                                                        child: Text(localList[index].weightM+"kg",
                                                                                        style: TextStyle(fontSize: 11,
                                                                                              fontFamily: 'Arciform',
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: Colors.grey
                                                                                            )  
                                                                                          ),
                                                                                      ),
                                                                                    //Icon(Icons.ac_unit)
                                                                                  ],),
                                                                                ],),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ),                                                                                         
                                                              ],),
                                                              Row(children: <Widget>[
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Container(
                                                                        child: Text('Diet: '+localList[index].diet,
                                                                        style: TextStyle(fontSize: 13,
                                                                            fontFamily: 'Arciform',
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.grey
                                                                          )  
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(4.0),
                                                                      child: Container(
                                                                        child: Text('Gestation: '+localList[index].gestation,
                                                                        style: TextStyle(fontSize: 13,
                                                                            fontFamily: 'Arciform',
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.grey
                                                                          )  
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ),
                                                              ],)                                         
                                                          ],),
                                                        ),
                                                      )
                                                      ],
                                                    ),
                                                  Container(
                                                    child: Column(
                                                      children: <Widget>[
                                                        ExpansionTile(
                                                          title: Text("Description",
                                                          style: TextStyle(fontSize: 17,
                                                              fontFamily: 'Arciform',
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.grey     
                                                            )                         
                                                          ),
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: const EdgeInsets.only(left:8.0),
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                child: Center(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(left:8.0, bottom:8.0),
                                                                    child: Text("The African Elephant is the largest mammal in the world and the largest of the three elephant species.  They can live up to 70 years - longer than any other mammal except humans.",
                                                                      style: TextStyle(fontSize: 12,
                                                                        fontFamily: 'Arciform',
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.grey                                              
                                                                      )
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        ExpansionTile(
                                                          title: Text("Behavioural Information",
                                                            style: TextStyle(fontSize: 17,
                                                                fontFamily: 'Arciform',
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.grey     
                                                            )                                      
                                                          ),
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: const EdgeInsets.only(left:8.0),
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                child: Center(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(left:8.0, bottom:8.0),
                                                                    child: Text(localList[index].behaviour,
                                                                      style: TextStyle(fontSize: 12,
                                                                        fontFamily: 'Arciform',
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.grey                                              
                                                                      )
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],                                     
                                                        ),
                                                        ExpansionTile(
                                                          title: Text("Habitat",
                                                            style: TextStyle(fontSize: 17,
                                                                fontFamily: 'Arciform',
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.grey     
                                                              )                                     
                                                          ),
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: const EdgeInsets.only(left:8.0),
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                child: Center(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(left:8.0, bottom:8.0),
                                                                    child: Text("The African Elephant is the largest mammal in the world and the largest of the three elephant species.  They can live up to 70 years - longer than any other mammal except humans.",
                                                                      style: TextStyle(fontSize: 12,
                                                                        fontFamily: 'Arciform',
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.grey                                              
                                                                      )
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],                                    
                                                        ),
                                                      ],),
                                                    ), 
                                                    SizedBox(height: 0.0,),
                                                    FlatButton(
                                                        child: Center(
                                                            child: Text(
                                                          'View More',
                                                            style: TextStyle(fontSize: 15,
                                                            fontFamily: 'Arciform'),
                                                          )
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15),
                                                        ),
                                                        onPressed: (){
                                                          Navigator.push(context, PageRouteBuilder(
                                                            pageBuilder: (context, animation1, animation2) => ImagesView(animals: localList),
                                                          ),);
                                                        },
                                                        color: Colors.black12,
                                                        highlightColor: Colors.grey,
                                                        padding: EdgeInsets.all(8.0),
                                                    ), 
                                                  
                                                  ],
                                                ),
                                              )
                                              );
                                            },
                                          ) : FutureBuilder(
                                              future: setAnimals(),
                                              builder: (BuildContext context, AsyncSnapshot snapshot){
                                                loaded = true;
                                                return ListView.builder(
                                                  padding: EdgeInsets.all(10.0),
                                                  itemCount:localList.length,
                                                  itemBuilder: (BuildContext context, int index){
                                                    return Card(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15.0),
                                                      ),
                                                      color: Colors.white,
                                                      elevation:10,
                                                      child: Padding(
                                                        padding: EdgeInsets.all(10.0),
                                                        child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Row(
                                                            children: <Widget>[
                                                              Expanded(
                                                                flex:0,
                                                                child: Container(
                                                                  height: 100,
                                                                  child: ClipRRect(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    child: Image(
                                                                      image: AssetImage('assets/images/logo.jpeg',
                                                                    ),
                                                                    fit: BoxFit.fill,
                                                                    )
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child: Container(
                                                                  child: Column(
                                                                    children: <Widget>[
                                                                      Padding(
                                                                        padding: const EdgeInsets.all(4.0),
                                                                        child: Text(localList[index].name,
                                                                          style: TextStyle(fontSize: 23,
                                                                            fontFamily: 'Arciform',
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.grey
                                                                          )                                     
                                                                        ),
                                                                      ),
                                                                      Row(children: <Widget>[
                                                                          Expanded(
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Container(
                                                                                child: Row(
                                                                                  children: <Widget>[
                                                                                    Expanded(
                                                                                      flex: 1,
                                                                                      child: Container(
                                                                                        child: Text('Size: ',
                                                                                        style: TextStyle(fontSize: 11,
                                                                                            fontFamily: 'Arciform',
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: Colors.grey
                                                                                          )  
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      flex: 2,
                                                                                        child: Container(
                                                                                        alignment: Alignment.bottomCenter,
                                                                                        child: Column(children: <Widget>[
                                                                                          Row(children: <Widget>[
                                                                                              Text(localList[index].heightF+"m",
                                                                                              style: TextStyle(fontSize: 11,
                                                                                                    fontFamily: 'Arciform',
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                    color: Colors.grey
                                                                                                  )  
                                                                                                ),
                                                                                              //Icon(Icons.ac_unit)
                                                                                          ],),
                                                                                          Row(children: <Widget>[
                                                                                              Text(localList[index].heightM+"m",
                                                                                              style: TextStyle(fontSize: 11,
                                                                                                    fontFamily: 'Arciform',
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                    color: Colors.grey
                                                                                                  )  
                                                                                                ),
                                                                                            //Icon(Icons.ac_unit)
                                                                                          ],),
                                                                                        ],),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ),  
                                                                          Expanded(
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Container(
                                                                                child: Row(
                                                                                  children: <Widget>[
                                                                                    Expanded(
                                                                                      flex: 1,
                                                                                      child: Container(
                                                                                        child: Text('Weight: ',
                                                                                        style: TextStyle(fontSize: 11,
                                                                                            fontFamily: 'Arciform',
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: Colors.grey
                                                                                          )  
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      flex: 2,
                                                                                        child: Container(
                                                                                        alignment: Alignment.bottomCenter,
                                                                                        child: Column(children: <Widget>[
                                                                                          Row(children: <Widget>[
                                                                                              Padding(
                                                                                                padding: const EdgeInsets.only(left:8.0),
                                                                                                child: Text(localList[index].weightF+"kg",
                                                                                                style: TextStyle(fontSize: 11,
                                                                                                      fontFamily: 'Arciform',
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                      color: Colors.grey
                                                                                                    )  
                                                                                                  ),
                                                                                              ),
                                                                                              //Icon(Icons.ac_unit)
                                                                                          ],),
                                                                                          Row(children: <Widget>[
                                                                                              Padding(
                                                                                                padding: const EdgeInsets.only(left:8.0),
                                                                                                child: Text(localList[index].weightM+"kg",
                                                                                                style: TextStyle(fontSize: 11,
                                                                                                      fontFamily: 'Arciform',
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                      color: Colors.grey
                                                                                                    )  
                                                                                                  ),
                                                                                              ),
                                                                                            //Icon(Icons.ac_unit)
                                                                                          ],),
                                                                                        ],),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ),                                                                                         
                                                                      ],),
                                                                      Row(children: <Widget>[
                                                                          Expanded(
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Container(
                                                                                child: Text('Diet: '+localList[index].diet,
                                                                                style: TextStyle(fontSize: 13,
                                                                                    fontFamily: 'Arciform',
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Colors.grey
                                                                                  )  
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ),
                                                                          Expanded(
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(4.0),
                                                                              child: Container(
                                                                                child: Text('Gestation: '+localList[index].gestation,
                                                                                style: TextStyle(fontSize: 13,
                                                                                    fontFamily: 'Arciform',
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Colors.grey
                                                                                  )  
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ),
                                                                      ],)                                         
                                                                  ],),
                                                                ),
                                                              )
                                                              ],
                                                            ),
                                                          Container(
                                                            child: Column(
                                                              children: <Widget>[
                                                                ExpansionTile(
                                                                  title: Text("Description",
                                                                  style: TextStyle(fontSize: 17,
                                                                      fontFamily: 'Arciform',
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.grey     
                                                                    )                         
                                                                  ),
                                                                  children: <Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left:8.0),
                                                                      child: Container(
                                                                        alignment: Alignment.center,
                                                                        child: Center(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.only(left:8.0, bottom:8.0),
                                                                            child: Text("The African Elephant is the largest mammal in the world and the largest of the three elephant species.  They can live up to 70 years - longer than any other mammal except humans.",
                                                                              style: TextStyle(fontSize: 12,
                                                                                fontFamily: 'Arciform',
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.grey                                              
                                                                              )
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                ExpansionTile(
                                                                  title: Text("Behavioural Information",
                                                                    style: TextStyle(fontSize: 17,
                                                                        fontFamily: 'Arciform',
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.grey     
                                                                    )                                      
                                                                  ),
                                                                  children: <Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left:8.0),
                                                                      child: Container(
                                                                        alignment: Alignment.center,
                                                                        child: Center(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.only(left:8.0, bottom:8.0),
                                                                            child: Text(localList[index].behaviour,
                                                                              style: TextStyle(fontSize: 12,
                                                                                fontFamily: 'Arciform',
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.grey                                              
                                                                              )
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],                                     
                                                                ),
                                                                ExpansionTile(
                                                                  title: Text("Habitat",
                                                                    style: TextStyle(fontSize: 17,
                                                                        fontFamily: 'Arciform',
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.grey     
                                                                      )                                     
                                                                  ),
                                                                  children: <Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left:8.0),
                                                                      child: Container(
                                                                        alignment: Alignment.center,
                                                                        child: Center(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.only(left:8.0, bottom:8.0),
                                                                            child: Text("The African Elephant is the largest mammal in the world and the largest of the three elephant species.  They can live up to 70 years - longer than any other mammal except humans.",
                                                                              style: TextStyle(fontSize: 12,
                                                                                fontFamily: 'Arciform',
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.grey                                              
                                                                              )
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],                                    
                                                                ),
                                                              ],),
                                                            ), 
                                                            SizedBox(height: 0.0,),
                                                            FlatButton(
                                                                child: Center(
                                                                    child: Text(
                                                                  'View More',
                                                                    style: TextStyle(fontSize: 15,
                                                                    fontFamily: 'Arciform'),
                                                                  )
                                                                ),
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(15),
                                                                ),
                                                                onPressed: (){
                                                                  Navigator.push(context, PageRouteBuilder(
                                                                    pageBuilder: (context, animation1, animation2) => ImagesView(animals: localList),
                                                                  ),);
                                                                },
                                                                color: Colors.black12,
                                                                highlightColor: Colors.grey,
                                                                padding: EdgeInsets.all(8.0),
                                                            ), 
                                                          
                                                          ],
                                                        ),
                                                      )
                                                      );
                                                    },
                                                  );
                                            }
                                          )
                                        ),
                                      ],
                                    ),
                                ),
                              ),
                                new WillPopScope(
                                    onWillPop: _onBackPressed,
                                    child: Scaffold(
                                      body: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                        Expanded(
                                          child: loaded1 ? ListView.builder(
                                          padding: EdgeInsets.all(10.0),
                                          itemCount:localList1.length,
                                          itemBuilder: (BuildContext context, int index){
                                            return Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15.0),
                                                  side: BorderSide(color: Colors.grey[200], width:4),
                                              ),
                                              color: Colors.white,
                                              elevation:10,
                                              child: Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        flex:0,
                                                        child: Container(
                                                          height: 100,
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(10),
                                                            child: Image(
                                                              image: AssetImage('assets/images/logo.jpeg',
                                                            ),
                                                            fit: BoxFit.fill,
                                                            )
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          child: Column(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding: const EdgeInsets.all(4.0),
                                                                child: Text(localList1[index].name,
                                                                  style: TextStyle(fontSize: 23,
                                                                    fontFamily: 'Arciform',
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.grey
                                                                  )                                     
                                                                ),
                                                              ),
                                                              Row(children: <Widget>[
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Container(
                                                                        child: Row(
                                                                          children: <Widget>[
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Container(
                                                                                child: Text('Size: ',
                                                                                style: TextStyle(fontSize: 11,
                                                                                    fontFamily: 'Arciform',
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Colors.grey
                                                                                  )  
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 2,
                                                                                child: Container(
                                                                                alignment: Alignment.bottomCenter,
                                                                                child: Column(children: <Widget>[
                                                                                  Row(children: <Widget>[
                                                                                      Text(localList1[index].heightF+"m",
                                                                                      style: TextStyle(fontSize: 11,
                                                                                            fontFamily: 'Arciform',
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: Colors.grey
                                                                                          )  
                                                                                        ),
                                                                                      //Icon(Icons.ac_unit)
                                                                                  ],),
                                                                                  Row(children: <Widget>[
                                                                                      Text(localList1[index].heightM+"m",
                                                                                      style: TextStyle(fontSize: 11,
                                                                                            fontFamily: 'Arciform',
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: Colors.grey
                                                                                          )  
                                                                                        ),
                                                                                    //Icon(Icons.ac_unit)
                                                                                  ],),
                                                                                ],),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ),  
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Container(
                                                                        child: Row(
                                                                          children: <Widget>[
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Container(
                                                                                child: Text('Weight: ',
                                                                                style: TextStyle(fontSize: 11,
                                                                                    fontFamily: 'Arciform',
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Colors.grey
                                                                                  )  
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 2,
                                                                                child: Container(
                                                                                alignment: Alignment.bottomCenter,
                                                                                child: Column(children: <Widget>[
                                                                                  Row(children: <Widget>[
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left:8.0),
                                                                                        child: Text(localList1[index].weightF+"kg",
                                                                                        style: TextStyle(fontSize: 11,
                                                                                              fontFamily: 'Arciform',
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: Colors.grey
                                                                                            )  
                                                                                          ),
                                                                                      ),
                                                                                      //Icon(Icons.ac_unit)
                                                                                  ],),
                                                                                  Row(children: <Widget>[
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left:8.0),
                                                                                        child: Text(localList1[index].weightM+"kg",
                                                                                        style: TextStyle(fontSize: 11,
                                                                                              fontFamily: 'Arciform',
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: Colors.grey
                                                                                            )  
                                                                                          ),
                                                                                      ),
                                                                                    //Icon(Icons.ac_unit)
                                                                                  ],),
                                                                                ],),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ),                                                                                         
                                                              ],),
                                                              Row(children: <Widget>[
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Container(
                                                                        child: Text('Diet: '+localList1[index].diet,
                                                                        style: TextStyle(fontSize: 13,
                                                                            fontFamily: 'Arciform',
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.grey
                                                                          )  
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(4.0),
                                                                      child: Container(
                                                                        child: Text('Gestation: '+localList1[index].gestation,
                                                                        style: TextStyle(fontSize: 13,
                                                                            fontFamily: 'Arciform',
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.grey
                                                                          )  
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ),
                                                              ],)                                         
                                                          ],),
                                                        ),
                                                      )
                                                      ],
                                                    ),
                                                  Container(
                                                    child: Column(
                                                      children: <Widget>[
                                                        ExpansionTile(
                                                          title: Text("Description",
                                                          style: TextStyle(fontSize: 17,
                                                              fontFamily: 'Arciform',
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.grey     
                                                            )                         
                                                          ),
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: const EdgeInsets.only(left:8.0),
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                child: Center(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(left:8.0, bottom:8.0),
                                                                    child: Text("The African Elephant is the largest mammal in the world and the largest of the three elephant species.  They can live up to 70 years - longer than any other mammal except humans.",
                                                                      style: TextStyle(fontSize: 12,
                                                                        fontFamily: 'Arciform',
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.grey                                              
                                                                      )
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        ExpansionTile(
                                                          title: Text("Behavioural Information",
                                                            style: TextStyle(fontSize: 17,
                                                                fontFamily: 'Arciform',
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.grey     
                                                            )                                      
                                                          ),
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: const EdgeInsets.only(left:8.0),
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                child: Center(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(left:8.0, bottom:8.0),
                                                                    child: Text(localList1[index].behaviour,
                                                                      style: TextStyle(fontSize: 12,
                                                                        fontFamily: 'Arciform',
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.grey                                              
                                                                      )
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],                                     
                                                        ),
                                                        ExpansionTile(
                                                          title: Text("Habitat",
                                                            style: TextStyle(fontSize: 17,
                                                                fontFamily: 'Arciform',
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.grey     
                                                              )                                     
                                                          ),
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: const EdgeInsets.only(left:8.0),
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                child: Center(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(left:8.0, bottom:8.0),
                                                                    child: Text("The African Elephant is the largest mammal in the world and the largest of the three elephant species.  They can live up to 70 years - longer than any other mammal except humans.",
                                                                      style: TextStyle(fontSize: 12,
                                                                        fontFamily: 'Arciform',
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.grey                                              
                                                                      )
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],                                    
                                                        ),
                                                      ],),
                                                    ), 
                                                    SizedBox(height: 0.0,),
                                                    FlatButton(
                                                        child: Center(
                                                            child: Text(
                                                          'View More',
                                                            style: TextStyle(fontSize: 15,
                                                            fontFamily: 'Arciform'),
                                                          )
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15),
                                                        ),
                                                        onPressed: (){
                                                          Navigator.push(context, PageRouteBuilder(
                                                            pageBuilder: (context, animation1, animation2) => ImagesView(animals: localList1),
                                                          ),);
                                                        },
                                                        color: Colors.black12,
                                                        highlightColor: Colors.grey,
                                                        padding: EdgeInsets.all(8.0),
                                                    ), 
                                                  
                                                  ],
                                                ),
                                              )
                                              );
                                            },
                                          ) : FutureBuilder(
                                              future: setAnimals(),
                                              builder: (BuildContext context, AsyncSnapshot snapshot){
                                                loaded1 = true;
                                                return ListView.builder(
                                                  padding: EdgeInsets.all(10.0),
                                                  itemCount:localList1.length,
                                                  itemBuilder: (BuildContext context, int index){
                                                    return Card(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15.0),
                                                      ),
                                                      color: Colors.white,
                                                      elevation:10,
                                                      child: Padding(
                                                        padding: EdgeInsets.all(10.0),
                                                        child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Row(
                                                            children: <Widget>[
                                                              Expanded(
                                                                flex:0,
                                                                child: Container(
                                                                  height: 100,
                                                                  child: ClipRRect(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    child: Image(
                                                                      image: AssetImage('assets/images/logo.jpeg',
                                                                    ),
                                                                    fit: BoxFit.fill,
                                                                    )
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child: Container(
                                                                  child: Column(
                                                                    children: <Widget>[
                                                                      Padding(
                                                                        padding: const EdgeInsets.all(4.0),
                                                                        child: Text(localList1[index].name,
                                                                          style: TextStyle(fontSize: 23,
                                                                            fontFamily: 'Arciform',
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.grey
                                                                          )                                     
                                                                        ),
                                                                      ),
                                                                      Row(children: <Widget>[
                                                                          Expanded(
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Container(
                                                                                child: Row(
                                                                                  children: <Widget>[
                                                                                    Expanded(
                                                                                      flex: 1,
                                                                                      child: Container(
                                                                                        child: Text('Size: ',
                                                                                        style: TextStyle(fontSize: 11,
                                                                                            fontFamily: 'Arciform',
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: Colors.grey
                                                                                          )  
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      flex: 2,
                                                                                        child: Container(
                                                                                        alignment: Alignment.bottomCenter,
                                                                                        child: Column(children: <Widget>[
                                                                                          Row(children: <Widget>[
                                                                                              Text(localList1[index].heightF+"m",
                                                                                              style: TextStyle(fontSize: 11,
                                                                                                    fontFamily: 'Arciform',
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                    color: Colors.grey
                                                                                                  )  
                                                                                                ),
                                                                                              //Icon(Icons.ac_unit)
                                                                                          ],),
                                                                                          Row(children: <Widget>[
                                                                                              Text(localList1[index].heightM+"m",
                                                                                              style: TextStyle(fontSize: 11,
                                                                                                    fontFamily: 'Arciform',
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                    color: Colors.grey
                                                                                                  )  
                                                                                                ),
                                                                                            //Icon(Icons.ac_unit)
                                                                                          ],),
                                                                                        ],),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ),  
                                                                          Expanded(
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Container(
                                                                                child: Row(
                                                                                  children: <Widget>[
                                                                                    Expanded(
                                                                                      flex: 1,
                                                                                      child: Container(
                                                                                        child: Text('Weight: ',
                                                                                        style: TextStyle(fontSize: 11,
                                                                                            fontFamily: 'Arciform',
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: Colors.grey
                                                                                          )  
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      flex: 2,
                                                                                        child: Container(
                                                                                        alignment: Alignment.bottomCenter,
                                                                                        child: Column(children: <Widget>[
                                                                                          Row(children: <Widget>[
                                                                                              Padding(
                                                                                                padding: const EdgeInsets.only(left:8.0),
                                                                                                child: Text(localList1[index].weightF+"kg",
                                                                                                style: TextStyle(fontSize: 11,
                                                                                                      fontFamily: 'Arciform',
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                      color: Colors.grey
                                                                                                    )  
                                                                                                  ),
                                                                                              ),
                                                                                              //Icon(Icons.ac_unit)
                                                                                          ],),
                                                                                          Row(children: <Widget>[
                                                                                              Padding(
                                                                                                padding: const EdgeInsets.only(left:8.0),
                                                                                                child: Text(localList1[index].weightM+"kg",
                                                                                                style: TextStyle(fontSize: 11,
                                                                                                      fontFamily: 'Arciform',
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                      color: Colors.grey
                                                                                                    )  
                                                                                                  ),
                                                                                              ),
                                                                                            //Icon(Icons.ac_unit)
                                                                                          ],),
                                                                                        ],),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ),                                                                                         
                                                                      ],),
                                                                      Row(children: <Widget>[
                                                                          Expanded(
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Container(
                                                                                child: Text('Diet: '+localList1[index].diet,
                                                                                style: TextStyle(fontSize: 13,
                                                                                    fontFamily: 'Arciform',
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Colors.grey
                                                                                  )  
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ),
                                                                          Expanded(
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(4.0),
                                                                              child: Container(
                                                                                child: Text('Gestation: '+localList1[index].gestation,
                                                                                style: TextStyle(fontSize: 13,
                                                                                    fontFamily: 'Arciform',
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Colors.grey
                                                                                  )  
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ),
                                                                      ],)                                         
                                                                  ],),
                                                                ),
                                                              )
                                                              ],
                                                            ),
                                                          Container(
                                                            child: Column(
                                                              children: <Widget>[
                                                                ExpansionTile(
                                                                  title: Text("Description",
                                                                  style: TextStyle(fontSize: 17,
                                                                      fontFamily: 'Arciform',
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.grey     
                                                                    )                         
                                                                  ),
                                                                  children: <Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left:8.0),
                                                                      child: Container(
                                                                        alignment: Alignment.center,
                                                                        child: Center(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.only(left:8.0, bottom:8.0),
                                                                            child: Text("The African Elephant is the largest mammal in the world and the largest of the three elephant species.  They can live up to 70 years - longer than any other mammal except humans.",
                                                                              style: TextStyle(fontSize: 12,
                                                                                fontFamily: 'Arciform',
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.grey                                              
                                                                              )
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                ExpansionTile(
                                                                  title: Text("Behavioural Information",
                                                                    style: TextStyle(fontSize: 17,
                                                                        fontFamily: 'Arciform',
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.grey     
                                                                    )                                      
                                                                  ),
                                                                  children: <Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left:8.0),
                                                                      child: Container(
                                                                        alignment: Alignment.center,
                                                                        child: Center(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.only(left:8.0, bottom:8.0),
                                                                            child: Text(localList1[index].behaviour,
                                                                              style: TextStyle(fontSize: 12,
                                                                                fontFamily: 'Arciform',
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.grey                                              
                                                                              )
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],                                     
                                                                ),
                                                                ExpansionTile(
                                                                  title: Text("Habitat",
                                                                    style: TextStyle(fontSize: 17,
                                                                        fontFamily: 'Arciform',
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.grey     
                                                                      )                                     
                                                                  ),
                                                                  children: <Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left:8.0),
                                                                      child: Container(
                                                                        alignment: Alignment.center,
                                                                        child: Center(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.only(left:8.0, bottom:8.0),
                                                                            child: Text("The African Elephant is the largest mammal in the world and the largest of the three elephant species.  They can live up to 70 years - longer than any other mammal except humans.",
                                                                              style: TextStyle(fontSize: 12,
                                                                                fontFamily: 'Arciform',
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.grey                                              
                                                                              )
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],                                    
                                                                ),
                                                              ],),
                                                            ), 
                                                            SizedBox(height: 0.0,),
                                                            FlatButton(
                                                                child: Center(
                                                                    child: Text(
                                                                  'View More',
                                                                    style: TextStyle(fontSize: 15,
                                                                    fontFamily: 'Arciform'),
                                                                  )
                                                                ),
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(15),
                                                                ),
                                                                onPressed: (){
                                                                  Navigator.push(context, PageRouteBuilder(
                                                                    pageBuilder: (context, animation1, animation2) => ImagesView(animals: localList1),
                                                                  ),);
                                                                },
                                                                color: Colors.black12,
                                                                highlightColor: Colors.grey,
                                                                padding: EdgeInsets.all(8.0),
                                                            ), 
                                                          
                                                          ],
                                                        ),
                                                      )
                                                      );
                                                    },
                                                  );
                                            }
                                          )
                                        ),
                                      ],
                                    ),
                                ),
                              ),
                                new WillPopScope(
                                    onWillPop: _onBackPressed,
                                    child: Scaffold(
                                      body: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                        Expanded(
                                          child: loaded2 ? ListView.builder(
                                          padding: EdgeInsets.all(10.0),
                                          itemCount:localList2.length,
                                          itemBuilder: (BuildContext context, int index){
                                            return Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15.0),
                                                  side: BorderSide(color: Colors.grey[200], width:4),
                                              ),
                                              color: Colors.white,
                                              elevation:10,
                                              child: Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        flex:0,
                                                        child: Container(
                                                          height: 100,
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(10),
                                                            child: Image(
                                                              image: AssetImage('assets/images/logo.jpeg',
                                                            ),
                                                            fit: BoxFit.fill,
                                                            )
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          child: Column(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding: const EdgeInsets.all(4.0),
                                                                child: Text(localList2[index].name,
                                                                  style: TextStyle(fontSize: 23,
                                                                    fontFamily: 'Arciform',
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.grey
                                                                  )                                     
                                                                ),
                                                              ),
                                                              Row(children: <Widget>[
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Container(
                                                                        child: Row(
                                                                          children: <Widget>[
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Container(
                                                                                child: Text('Size: ',
                                                                                style: TextStyle(fontSize: 11,
                                                                                    fontFamily: 'Arciform',
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Colors.grey
                                                                                  )  
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 2,
                                                                                child: Container(
                                                                                alignment: Alignment.bottomCenter,
                                                                                child: Column(children: <Widget>[
                                                                                  Row(children: <Widget>[
                                                                                      Text(localList2[index].heightF+"m",
                                                                                      style: TextStyle(fontSize: 11,
                                                                                            fontFamily: 'Arciform',
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: Colors.grey
                                                                                          )  
                                                                                        ),
                                                                                      //Icon(Icons.ac_unit)
                                                                                  ],),
                                                                                  Row(children: <Widget>[
                                                                                      Text(localList2[index].heightM+"m",
                                                                                      style: TextStyle(fontSize: 11,
                                                                                            fontFamily: 'Arciform',
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: Colors.grey
                                                                                          )  
                                                                                        ),
                                                                                    //Icon(Icons.ac_unit)
                                                                                  ],),
                                                                                ],),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ),  
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Container(
                                                                        child: Row(
                                                                          children: <Widget>[
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Container(
                                                                                child: Text('Weight: ',
                                                                                style: TextStyle(fontSize: 11,
                                                                                    fontFamily: 'Arciform',
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Colors.grey
                                                                                  )  
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 2,
                                                                                child: Container(
                                                                                alignment: Alignment.bottomCenter,
                                                                                child: Column(children: <Widget>[
                                                                                  Row(children: <Widget>[
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left:8.0),
                                                                                        child: Text(localList2[index].weightF+"kg",
                                                                                        style: TextStyle(fontSize: 11,
                                                                                              fontFamily: 'Arciform',
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: Colors.grey
                                                                                            )  
                                                                                          ),
                                                                                      ),
                                                                                      //Icon(Icons.ac_unit)
                                                                                  ],),
                                                                                  Row(children: <Widget>[
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left:8.0),
                                                                                        child: Text(localList2[index].weightM+"kg",
                                                                                        style: TextStyle(fontSize: 11,
                                                                                              fontFamily: 'Arciform',
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: Colors.grey
                                                                                            )  
                                                                                          ),
                                                                                      ),
                                                                                    //Icon(Icons.ac_unit)
                                                                                  ],),
                                                                                ],),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ),                                                                                         
                                                              ],),
                                                              Row(children: <Widget>[
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Container(
                                                                        child: Text('Diet: '+localList2[index].diet,
                                                                        style: TextStyle(fontSize: 13,
                                                                            fontFamily: 'Arciform',
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.grey
                                                                          )  
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(4.0),
                                                                      child: Container(
                                                                        child: Text('Gestation: '+localList2[index].gestation,
                                                                        style: TextStyle(fontSize: 13,
                                                                            fontFamily: 'Arciform',
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.grey
                                                                          )  
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ),
                                                              ],)                                         
                                                          ],),
                                                        ),
                                                      )
                                                      ],
                                                    ),
                                                  Container(
                                                    child: Column(
                                                      children: <Widget>[
                                                        ExpansionTile(
                                                          title: Text("Description",
                                                          style: TextStyle(fontSize: 17,
                                                              fontFamily: 'Arciform',
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.grey     
                                                            )                         
                                                          ),
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: const EdgeInsets.only(left:8.0),
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                child: Center(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(left:8.0, bottom:8.0),
                                                                    child: Text("The African Elephant is the largest mammal in the world and the largest of the three elephant species.  They can live up to 70 years - longer than any other mammal except humans.",
                                                                      style: TextStyle(fontSize: 12,
                                                                        fontFamily: 'Arciform',
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.grey                                              
                                                                      )
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        ExpansionTile(
                                                          title: Text("Behavioural Information",
                                                            style: TextStyle(fontSize: 17,
                                                                fontFamily: 'Arciform',
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.grey     
                                                            )                                      
                                                          ),
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: const EdgeInsets.only(left:8.0),
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                child: Center(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(left:8.0, bottom:8.0),
                                                                    child: Text(localList2[index].behaviour,
                                                                      style: TextStyle(fontSize: 12,
                                                                        fontFamily: 'Arciform',
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.grey                                              
                                                                      )
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],                                     
                                                        ),
                                                        ExpansionTile(
                                                          title: Text("Habitat",
                                                            style: TextStyle(fontSize: 17,
                                                                fontFamily: 'Arciform',
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.grey     
                                                              )                                     
                                                          ),
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: const EdgeInsets.only(left:8.0),
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                child: Center(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(left:8.0, bottom:8.0),
                                                                    child: Text("The African Elephant is the largest mammal in the world and the largest of the three elephant species.  They can live up to 70 years - longer than any other mammal except humans.",
                                                                      style: TextStyle(fontSize: 12,
                                                                        fontFamily: 'Arciform',
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.grey                                              
                                                                      )
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],                                    
                                                        ),
                                                      ],),
                                                    ), 
                                                    SizedBox(height: 0.0,),
                                                    FlatButton(
                                                        child: Center(
                                                            child: Text(
                                                          'View More',
                                                            style: TextStyle(fontSize: 15,
                                                            fontFamily: 'Arciform'),
                                                          )
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15),
                                                        ),
                                                        onPressed: (){
                                                          Navigator.push(context, PageRouteBuilder(
                                                            pageBuilder: (context, animation1, animation2) => ImagesView(animals: localList2),
                                                          ),);
                                                        },
                                                        color: Colors.black12,
                                                        highlightColor: Colors.grey,
                                                        padding: EdgeInsets.all(8.0),
                                                    ), 
                                                  
                                                  ],
                                                ),
                                              )
                                              );
                                            },
                                          ) : FutureBuilder(
                                              future: setAnimals(),
                                              builder: (BuildContext context, AsyncSnapshot snapshot){
                                                loaded2 = true;
                                                return ListView.builder(
                                                  padding: EdgeInsets.all(10.0),
                                                  itemCount:localList2.length,
                                                  itemBuilder: (BuildContext context, int index){
                                                    return Card(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15.0),
                                                      ),
                                                      color: Colors.white,
                                                      elevation:10,
                                                      child: Padding(
                                                        padding: EdgeInsets.all(10.0),
                                                        child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Row(
                                                            children: <Widget>[
                                                              Expanded(
                                                                flex:0,
                                                                child: Container(
                                                                  height: 100,
                                                                  child: ClipRRect(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    child: Image(
                                                                      image: AssetImage('assets/images/logo.jpeg',
                                                                    ),
                                                                    fit: BoxFit.fill,
                                                                    )
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child: Container(
                                                                  child: Column(
                                                                    children: <Widget>[
                                                                      Padding(
                                                                        padding: const EdgeInsets.all(4.0),
                                                                        child: Text(localList2[index].name,
                                                                          style: TextStyle(fontSize: 23,
                                                                            fontFamily: 'Arciform',
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.grey
                                                                          )                                     
                                                                        ),
                                                                      ),
                                                                      Row(children: <Widget>[
                                                                          Expanded(
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Container(
                                                                                child: Row(
                                                                                  children: <Widget>[
                                                                                    Expanded(
                                                                                      flex: 1,
                                                                                      child: Container(
                                                                                        child: Text('Size: ',
                                                                                        style: TextStyle(fontSize: 11,
                                                                                            fontFamily: 'Arciform',
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: Colors.grey
                                                                                          )  
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      flex: 2,
                                                                                        child: Container(
                                                                                        alignment: Alignment.bottomCenter,
                                                                                        child: Column(children: <Widget>[
                                                                                          Row(children: <Widget>[
                                                                                              Text(localList2[index].heightF+"m",
                                                                                              style: TextStyle(fontSize: 11,
                                                                                                    fontFamily: 'Arciform',
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                    color: Colors.grey
                                                                                                  )  
                                                                                                ),
                                                                                              //Icon(Icons.ac_unit)
                                                                                          ],),
                                                                                          Row(children: <Widget>[
                                                                                              Text(localList2[index].heightM+"m",
                                                                                              style: TextStyle(fontSize: 11,
                                                                                                    fontFamily: 'Arciform',
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                    color: Colors.grey
                                                                                                  )  
                                                                                                ),
                                                                                            //Icon(Icons.ac_unit)
                                                                                          ],),
                                                                                        ],),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ),  
                                                                          Expanded(
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Container(
                                                                                child: Row(
                                                                                  children: <Widget>[
                                                                                    Expanded(
                                                                                      flex: 1,
                                                                                      child: Container(
                                                                                        child: Text('Weight: ',
                                                                                        style: TextStyle(fontSize: 11,
                                                                                            fontFamily: 'Arciform',
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: Colors.grey
                                                                                          )  
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      flex: 2,
                                                                                        child: Container(
                                                                                        alignment: Alignment.bottomCenter,
                                                                                        child: Column(children: <Widget>[
                                                                                          Row(children: <Widget>[
                                                                                              Padding(
                                                                                                padding: const EdgeInsets.only(left:8.0),
                                                                                                child: Text(localList2[index].weightF+"kg",
                                                                                                style: TextStyle(fontSize: 11,
                                                                                                      fontFamily: 'Arciform',
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                      color: Colors.grey
                                                                                                    )  
                                                                                                  ),
                                                                                              ),
                                                                                              //Icon(Icons.ac_unit)
                                                                                          ],),
                                                                                          Row(children: <Widget>[
                                                                                              Padding(
                                                                                                padding: const EdgeInsets.only(left:8.0),
                                                                                                child: Text(localList2[index].weightM+"kg",
                                                                                                style: TextStyle(fontSize: 11,
                                                                                                      fontFamily: 'Arciform',
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                      color: Colors.grey
                                                                                                    )  
                                                                                                  ),
                                                                                              ),
                                                                                            //Icon(Icons.ac_unit)
                                                                                          ],),
                                                                                        ],),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ),                                                                                         
                                                                      ],),
                                                                      Row(children: <Widget>[
                                                                          Expanded(
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Container(
                                                                                child: Text('Diet: '+localList2[index].diet,
                                                                                style: TextStyle(fontSize: 13,
                                                                                    fontFamily: 'Arciform',
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Colors.grey
                                                                                  )  
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ),
                                                                          Expanded(
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(4.0),
                                                                              child: Container(
                                                                                child: Text('Gestation: '+localList2[index].gestation,
                                                                                style: TextStyle(fontSize: 13,
                                                                                    fontFamily: 'Arciform',
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Colors.grey
                                                                                  )  
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ),
                                                                      ],)                                         
                                                                  ],),
                                                                ),
                                                              )
                                                              ],
                                                            ),
                                                          Container(
                                                            child: Column(
                                                              children: <Widget>[
                                                                ExpansionTile(
                                                                  title: Text("Description",
                                                                  style: TextStyle(fontSize: 17,
                                                                      fontFamily: 'Arciform',
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.grey     
                                                                    )                         
                                                                  ),
                                                                  children: <Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left:8.0),
                                                                      child: Container(
                                                                        alignment: Alignment.center,
                                                                        child: Center(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.only(left:8.0, bottom:8.0),
                                                                            child: Text("The African Elephant is the largest mammal in the world and the largest of the three elephant species.  They can live up to 70 years - longer than any other mammal except humans.",
                                                                              style: TextStyle(fontSize: 12,
                                                                                fontFamily: 'Arciform',
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.grey                                              
                                                                              )
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                ExpansionTile(
                                                                  title: Text("Behavioural Information",
                                                                    style: TextStyle(fontSize: 17,
                                                                        fontFamily: 'Arciform',
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.grey     
                                                                    )                                      
                                                                  ),
                                                                  children: <Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left:8.0),
                                                                      child: Container(
                                                                        alignment: Alignment.center,
                                                                        child: Center(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.only(left:8.0, bottom:8.0),
                                                                            child: Text(localList2[index].behaviour,
                                                                              style: TextStyle(fontSize: 12,
                                                                                fontFamily: 'Arciform',
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.grey                                              
                                                                              )
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],                                     
                                                                ),
                                                                ExpansionTile(
                                                                  title: Text("Habitat",
                                                                    style: TextStyle(fontSize: 17,
                                                                        fontFamily: 'Arciform',
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.grey     
                                                                      )                                     
                                                                  ),
                                                                  children: <Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left:8.0),
                                                                      child: Container(
                                                                        alignment: Alignment.center,
                                                                        child: Center(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.only(left:8.0, bottom:8.0),
                                                                            child: Text("The African Elephant is the largest mammal in the world and the largest of the three elephant species.  They can live up to 70 years - longer than any other mammal except humans.",
                                                                              style: TextStyle(fontSize: 12,
                                                                                fontFamily: 'Arciform',
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.grey                                              
                                                                              )
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],                                    
                                                                ),
                                                              ],),
                                                            ), 
                                                            SizedBox(height: 0.0,),
                                                            FlatButton(
                                                                child: Center(
                                                                    child: Text(
                                                                  'View More',
                                                                    style: TextStyle(fontSize: 15,
                                                                    fontFamily: 'Arciform'),
                                                                  )
                                                                ),
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(15),
                                                                ),
                                                                onPressed: (){
                                                                  Navigator.push(context, PageRouteBuilder(
                                                                    pageBuilder: (context, animation1, animation2) => ImagesView(animals: localList2),
                                                                  ),);
                                                                },
                                                                color: Colors.black12,
                                                                highlightColor: Colors.grey,
                                                                padding: EdgeInsets.all(8.0),
                                                            ), 
                                                          
                                                          ],
                                                        ),
                                                      )
                                                      );
                                                    },
                                                  );
                                            }
                                          )
                                        ),
                                      ],
                                    ),
                                ),
                              ),
                              ]
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
                  bool boolean = await model.imagePicker();
                  Navigator.push(context, 
                      new MaterialPageRoute(builder: (context) => ConfirmView())
                  ); 
                } 
              ),
            )
        ) 
    );
  }
}

