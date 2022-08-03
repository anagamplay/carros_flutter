import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SitePage extends StatefulWidget {
  const SitePage({Key? key}) : super(key: key);

  @override
  State<SitePage> createState() => _SitePageState();
}

class _SitePageState extends State<SitePage> {
  WebViewController? controller;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Site'),
        actions: <Widget>[
          IconButton(onPressed: _onClickRefresh, icon: Icon(Icons.refresh),)
        ],
      ),
      body: WebView(
        initialUrl: 'https://flutter.dev/',
        onWebViewCreated: (controller) {
          this.controller = controller;
        },
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (request) {
          print(request.url);
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  void _onClickRefresh() {
    this.controller?.reload();
  }
}
