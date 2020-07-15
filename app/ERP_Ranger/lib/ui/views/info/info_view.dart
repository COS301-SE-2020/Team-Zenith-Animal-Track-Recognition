import 'package:ERP_Ranger/ui/views/confirm/confirm_view.dart';
import 'package:ERP_Ranger/ui/views/confirm/unconfirmed_view.dart';
import 'package:ERP_Ranger/ui/views/home/home_view.dart';
import 'images.dart';
import 'package:flutter/material.dart';
import '../../../core/viewmodels/info_viewmodel.dart';
import '../../widgets/bottom_nav.dart';
import '../base_view.dart';
import '../../../core/services/user.dart';

  
class InfoView extends StatefulWidget {
  InfoView({Key key}) : super(key: key);

  @override
  _InfoView createState() => _InfoView();
}

class _InfoView extends State<InfoView> with TickerProviderStateMixin{
  int _currentTabIndex = 1;
  int _startingTabCount = 4;
  List<Tab> _tabs = List<Tab>();
  List<Widget> _widgets = List<Widget>();
  List<String> names = List<String>();

  TabController _tabController;

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

  List<Widget> getWidgets(var data){
    _widgets.clear();
    for(int i = 0; i < _tabs.length;i++){
      _widgets.add(getWidget(data));
    }
    return _widgets;
  }
  
  Widget getWidget(int i){
    return ListView.builder(
      itemCount: i,
      itemBuilder: (BuildContext context, int index){
        return new Container(
        alignment: Alignment.centerLeft,
          margin: new EdgeInsets.all(12),
          padding: new EdgeInsets.all(5) ,
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black, width: 2,style: BorderStyle.solid)
          ), 
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ListTileTheme(
                dense: true,
                child: ListTileTheme(
                  dense: true,
                  child: Row(
                    children:<Widget>[
                      Expanded(flex:2,child: imageBlock),
                      Expanded(
                        flex:3,
                        child: Container(
                          height: 100,
                          width: 100,
                          child: Column(
                            children: <Widget>[
                              Expanded(flex:1,child: Container(child: animalName)),
                              Expanded(flex:2,child: Container(child: animalDetailTop)),
                              Expanded(flex:1,child: Container(child: animalDetailBottom)),
                            ], 
                          ),
                        ),
                      )
                    ]
                  ),
                ),
              ),
              ListTileTheme(dense:true,child: description),
              ListTileTheme(dense:true,child: behaviour),
              ListTileTheme(dense:true,child: habits),
              ListTileTheme(dense:true,child: viewMoreButton(context)),
            ],
          )
        );
      },
    );
  }
  
  Future<int> getLists() async{
    return 5;
  }

  void addNames(){
    names.add("BIG FIVE");
    names.add("BIG CATS");
    names.add("LARGE ANTELOPE");
    names.add("SMALL ANTELOPE");
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
      builder: (context, model, child) =>FutureBuilder(
        future: getLists(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
           return WillPopScope(
              onWillPop: () async { 
                if(Navigator.canPop(context)){
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }else{
                  print("noo");
                }
              },
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  leading: LeftMenu(),
                  title: textTitle,
                  actions: <Widget>[
                    SearchButton(),
                    MenuVert(),
                  ],
                  bottom: TabBar(
                    tabs: _tabs,
                    controller: _tabController,
                  ),
                ),
                body: Container(
                  color: Colors.grey,
                  child: TabBarView(
                    controller: _tabController,
                    children: getWidgets(snapshot.data),
                  ),
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
                    }
                    else{
                      Navigator.push(context, 
                        new MaterialPageRoute(builder: (context) => ConfirmView(animal: animals,))
                      ); 
                    }
                  } 
                ),
              ),
           );
          }else{
            return  Text("");
          }
        }
      ),
    );
  }
}

class LeftMenu extends StatefulWidget {
  LeftMenu({Key key}) : super(key: key);

  @override
  _LeftMenu createState() => _LeftMenu();
}

class _LeftMenu extends State<LeftMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
       child: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(Icons.menu,color: Colors.white,),
        onPressed: null
      ),
    );
  }
}

class SearchButton extends StatefulWidget {
  SearchButton({Key key}) : super(key: key);

