import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Non-Functional Testing of App', () {
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

    test('Walkthrough Script', () async {
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

      await driver.scroll(find.byValueKey('HomeListBody'), 0, -400,
          Duration(milliseconds: 500));
      await driver.scroll(
          find.byValueKey('HomeListBody'), 0, 400, Duration(milliseconds: 500));

      await driver.waitFor(find.byValueKey('Search'));
      await driver.tap(find.byValueKey('Search'));
      await driver.waitFor(find.byValueKey('DefaultTabController'));
      await driver.scroll(
          find.byValueKey('ListAnimals'), 0, -400, Duration(milliseconds: 500));
      await driver.scroll(
          find.byValueKey('ListAnimals'), 0, 400, Duration(milliseconds: 500));
      await driver.tap(find.text('SPECIES'));
      await driver.scroll(
          find.byValueKey('ListAnimals'), 0, -400, Duration(milliseconds: 500));
      await driver.scroll(
          find.byValueKey('ListAnimals'), 0, 400, Duration(milliseconds: 500));

      await driver.tap(find.byTooltip('Open navigation menu'));
      await driver.tap(find.text('Home'));

      await driver.tap(find.text('Animals'));
      await driver.tap(find.text('Upload'));

      await driver.tap(find.byValueKey('attachAnimal'));
      await driver.enterText('Lion');
      await driver.waitFor(find.text('Lion'));
      print('Animal Name entered!');

      await driver.tap(find.byValueKey('Longitude'));
      await driver.enterText('27.6786844');
      await driver.waitFor(find.text('27.6786844'));
      print('Longitude entered!');

      await driver.tap(find.byValueKey('Latitude'));
      await driver.enterText('-26.1557168');
      await driver.waitFor(find.text('-26.1557168'));
      print('Latitude entered!');

      await driver.tap(find.text('Profile'));
      await driver.scroll(
          find.byValueKey('ProfileList'), 0, -400, Duration(milliseconds: 500));
      await driver.scroll(
          find.byValueKey('ProfileList'), 0, 400, Duration(milliseconds: 500));

      await driver.tap(find.byTooltip('Open navigation menu'));
      await driver.tap(find.text('Achievements'));

      await driver.tap(find.byTooltip('Open navigation menu'));
      await driver.tap(find.text('Home'));
    });
  });
}
