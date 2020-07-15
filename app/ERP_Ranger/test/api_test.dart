import 'package:ERP_Ranger/core/services/api.dart';
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

  group("API Tests: ", ()
  {
    final api = new mock_Api();

    test ('API access test',()
    {

    expect(api.loginF("Wrong", "15454545"), false);

    });

    test ('API Login test',()
    {

    expect(api.loginT("root", "12345"), true);

    });

    test ('API return data test',()
    {

      expect(api.getResults().length, 6);

    });

     test ('API Error catch test',()
    {

    expect(api.getResultsN(), null);

    });

     test ('API invalid data test',()
    {

    expect(api.getResultsE(), []);

    });
 
  });
}