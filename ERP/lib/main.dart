import 'package:ERP_RANGER/app/locator.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'app/locator.dart';
import 'app/router.gr.dart';
void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      //home: HomeView(),
      initialRoute: Routes.homeViewRoute,
      onGenerateRoute: Router().onGenerateRoute,
      navigatorKey: locator<NavigationService>().navigatorKey,
    );
  }
}

