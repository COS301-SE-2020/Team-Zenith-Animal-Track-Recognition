import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
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
    int userLevel = 2;
    int _currentTabIndex;
    BottomNavigationState(this._currentTabIndex);
    BottomNavigation model = new BottomNavigation();
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

        return userLevel == 1 
        ? Container(
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, size: 2,),
                  title: Text('Home'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.info_outline),
                  title: Text('Animals',),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  title: Text('Profile',),
                ),
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
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info_outline),
                title: Text('Animals',),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.file_upload),
                title: Text('Upload'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('Profile',),
              ),
            ],
            selectedItemColor: Color(0xFFF2929C),
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
}










