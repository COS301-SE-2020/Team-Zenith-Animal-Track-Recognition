import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


class GraphQLConfiguration {
  static HttpLink httpLink = HttpLink(
    uri: "http://ec2-13-245-35-56.af-south-1.compute.amazonaws.com:4000/graphql",
  );

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
    ),
  );

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
      link: httpLink,
    );
  }
}