  @override
  _SearchButton createState() => _SearchButton();
}

class _SearchButton extends State<SearchButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
       child: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(Icons.search, color: Colors.white),
        onPressed: null
      ),
    );
  }
}

class MenuVert extends StatefulWidget {
  MenuVert({Key key}) : super(key: key);

  @override
  _MenuVert createState() => _MenuVert();
}

class _MenuVert extends State<MenuVert> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
       child: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(Icons.more_vert, color: Colors.white),
        onPressed: null
      ),
    );
  }
}

Widget textTitle = new Text(
  "Animal Information",
  textAlign: TextAlign.center,
  style: TextStyle(
    fontSize: 22,
    fontFamily: 'Arciform',
    fontWeight: FontWeight.bold,
    color: Colors.white
  )
);

//==============================
Widget imageBlock = new Container(
  alignment: Alignment.center,
  margin: new EdgeInsets.only(bottom:10, left:15,right:10,top:10 ),
  //padding: new EdgeInsets.all(5),
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

Widget viewMoreButton(var context)  {
  return ButtonTheme(
      minWidth: 200,
      child: RaisedButton(
      child: buttonName,
      color: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(10),
      onPressed: (){
        Navigator.push(context, 
          new MaterialPageRoute(builder: (context) => ImageView(animals: null,))
        );
      }
    ),
  );
}

Widget buttonName = new Text(
    "VIEW PHOTOS",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:15,
      fontFamily: 'Arciform',
      color: Colors.white
    ),
  );

Widget animalName = new Container(
  alignment: Alignment.centerLeft,
  padding: new EdgeInsets.all(5) ,
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
  ),
  //height: 0,
  child: Text(
    "AFRICAN BUSH ELEPHANT",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:17,
      fontFamily: 'Arciform',
      color: Colors.grey
    ),
  ),
);
//===============================
Widget animalDetailTop = new Container(
  alignment: Alignment.centerLeft,
   margin: EdgeInsets.all(0),
   padding: EdgeInsets.all(0),
  child: Row(
    children: <Widget>[
      Expanded(flex:1,child: sizeContainer),
      Expanded(flex:1,child: weightContainer)
    ]
  ),
);

Widget sizeContainer = new Container(
   margin: EdgeInsets.all(0),
   padding: EdgeInsets.all(0),
    child: Row(children: <Widget>[
      Expanded(flex: 1,child: sizeLabel,),
      Expanded(flex: 1,child: sizes),
    ],),
);

Widget weightContainer = new Container(
   margin: EdgeInsets.all(0),
   padding: EdgeInsets.all(0),
    child: Row(children: <Widget>[
      Expanded(flex: 1, child: weightLabel,),  
      Expanded(flex: 1, child: weights),   
    ],),
);

Widget sizeLabel = new Text(
    "Size:",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:12,
      fontFamily: 'Arciform',
      color: Colors.black
    ),
  );

Widget weightLabel = new Text(
    "Weight:",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:12,
      fontFamily: 'Arciform',
      color: Colors.black
    ),
  );

Widget sizes = Column(children: <Widget>[
    Expanded(flex:1, child: femaleSizeContainer("")),
    Expanded(flex:1, child: maleSizeContainer("") ),
],);

Widget maleSizeContainer(String male) {
 return Container(
   margin: EdgeInsets.all(0),
   padding: EdgeInsets.all(0),
   child: Row(
    children:<Widget>[
      Expanded(
        flex: 1,
        child: Text("3.5m",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize:10,
            fontFamily: 'Arciform',
            color: Colors.black
          ),
        ),
      ),
      Expanded(
        flex: 1,
        child: Icon(Icons.perm_identity,size: 20),
      )
    ]
),
 );
}

Widget femaleSizeContainer(String female){
  return Container(
   margin: EdgeInsets.all(0),
   padding: EdgeInsets.all(0),
    child: Row(
    children:<Widget>[
      Expanded(
        flex: 1,
        child: Text("3.2m",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize:10,
            fontFamily: 'Arciform',
            color: Colors.black
          ),    
        ),
      ),
      Expanded(
        flex: 1,
        child: Icon(Icons.perm_identity,size: 20,)
        )
      ]
    ),
  );

}

