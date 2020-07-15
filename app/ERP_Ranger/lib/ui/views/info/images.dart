import 'package:ERP_Ranger/core/services/mock_api.dart';
import 'package:flutter/material.dart';
import 'package:ERP_Ranger/ui/views/confirm/confirm_view.dart';
import 'package:ERP_Ranger/ui/views/confirm/unconfirmed_view.dart';
import '../../../core/services/user.dart';
import '../../../core/viewmodels/info_viewmodel.dart';
import 'package:ERP_Ranger/core/services/user.dart';
import '../../widgets/bottom_nav.dart';
import '../base_view.dart';


class ImageView extends StatefulWidget {
  final List<User> animals;
  ImageView({@required this.animals});
  @override
  _ImagesView createState() => _ImagesView(animals: animals);
}

class _ImagesView extends State<ImageView> with TickerProviderStateMixin{
  int _currentTabIndex = 1;
  int _startingTabCount = 3;
  List<Tab> _tabs = List<Tab>();
  List<Widget> _widgets = List<Widget>();
  List<String> names = List<String>();
  List<User> animals;
   TabController _tabController;
  _ImagesView({@required this.animals});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addNames();
    _tabController = TabController(length: _startingTabCount, vsync: this);
    _tabs.clear();
    for(int i = 0; i < _startingTabCount; i++){
      _tabs.add(getTab(names[i]));
    }
  }

  Tab getTab(String widgetNumber){
    return Tab(
    child: Text(
      "$widgetNumber",
      style: TextStyle(
          color:Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        )
      ),
    );
  }

  void addNames(){
    names.add("APPEARANCE");
    names.add("TRACKS");
    names.add("DROPPINGS");

  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigation bottomNavigation = new BottomNavigation();
    bottomNavigation.setIndex(_currentTabIndex);
    return BaseView<InfoModel>(
      builder: (context, model, child) => WillPopScope(
              onWillPop: () async { 
                if(Navigator.canPop(context)){
                  Navigator.of(context).pop();
                }else{
                  print("noo");
                }
              },
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  leading: BackButton(),
                  title: textTitle(""),
                  bottom: TabBar(
                    tabs: _tabs,
                    controller: _tabController,
                  ),
                ),
                body: Container(
                  color: Colors.grey[300],
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      AppearanceWidget(animalImage: null),
                      TracksWidget(animalImage: null),
                      DroppingsWidget(animalImage: null)
                    ],
                  ),
                ),
                bottomNavigationBar: BottomNavigation(),
                floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add_a_photo),
                backgroundColor: Color(0xFFF2929C),
                tooltip: 'Pick Image',
                onPressed:()async{
                    List<User> animals= await model.imagePicker();
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
              ),
      )
    );
  }
}

class BackButton extends StatefulWidget {
  BackButton({Key key});

  @override
  _BackButton createState() => _BackButton();
}

class _BackButton extends State<BackButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: IconButton(
         color: Colors.white,
         icon: Icon(Icons.arrow_back),
         onPressed: (){ 
           Navigator.of(context).pop();
         },
      ),
    );
  }
}

Widget textTitle(String name){
return Text(
  "AFRICAN BUSH ELEPHANT",
  textAlign: TextAlign.center,
  style: TextStyle(
    fontSize: 20,
    fontFamily: 'Arciform',
    fontWeight: FontWeight.bold,
    color: Colors.white
  )
);
} 

class AppearanceWidget extends StatefulWidget {
  final animalImage;
  AppearanceWidget({this.animalImage});

  @override
  _AppearanceWidget createState() => _AppearanceWidget();
}

class _AppearanceWidget extends State<AppearanceWidget> {
  final animalImage;
  _AppearanceWidget({this.animalImage});
  
  @override
  Widget build(BuildContext context) {
  return SafeArea(
    child: GridView.count(
      scrollDirection: Axis.vertical,
      crossAxisCount: 2,
      children: List.generate(10, (index){
      return Container(
        alignment: Alignment.center,
        margin: new EdgeInsets.all(10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage( "https://images.unsplash.com/photo-1551316679-9c6ae9dec224?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"),
            fit: BoxFit.fill,
          ),
          color: Colors.grey,
          borderRadius: BorderRadius.circular(15),
        ),
        height: 100,
        width: 100,
        );
      }),
    ),
  );
  }
}

class TracksWidget extends StatefulWidget {
  final animalImage;
  TracksWidget({this.animalImage});

  @override
  _TracksWidget createState() => _TracksWidget();
}

class _TracksWidget extends State<TracksWidget> {
  final animalImage;
  _TracksWidget({this.animalImage});

  @override
  Widget build(BuildContext context) {
  return SafeArea(
    child: GridView.count(
      scrollDirection: Axis.vertical,
      crossAxisCount: 2,
      children: List.generate(10, (index){
      return Container(
        alignment: Alignment.center,
        margin: new EdgeInsets.all(10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage( "https://images.unsplash.com/photo-1551316679-9c6ae9dec224?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"),
            fit: BoxFit.fill,
          ),
          color: Colors.grey,
          borderRadius: BorderRadius.circular(15),
        ),
        height: 100,
        width: 100,
        );
      }),
    ),
  );
  }
}

class DroppingsWidget extends StatefulWidget {
  final animalImage;
  DroppingsWidget({this.animalImage});

  @override
  _DroppingsWidget createState() => _DroppingsWidget();
}

class _DroppingsWidget extends State<DroppingsWidget> {
  final animalImage;
  _DroppingsWidget({this.animalImage});

  @override
  Widget build(BuildContext context) {
  return SafeArea(
    child: GridView.count(
      scrollDirection: Axis.vertical,
      crossAxisCount: 2,
      children: List.generate(10, (index){
      return Container(
        alignment: Alignment.center,
        margin: new EdgeInsets.all(10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage( "https://images.unsplash.com/photo-1551316679-9c6ae9dec224?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"),
            fit: BoxFit.fill,
          ),
          color: Colors.grey,
          borderRadius: BorderRadius.circular(15),
        ),
        height: 100,
        width: 100,
        );
      }),
    ),
  );
  }
}