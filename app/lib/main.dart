import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/services/theme.dart';
import 'package:ERP_RANGER/services/util.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/api/graphQLConf.dart';
import 'package:stacked_services/stacked_services.dart';
import 'app/locator.dart';
import 'app/router.gr.dart';

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(MyApp());
}
  
class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
   return FutureBuilder<bool>(
      future: getLoggedIn(),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return progressIndicator();
        }
        if(snapshot.hasData) {
          return snapshot.hasData == true ? MaterialApp(
            theme: basicTheme(),
            initialRoute: snapshot.data ? Routes.homeViewRoute : Routes.loginViewRoute,
            onGenerateRoute: Router().onGenerateRoute,
            navigatorKey: locator<NavigationService>().navigatorKey,
          )
          :progressIndicator();
        }else{
          return progressIndicator();
        }
      },
    );
  }
}


