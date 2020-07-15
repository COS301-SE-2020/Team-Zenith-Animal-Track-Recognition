class QueryMutation {
  String addPerson(String userName, String classifcation, int lat, int long, String time) {
    return """
      mutation {
        AddGeotags( Reporting_User_Name: "$userName", Classification: "$classifcation", lat: $lat, long: $long, timestamp: $time) {
          ID
          Reporting_User_Name {
            User_Name
          }
          Classification {
            Common_Name
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
    """;
  }

  String getImage(String token){
    return """ 
      {
        imageID(img: "", Token: "$token") {
          id
          species
          info
          img
        }
      }
    """;
  }

  String getHabitat(String token){
    return """ 
      {
        Habitats(Token:"$token"){
          Habitat_Name
          Broad_Description
          Distinguishing_Features
          Photo_Link
        }
      }
    """;
  }

  String getAnimals( String token){
    return """ 
      {
        animals(Token:"$token"){
        Common_Name
        HeightM
        HeightF
        WeightM
        WeightF
        Diet_Type
        Life_Span
        Gestation_Period
        Typical_Behaviour
        Pictures
        }
      }
    """;
  }

  String getGroup( String token){
    return """ 
      {
        Groups(Token:"$token"){
          Group_Name
        }
      }
    """;
  }
}