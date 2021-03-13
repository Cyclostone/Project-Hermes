import 'package:flutter/material.dart';
import 'package:gql_exec/gql_exec.dart';
import 'package:gql_http_link/gql_http_link.dart';
import 'package:gql_link/gql_link.dart';
import 'package:project_hermes_v1/src/github_gql/github_queries.data.gql.dart';
import 'package:project_hermes_v1/src/github_gql/github_queries.req.gql.dart';
import 'github_oauth_credentials.dart';

import 'src/github_login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Github GraphQL API Client',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Project Hermes'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return GithubLoginWidget(
        builder: (context, httpClient) {
          final link = HttpLink('https://api.github.com/graphql',
              httpClient: httpClient);
          return FutureBuilder<$ViewerDetail$viewer>(
            future: viewerDetail(link), //Completed Future Method
            builder: (context, snapshot) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(title),
                ),
                body: Center(
                  child: Text(snapshot.hasData
                      ? 'Hello ${snapshot.data.login}'
                      : 'Retrieving viewer login details...'),
                ),
              );
            },
          );
        },
        githubClientId: githubClientId,
        githubClientSecret: githubClientSecret,
        githubScopes: githubScopes);
  }
}

Future<$ViewerDetail$viewer> viewerDetail(Link link) async {
  var result = await link.request(ViewerDetail((b) => b)).first;
  if (result.errors != null && result.errors.isNotEmpty) {
    throw QueryException(result.errors);
  }
  return $ViewerDetail(result.data).viewer;
}

class QueryException implements Exception {
  QueryException(this.errors);
  List<GraphQLError> errors;
  @override
  String toString() {
    return 'Query Excception: ${errors.map((err) => '$err').join(',')}';
  }
}
