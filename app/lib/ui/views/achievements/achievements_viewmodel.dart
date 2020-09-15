import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/fake_api.dart';
import 'package:ERP_RANGER/services/api/graphQL.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:ERP_RANGER/services/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AchievementsViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  //final Api _api = locator<FakeApi>();
  final Api api = locator<GraphQL>();

  Future getModel() async {
    return api.getTrophies();
  }
}
