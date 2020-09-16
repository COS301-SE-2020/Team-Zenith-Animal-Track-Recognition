import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:injectable/injectable.dart';
import '../verification_exception.dart';
import 'api.dart';

final String domain = "http://putch.dyndns.org:55555/";
// final String domain =
//     "http://ec2-13-244-137-176.af-south-1.compute.amazonaws.com:55555/";

@lazySingleton
class GraphQL implements Api {
  @override
  Future<List<AnimalModel>> getAnimalModel(String category) async {
    List<String> categories = new List();
    List<String> groupNames = new List();
    List<AnimalModel> animalList = new List();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token");
    token = Uri.encodeFull(token);

    try {
      var connectivity = await (Connectivity().checkConnectivity());
      if (ConnectivityResult.none == connectivity) {
        throw Exception("");
      }

      final http.Response response = await http.get("$domain" +
          "graphql?query=query{groups(token:\"$token\"){groupName,groupID}}");

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        var list = body['data']['groups'] as List;

        String temp;
        for (int i = 0; i < list.length; i++) {
          temp = body['data']['groups'][i]['groupID'].toString();
          categories.add(temp);
          groupNames.add(
              body['data']['groups'][i]['groupName'].toString().toUpperCase());
        }
      } else {
        throw HttpException('500');
      }
      String groupId;
      for (int i = 0; i < categories.length; i++) {
        if (category == groupNames[i]) {
          groupId = categories[i];
          final http.Response res = await http.get("$domain" +
              "graphql?query=query{animals(token:\"$token\", group:\"$groupId\" ){pictures{URL},classification, commonName , heightM, heightF, weightM, weightF, dietType, gestationPeriod, animalDescription, typicalBehaviourM{behaviour, threatLevel}, typicalBehaviourF{behaviour,threatLevel}}}");

          for (int j = 0; j < categories.length; j++) {
            if (res.statusCode == 200) {
              var body = json.decode(res.body);
              var list = body["data"]["animals"] as List;
              animalList = list
                  .map<AnimalModel>((json) => AnimalModel.fromJson(json))
                  .toList();
            }
          }
        }
      }
      return animalList;
    } on SocketException {
      throw VerificationException(
          'Request Timed Out, Unable to Connect to The Server ');
    } on HttpException {
      throw VerificationException("Service is Unavailable");
    } on Exception {
      throw VerificationException('No Internet Connection');
    }
  }

  @override
  Future<List<ConfirmModel>> getConfirmModel(
      String pic, String lat, String long) async {
    try {
      var connectivity = await (Connectivity().checkConnectivity());
      if (ConnectivityResult.none == connectivity) {
        throw Exception("");
      }
      List<ConfirmModel> identifiedList = new List();

      SharedPreferences prefs = await SharedPreferences.getInstance();

      String token = prefs.getString("token");
      token = Uri.encodeFull(token);

      String link = "$domain" + "graphql?";
      List<String> tag;

      Position position =
          await getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);

      lat = position.latitude.toString();
      long = position.longitude.toString();

      String query =
          'mutation{identificationBase64(token: "$token" ,latitude: $lat, longitude: $long, tgas: $tag ,base64imge: "$pic" ){spoorIdentificationID, potentialMatches{animal{commonName, classification, pictures{URL}}confidence}}}';
      print(query);

      final http.Response response = await http.post(
        link,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'query': query}),
      );

      print(response.body);
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
      } else {
        throw HttpException('500');
      }
      print("Animal list size: " + identifiedList.length.toString());
      return identifiedList;
    } on SocketException {
      throw VerificationException(
          'Request Timed Out, Unable to Connect to The Server ');
    } on HttpException {
      throw VerificationException("Service is Unavailable");
    } on Exception {
      throw VerificationException('No Internet Connection');
    }
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
  Future<List<SearchModel>> getSearchModel() async {
    List<SearchModel> searchList = new List();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token");
    token = Uri.encodeFull(token);

    try {
      var connectivity = await (Connectivity().checkConnectivity());
      if (ConnectivityResult.none == connectivity) {
        throw SocketException("");
      }
      final http.Response response = await http.get("$domain" +
          "graphql?query=query{animals(token:\"$token\"){commonName, classification, pictures{URL}}}");

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        var list = body["data"]["animals"] as List;
        searchList = list
            .map<SearchModel>((json) => SearchModel.fromJson(json))
            .toList();
      } else {
        throw HttpException('500');
      }
      return searchList;
    } on SocketException {
      throw VerificationException('No Internet connection');
    } on HttpException {
      throw VerificationException("Service is unavailable");
    }
  }

  @override
  Future<List<String>> getTags() async {
    List<String> tags = new List();

    tags.add("Endagered");
    tags.add("Dangerous");
    tags.add("Infant");

    return tags;
  }

  @override
  Future<int> getUserLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("accessLevel");
  }

  @override
  void sendConfirmationSpoor(List<ConfirmModel> list, String tag) {
    // TODO: implement sendConfirmationSpoor
  }

  @override
  Future<List<ConfirmModel>> identifyImage(
      String pic, String lat, String long) async {
    return getConfirmModel(pic, lat, long);
  }

  @override
  Future<List<String>> getAnimalTags() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> _cards = new List();

    String token = prefs.getString("token");
    token = Uri.encodeFull(token);
    String id = prefs.getString("rangerID");
    id = Uri.encodeFull(id);

    try {
      var connectivity = await (Connectivity().checkConnectivity());
      if (ConnectivityResult.none == connectivity) {
        throw SocketException("");
      }
      final http.Response response = await http.get("$domain" +
          "graphql?query=query{animals(token: \"$token\"){animalID, commonName}}");

      if (response.statusCode == 200) {
        var body = json.decode(response.body);

        var list = body['data']['animals'] as List;

        for (int i = 0; i < list.length; i++) {
          _cards.add(body['data']['animals'][i]['commonName'].toString());
        }
      } else {
        throw HttpException('500');
      }

      return _cards;
    } on SocketException {
      throw VerificationException('No Internet connection');
    } on HttpException {
      throw VerificationException("Service is unavailable");
    }
  }

  @override
  Future<ConfirmModel> manualClassification(String pic, double lat, double long,
      double animalID, List<String> tags) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    token = Uri.encodeFull(token);
    int temp = animalID.toInt();
    String finalTemp = temp.toString();

    String link = "$domain" + "graphql?";
    ConfirmModel animal;

    print('Arrived here');

    try {
      var connectivity = await (Connectivity().checkConnectivity());
      if (ConnectivityResult.none == connectivity) {
        throw SocketException("");
      }

      String query =
          'mutation{UplodeBase64Identification(token: "$token",animalID: "$finalTemp" , latitude: $lat, longitude: $long, tgas: "$tags" ,base64imge: "$pic"){spoorIdentificationID, animal{commonName, classification, pictures{URL}}}}';

      print(query.toString());

      final http.Response response = await http.post(
        link,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'query': query}),
      );

      print(response.body.toString());

      if (response.statusCode == 200) {
        var body = json.decode(response.body);

        String animalName = body['data']['UplodeBase64Identification']['animal']
                ['commonName']
            .toString();
        String species = body['data']['UplodeBase64Identification']['animal']
                ['classification']
            .toString();
        String image = body['data']['UplodeBase64Identification']['animal']
                ['pictures'][0]['URL']
            .toString();

        animal = new ConfirmModel(
            accuracyScore: 0,
            animalName: animalName,
            image: image,
            species: species,
            type: "Track");
        print('Sucesss');
        return animal;
      } else {
        throw HttpException('500');
      }
    } on SocketException {
      throw VerificationException('No Internet connection');
    } on HttpException {
      throw VerificationException("Service is unavailable");
    }
  }

  @override
  Future<double> getAnimalID(String animalName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double animalID;

    String token = prefs.getString("token");
    token = Uri.encodeFull(token);
    String id = prefs.getString("rangerID");
    id = Uri.encodeFull(id);

    try {
      var connectivity = await (Connectivity().checkConnectivity());
      if (ConnectivityResult.none == connectivity) {
        throw SocketException("");
      }

      final http.Response response = await http.get("$domain" +
          "graphql?query=query{animals(token: \"$token\"){animalID, commonName}}");

      if (response.statusCode == 200) {
        var body = json.decode(response.body);

        var list = body['data']['animals'] as List;

        for (int i = 0; i < list.length; i++) {
          if (body['data']['animals'][i]['commonName'].toString() ==
              animalName) {
            animalID =
                double.parse(body['data']['animals'][i]['animalID'].toString());
          }
        }
      } else {
        throw HttpException('500');
      }
      return animalID;
    } on SocketException {
      throw VerificationException('No Internet connection');
    } on HttpException {
      throw VerificationException("Service is unavailable");
    }
  }

