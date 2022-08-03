import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SitePage extends StatefulWidget {
  const SitePage({Key? key}) : super(key: key);

  @override
  State<SitePage> createState() => _SitePageState();
}

class _SitePageState extends State<SitePage> {
  var _stackIdx = 1;
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
      body: _webView(),
    );
  }

  _webView() {
    return IndexedStack(
      index: _stackIdx,
      children: <Widget>[
        Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl: 'https://flutter.dev/',
                onPageFinished: _onPageFinished,
                onWebViewCreated: (controller) {
                  this.controller = controller;
                },
                javascriptMode: JavascriptMode.unrestricted,
                navigationDelegate: (request) {
                  print(request.url);
                  return NavigationDecision.navigate;
                },
              ),
            ),
          ],
        ),
        Container(
          color: Colors.white,
          child: Center(child: CircularProgressIndicator(),),
        )
      ],
    );
  }

  void _onClickRefresh() {
    this.controller?.reload();
  }

  void _onPageFinished(String value) {
    setState(() {
      _stackIdx = 0;
    });
  }
}