Widget weights = Column(children: <Widget>[
    Expanded(flex:1, child: femaleWeightContainer("")),
    Expanded(flex:1, child: maleWeightContainer("") ),
],);

Widget maleWeightContainer(String male) {
 return Container(
    margin: EdgeInsets.all(0),
   padding: EdgeInsets.all(0),
   child: Row(
    children:<Widget>[
      Expanded(
        flex: 1,
        child: Text("6000kg",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize:8,
            fontFamily: 'Arciform',
            color: Colors.black
          ),
        ),
      ),
      Expanded(
        flex: 1,
        child: Icon(Icons.perm_identity,size: 20,)
      )
    ]
  ),
 );
}

Widget femaleWeightContainer(String female){
 return Container(
   margin: EdgeInsets.all(0),
   padding: EdgeInsets.all(0),
   child: Row(
    children:<Widget>[
      Expanded(
        flex: 1,
        child: Text("4500kg",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize:8,
            fontFamily: 'Arciform',
            color: Colors.black
          ),
        ),
      ),
      Expanded(
        flex: 1,
        child: Icon(Icons.perm_identity,size: 20,)
      )
    ]
  ),
 );

}
//===============================
Widget animalDetailBottom = new Container(
  alignment: Alignment.centerLeft,
  child: Row(
    children: <Widget>[
      Expanded(flex: 1,
        child: diet,
      ),
      Expanded(flex: 1,
        child: gestation,
      ),
    ],
  )
);

Widget diet = new Container(
  child: Row(children: <Widget>[
      Expanded(flex:1, child: dietLabel,),
      Expanded(flex:1, child: dietInputLabel("diet"),),
  ],),
);

Widget gestation = new Container(
  child: Row(children: <Widget>[
      Expanded(flex:1, child: gestationLabel,),
      Expanded(flex:1, child: gestationInputLabel("gestation"),),
  ],),
);

Widget dietLabel = new Text(
    "Diet:",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:12,
      fontFamily: 'Arciform',
      color: Colors.black
    ),
  );

Widget dietInputLabel (String diet){
  return Text(
    "Herbivore",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:10,
      fontFamily: 'Arciform',
      color: Colors.black
    ),
  );
}

Widget gestationLabel = new Text(
    "Gestation:",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:11,
      fontFamily: 'Arciform',
      color: Colors.black
    ),
  );

Widget gestationInputLabel (String gestation){
  return Text(
    "24 Months",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:10,
      fontFamily: 'Arciform',
      color: Colors.black
    ),
  );
}
//===============================
Widget description = new ExpansionTile(
  title: descriptionTitle,
  children: <Widget>[
    Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left:17, bottom:15),
      child: behaviourBody
    )
  ],
);

Widget descriptionTitle = new Text(
    "Description",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:18,
      fontFamily: 'Arciform',
      color: Colors.grey
    ),
);

Widget descriptionBody = new Text(
    "This body text is used for demonstration purposes",
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize:13,
      fontFamily: 'Arciform',
      color: Colors.grey,
      fontWeight: FontWeight.bold,
    ),
);

Widget behaviour = new ExpansionTile(
  title: behaviourTitle,
  children: <Widget>[
    Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left:17, bottom:15),
      child: behaviourBody
    )
  ],
);

Widget behaviourTitle = new Text(
    "Behaiour",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:18,
      fontFamily: 'Arciform',
      color: Colors.grey
    ),
);

Widget behaviourBody = new Text(
    "This body text is used for demonstration purposes",
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize:13,
      fontFamily: 'Arciform',
      color: Colors.grey,
      fontWeight: FontWeight.bold,
    ),
);

Widget habits = new ExpansionTile(
  title: habitsTitle,
  children: <Widget>[
    Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left:17, bottom:15),
      child: behaviourBody
    )
  ],
);

Widget habitsTitle = new Text(
    "Habits",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:18,
      fontFamily: 'Arciform',
      color: Colors.grey
    ),
);

Widget habitsBody = new Text(
    "This body text is used for demonstration purposes",
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize:13,
      fontFamily: 'Arciform',
      fontWeight: FontWeight.bold,
      color: Colors.grey
    ),
);