// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
import 'dart:async';

import 'package:ERP_RANGER/app/locator.dart';
import 'package:ERP_RANGER/ui/views/animals/animal_view.dart';
import 'package:ERP_RANGER/ui/views/confirmed/confirmed_view.dart';
import 'package:ERP_RANGER/ui/views/home/home_view.dart';
import 'package:ERP_RANGER/ui/views/notconfirmed/notconfirmed_view.dart';
import 'package:ERP_RANGER/ui/views/profile/profile_view.dart';
import 'package:ERP_RANGER/ui/views/upload/upload_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ERP_RANGER/main.dart';

void main() {
  setupLocator();

  group('Home View Tests', () {
    testWidgets('Test presence of dynamic card data',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: HomeView(),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(HomeListBody), findsOneWidget);
    });
  });

  group('Animal View Tests', () {
    testWidgets('Test presence of dynamic tab list data',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AnimalView(),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(DefaultTabController), findsOneWidget);
    });
    testWidgets('Test presence of dynamic tab bar data',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AnimalView(),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(TabBar), findsOneWidget);
    });

    testWidgets('Test presence of dynamic tab bar view data',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AnimalView(),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(TabBarView), findsOneWidget);
    });
  });

  group('Profile View Tests', () {
    testWidgets('Test presence of dynamic recent identifications',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ProfileView(),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(ProfileListBody), findsOneWidget);
    });
  });

  group('Confirmed View Tests', () {
    testWidgets('Test presence dynamic data sheet',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ConfirmedView(),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(Scroll), findsOneWidget);
    });
  });

  group('Not confirmed View Tests', () {
    testWidgets('Test presence dynamic data sheet',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: NotConfirmedView(),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(NotConfirmedScroll), findsOneWidget);
    });
  });
}
