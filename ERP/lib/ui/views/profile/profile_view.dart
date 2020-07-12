import 'package:ERP_RANGER/ui/views/profile/profile_viewmodel.dart';
import 'package:ERP_RANGER/ui/widgets/bottom_navigation/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    int userLevel = 2;
    BottomNavigation bottomNavigation = BottomNavigation();
    if(userLevel == 1){
      bottomNavigation.setIndex(2);
    }else{
      bottomNavigation.setIndex(3);
    }

    return ViewModelBuilder<ProfileViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Center(child: Text(model.title),),
        bottomNavigationBar: BottomNavigation(),
        floatingActionButton: FloatingActionButton(onPressed: model.updateCounter,),
      ), 
      viewModelBuilder: () => ProfileViewModel(),
    );
  }
}