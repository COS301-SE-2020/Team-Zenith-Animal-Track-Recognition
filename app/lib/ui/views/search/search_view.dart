import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:ERP_RANGER/ui/views/search/search_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:path/path.dart';

SearchModel searchModel7 = SearchModel(commonName: "Buffalo", species: "Cape Buffalo",image: "https://images.unsplash.com/photo-1508605375977-9fe795aea86a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1148&q=80");

List<SearchModel> searchList = new List<SearchModel>();
List<SearchModel> displayList = new List<SearchModel>();
class SearchView extends StatelessWidget {
  const SearchView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.reactive(
      builder: (context, model, child) =>FutureBuilder(
        future: model.getSearchList(),
        builder: (context, snapshot){
          if(snapshot.hasError){
             return text("Error", 20);
          }if(snapshot.hasData){
            displayList.addAll(snapshot.data.displayList);
            searchList.addAll(snapshot.data.searchList);
            return WillPopScope(
              onWillPop:() async{
                if(Navigator.canPop(context)){
                  model.navigate(context);
                }
                return;
              },
              child: DefaultTabController(
                length: 2, 
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.black,
                    title: text("Search View", 25),
                    actions: <Widget>[IconBuilder(icon: Icons.search, colors: Colors.grey,index: 0)],
                    bottom: TabBar(tabs: [text("ANIMAL", 15),text("SPECIES", 15),]),
                  ),
                  body: Container(
                    color: Colors.grey[200],
                    child: TabBarView(
                      children: <Widget>[
                        ListBody(animalList: snapshot.data.animals,),
                        ListBody(animalList: snapshot.data.species,),
                      ],
                    )
                  ),
                )
              ), 
            );
          }else{
            return text("Null no Data", 20);
          }    
        }
      ) ,
      viewModelBuilder: () => SearchViewModel(),
    );
  }
}

// ignore: must_be_immutable
class IconBuilder extends ViewModelWidget<SearchViewModel> {
  IconData icon;
  Color colors;
  int index;
  IconBuilder({Key key,this.icon,this.colors,this.index}) : super(reactive: true);

  @override
  Widget build(BuildContext context, SearchViewModel model) {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
       child: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(icon, color: colors),
        onPressed: (){
          if(index == 0){
            showSearch(context: context, delegate: DataSearch(model:model));
          }else{
            model.navigateToInformation();
          }
        }
      ),
    );
  }
}

class ListBody extends ViewModelWidget<SearchViewModel> {
  List<SearchModel> animalList;
  ListBody({Key key, this.animalList}) : super(reactive: true);

  @override
  Widget build(BuildContext context, SearchViewModel model) {
    return ListView.builder(
      itemCount: animalList.length,
      itemBuilder: (context, index){
        return animalList[index].image == ""
        ? Container(
          margin: new EdgeInsets.only(left:30, top:17, bottom: 10),
          child: Text(
            animalList[index].commonName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize:16,
              fontFamily: 'Arciform',
              color: Colors.grey
            ),
          ),
        )
        :  Container(
          margin: new EdgeInsets.all(12),
          padding: new EdgeInsets.only(left:0,right:0,top:5,bottom: 5) ,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ), 
          child: ListTile(
            dense: true,
            leading: imageBlock(animalList[index].image),
            title: text4(animalList[index].species, 17),
            subtitle: text4(animalList[index].commonName,13),
            trailing: IconBuilder(icon: Icons.remove_red_eye, colors: Colors.grey,index: 1),
          ),
        );
      }
    );
  }
}

Widget imageBlock(String image){
  return Container(
    alignment: Alignment.center,
  // margin: new EdgeInsets.only(bottom:10, left:15,right:10,top:10 ),
    //padding: new EdgeInsets.all(5),
      decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage( image ),
        fit: BoxFit.fill,
      ),
      color: Colors.grey,
      borderRadius: BorderRadius.circular(10),
    ),
    height: 50,
    width: 50,
  );
}

//================================== TEXT TEMPLATES =============================
Widget text(String text, double font){
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: font,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.bold,
      color: Colors.white
    ),
  );
}

Widget text2(String text, double font){
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: font,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.bold,
      color: Colors.grey
    ),
  );
}

Widget text3(String text, double font){
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: font,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.normal,
      color: Colors.grey
    ),
  );
}

Widget text4(String text, double font){
  return Text(
    text,
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: font,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.bold,
      color: Colors.grey
    ),
  );
}

Widget text5(String text, double font){
  return Text(
    text,
    textAlign: TextAlign.right,
    style: TextStyle(
      fontSize: font,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.bold,
      color: Colors.grey
    ),
  );
}
//================================== TEXT TEMPLATES =============================
Widget iconButton(var model) {
  return IconButton(
    icon: Icon(Icons.remove_red_eye), 
    onPressed: (){
      print("object");
      model.navigateToInformation();
    }
  );
}


class DataSearch extends SearchDelegate<List<SearchModel>>{
  final model;
  DataSearch({this.model});
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    // actions for app bar
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: (){
        query = "";
      }),
    ];

  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    // leading icon on the left of appbar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some result based on the selection
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something
    // TODO: implement buildSuggestions

    final suggestionList = query.isEmpty
    ? displayList
    : searchList.where((p) => p.commonName.toLowerCase().startsWith(query) || p.species.toLowerCase().startsWith(query)).toList();

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index){
          return Container(
              margin: new EdgeInsets.all(12),
              padding: new EdgeInsets.only(left:0,right:0,top:5,bottom: 5) ,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ), 
              child: ListTile(
                dense: true,
                leading: imageBlock(suggestionList[index].image),
                title: text4(suggestionList[index].species,17),
                subtitle: text4(suggestionList[index].commonName,13),
                trailing: iconButton(model),
              ),
            );
        }
      );


  }

}