//=============================================

  @override
  Future<List<HomeModel>> getHomeModel() async {
    List<HomeModel> _cards = new List();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token");
    token = Uri.encodeFull(token);

    try {
      var connectivity = await (Connectivity().checkConnectivity());
      if (ConnectivityResult.none == connectivity) {
        throw Exception("");
      }

      final http.Response response = await http
          .get("$domain" +
              "graphql?query=query{spoorIdentification(token: \"$token\"){spoorIdentificationID,location{latitude, longitude}, dateAndTime{year, day, month},picture{URL}, ranger{firstName, lastName}, animal{commonName, classification},potentialMatches{confidence} }}")
          .timeout(const Duration(seconds: 7));

      if (response.statusCode == 200) {
        var body = json.decode(response.body);

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
          if (body['data']['spoorIdentification'][i]['animal']['commonName'] !=
              null) {
            cName = body['data']['spoorIdentification'][i]['animal']
                    ['commonName']
                .toString();
          } else {
            cName = 'N/A';
          }

          if (body['data']['spoorIdentification'][i]['animal']
                  ['classification'] !=
              null) {
            sName = body['data']['spoorIdentification'][i]['animal']
                    ['classification']
                .toString();
          } else {
            sName = 'N/A';
          }

          if (body['data']['spoorIdentification'][i]['dateAndTime']['month'] !=
                  null &&
              body['data']['spoorIdentification'][i]['dateAndTime']['day'] !=
                  null &&
              body['data']['spoorIdentification'][i]['dateAndTime']['year'] !=
                  null) {
            mon = int.parse(body['data']['spoorIdentification'][i]
                    ['dateAndTime']['month']
                .toString());
            day = int.parse(body['data']['spoorIdentification'][i]
                    ['dateAndTime']['day']
                .toString());
            year = int.parse(body['data']['spoorIdentification'][i]
                    ['dateAndTime']['year']
                .toString());

            track = new DateTime(year, mon, day);
            Duration difference = now.difference(track);
            date = (difference.inHours / 24).floor().toString() + " days ago";
          } else {
            date = "N/A";
          }

          if (body['data']['spoorIdentification'][i]['location']['latitude'] !=
                  null &&
              body['data']['spoorIdentification'][i]['location']['longitude'] !=
                  null) {
            location = body['data']['spoorIdentification'][i]['location']
                        ['latitude']
                    .toString() +
                " , " +
                body['data']['spoorIdentification'][i]['location']['longitude']
                    .toString();
          } else {
            location = 'N/A';
          }

          if (body['data']['spoorIdentification'][i]['ranger']['firstName'] !=
                  null &&
              body['data']['spoorIdentification'][i]['ranger']['lastName'] !=
                  null) {
            ranger = body['data']['spoorIdentification'][i]['ranger']
                        ['firstName']
                    .toString() +
                " " +
                body['data']['spoorIdentification'][i]['ranger']['lastName']
                    .toString();
          } else {
            ranger = 'N/A';
          }

          if (body['data']['spoorIdentification'][i]['picture']['URL'] !=
              null) {
            pic = body['data']['spoorIdentification'][i]['picture']['URL']
                .toString();
          } else {
            pic = "N/A";
          }

          var list = body['data']['spoorIdentification'][i]['potentialMatches']
              as List;

          if (list.length != 0) {
            if (body['data']['spoorIdentification'][i]['potentialMatches'][0]
                    ['confidence'] !=
                null) {
              score = body['data']['spoorIdentification'][i]['potentialMatches']
                      [0]['confidence']
                  .toString();
              count = double.parse(score) * 100;
              score = count.toString().substring(0, score.length - 1) + "%";
              int index = score.indexOf('.');
              if (index == (score.indexOf("%") - 1)) {
                score = score.replaceAll('.', "");
              }
            } else {
              score = 'N/A';
            }
          } else {
            score = 'N/A';
          }

          if (body['data']['spoorIdentification'][i]['spoorIdentificationID'] !=
              null) {
            id = body['data']['spoorIdentification'][i]['spoorIdentificationID']
                .toString();
          } else {
            id = 'N/A';
          }
          _cards.add(new HomeModel(
              cName, sName, location, ranger, date, score, tag, pic, id));
        }
        return _cards;
      } else {
        throw HttpException('500');
      }
    } on SocketException {
      throw VerificationException(
          'Request Timed Out, Unable to Connect to The Server ');
    } on HttpException {
      throw VerificationException("Service is Unavailable");
    } on TimeoutException {
      throw VerificationException('Request Timed Out');
    } on Exception {
      throw VerificationException('No Internet Connection');
    }
  }

  @override
  Future<List<SpoorModel>> getSpoorModel(String animal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<SpoorModel> _cards = new List();

    String token = prefs.getString("token");
    token = Uri.encodeFull(token);
    String id = prefs.getString("rangerID");
    id = Uri.encodeFull(id);

    try {
      var connectivity = await (Connectivity().checkConnectivity());
      if (ConnectivityResult.none == connectivity) {
        throw Exception("");
      }

      final http.Response response = await http
          .get("$domain" +
              "graphql?query=query{spoorIdentification(token: \"$token\",spoorIdentificationID: \"$animal\" ){spoorIdentificationID,picture{URL},location{latitude, longitude}, dateAndTime{year, day, month}, ranger{firstName, lastName},potentialMatches{animal{commonName, classification, pictures{URL}},confidence} }}")
          .timeout(const Duration(seconds: 7));

      if (response.statusCode == 200) {
        var body = json.decode(response.body);

        if (body['data']['spoorIdentification'].toString() == "[]") {
          throw VerificationException("Animal Data Not Found");
        }
        print("=======================================");
        print(body);
        print("=======================================");
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
        print(animal);
        if (body['data']['spoorIdentification'][0]['location']['latitude'] !=
                null &&
            body['data']['spoorIdentification'][0]['location']['latitude'] !=
                "" &&
            body['data']['spoorIdentification'][0]['location']['longitude'] !=
                null &&
            body['data']['spoorIdentification'][0]['location']['longitude'] !=
                "") {
          location = body['data']['spoorIdentification'][0]['location']
                      ['latitude']
                  .toString() +
              " , " +
              body['data']['spoorIdentification'][0]['location']['longitude']
                  .toString();
        } else {
          location = "N/A";
        }

        if (body['data']['spoorIdentification'][0]['ranger']['firstName'] !=
                null &&
            body['data']['spoorIdentification'][0]['ranger']['firstName'] !=
                "" &&
            body['data']['spoorIdentification'][0]['ranger']['lastName'] !=
                null &&
            body['data']['spoorIdentification'][0]['ranger']['lastName'] !=
                "") {
          ranger = body['data']['spoorIdentification'][0]['ranger']['firstName']
                  .toString() +
              " " +
              body['data']['spoorIdentification'][0]['ranger']['lastName']
                  .toString();
        } else {
          ranger = "N/A";
        }

        if (body['data']['spoorIdentification'][0]['dateAndTime']['month'] !=
                null &&
            body['data']['spoorIdentification'][0]['dateAndTime']['month'] !=
                "" &&
            body['data']['spoorIdentification'][0]['dateAndTime']['day'] !=
                null &&
            body['data']['spoorIdentification'][0]['dateAndTime']['day'] !=
                "" &&
            body['data']['spoorIdentification'][0]['dateAndTime']['year'] !=
                null &&
            body['data']['spoorIdentification'][0]['dateAndTime']['year'] !=
                "") {
          mon = int.parse(body['data']['spoorIdentification'][0]['dateAndTime']
                  ['month']
              .toString());
          day = int.parse(body['data']['spoorIdentification'][0]['dateAndTime']
                  ['day']
              .toString());
          year = int.parse(body['data']['spoorIdentification'][0]['dateAndTime']
                  ['year']
              .toString());

          track = new DateTime(year, mon, day);
          Duration difference = now.difference(track);
          date = (difference.inHours / 24).floor().toString() + " days ago";
        } else {
          date = "N/A";
        }

        if (body['data']['spoorIdentification'][0]['potentialMatches'][temp]
                    ['animal']['commonName'] !=
                null &&
            body['data']['spoorIdentification'][0]['potentialMatches'][temp]
                    ['animal']['commonName'] !=
                "") {
          cName = body['data']['spoorIdentification'][0]['potentialMatches']
                  [temp]['animal']['commonName']
              .toString();
        } else {
          cName = "N/A";
        }

        if (body['data']['spoorIdentification'][0]['potentialMatches'][temp]
                    ['animal']['classification'] !=
                null &&
            body['data']['spoorIdentification'][0]['potentialMatches'][temp]
                    ['animal']['classification'] !=
                "") {
          sName = body['data']['spoorIdentification'][0]['potentialMatches']
                  [temp]['animal']['classification']
              .toString();
        } else {
          sName = "N/A";
        }

        if (body['data']['spoorIdentification'][0]['potentialMatches'][temp]
                    ['confidence'] !=
                null &&
            body['data']['spoorIdentification'][0]['potentialMatches'][temp]
                    ['confidence'] !=
                "") {
          score = body['data']['spoorIdentification'][0]['potentialMatches']
                  [temp]['confidence']
              .toString();

          count = double.parse(score) * 100;

          score = count.toString().substring(0, score.length - 1) + "%";
          int index = score.indexOf('.');
          if (index == (score.indexOf("%") - 1)) {
            score = score.replaceAll('.', "");
          }
        } else {
          score = "N/A";
        }

        if (body['data']['spoorIdentification'][0]['picture']['URL'] != null &&
            body['data']['spoorIdentification'][0]['picture']['URL'] != "") {
          pic = body['data']['spoorIdentification'][0]['picture']['URL']
              .toString();
        } else {
          pic = "N/A";
        }

        _cards.add(new SpoorModel(
            cName, sName, location, ranger, date, score, tag, pic, ""));

        for (int i = 0; i < list.length; i++) {
          if (body['data']['spoorIdentification'][0]['potentialMatches'][i]
                      ['animal']['commonName'] !=
                  null &&
              body['data']['spoorIdentification'][0]['potentialMatches'][i]
                      ['animal']['commonName'] !=
                  "") {
            cName = body['data']['spoorIdentification'][0]['potentialMatches']
                    [i]['animal']['commonName']
                .toString();
          } else {
            cName = "N/A";
          }
          if (body['data']['spoorIdentification'][0]['potentialMatches'][i]
                      ['animal']['classification'] !=
                  null &&
              body['data']['spoorIdentification'][0]['potentialMatches'][i]
                      ['animal']['classification'] !=
                  "") {
            sName = body['data']['spoorIdentification'][0]['potentialMatches']
                    [i]['animal']['classification']
                .toString();
          } else {
            sName = "N/A";
          }

          if (body['data']['spoorIdentification'][0]['potentialMatches'][i]
                      ['confidence'] !=
                  null &&
              body['data']['spoorIdentification'][0]['potentialMatches'][i]
                      ['confidence'] !=
                  "") {
            score = body['data']['spoorIdentification'][0]['potentialMatches']
                    [i]['confidence']
                .toString();
            count = double.parse(score) * 100;
            score = count.toString().substring(0, score.length - 1) + "%";

            int index = score.indexOf('.');
            if (index == (score.indexOf("%") - 1)) {
              score = score.replaceAll('.', "");
            }
          } else {
            score = "N/A";
          }

          if (body['data']['spoorIdentification'][0]['potentialMatches'][i]
                      ['animal']['pictures'][0]['URL'] !=
                  null &&
              body['data']['spoorIdentification'][0]['potentialMatches'][i]
                      ['animal']['pictures'][0]['URL'] !=
                  "") {
            pic = body['data']['spoorIdentification'][0]['potentialMatches'][i]
                    ['animal']['pictures'][0]['URL']
                .toString();
          } else {
            pic = "N/A";
          }

          _cards.add(
              new SpoorModel(cName, sName, "", "", "", score, "", pic, ""));
        }

        return _cards;
      } else {
        throw HttpException('500');
      }
    } on SocketException {
      throw VerificationException(
          'Request Timed Out, Unable to Connect to The Server ');
    } on HttpException {
      throw VerificationException("Service is Unavailable");
    } on TimeoutException {
      throw VerificationException('Request Timed Out');
    } on Exception {
      throw VerificationException('No Internet Connection');
    }
  }

  @override
  Future<SimilarSpoorModel> getSpoorSimilarModel(String animal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token");
    token = Uri.encodeFull(token);
    String id = prefs.getString("rangerID");
    id = Uri.encodeFull(id);

    try {
      var connectivity = await (Connectivity().checkConnectivity());
      if (ConnectivityResult.none == connectivity) {
        throw Exception("");
      }

      final http.Response response = await http
          .get("$domain" +
              "graphql?query=query{spoorIdentification(token: \"$token\",spoorIdentificationID: \"$animal\" ){spoorIdentificationID,picture{URL},location{latitude, longitude}, dateAndTime{year, day, month}, ranger{firstName, lastName},potentialMatches{animal{commonName, classification, pictures{URL}},confidence} }}")
          .timeout(const Duration(seconds: 7));

      List<String> similarSpoor = new List();
      similarSpoor.add('N/A');
      similarSpoor.add('N/A');
      similarSpoor.add('N/A');
      similarSpoor.add('N/A');
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
      } else {
        throw HttpException('500');
      }
      SimilarSpoorModel similarSpoorModel = new SimilarSpoorModel(similarSpoor);
      return similarSpoorModel;
    } on SocketException {
      throw VerificationException(
          'Request Timed Out, Unable to Connect to The Server ');
    } on HttpException {
      throw VerificationException("Service is Unavailable");
    } on TimeoutException {
      throw VerificationException('Request Timed Out');
    } on Exception {
      throw VerificationException('No Internet Connection');
    }
  }

  @override
  Future<TabModel> getTabModel() async {
    List<String> categories = new List();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token");
    token = Uri.encodeFull(token);
    String id = prefs.getString("rangerID");
    id = Uri.encodeFull(id);

    try {
      var connectivity = await (Connectivity().checkConnectivity());
      if (ConnectivityResult.none == connectivity) {
        throw Exception("");
      }
      final http.Response response = await http
          .get("$domain" +
              "graphql?query=query{groups(token:\"$token\"){groupName}}")
          .timeout(const Duration(seconds: 7));

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        var list = body['data']['groups'] as List;

        String temp;
        int count;
        for (int i = 0; i < list.length; i++) {
          count = list[i].toString().length;
          temp = list[i].toString().substring(12, count - 1);

          categories.add(temp.toUpperCase());
        }
      } else {
        throw HttpException('500');
      }

      return TabModel(categories: categories, length: categories.length);
    } on SocketException {
      throw VerificationException(
          'Request Timed Out, Unable to Connect to The Server ');
    } on HttpException {
      throw VerificationException("Service is Unavailable");
    } on TimeoutException {
      throw VerificationException('Request Timed Out');
    } on Exception {
      throw VerificationException('No Internet Connection');
    }
  }

  @override
  Future<InfoModel> getInfoModel(String name) async {
    InfoModel infoModel;
    List<String> appearance = new List();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String habitat = "N/A";
    String threat = "N/A";
    String commonName;
    String gestation;
    String diet;
    String overview;
    String description;
    String behaviour;
    String heightF;
    String heightM;
    String weightF;
    String weightM;
    token = Uri.encodeFull(token);

    try {
      var connectivity = await (Connectivity().checkConnectivity());
      if (ConnectivityResult.none == connectivity) {
        throw SocketException("");
      }

      final http.Response response = await http
          .get("$domain" +
              "graphql?query=query{animalsByClassification(token:\"$token\", classification:\"$name\"){pictures{URL},classification, commonName,animalOverview , heightM, heightF, weightM, weightF, dietType, gestationPeriod, animalDescription, typicalBehaviourM{behaviour, threatLevel}, typicalBehaviourF{behaviour,threatLevel}, habitats{description}}}")
          .timeout(const Duration(seconds: 7));

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
        String species;
        if (body["data"]["animalsByClassification"]["commonName"] != null &&
            body["data"]["animalsByClassification"]["commonName"] != "") {
          species =
              body["data"]["animalsByClassification"]["commonName"].toString();
        } else {
          species = "N/A";
        }
        if (body["data"]["animalsByClassification"]["classification"] != null &&
            body["data"]["animalsByClassification"]["classification"] != "") {
          commonName = body["data"]["animalsByClassification"]["classification"]
              .toString();
        } else {
          commonName = "N/A";
        }

        if (body["data"]["animalsByClassification"]["gestationPeriod"] !=
                null &&
            body["data"]["animalsByClassification"]["gestationPeriod"] != "") {
          gestation = body["data"]["animalsByClassification"]["gestationPeriod"]
              .toString();
        } else {
          gestation = "N/A";
        }

        if (body["data"]["animalsByClassification"]["dietType"] != null &&
            body["data"]["animalsByClassification"]["dietType"] != "") {
          diet = body["data"]["animalsByClassification"]["dietType"].toString();
        } else {
          diet = "N/A";
        }

        if (body["data"]["animalsByClassification"]["animalOverview"] != null &&
            body["data"]["animalsByClassification"]["animalOverview"] != "") {
          overview = body["data"]["animalsByClassification"]["animalOverview"]
              .toString();
        } else {
          overview = "N/A";
        }

        if (body["data"]["animalsByClassification"]["animalDescription"] !=
                null &&
            body["data"]["animalsByClassification"]["animalDescription"] !=
                "") {
          description = body["data"]["animalsByClassification"]
                  ["animalDescription"]
              .toString();
        } else {
          description = "N/A";
        }

        if (body["data"]["animalsByClassification"]["typicalBehaviourM"] !=
                null &&
            body["data"]["animalsByClassification"]["typicalBehaviourM"] !=
                "") {
          behaviour = body["data"]["animalsByClassification"]
                  ["typicalBehaviourM"]
              .toString();
        } else {
          behaviour = "N/A";
        }
        if (body["data"]["animalsByClassification"]["habitats"][0]
                    ["description"] !=
                null &&
            body["data"]["animalsByClassification"]["habitats"][0]
                    ["description"] !=
                "") {
          habitat = body["data"]["animalsByClassification"]["habitats"][0]
                  ["description"]
              .toString();
        } else {
          habitat = "N/A";
        }
        if (body["data"]["animalsByClassification"]["typicalBehaviourM"]
                    ["threatLevel"] !=
                null &&
            body["data"]["animalsByClassification"]["typicalBehaviourM"]
                    ["threatLevel"] !=
                "") {
          threat = body["data"]["animalsByClassification"]["typicalBehaviourM"]
                  ["threatLevel"]
              .toString();
        } else {
          threat = "N/A";
        }
        if (body["data"]["animalsByClassification"]["heightF"] != null &&
            body["data"]["animalsByClassification"]["heightF"] != "") {
          heightF =
              body["data"]["animalsByClassification"]["heightF"].toString();
          heightF = heightF + " m";
        } else {
          heightF = "N/A";
        }
        if (body["data"]["animalsByClassification"]["heightM"] != null &&
            body["data"]["animalsByClassification"]["heightM"] != "") {
          heightM =
              body["data"]["animalsByClassification"]["heightM"].toString();
          heightM = heightM + " m";
        } else {
          heightM = "N/A";
        }
        if (body["data"]["animalsByClassification"]["weightF"] != null &&
            body["data"]["animalsByClassification"]["weightF"] != "") {
          weightF =
              body["data"]["animalsByClassification"]["weightF"].toString();
          weightF = weightF + " kg";
        } else {
          weightF = "N/A";
        }
        if (body["data"]["animalsByClassification"]["weightM"] != null &&
            body["data"]["animalsByClassification"]["weightM"] != "") {
          weightM =
              body["data"]["animalsByClassification"]["weightM"].toString();
          weightM = weightM + " kg";
        } else {
          weightM = "N/A";
        }

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
      } else {
        throw HttpException('500');
      }

      return infoModel;
    } on HttpException {
      throw VerificationException("Service is Unavailable");
    } on TimeoutException {
      throw VerificationException('Request Timed Out');
    } on Exception {
      throw VerificationException('No Internet Connection');
    }
  }

  @override
  Future<GalleryModel> getGalleryModel(String i) async {
    List<String> appearance = new List();
    List<String> tracks = new List();
    List<List<String>> gallery = new List();
    String name;

    try {
      var connectivity = await (Connectivity().checkConnectivity());
      if (ConnectivityResult.none == connectivity) {
        throw Exception("");
      }

      final http.Response response = await http.get("$domain" +
          "graphql?query=query{pictures(classification: \"$i\",kindOfPicture: \"animal\" ){picturesID,URL,kindOfPicture}}");

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        var list = body['data']['pictures'] as List;

        for (int i = 0; i < list.length; i++) {
          appearance.add(body['data']['pictures'][i]['URL'].toString());
        }
      } else {
        throw HttpException('500');
      }

      final http.Response res = await http.get("$domain" +
          "graphql?query=query{pictures(classification: \"$i\",kindOfPicture: \"trak\" ){picturesID,URL,kindOfPicture}}");

      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        var list = body['data']['pictures'] as List;

        for (int i = 0; i < list.length; i++) {
          tracks.add(body['data']['pictures'][i]['URL'].toString());
        }
      } else {
        throw HttpException('500');
      }
      name = i;
      gallery.add(appearance);
      gallery.add(tracks);
      return GalleryModel(galleryList: gallery, name: name);
    } on SocketException {
      throw VerificationException(
          'Request Timed Out, Unable to Connect to The Server ');
    } on HttpException {
      throw VerificationException("Service is Unavailable");
    } on Exception {
      throw VerificationException('No Internet Connection');
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

    try {
      var connectivity = await (Connectivity().checkConnectivity());
      if (ConnectivityResult.none == connectivity) {
        throw SocketException("");
      }

      final http.Response response = await http
          .get("$domain" +
              "graphql?query=query{spoorIdentification(token: \"$token\", ranger: \"$id\"){spoorIdentificationID,location{latitude, longitude}, dateAndTime{year, day, month},picture{URL}, ranger{firstName, lastName}, animal{commonName, classification},potentialMatches{confidence} }}")
          .timeout(const Duration(seconds: 7));

      print("Response: " + response.statusCode.toString());

      if (response.statusCode == 200) {
        var body = json.decode(response.body);

        String cName;
        String sName;
        String location;
        String ranger;
        String date;
        String tag = "TBD";
        String pic;
        String score;
        String id;
        double count;
        DateTime now = DateTime.now();
        DateTime track;
        int mon;
        int year;
        int day;

        for (int i = 0; i < 15; i++) {
          if (body['data']['spoorIdentification'][i]['animal']['commonName'] !=
              null) {
            cName = body['data']['spoorIdentification'][i]['animal']
                    ['commonName']
                .toString();
          } else {
            cName = 'N/A';
          }

          if (body['data']['spoorIdentification'][i]['animal']
                  ['classification'] !=
              null) {
            sName = body['data']['spoorIdentification'][i]['animal']
                    ['classification']
                .toString();
          } else {
            sName = 'N/A';
          }

          if (body['data']['spoorIdentification'][i]['dateAndTime']['month'] !=
                  null &&
              body['data']['spoorIdentification'][i]['dateAndTime']['day'] !=
                  null &&
              body['data']['spoorIdentification'][i]['dateAndTime']['year'] !=
                  null) {
            mon = int.parse(body['data']['spoorIdentification'][i]
                    ['dateAndTime']['month']
                .toString());
            day = int.parse(body['data']['spoorIdentification'][i]
                    ['dateAndTime']['day']
                .toString());
            year = int.parse(body['data']['spoorIdentification'][i]
                    ['dateAndTime']['year']
                .toString());

            track = new DateTime(year, mon, day);
            Duration difference = now.difference(track);
            date = (difference.inHours / 24).floor().toString() + " days ago";
          } else {
            date = "N/A";
          }

          if (body['data']['spoorIdentification'][i]['location']['latitude'] !=
                  null &&
              body['data']['spoorIdentification'][i]['location']['longitude'] !=
                  null) {
            location = body['data']['spoorIdentification'][i]['location']
                        ['latitude']
                    .toString() +
                " , " +
                body['data']['spoorIdentification'][i]['location']['longitude']
                    .toString();
          } else {
            location = 'N/A';
          }

          if (body['data']['spoorIdentification'][i]['ranger']['firstName'] !=
                  null &&
              body['data']['spoorIdentification'][i]['ranger']['lastName'] !=
                  null) {
            ranger = body['data']['spoorIdentification'][i]['ranger']
                        ['firstName']
                    .toString() +
                " " +
                body['data']['spoorIdentification'][i]['ranger']['lastName']
                    .toString();
          } else {
            ranger = 'N/A';
          }

          if (body['data']['spoorIdentification'][i]['picture']['URL'] !=
              null) {
            pic = body['data']['spoorIdentification'][i]['picture']['URL']
                .toString();
          } else {
            pic = "N/A";
          }

          var list = body['data']['spoorIdentification'][i]['potentialMatches']
              as List;

          if (list.length != 0) {
            if (body['data']['spoorIdentification'][i]['potentialMatches'][0]
                    ['confidence'] !=
                null) {
              score = body['data']['spoorIdentification'][i]['potentialMatches']
                      [0]['confidence']
                  .toString();
              count = double.parse(score) * 100;
              score = count.toString().substring(0, score.length - 1) + "%";
              int index = score.indexOf('.');
              if (index == (score.indexOf("%") - 1)) {
                score = score.replaceAll('.', "");
              }
            } else {
              score = 'N/A';
            }
          } else {
            score = 'N/A';
          }

          if (body['data']['spoorIdentification'][i]['spoorIdentificationID'] !=
              null) {
            id = body['data']['spoorIdentification'][i]['spoorIdentificationID']
                .toString();
          } else {
            id = 'N/A';
          }
          _cards.add(new ProfileModel(
              cName, sName, location, ranger, date, score, tag, pic, id));
        }

        return _cards;
      } else {
        throw HttpException('500');
      }
    } on SocketException {
      throw VerificationException(
          'Request Timed Out, Unable to Connect to The Server ');
    } on HttpException {
      throw VerificationException("Service is Unavailable");
    } on Exception {
      throw VerificationException('No Internet Connection');
    }
  }

  @override
  Future<ProfileInfoModel> getProfileInfoData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token");
    token = Uri.encodeFull(token);
    String id = prefs.getString("rangerID");
    id = Uri.encodeFull(id);

    String name;
    String numb;
    String mail;
    String pic;

    try {
      var connectivity = await (Connectivity().checkConnectivity());
      if (ConnectivityResult.none == connectivity) {
        throw SocketException("");
      }
      final http.Response response = await http
          .get("$domain" +
              "graphql?query=query{users(tokenIn: \"$token\", rangerID: \"$id\"){firstName, lastName,phoneNumber, eMail, pictureURL}}")
          .timeout(const Duration(seconds: 7));

      if (response.statusCode == 200) {
        var body = json.decode(response.body);

        if (body['data']['users'][0]['firstName'] != null &&
            body['data']['users'][0]['firstName'] != "" &&
            body['data']['users'][0]['lastName'] != null &&
            body['data']['users'][0]['lastName'] != "") {
          name = body['data']['users'][0]['firstName'].toString() +
              " " +
              body['data']['users'][0]['lastName'].toString();
        } else {
          name = "N/A";
        }

        if (body['data']['users'][0]['phoneNumber'] != null &&
            body['data']['users'][0]['phoneNumber'] != "") {
          numb = body['data']['users'][0]['phoneNumber'].toString();
        } else {
          numb = "N/A";
        }

        if (body['data']['users'][0]['eMail'] != null &&
            body['data']['users'][0]['eMail'] != "") {
          mail = body['data']['users'][0]['eMail'].toString();
        } else {
          mail = "N/A";
        }

        if (body['data']['users'][0]['pictureURL'] != null &&
            body['data']['users'][0]['pictureURL'] != "") {
          pic = body['data']['users'][0]['pictureURL'].toString();
        } else {
          pic = "N/A";
        }
      } else {
        throw HttpException('500');
      }

      final http.Response res = await http
          .get("$domain" +
              "graphql?query=query{rangersStats(token: \"$token\", rangerID: \"$id\"){spoors, mostTrackedAnimal{commonName}, nuberOfanamils}}")
          .timeout(const Duration(seconds: 7));

      String tracks;
      String noAnimals;
      if (res.statusCode == 200) {
        var body = json.decode(res.body);

        tracks = body['data']['rangersStats']['spoors'].toString();

        noAnimals = body['data']['rangersStats']['nuberOfanamils'].toString();
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      int alevel = prefs.getInt("accessLevel");
      ProfileInfoModel profileInfo = new ProfileInfoModel(
          name: name,
          number: numb,
          email: mail,
          picture: pic,
          animalsTracked: noAnimals,
          spoorIdentified: tracks,
          speciesTracked: alevel.toString());

      return profileInfo;
    } on SocketException {
      throw VerificationException(
          'Request Timed Out, Unable to Connect to The Server ');
    } on HttpException {
      throw VerificationException("Service is Unavailable");
    } on Exception {
      throw VerificationException('No Internet Connection');
    }
  }

  @override
  Future<List<TrophyModel>> getTrophies() async {
    try {
      var connectivity = await (Connectivity().checkConnectivity());
      if (ConnectivityResult.none == connectivity) {
        throw Exception("");
      }
      var check = 200;
      if (check == 200) {
        List<TrophyModel> trophies = new List();
        List<String> trophyTitled = [
          'New Recruit',
          'First Shot',
          'AK-47 Automatic',
          'Sharp Shooter',
          'Hunter',
          'Trophy 6',
          'Trophy 7',
          'Trophy 8',
          'Trophy 9',
          'Trophy 10'
        ];

        List<String> descriptions = [
          'Make First Identification',
          'Make 50 Identifications',
          'Make 75 Identifications',
          'Make 100 Identifications',
          'Track All Big 5 Animals',
          'Trophy 6',
          'Trophy 7',
          'Trophy 8',
          'Trophy 9',
          'Trophy 10'
        ];

        List<String> images = [
          'assets/images/trophies/military.png',
          'assets/images/trophies/bronze.png',
          'assets/images/trophies/silver.png',
          'assets/images/trophies/gold.png',
          'assets/images/trophies/hunter.png',
          'assets/images/trophy.png',
          'assets/images/trophy.png',
          'assets/images/trophy.png',
          'assets/images/trophy.png',
          'assets/images/trophy.png',
        ];

        for (int i = 0; i < trophyTitled.length; i++) {
          trophies.add(new TrophyModel(
              image: images[i],
              descrption: descriptions[i],
              title: trophyTitled[i]));
        }
        return trophies;
      } else {
        throw HttpException('500');
      }
    } on SocketException {
      throw VerificationException(
          'Request Timed Out, Unable to Connect to The Server ');
    } on HttpException {
      throw VerificationException("Service is Unavailable");
    } on TimeoutException {
      throw VerificationException('Request Timed Out');
    } on Exception {
      throw VerificationException('No Internet Connection');
    }
  }
}
