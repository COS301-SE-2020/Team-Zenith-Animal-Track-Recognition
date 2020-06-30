

import 'dart:convert';
import 'dart:core';

import 'package:ERP_Ranger/core/services/graphQLConf.dart';
import 'package:ERP_Ranger/core/services/user.dart';
import 'package:ERP_Ranger/ui/views/home/animal_infoview.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class animal
{
          String classification;
          String common_Name;
          int heightM;
          int heightF;
          int weightM;
          int weightF;
          String diet_Type; 
          String life_Span;
          String gestation_Period;
          String typical_Behaviour;
}

class pictures
{
  int id;
  String url;
  String kind_of_picture;
}

class imageID
{
    double confidence;
    animal ani;
    List<pictures> pic;

}

class result
{
  List<imageID> images = new List<imageID>();
}

class mock_Api
{

bool valid = false;


 bool loginT(String name, String pass)
 {   
   return true;
 }

 bool loginF(String name, String pass)
 { 
  return false;
 }

List<User> getResults()
{
  pictures pic = new pictures();
  pic.id = 1;
  pic.kind_of_picture = "Animal";
  pic.url = "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/Lion_waiting_in_Namibia.jpg?alt=media&token=a14daabf-3b38-4861-a9c9-e32b2fab9754";

  List<pictures> pics = new List<pictures>();
  pics.add(pic);
  pics.add(pic);
  pics.add(pic);

  animal ani = new animal();

  ani.classification = "Panthera leo";
  ani.common_Name = "Lion";
  ani.heightM = 100;
  ani.heightF = 200;
  ani.weightM = 500;
  ani.weightF = 600;
  ani.diet_Type = "Carnivorous";
  ani.life_Span = "15 years";
  ani.gestation_Period = "102 days";
  ani.typical_Behaviour = "Fiercely territorial and pack-oriented, treat with caution. Will generally only charge if provoked.";

  imageID img = new imageID();
  img.ani = ani;
  img.confidence = 0.5454885442184848555;
  img.pic = pics;

  result results = new result();

  results.images.add(img);
  results.images.add(img);
  results.images.add(img);
  results.images.add(img);
  results.images.add(img);
  results.images.add(img);

        List<User> animals = [];
        
       
        if(result == null){
          throw Exception;
        }
        else{
          valid = true;
        }

      // for(int i = 0; i < results.images.length; i++){
      //   String conf ;
      //   double holder = results.images[i].confidence * 100;
      //   conf = holder.toString();
      //   conf = conf.substring(0,4);
      //   conf += "%";
      //   String maleH = results.images[i].ani.heightM.toString();  
      //   String femH = results.images[i].ani.heightF.toString();
      //   String maleW = results.images[i].ani.weightM.toString(); 
      //   String femW = results.images[i].ani.weightF.toString(); 
      //   User animal = User(0, results.images[i].ani.common_Name, results.images[i].pic.toString(),
      //     conf, results.images[i].ani.classification, maleH, 
      //     femH,  maleW, femW , 
      //     results.images[i].ani.diet_Type , results.images[i].ani.life_Span, results.images[i].ani.gestation_Period, 
      //     results.images[i].ani.typical_Behaviour,
      //   );
      //   animals.add(animal);
      // }


        if(true){
            return animals;
        }else{
            return animals;
        }
    }

List<User> getResultsE()
{
  List<User> animals = new List<User>();

  return animals;
}

List<User> getResultsN()
{
  

 result results = new result();

        List<User> animals = [];
        

       
        if(results.images == null){
          throw Exception;
        }
        else{
          valid = true;
        }

      // for(int i = 0; i < results.images.length; i++){
      //   String conf ;
      //   double holder = results.images[i].confidence * 100;
      //   conf = holder.toString();
      //   conf = conf.substring(0,4);
      //   conf += "%";
      //   String maleH = results.images[i].ani.heightM.toString();  
      //   String femH = results.images[i].ani.heightF.toString();
      //   String maleW = results.images[i].ani.weightM.toString(); 
      //   String femW = results.images[i].ani.weightF.toString(); 
      //   User animal = User(0, results.images[i].ani.common_Name, results.images[i].pic.toString(),
      //     conf, results.images[i].ani.classification, maleH, 
      //     femH,  maleW, femW , 
      //     results.images[i].ani.diet_Type , results.images[i].ani.life_Span, results.images[i].ani.gestation_Period, 
      //     results.images[i].ani.typical_Behaviour,
      //   );
      //   animals.add(animal);
      // }
  


}

bool ValidateQuery(String query)
{
  if(query.length == 0)
    return false;
  else
    return true;
}


bool login(String name, String pass)
{
         SharedPreferences.setMockInitialValues({});
        //SharedPreferences prefs = SharedPreferences.getInstance() ;
        // GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
        // GraphQLClient _client = graphQLConfiguration.clientToQuery();

        if(name == "" || pass == "")
          return false;
        else
          return true;

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
        // QueryResult result = _client.query(
        //     QueryOptions(
        //       documentNode: gql(getlogin),
        //       variables: {
        //         'name' : name,
        //         'pass' : pass,
        //       }
        //     ),
        // ) as QueryResult ;

        // if(result.hasException){
        //   print(result.exception.toString());
        // }
        // else{
        //   print(result.data['login']['User_Name']);
        // }

        // if(result.hasException == false){
        //     //prefs.setBool("loggedIn", true);
        //     //prefs.setString('token', result.data['login']['Token']);
        //     return (true);
        // }else{
        //     return (false);
        // }

    }


}