import 'package:ERP_Ranger/ui/views/home/animal_infoview.dart';
import 'package:ERP_Ranger/ui/views/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'ui/views/confirm/confirm_view.dart';
import 'ui/views/login/login_view.dart';
import 'ui/views/home/home_view.dart';
import 'ui/views/info/info_view.dart';
import 'ui/views/home/animal_infoview.dart';
import 'ui/views/upload/uploadView.dart';

const String initialRoute = "login";

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeView(animal: null,));
      case 'login':
        return MaterialPageRoute(builder: (_) => LoginView());
      case 'confirm':
        return MaterialPageRoute(builder: (_) => ConfirmView(animal: null,));
      case 'info':
        return MaterialPageRoute(builder: (_) => InfoView());
      case 'animal_info':
        return MaterialPageRoute(builder: (_) => AnimalView(null));
      case 'upload':
        return MaterialPageRoute(builder: (_) => UploadView());
      case 'profile':
        return MaterialPageRoute(builder: (_) => ProfileView());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ));
    }
  }
}
