import 'package:ERP_RANGER/ui/views/home/home_view.dart';
import 'package:flutter/material.dart';
//import 'app/router.gr.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomeView(),
      //onGenerateRoute: Router().onGenerateRoute,
    );
  }
}

