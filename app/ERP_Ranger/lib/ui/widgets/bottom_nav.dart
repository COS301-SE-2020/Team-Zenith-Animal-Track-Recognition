import 'package:ERP_Ranger/ui/views/home/home_view.dart';
import 'package:ERP_Ranger/ui/views/info/info_view.dart';
import 'package:ERP_Ranger/ui/views/profile/profile_view.dart';
import 'package:ERP_Ranger/ui/views/upload/uploadView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatefulWidget{
    static int _currentTabIndex = 0;
    void setIndex(int index){
        _currentTabIndex = index;
    }

    @override
    BottomNavigationState createState() => BottomNavigationState(_currentTabIndex);
}

class BottomNavigationState extends State<BottomNavigation> {
    int _currentTabIndex;
    BottomNavigationState(this._currentTabIndex);
    BottomNavigation model = new BottomNavigation();

    @override
    Widget build (BuildContext context) {

    _onTap(int selectedIndex){
      if (_currentTabIndex != selectedIndex) {
          setState(() {
            model.setIndex(selectedIndex);
        
            switch (selectedIndex) {
              case 0:
                Navigator.push(context, PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => HomeView(animal: null,),
                ),);
                break;
              case 1:
                Navigator.push(context, PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => InfoView(),
                ),);
                break;
              case 2:
                Navigator.push(context, PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => UploadView(),
                ),);
                break;
              case 3:
                Navigator.push(context, PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => ProfileView(),
                ),);
                break;
              }
            }
          );
        }
      }


        return Container(
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text('Home'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.info_outline),
                  title: Text('Info',),
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
              onTap: _onTap,
              currentIndex: _currentTabIndex,
            ),        
        );
    }
}
















// class BottomView extends StatelessWidget {
//   BottomView({Key key}) : super(key: key);

//   void setIndex(int tab){
//       _currentIndex = tab;
//   }

//   int _currentIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<BottomViewModel>.reactive(
//       builder: (context, model, child) => Container(
//           child: BottomNavigationBar(
//             currentIndex: _currentIndex,
//             items: const <BottomNavigationBarItem>[
//               BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               title: Text('Home', 
//                   style: TextStyle(
//                     fontSize: 15,
//                   ),
//                 ),
//               ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.info_outline),
//               title: Text('information', 
//                 style: TextStyle(
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//           ],
//           onTap: (index) => {
//               if(index != _currentIndex){
//                   print(index),
//                   _currentIndex = index,
//                   model.rebuild(index)
//               }
//           },
//         ),
//       ),
//       viewModelBuilder: () => BottomViewModel(),
//     );
//   }
// }