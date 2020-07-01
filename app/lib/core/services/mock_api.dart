

import 'dart:convert';
import 'dart:core';

import 'package:ERP_Ranger/core/services/graphQLConf.dart';
import 'package:ERP_Ranger/core/services/user.dart';
import 'package:ERP_Ranger/ui/views/home/animal_infoview.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockApi
{

  static final getData = [
    {
      'name': 'Elephant',
      'species': 'African Bush',
      'location': 'Kruger park',
      'captured': 'Kagiso Ndlovu',
      'time': '4m ago',
      'score': '67%',
      'tag':'tag1',
      'pic':'assets/images/Elephant.jpeg',
    },
    {
      'name': 'Rhino',
      'species': 'White',
      'location': 'Kruger park',
      'captured': 'Pricille Berlien',
      'time': '4m ago',
      'score': '92%',
      'tag':'tag2',
      'pic':'assets/images/rhino.jpeg',
    },
    {
      'name': 'Buffalo',
      'species': 'Cape Buffalo',
      'location': 'Kruger park',
      'captured': 'Charles De Clarke',
      'time': '4m ago',
      'score': '56%',
      'tag':'tag1',
      'pic':'assets/images/buffalo.jpeg',
    },
    {
      'name': 'Springbok',
      'species': 'Antelope',
      'location': 'Kruger park',
      'captured': 'Obakeng Seageng',
      'time': '10m ago',
      'score': '87%',
      'tag':'tag3',
      'pic':'assets/images/springbok.jpg',
    },
    {
      'name': 'Blesbok',
      'species': 'Antelope',
      'location': 'Kruger park',
      'captured': 'Zachary Christophers',
      'time': '80m ago',
      'score': '100%',
      'tag':'tag4',
      'pic':'assets/images/Blesbok.jpg',
    },
    {
      'name': 'Red hartebeest',
      'species': 'A. buselaphus',
      'location': 'Kruger park',
      'captured': 'Kagiso Ndlovu',
      'time': '1d ago',
      'score': '23%',
      'tag':'tag4',
      'pic':'assets/images/Red_Hartebeest.jpg',
    },
  ];
}