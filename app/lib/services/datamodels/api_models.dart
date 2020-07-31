class HomeModel{
  String name;
  String species;
  String location;
  String captured;
  String time;
  String score;
  String tag;
  String pic;

  HomeModel(this.name, this.species, this.location, this.captured, this.time,
      this.score, this.tag, this.pic);
}

class SpoorModel{
  String name;
  String species;
  String location;
  String captured;
  String time;
  String score;
  String tag;
  String pic;

  SpoorModel(this.name, this.species, this.location, this.captured, this.time,
      this.score, this.tag, this.pic);
}

class SimilarSpoorModel{
  List<String> similarSpoors;
  SimilarSpoorModel(this.similarSpoors);
}

class AnimalModel{
  String image;
  String animalName;
  double sizeM;
  double sizeF;
  int weightM;
  int weightF;
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
  String name;
  String species;
  String location;
  String captured;
  String time;
  String score;
  String tag;
  String pic;
  
  ProfileModel(this.name, this.species, this.location, this.captured, this.time,
      this.score, this.tag, this.pic);
}

class ProfileInfoModel{
  int spoorIdentified;
  int animalsTracked;
  int speciesTracked;
  ProfileInfoModel({this.animalsTracked,this.speciesTracked,this.spoorIdentified});
}

class ConfirmModel{
  String image;
  String type;
  String animalName;
  String species;
  int accuracyScore;

  ConfirmModel({this.accuracyScore,this.animalName,this.image,this.species,this.type});
}

class SearchModel{
  String image;
  String commonName;
  String species;

  SearchModel({this.commonName,this.image,this.species});
}

class GalleryModel{
  // int numCategories;
  List<List<String>> galleryList;
  String name;
  GalleryModel({this.galleryList,this.name});
}

class InfoModel{
  String species;
  String commonName;
  String gestation;
  String diet;
  String overview;
  String description;
  String behaviour;
  String habitat;
  String threat;
  double heightF1;
  double heightF2;
  double heightM1;
  double heightM2;
  double weightF1;
  double weightF2;
  double weightM1;
  double weightM2;
  List<String> carouselImages;

InfoModel({this.species,this.commonName,this.gestation,this.diet,this.overview,this.description,this.behaviour,this.habitat,this.threat,
    this.heightF1,this.heightF2,this.heightM1,this.heightM2,this.weightF1,this.weightF2,this.weightM1, this.weightM2, this.carouselImages
  });
}

class LoginResponse{
  
}
