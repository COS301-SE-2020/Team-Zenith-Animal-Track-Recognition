import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/graphQL.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends BaseViewModel {
  //final Api api = locator<MockApi>();
  final Api api = locator<GraphQL>();

  Future<TempObject> getRecentIdentifications() async {
    List<ProfileModel> recentIdentifications = await api.getProfileModel();
    ProfileInfoModel infoModel = await api.getProfileInfoData();
    int userlevel = await api.getUserLevel();
    TempObject temp = TempObject(
        animalList: recentIdentifications,
        infoModel: infoModel,
        userLevel: userlevel);
    return temp;
  }
}

class TempObject {
  List<ProfileModel> animalList;
  ProfileInfoModel infoModel;
  int userLevel;
  TempObject({this.animalList, this.infoModel, this.userLevel});
}
