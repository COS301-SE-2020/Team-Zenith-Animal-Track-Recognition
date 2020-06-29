import 'dart:async';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user.dart';
import 'graphQLConf.dart';


class Api{
    

    Future<bool> login(String name, String pass) async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
        GraphQLClient _client = graphQLConfiguration.clientToQuery();

        String getlogin = """ 
          query GetLoggin(\$name: String!, \$pass: String!){
            login(User_Name: \$name, Password: \$pass){
              User_Name
              Token
              Password
              Access_Level
              e_mail
            }
          }
        """;
        QueryResult result = await _client.query(
            QueryOptions(
              documentNode: gql(getlogin),
              variables: {
                'name' : name,
                'pass' : pass,
              }
            ),
        );

        if(result.hasException){
          print(result.exception.toString());
        }
        else{
          print(result.data['login']['User_Name']);
        }

        if(result.hasException == false){
            prefs.setBool("loggedIn", true);
            prefs.setString('token', result.data['login']['Token']);
            return (true);
        }else{
            return (false);
        }

    }

    Future<List<User>> getResults() async{
        List<User> animals = [];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
        GraphQLClient _client = graphQLConfiguration.clientToQuery();

        String getlogin = """ 
          query getAnimals(\$token: String!, \$image: String!){
            imageID(Token: \$token, img: \$image){
             confidence
              animal {
                Classification
                Common_Name
                HeightM
                HeightF
                WeightM
                WeightF
                Habitats {
                  ID
                  Habitat_Name
                  Broad_Description
                  Distinguishing_Features
                  Photo_Link
                }
                Diet_Type
                Life_Span
                Gestation_Period
                Typical_Behaviour
                Pictures {
                  ID
                  GeotagID {
                    ID
                    Reporting_User_Name {
                      User_Name
                      Access_Level
                      e_mail
                    }
                    Geotag {
                      lat
                      long
                    }
                    timestamp {
                      timestamp
                    }
                  }
                }
              }
            }
          }
        """;
        QueryResult result = await _client.query(
            QueryOptions(
              documentNode: gql(getlogin),
              variables: {
                'token' : prefs.getString('token'),
                'image' : "",
              }
            ),
        );

        if(result.hasException){
          print(result.exception.toString());
        }
        else{
          //print(result.data['imageID'].length);
        }

      for(int i = 0; i < result.data['imageID'].length; i++){
        String conf ;
        double holder = result.data['imageID'][i]['confidence'] * 100;
        conf = holder.toString();
        conf = conf.substring(0,4);
        conf += "%";
        String maleH = result.data['imageID'][i]['animal']['HeightM'].toString();
        String femH = result.data['imageID'][i]['animal']['HeightF'].toString();
        String maleW = result.data['imageID'][i]['animal']['WeightM'].toString();
        String femW = result.data['imageID'][i]['animal']['WeightF'].toString();
        User animal = User(0, result.data['imageID'][i]['animal']['Common_Name'], result.data['imageID'][i]['animal']['Pictures'],
          conf, result.data['imageID'][i]['animal']['Classification'], maleH, 
          femH,  maleW, femW , 
          result.data['imageID'][i]['animal']['Diet_Type'] , result.data['imageID'][i]['animal']['Life_Span'], result.data['imageID'][i]['animal']['Gestation_Period'], 
          result.data['imageID'][i]['animal']['Typical_Behaviour'],
        );
        animals.add(animal);
      }


        if(true){
            return animals;
        }else{
            return animals;
        }
    }

    Future<bool> updateImage(String url,Map map) async{
        if(true){
            return true;
        }else{
            return false;
        }

    }


}
