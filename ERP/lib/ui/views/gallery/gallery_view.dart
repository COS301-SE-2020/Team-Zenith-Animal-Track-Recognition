import 'package:ERP_RANGER/ui/views/gallery/gallery_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GalleryViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Center(child: Text(model.title),),
        floatingActionButton: FloatingActionButton(onPressed: model.updateCounter,),
      ), 
      viewModelBuilder: () => GalleryViewModel(),
    );
  }
}