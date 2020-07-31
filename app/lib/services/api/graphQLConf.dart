import 'package:flutter/material.dart';
import "package:graphql_flutter/graphql_flutter.dart";

class GraphQLConfiguration{
  static HttpLink httpLink = HttpLink(
    uri: "http://putch.dyndns.org:55555/graphql",//server
  );

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: InMemoryCache()
    )
  );

  GraphQLClient clientToQuery(){
    return GraphQLClient(
      cache: InMemoryCache(),
      link: httpLink,
    );
  }
}