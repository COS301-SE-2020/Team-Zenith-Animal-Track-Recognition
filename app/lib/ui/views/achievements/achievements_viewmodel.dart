import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/graphQL.dart';
import 'package:stacked/stacked.dart';

class AchievementsViewModel extends BaseViewModel {
  //final Api _api = locator<MockApi>();
  final Api api = locator<GraphQL>();

  Future getModel() async {
    return api.getTrophies();
  }
}
