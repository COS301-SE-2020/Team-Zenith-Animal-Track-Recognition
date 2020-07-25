class HomeModel{

}

class AnimalModel{
  String image;
  String animalName;
  double sizeM;
  double sizeF;
  double weightM;
  double weightF;
  String diet;
  String gestation;
  String description;
  String behaviour;
  String habitats;

  AnimalModel({this.image, this.animalName, this.behaviour, this.description, this.diet, this.gestation, this.habitats, 
        this.sizeF, this.sizeM, this.weightF, this.weightM});

}

class TabModel{
  List<String> categories;
  int length;
  TabModel({this.categories, this.length});
}

class ProfileModel{

}

class ConfirmModel{
  String image;
  String type;
  String animalName;
  String species;
  double accuracyScore;

  ConfirmModel({this.accuracyScore,this.animalName,this.image,this.species,this.type});
}

class SearchModel{
  String image;
  String commonName;
  String species;

  SearchModel({this.commonName,this.image,this.species});
}

class GalleryModel{
  int numCategories;
  List<String> appearance;
  List<String> tracks;
  List<String> droppings;
  GalleryModel({this.appearance,this.droppings, this.numCategories, this.tracks});
}

class InfoModel{

}

class LoginResponse{
  
}
