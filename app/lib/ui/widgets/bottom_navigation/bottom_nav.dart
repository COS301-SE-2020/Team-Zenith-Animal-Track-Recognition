import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/fake_api.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';

class BottomNavigation extends StatefulWidget{
    static int _currentTabIndex = 0;
    void setIndex(int index){
        _currentTabIndex = index;
    }

    @override
    BottomNavigationState createState() => BottomNavigationState(_currentTabIndex);
}

class BottomNavigationState extends State<BottomNavigation> {
    //int userLevel = 2;
    int _currentTabIndex;
    BottomNavigationState(this._currentTabIndex);
    BottomNavigation model = new BottomNavigation();
    final Api _api = locator<FakeApi>();
    final NavigationService _navigationService = locator<NavigationService>();

    @override
    Widget build (BuildContext context) {

    _onTap(int selectedIndex){
      if(selectedIndex == 2 && _currentTabIndex == 3){
        _currentTabIndex = _currentTabIndex-1;
      }
      if (_currentTabIndex != selectedIndex) {
          setState(() {        
            switch (selectedIndex) {
              case 0:
                _navigationService.navigateTo(Routes.homeViewRoute);
                break;
              case 1:
                _navigationService.navigateTo(Routes.animalViewRoute);
                break;
              case 2:
                _navigationService.navigateTo(Routes.profileViewRoute);
                break;
              }
            }
          );
        }
      }

   _onTap2(int selectedIndex){
      if (_currentTabIndex != selectedIndex) {
          setState(() {        
            switch (selectedIndex) {
              case 0:
                _navigationService.navigateTo(Routes.homeViewRoute);
                break;
              case 1:
                _navigationService.navigateTo(Routes.animalViewRoute);
                break;
              case 2:
                _navigationService.navigateTo(Routes.uploadViewRoute);
                break;
              case 3:
                _navigationService.navigateTo(Routes.profileViewRoute);
                break;
              }
            }
          );
        }
      }

      return FutureBuilder(
        future: _api.getUserLevel(),
        builder: (context, snapshot){
          if(snapshot.hasError){
             return Center(child: text("Error", 20));
          }    
          if(snapshot.hasData){
            return snapshot.data == 1 
            ? Container(
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home, color: Colors.grey),
                      title: Text('Home', style: TextStyle(color: Colors.grey)),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.pets, color: Colors.grey),
                      title: Text('Animals', style: TextStyle(color: Colors.grey)),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle, color: Colors.grey),
                      title: Text('Profile', style: TextStyle(color: Colors.grey)),
                    )
                  ],
                  selectedItemColor: Color(0xFFF2929C),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Helvetica',
                    color: Colors.grey
                  ),
                  showUnselectedLabels: true,
                  unselectedItemColor: Colors.grey,
                  onTap: _onTap,
                  currentIndex: _currentTabIndex,
                ),        
            )
          : Container(
              child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home, color: Colors.grey),
                      title: Text('Home', style: TextStyle(color: Colors.grey)),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.pets, color: Colors.grey),
                      title: Text('Animals', style: TextStyle(color: Colors.grey)),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.file_upload, color: Colors.grey),
                      title: Text('Upload', style: TextStyle(color: Colors.grey)),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle, color: Colors.grey),
                      title: Text('Profile', style: TextStyle(color: Colors.grey)),
                    )
                  ],
                selectedItemColor: Colors.black,
                unselectedLabelStyle: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Helvetica',
                  color: Colors.grey
                ),
                showUnselectedLabels: true,
                unselectedItemColor: Colors.grey,
                onTap: _onTap2,
                currentIndex: _currentTabIndex,
              ),        
            );
          }
          else{
            return Center(child: text("Null no Data", 20));
          }
        }
      );
    }
}

Widget text(String text, double font){
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: font,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.bold,
      color: Colors.white
    ),
  );
}









