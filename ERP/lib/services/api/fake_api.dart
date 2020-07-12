import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:injectable/injectable.dart';
import 'api.dart';

@lazySingleton
class FakeApi implements Api{
  @override
  Future<List<AnimalModel>> getAnimalModel() async{
    // TODO: implement getAnimalModel
    throw UnimplementedError();
  }

  @override
  Future<List<ConfirmModel>> getConfirmModel() async{
    // TODO: implement getConfirmModel
    throw UnimplementedError();
  }

  @override
  Future<List<GalleryModel>> getGalleryModel() async{
    // TODO: implement getGalleryModel
    throw UnimplementedError();
  }

  @override
  Future<List<HomeModel>> getHomeModel() async{
    // TODO: implement getHomeModel
    throw UnimplementedError();
  }

  @override
  Future<List<InfoModel>> getInfoModel() async {
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
  
}