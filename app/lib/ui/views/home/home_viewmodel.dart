import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/mock_api.dart';
import 'package:ERP_RANGER/services/api/graphQL.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
<<<<<<< Updated upstream
<<<<<<< Updated upstream
import 'package:ERP_RANGER/services/verification_exception.dart';
import 'package:image_picker/image_picker.dart';
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  //final Api api = locator<GraphQL>();
  final Api api = locator<MockApi>();

  List<HomeModel> animals = null;

  Future<List<HomeModel>> getRecentIdentifications() async {
    List<HomeModel> recentIdentifications = await api.getHomeModel();
    animals = recentIdentifications;
    return recentIdentifications;
  }
}
