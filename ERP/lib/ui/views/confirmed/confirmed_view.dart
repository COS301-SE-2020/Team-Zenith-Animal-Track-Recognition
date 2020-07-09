import 'package:ERP_RANGER/ui/views/confirmed/confirmed_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ConfirmedView extends StatelessWidget {
  const ConfirmedView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ConfirmedViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Center(child: Text(model.title),),
        floatingActionButton: FloatingActionButton(onPressed: model.updateCounter,),
      ), 
      viewModelBuilder: () => ConfirmedViewModel(),
    );
  }
}