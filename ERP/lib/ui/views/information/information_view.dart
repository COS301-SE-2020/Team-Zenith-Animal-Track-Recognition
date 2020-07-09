import 'package:ERP_RANGER/ui/views/information/information_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class InformationView extends StatelessWidget {
  const InformationView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InformationViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Center(child: Text(model.title),),
        floatingActionButton: FloatingActionButton(onPressed: model.updateCounter,),
      ), 
      viewModelBuilder: () => InformationViewModel(),
    );
  }
}