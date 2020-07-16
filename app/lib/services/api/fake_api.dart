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
      animalName: "AFRICAN BUSH ELEPHANT",diet: "Herbivore",gestation: "24 Months",sizeM: 3.5,sizeF: 3.2,weightF: 4500,weightM: 6000,
      image: "https://images.unsplash.com/photo-1505148230895-d9a785a555fa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2134&q=80",
      description: "This body text is used for demonstration purposes",behaviour: "This body text is used for demonstration purposes",habitats: "This body text is used for demonstration purposes",
    );

    AnimalModel wildebeest = AnimalModel(
      animalName: "Black Wildebeest",diet: "Herbivore",gestation: "24 Months",sizeM: 3,sizeF: 2.8,weightF: 350,weightM: 450,
      image: "https://images.unsplash.com/photo-1516729445616-0393420f6089?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
      description: "This body text is used for demonstration purposes",behaviour: "This body text is used for demonstration purposes",habitats: "This body text is used for demonstration purposes",
    );

    AnimalModel jackal = AnimalModel(
      animalName: "Black-Backed Jackal",diet: "Carnivore",gestation: "8 Months",sizeM: 15,sizeF: 1.2,weightF: 56,weightM: 61,
      image: "https://images.unsplash.com/photo-1576313966078-951c6cdd8866?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
      description: "This body text is used for demonstration purposes",behaviour: "This body text is used for demonstration purposes",habitats: "This body text is used for demonstration purposes",
    );

    AnimalModel hippo = AnimalModel(
      animalName: "Common Hippopotamus",diet: "Omnivore",gestation: "15 Months",sizeM: 2.3,sizeF: 2.1,weightF: 1600,weightM: 1800,
      image: "https://images.unsplash.com/photo-1553521306-9387d3795516?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
      description: "This body text is used for demonstration purposes",behaviour: "This body text is used for demonstration purposes",habitats: "This body text is used for demonstration purposes",
    );

    AnimalModel buffalo = AnimalModel(
      animalName: "Cape Buffalo",diet: "Herbivore",gestation: "13 Months",sizeM:2.0,sizeF: 1.8,weightF: 330,weightM: 470,
      image: "https://images.unsplash.com/photo-1508605375977-9fe795aea86a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1148&q=80",
      description: "This body text is used for demonstration purposes",behaviour: "This body text is used for demonstration purposes",habitats: "This body text is used for demonstration purposes",
    );
    animalList.add(buffalo);
    animalList.add(elephant);
    animalList.add(hippo);
    animalList.add(jackal);
    animalList.add(wildebeest
    );
    return animalList;
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
  HomeModel card1 = new HomeModel('Elephant','African Bush','Kruger park','Kagiso Ndlovu','4m ago','67%','Dangerous','assets/images/Elephant.jpeg');

  HomeModel card2 = new HomeModel('Rhino','White','Kruger park','Pricille Berlien','4m ago','92%','Endangered','assets/images/rhino.jpeg',);

  HomeModel card3 = new HomeModel('Buffalo','Cape Buffalo','Kruger park','Charles De Clarke','4m ago','56%','tag1','assets/images/buffalo.jpeg');

  HomeModel card4 = new HomeModel('Springbok','Antelope','Kruger park','Obakeng Seageng','10m ago','87%','Abundant','assets/images/springbok.jpg');

  HomeModel card5 = new HomeModel('Blesbok','Antelope','Kruger park','Zachary Christophers','80m ago','100%','tag4','assets/images/Blesbok.jpg');

  HomeModel card6 = new HomeModel('Red hartebeest','A. buselaphus','Kruger park','Kagiso Ndlovu','1d ago','23%','tag4','assets/images/Red_Hartebeest.jpg');
  
      List<HomeModel> _cards = new List();
      _cards.add(card1);
      _cards.add(card2);
      _cards.add(card3);
      _cards.add(card4);
      _cards.add(card5);
      _cards.add(card6);

      return _cards;
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
 
  ProfileModel card1 = new ProfileModel('Elephant','African Bush','Kruger park','Kagiso Ndlovu','4m ago','67%','Dangerous','assets/images/Elephant.jpeg');

  ProfileModel card2 = new ProfileModel('Rhino','White','Kruger park','Pricille Berlien','4m ago','92%','Endangered','assets/images/rhino.jpeg',);

  ProfileModel card3 = new ProfileModel('Buffalo','Cape Buffalo','Kruger park','Charles De Clarke','4m ago','56%','tag1','assets/images/buffalo.jpeg');

  ProfileModel card4 = new ProfileModel('Springbok','Antelope','Kruger park','Obakeng Seageng','10m ago','87%','Abundant','assets/images/springbok.jpg');

  ProfileModel card5 = new ProfileModel('Blesbok','Antelope','Kruger park','Zachary Christophers','80m ago','100%','tag4','assets/images/Blesbok.jpg');

  ProfileModel card6 = new ProfileModel('Red hartebeest','A. buselaphus','Kruger park','Kagiso Ndlovu','1d ago','23%','tag4','assets/images/Red_Hartebeest.jpg');
      
       List<ProfileModel> _cards = new List();
      _cards.add(card1);
      _cards.add(card2);
      _cards.add(card3);
      _cards.add(card4);
      _cards.add(card5);
      _cards.add(card6);

      return _cards;
  }

  @override
  Future<List<ConfirmModel>> getConfirmModel() async{
    List<ConfirmModel> identifiedList = new List();
    ConfirmModel identifiedAnimal = ConfirmModel(accuracyScore: 82,type:"Track",animalName: "Elephant", species: "African Bush", image: "https://images.unsplash.com/photo-1551316679-9c6ae9dec224?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60");
    ConfirmModel identifiedAnimal1 = ConfirmModel(accuracyScore: 73,type:"Track",animalName: "Wildebeest", species: "Black Wildebeest", image: "https://images.unsplash.com/photo-1516729445616-0393420f6089?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80");  
    ConfirmModel identifiedAnimal2 = ConfirmModel(accuracyScore: 59,type:"Track",animalName: "Jackal", species: "Black-Backed Jackal", image: "https://images.unsplash.com/photo-1576313966078-951c6cdd8866?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80");
    ConfirmModel identifiedAnimal3 = ConfirmModel(accuracyScore: 32,type:"Track",animalName: "Hippopotamus", species: "Common Hippopotamus", image: "https://images.unsplash.com/photo-1553521306-9387d3795516?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80");  
    ConfirmModel identifiedAnimal4 = ConfirmModel(accuracyScore: 11,type:"Track",animalName: "Antelope", species: "Blesbok", image: "https://images.unsplash.com/photo-1590692462025-f84292449cbe?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1051&q=80");

    identifiedList.add(identifiedAnimal);
    identifiedList.add(identifiedAnimal1);
    identifiedList.add(identifiedAnimal2);
    identifiedList.add(identifiedAnimal3);
    identifiedList.add(identifiedAnimal4);
    return identifiedList;
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

  @override
  Future<ProfileInfoModel> getProfileInfoData() async{
    ProfileInfoModel profileInfo = new ProfileInfoModel(animalsTracked: 17, spoorIdentified: 150,speciesTracked: 38);
    return profileInfo;
  }

  @override
  Future<List<ConfirmModel>>identifyImage(String url) {
      if(true){
        return getConfirmModel();
      }else{
        return null;
      }
  }
  
}