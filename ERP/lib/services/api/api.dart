import 'package:ERP_RANGER/services/datamodels/api_models.dart';

import '../datamodels/api_models.dart';
abstract class Api {
  Future<List<HomeModel>> getHomeModel();

  Future<List<AnimalModel>> getAnimalModel();

  Future<List<ProfileModel>> getProfileModel();

  Future<List<ConfirmModel>> getConfirmModel();

  Future<List<SearchModel>> getSearchModel();

  Future<List<GalleryModel>> getGalleryModel();

  Future<List<InfoModel>> getInfoModel();

  Future<LoginResponse> getLoginModel();
}