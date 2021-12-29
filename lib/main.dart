import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MaterialApp(
    title: 'MTN NEWS',
    home: MtnNewsHome(),
  ));
}

class MtnNewsHome extends StatefulWidget {
  @override
  _MtnNewsHome createState() => _MtnNewsHome();
}

class _MtnNewsHome extends State<MtnNewsHome> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: 'https://news.mtn.co.kr/',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
        children: <Widget>[
          NavigationControls(_controller.future),
          Spacer(),
          IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                print('press share');
              }),
        ],
      )),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController? controller = snapshot.data;
        return Row(children: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: !webViewReady
                ? null
                : () async {
                    if (await controller!.canGoBack()) {
                      await controller.goBack();
                    } else {
                      // ignore: deprecated_member_use
                      Scaffold.of(context).showSnackBar(
                        const SnackBar(content: Text('No back history item')),
                      );
                      return;
                    }
                  },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: !webViewReady
                ? null
                : () async {
                    if (await controller!.canGoForward()) {
                      await controller.goForward();
                    } else {
                      // ignore: deprecated_member_use
                      Scaffold.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('No forward history item')),
                      );
                      return;
                    }
                  },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: !webViewReady
                ? null
                : () {
                    controller!.reload();
                  },
          )
        ]);
      },
    );
  }
}
