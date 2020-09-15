// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Counter App', () {
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

    test('check flutter driver health', () async {
      Health health = await driver.checkHealth();
      print(health.status);
    });

    test('Log in', () async {
      await driver.tap(find.byValueKey('InputUser'));
      await driver.enterText('obi@gmail.com');
      await driver.waitFor(find.text('obi@gmail.com'));
      print('Username entered!');

      await driver.tap(find.byValueKey('InputPassword'));
      await driver.enterText('12345');
      await driver.waitFor(find.text('12345'));
      print('Password entered!');

      await driver.tap(find.byValueKey('LoginButton'));
      print('Successful Log in');

      await driver.tap(find.byValueKey('TrackID'));
    });
  });
}
