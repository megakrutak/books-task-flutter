import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebScreen extends StatefulWidget {
  WebScreen({@required this.webLink, this.title, Key key})
      : assert(webLink != null),
        super(key: key);

  final String webLink;
  final String title;

  @override
  _WebScreenState createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title ?? widget.webLink),
          backgroundColor: Colors.green),
      body: WebView(
        gestureNavigationEnabled: true,
        initialUrl: widget.webLink,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
}
