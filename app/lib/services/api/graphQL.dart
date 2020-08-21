import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:injectable/injectable.dart';
import 'api.dart';

@lazySingleton
class GraphQL implements Api{
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
  Future<LoginResponse> getLoginModel() async{
    // TODO: implement getLoginModel
    throw UnimplementedError();
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