import 'package:ERP_RANGER/ui/views/identification/identification_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class IdentificationView extends StatelessWidget {
  const IdentificationView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<IdentificationViewModel>.reactive(
      builder: (context, model, child) =>FutureBuilder(
        future: model.getIdentified(),
      ), 
      viewModelBuilder: () => IdentificationViewModel(),
    );
  }
}