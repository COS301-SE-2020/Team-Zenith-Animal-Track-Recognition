import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'graphQLConf.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:injectable/injectable.dart';
import 'api.dart';

@lazySingleton
class GraphQL implements Api{
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  @override
  Future<List<AnimalModel>> getAnimalModel(String category) async{
    // TODO: implement getAnimalModel
    throw UnimplementedError();
  }

  @override
  Future<List<ConfirmModel>> getConfirmModel() async{
    // TODO: implement getConfirmModel
    throw UnimplementedError();
  }

  @override
  Future<GalleryModel> getGalleryModel(String i) async{
    // TODO: implement getGalleryModel
    throw UnimplementedError();
  }

  @override
  Future<List<HomeModel>> getHomeModel() async{
    // TODO: implement getHomeModel
    throw UnimplementedError();
  }

  @override
  Future<InfoModel> getInfoModel(String name) async {
    // TODO: implement getInfoModel
    throw UnimplementedError();
  }

  @override
  Future<LoginResponse> getLoginModel(String email, String password) async{
        print(email);
        print(password);
        email = Uri.encodeFull(email);
        password = Uri.encodeFull(password);
         final http.Response response = await http.get(
          "http://putch.dyndns.org:55555/graphql?query=query{login(e_mail:\"$email\",Password:\"$password\"){Token,Access_Level}}",
        );

        if(response.statusCode == 200) {
            var body = json.decode(response.body);
            print(body["data"]["login"]["Token"]);
            print(body["data"]["login"]["Access_Level"]);
            int accessLevel = int.parse(body["data"]["login"]["Access_Level"]);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setInt("accessLevel",accessLevel );
            prefs.setString("Token", body["data"]["login"]["Token"]);
           // return true;
        }

  }

  @override
  Future<List<ProfileModel>> getProfileModel()async {
    // TODO: implement getProfileModel
    throw UnimplementedError();
  }

  @override
  Future<List<SearchModel>> getSearchModel() async{
    // TODO: implement getSearchModel
    throw UnimplementedError();
  }

  @override
  Future<TabModel> getTabModel(String tab, String tab2, String tab3) {
    // TODO: implement getTabModel
    throw UnimplementedError();
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