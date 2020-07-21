import 'dart:convert';
import 'dart:io';

import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/fake_api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final Api _api = locator<FakeApi>();

  Future<List<HomeModel>> getRecentIdentifications() async {
    List<HomeModel> recentIdentifications = await _api.getHomeModel();
    return recentIdentifications;
  }

  void navigateToSearchView() {
    _navigationService.navigateTo(Routes.searchViewRoute);
  }

  void navigateToInfo() {
    _navigationService.navigateTo(Routes.identificationViewRoute);
  }

  void navigateToConfirmView() {
    _navigationService.navigateTo(Routes.confirmlViewRoute);
  }

  void navigateToNotConfirmView() {
    _navigationService.navigateTo(Routes.notConfirmedViewRoute);
  }

  void captureImage() async {
    File image;
    final picker = ImagePicker();

    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      String url = base64Encode(image.readAsBytesSync());
      List<ConfirmModel> animals = await _api.identifyImage(url);
      if (animals != null) {
        navigateToConfirmView();
      } else {
        navigateToNotConfirmView();
      }
    }

    return null;
  }
}
// builder: (context, model, child) => Scaffold(
//     appBar: AppBar(
//       title: Text('Profile', style: TextStyle(color: Colors.white)),
//       centerTitle: false,
//       backgroundColor: Colors.black,
//       leading: IconButton(
//         icon: Icon(
//           Icons.menu,
//         ),
//         onPressed: () {},
//       ),
//       actions: <Widget>[
//         Padding(
//             padding: EdgeInsets.only(right: 20.0),
//             child: GestureDetector(
//               onTap: () {},
//               child: Icon(
//                 Icons.search,
//                 size: 26.0,
//                 color: Colors.white,
//               ),
//             )
//         ),
//         Padding(
//             padding: EdgeInsets.only(right: 20.0),
//             child: GestureDetector(
//               onTap: () {},
//               child: Icon(
//                 Icons.more_vert,
//                 color: Colors.white,
//               ),
//             )
//         )
//       ],
//     ),
//   body: topbar(),
//   bottomNavigationBar: BottomNavigation(),
//     floatingActionButton: FloatingActionButton(
//       onPressed: () {},
//       child: Icon(Icons.camera_alt),
//       backgroundColor: Colors.grey,
//     ),
// )
