import 'package:flutter/material.dart';
import 'package:ERP_Ranger/ui/views/confirm/confirm_view.dart';
import '../../../core/services/user.dart';
import '../../../core/viewmodels/info_viewmodel.dart';
import '../../widgets/bottom_nav.dart';
import '../base_view.dart';


class ImagesView extends StatefulWidget {
  List<User> animals;
  ImagesView({@required this.animals});
  @override
  _ImagesView createState() => _ImagesView(animals: animals);
}

class _ImagesView extends State<ImagesView> {
  int _currentTabIndex = 1;
  List<User> animals;
  _ImagesView({@required this.animals});

  @override
  Widget build(BuildContext context) {
    BottomNavigation bottomNavigation = new BottomNavigation();
    bottomNavigation.setIndex(_currentTabIndex);
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
                        //color: Colors.black,
                        margin: new EdgeInsets.only(top:20),
                        height: 30,
                        width: 500,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.keyboard_backspace),
                              padding: EdgeInsets.only(bottom:1),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:33.0),
                              child: Center(
                                child: Text("Animal infomation",
                                  style: TextStyle(fontSize: 25,
                                  fontFamily: 'Arciform',
                                  fontWeight: FontWeight.bold)
                                ),
                              ),
                            ),
                          ],
                        )
                      ),
                    ),
                    TabBar(
                    indicatorColor: Colors.grey,
                    indicatorWeight: 5,
                    tabs: <Widget>[
                      Tab(child: Text('Appearance',
                        style: TextStyle(fontSize: 15,
                            fontFamily: 'Arciform',
                            color: Colors.black,
                            fontWeight: FontWeight.bold  
                          ),
                        ),
                      ),
                      Tab(
                        child: Text('Tracks',
                          style: TextStyle(fontSize: 15,
                            fontFamily: 'Arciform',
                            color: Colors.black,
                            fontWeight: FontWeight.bold  
                          ),
                        ),
                      ),
                      Tab(
                        child: Text('Droppings',
                          style: TextStyle(fontSize: 15,
                            fontFamily: 'Arciform',
                            color: Colors.black,
                            fontWeight: FontWeight.bold  
                          ),
                        ),
                      ),
                    ],
                  )
                ],),
              ),
              Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                ),
                child: TabBarView(
                    children: [
                      CardsB(localList: animals,),
                      CardsB(localList: animals),
                      CardsB(localList: animals)
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
        ),

      ),
    );
  }
}

class CardsB extends StatelessWidget {

  List<User> localList;

  CardsB({@required this.localList});

  @override
  Widget build(BuildContext context) {
    return new GridView.builder(
      itemCount: localList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (BuildContext context,int index) {
        return new Card(
           shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          child: Image.asset('assets/images/logo.jpeg'),
        );
      },
    );
  }
}