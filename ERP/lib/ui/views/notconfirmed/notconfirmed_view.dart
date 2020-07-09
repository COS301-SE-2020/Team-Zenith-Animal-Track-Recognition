import 'package:ERP_RANGER/ui/views/notconfirmed/notconfirmed_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class NotConfirmedView extends StatelessWidget {
  const NotConfirmedView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotConfirmedViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Center(child: Text(model.title),),
        floatingActionButton: FloatingActionButton(onPressed: model.updateCounter,),
      ), 
      viewModelBuilder: () => NotConfirmedViewModel(),
    );
  }
}