import 'package:ERP_Ranger/ui/views/home/animal_infoview.dart';
import 'package:flutter/material.dart';
import 'ui/views/confirm/confirm_view.dart';
import 'ui/views/login/login_view.dart';
import 'ui/views/home/home_view.dart';
import 'ui/views/info/info_view.dart';
import 'ui/views/home/animal_infoview.dart';
import 'ui/views/heatmap/heatmap_view.dart';

const String initialRoute = "login";

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeView());
      case 'login':
        return MaterialPageRoute(builder: (_) => LoginView());
      case 'confirm':
        return MaterialPageRoute(builder: (_) => ConfirmView());
      case 'info':
        return MaterialPageRoute(builder: (_) => InfoView());
      case 'animal_info':
        return MaterialPageRoute(builder: (_) => AnimalView(null));
      case 'heat_map':
        return MaterialPageRoute(builder: (_) => HeatMapView());

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
