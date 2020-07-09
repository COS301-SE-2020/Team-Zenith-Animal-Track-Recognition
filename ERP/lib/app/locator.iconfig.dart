// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:ERP_RANGER/services/api/api.dart';
import 'package:ERP_RANGER/services/api/fake_api.dart';
import 'package:ERP_RANGER/services/api/graphQL.dart';
import 'package:get_it/get_it.dart';

const bool USE_FAKE_DATA = true;

void $initGetIt(GetIt g, {String environment}) {
  // g.registerLazySingleton<FakeApi>(() => FakeApi());
  // g.registerLazySingleton<GraphQL>(() => GraphQL());
  g.registerLazySingleton<Api>(() => USE_FAKE_DATA ? FakeApi() : GraphQL());
}
