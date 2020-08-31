import 'dart:io';

import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/services/theme.dart';
import 'package:ERP_RANGER/services/util.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/api/graphQLConf.dart';
import 'package:path/path.dart' as p;
import 'package:stacked_services/stacked_services.dart';
import 'app/locator.dart';
import 'app/router.gr.dart';

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
Directory _appDocsDir;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _appDocsDir = await getApplicationDocumentsDirectory();
  setupLocator();
  runApp(MyApp());
}

File fileFromDocsDir(String filename) {
  String pathName = p.join(_appDocsDir.path, filename);
  return File(pathName);
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
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return progressIndicator();
        }
        if (snapshot.hasData) {
          return snapshot.hasData == true
              ? MaterialApp(
                  theme: basicTheme(),
                  initialRoute: snapshot.data
                      // ? Routes.loginViewRoute
                      // : Routes.homeViewRoute,
                      ? Routes.uploadViewRoute
                      : Routes.uploadViewRoute,
                  onGenerateRoute: Router().onGenerateRoute,
                  navigatorKey: locator<NavigationService>().navigatorKey,
                )
              : progressIndicator();
        } else {
          return progressIndicator();
        }
      },
    );
  }
}
