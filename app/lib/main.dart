import 'package:ERP_RANGER/app/locator.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/api/graphQLConf.dart';
import 'package:stacked_services/stacked_services.dart';
import 'app/locator.dart';
import 'app/router.gr.dart';

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(GraphQLProvider(
      client: graphQLConfiguration.client,
      child: CacheProvider(child: MyApp())));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getLoggedIn(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: CircularProgressIndicator(
            value: 5,
            backgroundColor: Colors.blue,
          ));
        }
        if (snapshot.hasData) {
          return MaterialApp(
            initialRoute:
                snapshot.data ? Routes.homeViewRoute : Routes.loginViewRoute,
            onGenerateRoute: Router().onGenerateRoute,
            navigatorKey: locator<NavigationService>().navigatorKey,
          );
        } else {
          return Center(
              child: CircularProgressIndicator(
            value: 5,
            backgroundColor: Colors.blue,
          ));
        }
      },
    );
  }
}

Future<bool> getLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool loggedIn = prefs.getBool('loggedIn') ?? false;
  return false;
}
