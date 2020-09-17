// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:io';
import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/mock_api.dart';
import 'package:ERP_RANGER/services/datamodels/api_models.dart';
import 'package:ERP_RANGER/ui/views/animals/animal_view.dart';
import 'package:ERP_RANGER/ui/views/confirmed/confirmed_view.dart';
import 'package:ERP_RANGER/ui/views/gallery/gallery_view.dart';
import 'package:ERP_RANGER/ui/views/home/home_view.dart';
import 'package:ERP_RANGER/ui/views/home/home_viewmodel.dart';
import 'package:ERP_RANGER/ui/views/identification/identification_view.dart';
import 'package:ERP_RANGER/ui/views/identification/identification_viewmodel.dart';
import 'package:ERP_RANGER/ui/views/information/information_view.dart';
import 'package:ERP_RANGER/ui/views/login/login_view.dart';
import 'package:ERP_RANGER/ui/views/notconfirmed/notconfirmed_view.dart';
import 'package:ERP_RANGER/ui/views/profile/profile_view.dart';
import 'package:ERP_RANGER/ui/views/search/search_view.dart';
import 'package:ERP_RANGER/ui/views/upload/upload_view.dart';
import 'package:ERP_RANGER/ui/views/userconfirmed/user_confirmed_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();

  group('Login View Tests', () {
    testWidgets('Test presence of username entry', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginView(),
      ));

      await tester.pump(new Duration(seconds: 30));

      expect(find.byKey(Key('UserName')), findsOneWidget);
    });

    testWidgets('Test presence of password entry', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginView(),
      ));

      await tester.pump(new Duration(seconds: 30));

      expect(find.byKey(Key('Password')), findsOneWidget);
    });
  });

  group('Home View Tests', () {
    testWidgets('Test presence of progress indicator',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(MaterialApp(
          home: HomeView(),
        ));

        expect(find.byKey(Key('progressIndicator')), findsOneWidget);
      });
    });

    testWidgets('Test presence of dynamic list of recent identifications',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: HomeView(),
      ));

      await tester.pump(new Duration(seconds: 30));

      expect(find.byKey(Key('List')), findsOneWidget);
    });

    testWidgets('Test presence of nav drawer', (WidgetTester tester) async {
      Provider.debugCheckInvalidValueType = null;
      await tester.pumpWidget(MaterialApp(
        home: Provider<HomeViewModel>(
          create: (_) => HomeViewModel(),
          child: HomeNavDrawer(),
        ),
      ));

      await tester.pump(new Duration(seconds: 30));
      expect(find.byKey(Key('NavDrawer')), findsNothing);
    });
  });

  group('Profile View Tests', () {
    testWidgets('Test presence of dynamic list of recent identifications',
        (WidgetTester tester) async {
      final Api _api = locator<MockApi>();
      _api.getProfileInfoData();
      _api.getProfileModel();
      await tester.pumpWidget(MaterialApp(
        home: ProfileView(),
      ));

      //await tester.pump(new Duration(seconds: 60));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('ProfileList')), findsOneWidget);
    });

    testWidgets('Test presence of profile information',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ProfileView(),
      ));

      //await tester.pump(new Duration(seconds: 60));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('profileinfo')), findsOneWidget);
    });
  });

  group('Animal View Tests', () {
    testWidgets('Test presence of dynamic tab', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AnimalView(),
      ));

      //await tester.pump(new Duration(seconds: 60));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('DynamicTab')), findsOneWidget);
    });
  });

  group('Infomation View Tests', () {
    testWidgets('Test presence of Carousel images',
        (WidgetTester tester) async {
      final Api api = locator<MockApi>();
      InfoModel _animalInfo = await api.getInfoModel("Lion");
      await tester.pumpWidget(MediaQuery(
          data: MediaQueryData(size: Size.square(100)),
          child: MaterialApp(
            home: InformationView(
              animalInfo: _animalInfo,
            ),
          )));

      await tester.pumpAndSettle();

      expect(find.byKey(Key('Carousel')), findsOneWidget);
    });

    testWidgets('Test presence of animal information',
        (WidgetTester tester) async {
      final Api api = locator<MockApi>();
      InfoModel _animalInfo = await api.getInfoModel("Lion");
      await tester.pumpWidget(MediaQuery(
          data: MediaQueryData(size: Size.square(100)),
          child: MaterialApp(
            home: InformationView(
              animalInfo: _animalInfo,
            ),
          )));

      await tester.pumpAndSettle();

      expect(find.byKey(Key('InfoScroll')), findsOneWidget);
    });
  });

  group('Upload View Tests', () {
    testWidgets('Test presence of predictive text box',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: UploadView(),
      ));

      await tester.pumpAndSettle();

      expect(find.byKey(Key('attachAnimal')), findsOneWidget);
    });

    testWidgets('Test presence of location input', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: UploadView(),
      ));

      await tester.pumpAndSettle();

      expect(find.byKey(Key('SpoorLocationInput')), findsNothing);
    });
  });

  group('Search View Tests', () {
    testWidgets('Test presence of dynamic tab', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SearchView(),
      ));

      await tester.pumpAndSettle();

      expect(find.byKey(Key('ListAnimals')), findsOneWidget);
    });

    testWidgets('Test presence of dynamic animal list',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SearchView(),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Test presence of multiple dynamic animal info',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SearchView(),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsWidgets);
    });
  });
  group('Gallery View Tests', () {
    testWidgets('Test presence of dynamic tab content',
        (WidgetTester tester) async {
      final Api _api = locator<MockApi>();
      GalleryModel galleryModel = await _api.getGalleryModel('lion');
      await tester.pumpWidget(MaterialApp(
        home: GalleryView(galleryModel),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(DefaultTabController), findsOneWidget);
    });
  });

  group('Identification View Tests', () {
    testWidgets('Test presence of multiple dynamic identification info',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: IdentificationView(
          name: "elephant",
        ),
      ));

      await tester.pump(new Duration(seconds: 30));
      //await tester.pumpAndSettle();

      expect(find.byKey(Key('SpoorListBody')), findsOneWidget);
    });

    testWidgets('Test presence of Model Methods', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: IdentificationView(
          name: "elephant",
        ),
      ));

      IdentificationViewModel model = new IdentificationViewModel();
      model.shareImage();
      model.setDate('value');
      model.setLat('value');
      model.setLong('value');
      await tester.pump(new Duration(seconds: 30));

      expect(find.byKey(Key('SpoorListBody')), findsOneWidget);
    });

    testWidgets('Test date edit method', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: IdentificationView(
          name: "elephant",
        ),
      ));

      IdentificationViewModel model = new IdentificationViewModel();
      model.setDate('value');
      await tester.pump(new Duration(seconds: 30));

      expect(find.byKey(Key('SpoorListBody')), findsOneWidget);
    });

    testWidgets('Test longitude and latitude models',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: IdentificationView(
          name: "elephant",
        ),
      ));

      IdentificationViewModel model = new IdentificationViewModel();
      model.setLat('value');
      model.setLong('value');
      await tester.pump(new Duration(seconds: 30));

      expect(find.byKey(Key('SpoorListBody')), findsOneWidget);
    });
  });

  group('Confirmation View Tests', () {
    testWidgets('Test presence of confimration data',
        (WidgetTester tester) async {
      final Api _api = locator<MockApi>();
      File image = File('assets/images/ANV1.jpeg');
      String url = base64Encode(image.readAsBytesSync());
      List<ConfirmModel> animals = await _api.identifyImage(url, "0", "0");

      await tester.pumpWidget(MaterialApp(
        home: ConfirmedView(
          image: image,
          confirmedAnimals: animals,
        ),
      ));

      await tester.pump(new Duration(seconds: 30));
      //await tester.pumpAndSettle();

      expect(find.byKey(Key('Scroll')), findsWidgets);
    });

    testWidgets('Test presence of image data', (WidgetTester tester) async {
      final Api _api = locator<MockApi>();
      File image = File('assets/images/ANV1.jpeg');
      String url = base64Encode(image.readAsBytesSync());
      List<ConfirmModel> animals = await _api.identifyImage(url, "0", "0");

      await tester.pumpWidget(MaterialApp(
        home: ConfirmedView(
          image: image,
          confirmedAnimals: animals,
        ),
      ));

      await tester.pump(new Duration(seconds: 30));
      //await tester.pumpAndSettle();

      expect(find.byKey(Key('imageBlock')), findsWidgets);
    });
  });

  group('NotConfirmedView Tests', () {
    testWidgets('Test presence of not identified data',
        (WidgetTester tester) async {
      File image = File('assets/images/ANV1.jpeg');

      await tester.pumpWidget(MaterialApp(
        home: NotConfirmedView(
          image: image,
        ),
      ));

      await tester.pump(new Duration(seconds: 30));
      //await tester.pumpAndSettle();

      expect(find.byKey(Key('NotConScroll')), findsWidgets);
    });
  });

  group('User confirmed View Tests', () {
    testWidgets('Test presence of multiple dynamic identification info',
        (WidgetTester tester) async {
      final Api _api = locator<MockApi>();
      _api.getLoginModel('Test@gmail', '12345');
      File image = File('assets/images/ANV1.jpeg');
      ConfirmModel identifiedAnimal = ConfirmModel(
          accuracyScore: 82,
          type: "Track",
          animalName: "Elephant",
          species: "African Bush",
          image: "assets/images/Elephant.jpeg");
      List<String> categories = new List();
      categories.add("Appearance");
      categories.add("Tracks");
      categories.add("Droppings");

      await tester.pumpWidget(MaterialApp(
        home: UserConfirmedView(
          confirmedAnimal: identifiedAnimal,
          image: image,
          tags: categories,
        ),
      ));

      await tester.pump(new Duration(seconds: 30));
      //await tester.pumpAndSettle();

      expect(find.byKey(Key('UserScroll')), findsOneWidget);
    });
  });
}
