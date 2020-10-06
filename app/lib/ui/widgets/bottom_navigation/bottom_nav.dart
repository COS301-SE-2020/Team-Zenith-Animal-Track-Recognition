import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/app/router.gr.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/mock_api.dart';
import 'package:ERP_RANGER/services/util.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class BottomNavigation extends StatefulWidget {
  static int _currentTabIndex = 0;
  void setIndex(int index) {
    _currentTabIndex = index;
  }

  @override
  BottomNavigationState createState() =>
      BottomNavigationState(_currentTabIndex);
}

class BottomNavigationState extends State<BottomNavigation> {
  //int userLevel = 2;
  int _currentTabIndex;
  BottomNavigationState(this._currentTabIndex);
  BottomNavigation model = new BottomNavigation();
  final Api _api = locator<MockApi>();
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    _onTap(int selectedIndex) {
      if (selectedIndex == 2 && _currentTabIndex == 3) {
        _currentTabIndex = _currentTabIndex - 1;
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
        });
      }
    }

    _onTap2(int selectedIndex) {
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
        });
      }
    }

    return FutureBuilder(
        future: _api.getUserLevel(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return progressIndicator();
          }
          if (snapshot.hasData) {
            if (snapshot.data == 1) {
              return Container(
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      title: bottomNavigationText('Home', context),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.pets),
                      title: bottomNavigationText('Animals', context),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle),
                      title: bottomNavigationText('Profile', context),
                    )
                  ],
                  selectedItemColor: Color.fromRGBO(80, 156, 208, 1),
                  selectedIconTheme: IconThemeData(
                    color: Color.fromRGBO(80, 156, 208, 1),
                  ),
                  unselectedLabelStyle: TextStyle(
                      fontSize: 14,
                      fontFamily: 'MavenPro',
                      color: Colors.black87),
                  showUnselectedLabels: true,
                  unselectedItemColor: Colors.black87,
                  onTap: _onTap,
                  currentIndex: _currentTabIndex,
                ),
              );
            } else {
              return Container(
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      title: bottomNavigationText('Home', context),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.pets),
                      title: bottomNavigationText('Animals', context),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.file_upload),
                      title: bottomNavigationText('Upload', context),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle),
                      title: bottomNavigationText('Profile', context),
                    )
                  ],
                  selectedItemColor: Color.fromRGBO(80, 156, 208, 1),
                  selectedIconTheme: IconThemeData(
                    color: Color.fromRGBO(80, 156, 208, 1),
                  ),
                  unselectedLabelStyle: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Helvetica',
                      color: Colors.black87),
                  showUnselectedLabels: true,
                  unselectedItemColor: Colors.black87,
                  onTap: _onTap2,
                  currentIndex: _currentTabIndex,
                ),
              );
            }
          } else {
            return progressIndicator();
          }
        });
  }
}
