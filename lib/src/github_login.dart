import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';

final _authorizationEndpoint =
    Uri.parse('https://github.com/login/oauth/authorize');
final _tokenEndPoint = Uri.parse('https://github.com/login/oauth/access_token');

class GithubLoginWidget extends StatefulWidget {
  const GithubLoginWidget({
    @required this.builder,
    @required this.githubClientId,
    @required this.githubClientSecret,
    @required this.githubScopes,
  });
  final AuthenticatedBuilder builder;
  final String githubClientId;
  final String githubClientSecret;
  final List<String> githubScopes;

  @override
  _GithubLoginWidgetState createState() => _GithubLoginWidgetState();
}

typedef AuthenticatedBuilder = Widget Function(
    BuildContext context, oauth2.Client client);

class _GithubLoginWidgetState extends State<GithubLoginWidget> {
  HttpServer _redirectServer;
  oauth2.Client _client;

  @override
  Widget build(BuildContext context) {
    if (_client != null) {
      return widget.builder(context, _client);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Github Login'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () async {
            await _redirectServer?.close();
            // Bind to an ephemeral port on localhost
            _redirectServer = await HttpServer.bind('localhost', 0);
            // TODO Complete _getOAuth2Client method
            var authenticatedHttpClient = await _getOAuth2Client();
            setState(() {
              _client = authenticatedHttpClient;
            });
          },
          child: const Text('Login to Github'),
        ),
      ),
    );
  }

  Future<oauth2.Client> _getOAuth2Client(Uri redirectUrl) async {
    if (widget.githubClientId.isEmpty || widget.githubClientSecret.isEmpty) {
      throw const GithubLoginException(
          // TODO Complete GithubLogin Exception Class First
          );
    }
  }
}
