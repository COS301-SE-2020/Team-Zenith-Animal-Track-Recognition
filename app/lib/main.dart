import 'package:ERP_Ranger/ui/views/home/home_view.dart';
import 'package:ERP_Ranger/ui/views/login/login_view.dart';
import 'core/services/graphQLConf.dart';
import 'package:ERP_Ranger/router.dart';
import 'package:ERP_Ranger/locator.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
 void main() {
   WidgetsFlutterBinding.ensureInitialized();
  // setup locator
  setupLocator();
  runApp(
    GraphQLProvider(
      client: graphQLConfiguration.client,
      child: CacheProvider(child: ERP()),
    ),
  );
}

class ERP extends StatefulWidget {

  @override
  _ERP createState() => _ERP();
}

class _ERP extends State<ERP> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: getLoggedIn(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            print(snapshot.error);
          }
          if(snapshot.data == true){
            return MaterialApp(
              title: 'Flutter Demo',
              initialRoute: 'home',
              debugShowCheckedModeBanner: false,
              onGenerateRoute: Router.generateRoute,
            );
          }else {
            return MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              initialRoute: '/',
              onGenerateRoute: Router.generateRoute,
            );
          }
        },
    );
  }
}

Future<bool> getLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool loggedIn = prefs.getBool('loggedIn') ?? false;
  prefs.setBool("loaded", false);
  await prefs.setInt('tabIndex', 0);
  return loggedIn;
}