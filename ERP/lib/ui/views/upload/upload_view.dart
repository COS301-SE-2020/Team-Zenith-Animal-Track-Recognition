import 'package:ERP_RANGER/ui/views/upload/upload_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class UploadView extends StatelessWidget {
  const UploadView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UploadViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Center(child: Text(model.title),),
        floatingActionButton: FloatingActionButton(onPressed: model.updateCounter,),
      ), 
      viewModelBuilder: () => UploadViewModel(),
    );
  }
}