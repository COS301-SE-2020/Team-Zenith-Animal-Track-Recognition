import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'graphQLConf.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:injectable/injectable.dart';
import 'api.dart';

final String domain =
    "http://ec2-13-244-161-244.af-south-1.compute.amazonaws.com:55555/";

@lazySingleton
class GraphQL implements Api {
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  @override
  Future<List<AnimalModel>> getAnimalModel(String category) async {
    List<String> categories = new List();
    List<AnimalModel> animalList = new List();

    // SharedPreferences prefs = await SharedPreferences.getInstance();

    // String token = prefs.getString("Token");
    // token = Uri.encodeFull(token);

    // print("Here is the token: " + token);

    String token = "h10hYNuJeTbmWH1ZSi5R";
    token = Uri.encodeFull(token);

    final http.Response response = await http.get(
        "$domain" + "graphql?query=query{groups(token:\"$token\"){groupName}}");

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var list = body['data']['groups'] as List;

      String temp;
      int count;
      for (int i = 0; i < list.length; i++) {
        count = list[i].toString().length;
        temp = list[i].toString().substring(12, count - 1);
        categories.add(temp);
      }
    } else {}

    for (int i = 0; i < categories.length; i++) {
      if (category == categories[i]) {
        i++;
        final http.Response res = await http.get("$domain" +
            "graphql?query=query{animals(token:\"$token\", group:\"$i\" ){pictures{URL},classification, commonName , heightM, heightF, weightM, weightF, dietType, gestationPeriod, animalDescription, typicalBehaviourM{behaviour, threatLevel}, typicalBehaviourF{behaviour,threatLevel}}}");

        for (int j = 0; j < categories.length; j++) {
          if (res.statusCode == 200) {
            var body = json.decode(res.body);
            var list = body["data"]["animals"] as List;
            //print(list);
            animalList = list
                .map<AnimalModel>((json) => AnimalModel.fromJson(json))
                .toList();
          }
        }
      }
    }
    return animalList;
  }

  @override
  Future<List<ConfirmModel>> getConfirmModel() async {
    // TODO: implement getConfirmModel
    throw UnimplementedError();
  }

  @override
  Future<GalleryModel> getGalleryModel(String i) async {
    List<String> appearance = new List();
    List<String> tracks = new List();
    List<String> droppings = new List();
    List<List<String>> gallery = new List();
    String name;

    if (i == "diceros bicornis") {
      appearance.add("assets/images/appearance/rhino/p1.jpg");
      appearance.add("assets/images/appearance/rhino/p2.jpg");
      appearance.add("assets/images/appearance/rhino/p3.jpg");
      appearance.add("assets/images/appearance/rhino/p4.jpg");

      tracks.add("assets/images/print/rhino/print1.jpg");
      tracks.add("assets/images/print/rhino/print2.jpg");
      tracks.add("assets/images/print/rhino/print3.jpg");
      tracks.add("assets/images/print/rhino/print4.jpg");

      droppings.add("assets/images/droppings/rhino/drop1.jpg");
      droppings.add("assets/images/droppings/rhino/drop2.jpg");
      droppings.add("assets/images/droppings/rhino/drop3.jpg");
      name = "Black Rhinoceroses";
    }

    gallery.add(appearance);
    gallery.add(tracks);
    gallery.add(droppings);
    return GalleryModel(galleryList: gallery, name: name);
  }

  @override
  Future<List<HomeModel>> getHomeModel() async {
    // TODO: implement getHomeModel
    throw UnimplementedError();
  }

  @override
  Future<InfoModel> getInfoModel(String name) async {
    InfoModel infoModel;
    List<String> appearance = new List();

    print("In graph QL: " + name);

    String token = "h10hYNuJeTbmWH1ZSi5R";
    token = Uri.encodeFull(token);

    final http.Response response = await http.get("$domain" +
        "graphql?query=query{animalsByClassification(token:\"$token\", classification:\"$name\"){pictures{URL},classification, commonName,animalOverview , heightM, heightF, weightM, weightF, dietType, gestationPeriod, animalDescription, typicalBehaviourM{behaviour, threatLevel}, typicalBehaviourF{behaviour,threatLevel}}}");

    print("Response status: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      var list = body['data']['animalsByClassification']['pictures'] as List;

      String temp;
      int count;
      for (int i = 0; i < list.length; i++) {
        count = list[i].toString().length;
        temp = list[i].toString().substring(6, count - 1);
        appearance.add(temp);
      }

      String species =
          body["data"]["animalsByClassification"]["commonName"].toString();
      String commonName =
          body["data"]["animalsByClassification"]["classification"].toString();
      String gestation =
          body["data"]["animalsByClassification"]["gestationPeriod"].toString();
      String diet =
          body["data"]["animalsByClassification"]["dietType"].toString();
      String overview =
          body["data"]["animalsByClassification"]["animalOverview"].toString();
      String description = body["data"]["animalsByClassification"]
              ["animalDescription"]
          .toString();
      String behaviour = body["data"]["animalsByClassification"]
              ["typicalBehaviourM"]
          .toString();
      String habitat = "Habitat";
      String threat = "INSERT API";
      String heightF =
          body["data"]["animalsByClassification"]["heightF"].toString();
      String heightM =
          body["data"]["animalsByClassification"]["heightM"].toString();
      String weightF =
          body["data"]["animalsByClassification"]["weightF"].toString();
      String weightM =
          body["data"]["animalsByClassification"]["weightM"].toString();

      infoModel = new InfoModel(
          commonName: commonName,
          species: species,
          gestation: gestation,
          diet: diet,
          overview: overview,
          description: description,
          behaviour: behaviour,
          habitat: habitat,
          threat: threat,
          heightF: heightF,
          heightM: heightM,
          weightF: weightF,
          weightM: weightM,
          carouselImages: appearance);

      print("At the end: " + commonName);
    } else {}

    return infoModel;
  }

  @override
  Future<LoginResponse> getLoginModel(String email, String password) async {
    print("Here is the password: " + password);
    print("Here is the email: " + email);

    email = Uri.encodeFull(email);
    password = Uri.encodeFull(password);
    final http.Response response = await http.get(
      "$domain" +
          "graphql?query=query{login(eMail:\"$email\",password:\"$password\"){token,accessLevel}}",
    );

    print("Response: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      int accessLevel = int.parse(body["data"]["login"]["accessLevel"]);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("accessLevel", accessLevel);
      prefs.setString("Token", body["data"]["login"]["token"]);
      return new LoginResponse();
    }
  }

  @override
  Future<List<ProfileModel>> getProfileModel() async {
    // TODO: implement getProfileModel
    throw UnimplementedError();
  }

  @override
  Future<List<SearchModel>> getSearchModel() async {
    List<SearchModel> searchList = new List();

    String token = "h10hYNuJeTbmWH1ZSi5R";
    token = Uri.encodeFull(token);

    final http.Response response = await http.get("$domain" +
        "graphql?query=query{animals(token:\"$token\"){commonName, classification, pictures{URL}}}");

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var list = body["data"]["animals"] as List;
      print(list);
      searchList =
          list.map<SearchModel>((json) => SearchModel.fromJson(json)).toList();
    }
    return searchList;
  }

  @override
  Future<TabModel> getTabModel() async {
    List<String> categories = new List();

    String token = "h10hYNuJeTbmWH1ZSi5R";
    token = Uri.encodeFull(token);

    final http.Response response = await http.get(
        "$domain" + "graphql?query=query{groups(token:\"$token\"){groupName}}");

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var list = body['data']['groups'] as List;

      String temp;
      int count;
      for (int i = 0; i < list.length; i++) {
        count = list[i].toString().length;
        temp = list[i].toString().substring(12, count - 1);

        categories.add(temp);
      }
    } else {
      print("Error");
    }

    return TabModel(categories: categories, length: categories.length);
  }

  @override
  Future<List<String>> getTags() {
    // TODO: implement getTags
    throw UnimplementedError();
  }

  @override
  Future<int> getUserLevel() {
    // TODO: implement getTags
    throw UnimplementedError();
  }

  @override
  void sendConfirmationSpoor(List<ConfirmModel> list, String tag) {
    // TODO: implement sendConfirmationSpoor
  }

  @override
  Future<ProfileInfoModel> getProfileInfoData() {
    // TODO: implement getProfileInfoData
    throw UnimplementedError();
  }

  @override
  Future<List<ConfirmModel>> identifyImage(String url) {
    // TODO: implement identifyImage
  }

  @override
  Future<List<SpoorModel>> getSpoorModel(String animal) {
    // TODO: implement getSpoorModel
    throw UnimplementedError();
  }

  @override
  Future<SimilarSpoorModel> getSpoorSimilarModel(String animal) {
    // TODO: implement getSpoorSimilarModel
    throw UnimplementedError();
  }
}
