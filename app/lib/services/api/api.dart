import 'package:ERP_RANGER/services/datamodels/api_models.dart';

import '../datamodels/api_models.dart';
abstract class Api {
  Future<List<HomeModel>> getHomeModel();

  Future<List<AnimalModel>> getAnimalModel(String category);

  Future<TabModel> getTabModel(String tab, String tab2, String tab3);

  Future<List<ProfileModel>> getProfileModel();

  Future<List<SpoorModel>> getSpoorModel(String animal);
  
  Future<SimilarSpoorModel> getSpoorSimilarModel(String animal);

  Future<List<ConfirmModel>> getConfirmModel();

  Future<List<SearchModel>> getSearchModel();

  Future<GalleryModel> getGalleryModel(String i);

  Future<InfoModel> getInfoModel(String name);

  Future<LoginResponse> getLoginModel();

  Future<List<String>> getTags();

  Future<ProfileInfoModel> getProfileInfoData();

  void sendConfirmationSpoor(List<ConfirmModel> list, String tag);

  Future<List<ConfirmModel>> identifyImage(String url);

  Future<int> getUserLevel();
}