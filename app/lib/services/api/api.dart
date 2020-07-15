import 'package:ERP_RANGER/services/datamodels/api_models.dart';

import '../datamodels/api_models.dart';
abstract class Api {
  Future<List<HomeModel>> getHomeModel();

  Future<List<AnimalModel>> getAnimalModel();

  Future<TabModel> getTabModel(String tab, String tab2, String tab3);

  Future<List<ProfileModel>> getProfileModel();

  Future<List<ConfirmModel>> getConfirmModel();

  Future<List<SearchModel>> getSearchModel();

  Future<GalleryModel> getGalleryModel();

  Future<List<InfoModel>> getInfoModel();

  Future<LoginResponse> getLoginModel();

  Future<List<String>> getTags();

  void sendConfirmationSpoor(List<ConfirmModel> list, String tag);
}