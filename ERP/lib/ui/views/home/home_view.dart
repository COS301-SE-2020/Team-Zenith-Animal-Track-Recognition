import 'package:ERP_RANGER/ui/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Center(child: Text(model.title),),
        floatingActionButton: FloatingActionButton(onPressed: model.updateCounter,),
      ), 
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}