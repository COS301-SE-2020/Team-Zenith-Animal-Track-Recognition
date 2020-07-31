import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:ERP_RANGER/services/util.dart';
import 'package:ERP_RANGER/ui/views/search/search_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';


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
             return progressIndicator();
          }if(snapshot.hasData){
            displayList.clear();
            searchList.clear();
            displayList.addAll(snapshot.data.displayList);
            searchList.addAll(snapshot.data.searchList);
            return WillPopScope(
              onWillPop:() async{
                if(Navigator.canPop(context)){
                  navigateBack(context);
                }
                return;
              },
              child: DefaultTabController(
                length: 2, 
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.black,
                    title: appBarTitle("Search View", context),
                    actions: <Widget>[IconBuilder(icon: Icons.search, colors: Colors.grey,index: 0)],
                    bottom: TabBar(tabs: [text14CenterBoldGrey("ANIMAL"),text14CenterBoldGrey("SPECIES"),]),
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
            return  progressIndicator();
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
  String name;
  IconBuilder({Key key,this.icon,this.colors,this.index,this.name}) : super(reactive: true);

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
            navigateToInfo(name.toLowerCase());
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
          child: text16LeftBoldGrey(animalList[index].commonName),
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
            title: text16LeftBoldGrey(animalList[index].species),
            subtitle: text12LeftBoldGrey(animalList[index].commonName),
            trailing: IconBuilder(icon: Icons.remove_red_eye, colors: Colors.grey,index: 1, name:animalList[index].commonName ,),
          ),
        );
      }
    );
  }
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
                title: text16LeftBoldGrey(suggestionList[index].species),
                subtitle: text16LeftBoldGrey(suggestionList[index].commonName),
                trailing: iconButton(model),
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

Widget iconButton(var model) {
  return IconButton(
    icon: Icon(Icons.remove_red_eye), 
    onPressed: (){
      print("object");
      model.navigateToInformation();
    }
  );
}