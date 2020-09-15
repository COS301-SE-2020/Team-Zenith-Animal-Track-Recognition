import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/graphQL.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  final Api api = locator<GraphQL>();
  //final Api api = locator<MockApi>();

  List<HomeModel> animals;

  Future<List<HomeModel>> getRecentIdentifications() async {
    List<HomeModel> animals = await api.getHomeModel();
    return animals;
  }
}
