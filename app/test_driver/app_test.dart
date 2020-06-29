
import 'package:ERP_Ranger/core/services/user.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:ERP_Ranger/core/services/api.dart';
import 'dart:ui';


void main() {


  
  group('API Tests', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test ('API Login test',() async
    {
    final api = Api();

    expect(await Api().getResults(), List<User>().length == 6);

    });

  });
}
