import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/graphQL.dart';
import 'package:stacked/stacked.dart';

class BottomNavModel extends BaseViewModel {
  final Api _api = locator<GraphQL>();

  Future<int> getUserLevel() async {
    int userlevel = await _api.getUserLevel();
    return userlevel;
  }
}
