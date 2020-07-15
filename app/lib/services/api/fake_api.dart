import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:injectable/injectable.dart';
import 'api.dart';

@lazySingleton
class FakeApi implements Api{
  @override
  Future<List<AnimalModel>> getAnimalModel() async{
    List<AnimalModel> animalList = new List();
    AnimalModel elephant = AnimalModel(
      animalName: "AFRICAN BUSH ELEPHANT",
      image: "https://images.unsplash.com/photo-1551316679-9c6ae9dec224?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
      description: "This body text is used for demonstration purposes",
      behaviour: "This body text is used for demonstration purposes",
      habitats: "This body text is used for demonstration purposes",
      diet: "Herbivore",
      gestation: "24 Months",
      sizeM: 3.5,
      sizeF: 3.2,
      weightF: 4500,
      weightM: 6000
    );
    for(int i = 0; i < 5 ; i++){
      animalList.add(elephant);
    }
    return animalList;
  }

  @override
  Future<List<ConfirmModel>> getConfirmModel() async{
    List<ConfirmModel> identifiedList = new List();
    ConfirmModel identifiedAnimal = ConfirmModel(accuracyScore: 67,type:"Track",animalName: "Elephant", species: "African Bush", image: "https://images.unsplash.com/photo-1551316679-9c6ae9dec224?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60");

    for(int i = 0; i < 5;i++){
      identifiedList.add(identifiedAnimal);
    }
    return identifiedList;
  }

  @override
  Future<GalleryModel> getGalleryModel() async{
    List<String> appearance = new List();
    List<String> tracks = new List();
    List<String> droppings  = new List();
    int numCategories = 3;

    for(int i = 0; i < 8; i++){
      appearance.add("https://images.unsplash.com/photo-1551316679-9c6ae9dec224?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60");
      droppings.add("https://images.unsplash.com/photo-1551316679-9c6ae9dec224?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60");
      tracks.add("https://images.unsplash.com/photo-1551316679-9c6ae9dec224?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60");
    }
    return GalleryModel(appearance: appearance,droppings: droppings,tracks: tracks, numCategories: numCategories);

  }

  @override
  Future<List<HomeModel>> getHomeModel() async{
    // TODO: implement getHomeModel
    throw UnimplementedError();
  }

  @override
  Future<List<InfoModel>> getInfoModel() async {
    // TODO: implement getInfoModel
    throw UnimplementedError();
  }

  @override
  Future<LoginResponse> getLoginModel() async{
    // TODO: implement getLoginModel
    throw UnimplementedError();
  }

  @override
  Future<List<ProfileModel>> getProfileModel()async {
    // TODO: implement getProfileModel
    throw UnimplementedError();
  }

  @override
  Future<List<SearchModel>> getSearchModel() async{
    List<SearchModel> searchList = new List();
    SearchModel searchModel = SearchModel(commonName:"Elephant" , species: "African Bush Elephant",image: "https://images.unsplash.com/photo-1551316679-9c6ae9dec224?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60");
    SearchModel searchModel1 = SearchModel(commonName: "Wildebeest", species:"Black Wildebeest" ,image: "https://images.unsplash.com/photo-1516729445616-0393420f6089?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80");
    SearchModel searchModel2 = SearchModel(commonName: "Jackal", species: "Black-Backed Jackal",image: "https://images.unsplash.com/photo-1576313966078-951c6cdd8866?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80");
    SearchModel searchModel3 = SearchModel(commonName: "Hippopotamus", species: "Common Hippopotamus",image: "https://images.unsplash.com/photo-1553521306-9387d3795516?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80");
    SearchModel searchModel4 = SearchModel(commonName: "Antelope", species:"Blesbok" ,image:  "https://images.unsplash.com/photo-1590692462025-f84292449cbe?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1051&q=80");
    SearchModel searchModel5 = SearchModel(commonName: "Antelope", species:"Red Hartebeest" ,image: "https://images.unsplash.com/photo-1593735962887-bef0731874bd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1225&q=80");
    SearchModel searchModel6 = SearchModel(commonName: "Antelope", species:"Waterbuck", image:"https://images.unsplash.com/photo-1581262100228-02ce45aa5074?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80" );
    SearchModel searchModel7 = SearchModel(commonName: "Buffalo", species: "Cape Buffalo",image: "https://images.unsplash.com/photo-1508605375977-9fe795aea86a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1148&q=80");

    searchList.add(searchModel);
    searchList.add(searchModel1);
    searchList.add(searchModel2);
    searchList.add(searchModel3);
    searchList.add(searchModel4);
    searchList.add(searchModel5);
    searchList.add(searchModel6);
    searchList.add(searchModel7);
    return searchList;
  }

  @override
  Future<TabModel> getTabModel(String tab, String tab2, String tab3) async {
    List<String> categories = new List();
    categories.add(tab);
    categories.add(tab2);
    categories.add(tab3);


    return TabModel(categories: categories, length: categories.length);
  }

  @override
  Future<List<String>> getTags() async{
    List<String> tags = new List();
    for(int i = 0; i < 5; i++){
      int j = i+1;
      tags.add("Tag $j");
    }
    return tags;
  }

  @override
  void sendConfirmationSpoor(List<ConfirmModel> list, String tag) {
    // TODO: implement sendConfirmationSpoor
  }
  
}