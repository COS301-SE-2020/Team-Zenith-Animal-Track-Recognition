class HomeModel {
  String name;
  String species;
  String location;
  String captured;
  String time;
  String score;
  String tag;
  String pic;
  String id;

  HomeModel(this.name, this.species, this.location, this.captured, this.time,
      this.score, this.tag, this.pic, this.id);
}

class SpoorModel {
  String name;
  String species;
  String location;
  String captured;
  String time;
  String score;
  String tag;
  String pic;
  String id;

  SpoorModel(this.name, this.species, this.location, this.captured, this.time,
      this.score, this.tag, this.pic, this.id);
}

class SimilarSpoorModel {
  List<String> similarSpoors;
  SimilarSpoorModel(this.similarSpoors);
}

class AnimalModel {
  String image;
  String animalName;
  String classification;
  String sizeM;
  String sizeF;
  String weightM;
  String weightF;
  String diet;
  String gestation;
  String description;
  String behaviour;
  String habitats;

  AnimalModel(
      {this.image,
      this.animalName,
      this.classification,
      this.behaviour,
      this.description,
      this.diet,
      this.gestation,
      this.habitats,
      this.sizeF,
      this.sizeM,
      this.weightF,
      this.weightM});

  factory AnimalModel.fromJson(Map<String, dynamic> json) {
    return AnimalModel(
      image: json["pictures"][0]
          .toString()
          .substring(6, json["pictures"][0].toString().length - 1),
      classification: json["classification"].toString(),
      animalName: json["commonName"].toString(),
      behaviour: json["typicalBehaviourM"].toString(),
      description: json["animalDescription"].toString(),
      diet: json["dietType"].toString(),
      gestation: json["gestationPeriod"].toString(),
      habitats: "INSERT FROM API",
      sizeM: json["heightM"].toString(),
      sizeF: json["heightF"].toString(),
      weightM: json["weightM"].toString(),
      weightF: json["weightF"].toString(),
    );
  }
}

class TabModel {
  List<String> categories;
  int length;
  TabModel({this.categories, this.length});
}

class ProfileModel {
  String name;
  String species;
  String location;
  String captured;
  String time;
  String score;
  String tag;
  String pic;
  String id;

  ProfileModel(this.name, this.species, this.location, this.captured, this.time,
      this.score, this.tag, this.pic, this.id);
}

class ProfileInfoModel {
  String name;
  String number;
  String email;
  String picture;
  String spoorIdentified;
  String animalsTracked;
  String speciesTracked;
  ProfileInfoModel(
      {this.name,
      this.number,
      this.email,
      this.picture,
      this.animalsTracked,
      this.speciesTracked,
      this.spoorIdentified});
}

class ConfirmModel {
  String image;
  String type;
  String animalName;
  String species;
  double accuracyScore;

  ConfirmModel(
      {this.accuracyScore,
      this.animalName,
      this.image,
      this.species,
      this.type});
}

class SearchModel {
  String image;
  String commonName;
  String species;

  SearchModel({this.commonName, this.image, this.species});

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
        commonName: json["commonName"].toString(),
        species: json["classification"].toString(),
        image: json["pictures"][0]
            .toString()
            .substring(6, json["pictures"][0].toString().length - 1));
  }
}

class GalleryModel {
  List<List<String>> galleryList;
  String name;
  GalleryModel({this.galleryList, this.name});
}

class InfoModel {
  String species;
  String commonName;
  String gestation;
  String diet;
  String overview;
  String description;
  String behaviour;
  String habitat;
  String threat;
  String heightF;
  String heightM;
  String weightF;
  String weightM;
  List<String> carouselImages;

  InfoModel(
      {this.species,
      this.commonName,
      this.gestation,
      this.diet,
      this.overview,
      this.description,
      this.behaviour,
      this.habitat,
      this.threat,
      this.heightF,
      this.heightM,
      this.weightF,
      this.weightM,
      this.carouselImages});

  factory InfoModel.fromJson(Map<String, dynamic> json, List<String> list) {
    return InfoModel(
        species: json["classification"],
        commonName: json["commonName"],
        gestation: json["gestationPeriod"],
        diet: json["dietType"],
        overview: json["animalOverview"],
        description: json["animalDescription"],
        behaviour: json["typicalBehaviourM"],
        habitat: "INSERT API",
        threat: "Information to be filled",
        heightF: json["heightF"],
        heightM: json["heightM"],
        weightF: json["weightF"],
        weightM: json["weightM"],
        carouselImages: list);
  }
}

class TrophyModel {
  String title;
  String descrption;
  String image;

  TrophyModel({this.descrption, this.image, this.title});
}
