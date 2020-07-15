import 'package:ERP_Ranger/core/services/mock_api.dart';
import 'package:ERP_Ranger/core/services/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ERP_Ranger/core/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/src/services/platform_channel.dart';

void main()
{
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});


  group("Unit tests: ", ()
  {
    final api = new mock_Api();

    test (' Valid Login Verification',() async
    {
      expect(mock_Api().login("root", "12345"), true );
      

    });

    test (' Invalid Login Verification',()
    {

    expect(mock_Api().login("", ""), false);

    });


     test ('Make data request',()
    {

    expect(mock_Api().ValidateQuery(""" 
          query GetLoggin(\$name: String!, \$pass: String!){
            login(User_Name: \$name, Password: \$pass){
              User_Name
              Token
              Password
              Access_Level
              e_mail
            }
          }
        """), true);

    });

    test ('Wrong data request',()
    {

    expect(mock_Api().ValidateQuery(""), false);

    });
 
 });
}