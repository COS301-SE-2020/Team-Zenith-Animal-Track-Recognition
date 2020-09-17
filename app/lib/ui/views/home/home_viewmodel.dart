import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/graphQL.dart';
import 'package:ERP_RANGER/services/api/mock_api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  //final Api api = locator<GraphQL>();
  final Api api = locator<MockApi>();

  List<HomeModel> animals;
  bool newNotifications = false;

  Future<List<HomeModel>> getRecentIdentifications() async {
    List<HomeModel> recentIdentifications = await api.getHomeModel();
    animals = recentIdentifications;
    //newNotifications = await api.getNewTrophyNotification();
    return recentIdentifications;
  }
}
