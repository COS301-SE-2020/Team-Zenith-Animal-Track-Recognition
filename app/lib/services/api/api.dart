import 'package:ERP_RANGER/services/datamodels/api_models.dart';

import '../datamodels/api_models.dart';

abstract class Api {
  Future<List<HomeModel>> getHomeModel();

  Future<List<AnimalModel>> getAnimalModel(String category);

  Future<TabModel> getTabModel();

  Future<List<ProfileModel>> getProfileModel();

  Future<List<SpoorModel>> getSpoorModel(String animal);

  Future<SimilarSpoorModel> getSpoorSimilarModel(String animal);

  Future<List<ConfirmModel>> getConfirmModel(
      String pic, String lat, String long);

  Future<List<SearchModel>> getSearchModel();

  Future<GalleryModel> getGalleryModel(String i);

  Future<InfoModel> getInfoModel(String name);

  Future<LoginResponse> getLoginModel(String email, String password);

  Future<List<String>> getTags();

  Future<List<String>> getAnimalTags();

  Future<ProfileInfoModel> getProfileInfoData();

  void sendConfirmationSpoor(List<ConfirmModel> list, String tag);

  Future<List<ConfirmModel>> identifyImage(String pic, String lat, String long);

  Future<int> getUserLevel();
}
