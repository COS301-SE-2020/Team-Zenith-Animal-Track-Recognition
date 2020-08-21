import 'dart:convert';
import 'dart:io';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'graphQLConf.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:injectable/injectable.dart';
import 'api.dart';

final String domain = "http://putch.dyndns.org:55555/";

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
  Future<List<ConfirmModel>> getConfirmModel(
      String pic, String lat, String long) async {
    List<ConfirmModel> identifiedList = new List();

    String token = "h10hYNuJeTbmWH1ZSi5R";
    token = Uri.encodeFull(token);

    Map<String, String> headers = {"Content-type": "application/json"};

    String link = "$domain" + "graphql?";
    List<String> tag;

    String query =
        'mutation{identificationBase64(token: "$token" ,base64imge: "$pic", latitude: $lat, longitude: $long, tgas: $tag){spoorIdentificationID, potentialMatches{animal{commonName, classification, pictures{URL}}confidence}}}';

    print(query);
    final http.Response response = await http.post(
      link,
      headers: {"Content-Type": "application/json"},
      body: json.encode({'query': query}),
    );

    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      var list =
          body['data']['identificationBase64']['potentialMatches'] as List;

      String score;
      String type = "Track";
      String cName;
      String sName;
      String pic;

      double count;
      int temp = list.length - 1;

      score = body['data']['identificationBase64']['potentialMatches'][temp]
              ['confidence']
          .toString();
      count = double.parse(score) * 100;
      score = count.toString().substring(0, score.length - 1) + "%";

      cName = body['data']['identificationBase64']['potentialMatches'][temp]
              ['animal']['commonName']
          .toString();
      sName = body['data']['identificationBase64']['potentialMatches'][temp]
              ['animal']['classification']
          .toString();
      pic = body['data']['identificationBase64']['potentialMatches'][temp]
              ['animal']['pictures'][0]['URL']
          .toString();

      identifiedList.add(new ConfirmModel(
          accuracyScore: count,
          animalName: cName,
          image: pic,
          species: sName,
          type: type));

      for (int i = 0; i < list.length; i++) {
        score = body['data']['identificationBase64']['potentialMatches'][i]
                ['confidence']
            .toString();
        count = double.parse(score) * 100;
        score = count.toString().substring(0, score.length - 1) + "%";

        cName = body['data']['identificationBase64']['potentialMatches'][i]
                ['animal']['commonName']
            .toString();
        sName = body['data']['identificationBase64']['potentialMatches'][i]
                ['animal']['classification']
            .toString();
        pic = body['data']['identificationBase64']['potentialMatches'][i]
                ['animal']['pictures'][0]['URL']
            .toString();

        identifiedList.add(new ConfirmModel(
            accuracyScore: count,
            animalName: cName,
            image: pic,
            species: sName,
            type: type));
      }
    }

    print("Animal list size: " + identifiedList.length.toString());
    return identifiedList;
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
    List<HomeModel> _cards = new List();

    String token = "h10hYNuJeTbmWH1ZSi5R";
    token = Uri.encodeFull(token);

    final http.Response response = await http.get("$domain" +
        "graphql?query=query{spoorIdentification(token: \"$token\"){spoorIdentificationID,location{latitude, longitude}, dateAndTime{year, day, month},picture{URL}, ranger{firstName, lastName}, animal{commonName, classification},potentialMatches{confidence} }}");

    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      var list =
          body['data']['spoorIdentification'][0]['potentialMatches'] as List;
      int temp = list.length - 1;

      String cName;
      String sName;
      String location;
      String ranger;
      String date;
      String tag = "TBD";
      String pic;
      String score;
      double count;
      DateTime now = DateTime.now();
      DateTime track;
      int mon;
      int year;
      int day;
      String id;

      for (int i = 0; i < 15; i++) {
        cName = body['data']['spoorIdentification'][i]['animal']['commonName']
            .toString();

        sName = body['data']['spoorIdentification'][i]['animal']
                ['classification']
            .toString();
        date = body['data']['spoorIdentification'][i]['dateAndTime']['day']
                .toString() +
            " " +
            body['data']['spoorIdentification'][i]['dateAndTime']['month']
                .toString();

        mon = int.parse(body['data']['spoorIdentification'][i]['dateAndTime']
                ['month']
            .toString());
        day = int.parse(body['data']['spoorIdentification'][i]['dateAndTime']
                ['day']
            .toString());
        year = int.parse(body['data']['spoorIdentification'][i]['dateAndTime']
                ['year']
            .toString());

        track = new DateTime(year, mon, day);
        Duration difference = now.difference(track);
        date = (difference.inDays / 365).floor().toString() + " days ago";

        location = body['data']['spoorIdentification'][i]['location']
                    ['latitude']
                .toString() +
            " , " +
            body['data']['spoorIdentification'][i]['location']['longitude']
                .toString();
        ranger = body['data']['spoorIdentification'][i]['ranger']['firstName']
                .toString() +
            " " +
            body['data']['spoorIdentification'][i]['ranger']['lastName']
                .toString();

        pic =
            body['data']['spoorIdentification'][i]['picture']['URL'].toString();
        score = body['data']['spoorIdentification'][i]['potentialMatches'][temp]
                ['confidence']
            .toString();
        count = double.parse(score) * 100;
        score = count.toString().substring(0, score.length - 1) + "%";

        id = body['data']['spoorIdentification'][i]['spoorIdentificationID']
            .toString();

        _cards.add(new HomeModel(
            cName, sName, location, ranger, date, score, tag, pic, id));
      }

      return _cards;
    }
  }

  @override
  Future<InfoModel> getInfoModel(String name) async {
    InfoModel infoModel;
    List<String> appearance = new List();

    String token = "h10hYNuJeTbmWH1ZSi5R";
    token = Uri.encodeFull(token);

    final http.Response response = await http.get("$domain" +
        "graphql?query=query{animalsByClassification(token:\"$token\", classification:\"$name\"){pictures{URL},classification, commonName,animalOverview , heightM, heightF, weightM, weightF, dietType, gestationPeriod, animalDescription, typicalBehaviourM{behaviour, threatLevel}, typicalBehaviourF{behaviour,threatLevel}}}");

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
    } else {}

    return infoModel;
  }

  @override
  Future<LoginResponse> getLoginModel(String email, String password) async {
    email = Uri.encodeFull(email);
    password = Uri.encodeFull(password);
    final http.Response response = await http.get(
      "$domain" +
          "graphql?query=query{login(eMail:\"$email\",password:\"$password\"){token,accessLevel,rangerID}}",
    );

    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      int accessLevel = int.parse(body["data"]["login"]["accessLevel"]);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("accessLevel", accessLevel);
      prefs.setString("token", body["data"]["login"]["token"]);
      prefs.setString("rangerID", body["data"]["login"]["rangerID"]);
      return new LoginResponse();
    }
  }

  @override
  Future<List<ProfileModel>> getProfileModel() async {
    List<ProfileModel> _cards = new List();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token");
    token = Uri.encodeFull(token);
    String id = prefs.getString("rangerID");
    id = Uri.encodeFull(id);

    final http.Response response = await http.get("$domain" +
        "graphql?query=query{spoorIdentification(token: \"$token\", ranger: \"$id\"){spoorIdentificationID,location{latitude, longitude}, dateAndTime{year, day, month},picture{URL}, ranger{firstName, lastName}, animal{commonName, classification},potentialMatches{confidence} }}");

    print("Response: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      var list = body['data']['spoorIdentification'] as List;

      print(body['data']['spoorIdentification'][0]['potentialMatches'][0]
              ['confidence']
          .toString());

      String cName;
      String sName;
      String location;
      String ranger;
      String date;
      String tag = "TBD";
      String pic;
      String score;
      double count;
      DateTime now = DateTime.now();
      DateTime track;
      int mon;
      int year;
      int day;

      for (int i = 0; i < 15; i++) {
        cName = body['data']['spoorIdentification'][i]['animal']['commonName']
            .toString();

        sName = body['data']['spoorIdentification'][i]['animal']
                ['classification']
            .toString();
        date = body['data']['spoorIdentification'][i]['dateAndTime']['day']
                .toString() +
            " " +
            body['data']['spoorIdentification'][i]['dateAndTime']['month']
                .toString();

        mon = int.parse(body['data']['spoorIdentification'][i]['dateAndTime']
                ['month']
            .toString());
        day = int.parse(body['data']['spoorIdentification'][i]['dateAndTime']
                ['day']
            .toString());
        year = int.parse(body['data']['spoorIdentification'][i]['dateAndTime']
                ['year']
            .toString());

        track = new DateTime(year, mon, day);
        Duration difference = now.difference(track);
        date = (difference.inDays / 365).floor().toString() + " days ago";

        location = body['data']['spoorIdentification'][i]['location']
                    ['latitude']
                .toString() +
            " , " +
            body['data']['spoorIdentification'][i]['location']['longitude']
                .toString();
        ranger = body['data']['spoorIdentification'][i]['ranger']['firstName']
                .toString() +
            " " +
            body['data']['spoorIdentification'][i]['ranger']['lastName']
                .toString();

        pic =
            body['data']['spoorIdentification'][i]['picture']['URL'].toString();
        score = body['data']['spoorIdentification'][i]['potentialMatches'][0]
                ['confidence']
            .toString();
        count = double.parse(score) * 100;
        score = count.toString().substring(0, score.length - 1) + "%";
        _cards.add(new ProfileModel(
            cName, sName, location, ranger, date, score, tag, pic));
      }

      print("List length: " + _cards.length.toString());
      return _cards;
    }
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
      for (int i = 1; i < list.length; i++) {
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
  Future<List<String>> getTags() async {
    List<String> tags = new List();

    tags.add("Endagered");
    tags.add("Dangerous");
    tags.add("Infant");
    // for (int i = 0; i < 5; i++) {
    //   int j = i + 1;
    //   tags.add("Tag $j");
    // }
    return tags;
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
  Future<ProfileInfoModel> getProfileInfoData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token");
    token = Uri.encodeFull(token);
    String id = prefs.getString("rangerID");
    id = Uri.encodeFull(id);

    String query =
        'query{users(tokenIn: $token, rangerID: $id){firstName, lastName,phoneNumber, eMail, pictureURL}}';

    final http.Response response = await http.get("$domain" +
        "graphql?query=query{users(tokenIn: \"$token\", rangerID: \"$id\"){firstName, lastName,phoneNumber, eMail, pictureURL}}");

    String name;
    String numb;
    String mail;
    String pic;
    String aTrack;
    String sId;
    String sTrack;

    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      name = body['data']['users'][0]['firstName'].toString() +
          " " +
          body['data']['users'][0]['lastName'].toString();
      numb = body['data']['users'][0]['phoneNumber'].toString();
      mail = body['data']['users'][0]['eMail'].toString();
      pic = body['data']['users'][0]['pictureURL'].toString();
    }

    ProfileInfoModel profileInfo = new ProfileInfoModel(
        name: name,
        number: numb,
        email: mail,
        picture: pic,
        animalsTracked: "17",
        spoorIdentified: "150",
        speciesTracked: "38");

    return profileInfo;
  }

  @override
  Future<List<ConfirmModel>> identifyImage(
      String pic, String lat, String long) async {
    return getConfirmModel(pic, lat, long);
  }

  @override
  Future<List<SpoorModel>> getSpoorModel(String animal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<SpoorModel> _cards = new List();

    String token = prefs.getString("token");
    token = Uri.encodeFull(token);
    String id = prefs.getString("rangerID");
    id = Uri.encodeFull(id);

    final http.Response response = await http.get("$domain" +
        "graphql?query=query{spoorIdentification(token: \"$token\",spoorIdentificationID: \"$animal\" ){spoorIdentificationID,picture{URL},location{latitude, longitude}, dateAndTime{year, day, month}, ranger{firstName, lastName},potentialMatches{animal{commonName, classification, pictures{URL}},confidence} }}");

    print("Response: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      var list =
          body['data']['spoorIdentification'][0]['potentialMatches'] as List;

      String cName;
      String sName;
      String location;
      String ranger;
      String date;
      String tag = "TBD";
      String pic;
      String score;
      double count;
      DateTime now = DateTime.now();
      DateTime track;
      int mon;
      int year;
      int day;

      int temp = (list.length - 1);

      mon = int.parse(body['data']['spoorIdentification'][0]['dateAndTime']
              ['month']
          .toString());
      day = int.parse(body['data']['spoorIdentification'][0]['dateAndTime']
              ['day']
          .toString());
      year = int.parse(body['data']['spoorIdentification'][0]['dateAndTime']
              ['year']
          .toString());

      location = body['data']['spoorIdentification'][0]['location']['latitude']
              .toString() +
          " , " +
          body['data']['spoorIdentification'][0]['location']['longitude']
              .toString();
      ranger = body['data']['spoorIdentification'][0]['ranger']['firstName']
              .toString() +
          " " +
          body['data']['spoorIdentification'][0]['ranger']['lastName']
              .toString();

      track = new DateTime(year, mon, day);
      Duration difference = now.difference(track);
      date = (difference.inDays / 365).floor().toString() + " days ago";

      cName = body['data']['spoorIdentification'][0]['potentialMatches'][temp]
              ['animal']['commonName']
          .toString();
      sName = body['data']['spoorIdentification'][0]['potentialMatches'][temp]
              ['animal']['classification']
          .toString();

      score = body['data']['spoorIdentification'][0]['potentialMatches'][temp]
              ['confidence']
          .toString();
      count = double.parse(score) * 100;
      score = count.toString().substring(0, score.length - 1) + "%";

      print("Score: " + score);

      pic = body['data']['spoorIdentification'][0]['picture']['URL'].toString();

      _cards.add(new SpoorModel(
          cName, sName, location, ranger, date, score, tag, pic, ""));

      print("List length: " + temp.toString());

      for (int i = 0; i < list.length; i++) {
        cName = body['data']['spoorIdentification'][0]['potentialMatches'][i]
                ['animal']['commonName']
            .toString();
        sName = body['data']['spoorIdentification'][0]['potentialMatches'][i]
                ['animal']['classification']
            .toString();

        score = body['data']['spoorIdentification'][0]['potentialMatches'][i]
                ['confidence']
            .toString();
        count = double.parse(score) * 100;
        score = count.toString().substring(0, score.length - 1) + "%";

        pic = body['data']['spoorIdentification'][0]['potentialMatches'][i]
                ['animal']['pictures'][0]['URL']
            .toString();

        print(i);

        _cards
            .add(new SpoorModel(cName, sName, "", "", "", score, "", pic, ""));
      }

      print("List length at end: " + _cards.length.toString());
      return _cards;
    }
  }

  @override
  Future<SimilarSpoorModel> getSpoorSimilarModel(String animal) async {
    List<String> similarSpoor = new List();
    if (animal == "elephant") {
      similarSpoor.add('assets/images/print/elephant/print1.jpg');
      similarSpoor.add('assets/images/print/elephant/print2.jpg');
      similarSpoor.add('assets/images/print/elephant/print3.jpg');
      similarSpoor.add('assets/images/print/elephant/print4.jpg');
    } else if (animal == "buffalo") {
      similarSpoor.add('assets/images/print/buffalo/print1.jpg');
      similarSpoor.add('assets/images/print/buffalo/print2.jpg');
      similarSpoor.add('assets/images/print/buffalo/print3.jpg');
      similarSpoor.add('assets/images/print/buffalo/print4.jpg');
    } else if (animal == "rhino") {
      similarSpoor.add('assets/images/print/rhino/print1.jpg');
      similarSpoor.add('assets/images/print/rhino/print2.jpg');
      similarSpoor.add('assets/images/print/rhino/print3.jpg');
      similarSpoor.add('assets/images/print/rhino/print4.jpg');
    } else {
      similarSpoor.add('assets/images/print/rhino/print1.jpg');
      similarSpoor.add('assets/images/print/rhino/print2.jpg');
      similarSpoor.add('assets/images/print/rhino/print3.jpg');
      similarSpoor.add('assets/images/print/rhino/print4.jpg');
    }

    SimilarSpoorModel similarSpoorModel = new SimilarSpoorModel(similarSpoor);
    return similarSpoorModel;
  }
}
