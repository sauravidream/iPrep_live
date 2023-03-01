import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:idream/custom_widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../test_prep/test_prep_provider/test_proivider.dart';

class TestPrepWebPage extends StatefulWidget {
  final String? link;
  final CookieManager? cookieManager;

  const TestPrepWebPage(
      {Key? key, required this.link, required this.cookieManager})
      : super(key: key);

  @override
  TestPrepWebPageState createState() => TestPrepWebPageState();
}

class TestPrepWebPageState extends State<TestPrepWebPage>
    with TickerProviderStateMixin {
  bool isLoading = true;
  bool isWebHeader = false;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }

    super.initState();
  }

  @override
  void dispose() {
    widget.cookieManager?.clearCookies().whenComplete(() {
      print("clear Cookies");
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tesPro = Provider.of<TestProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        await widget.cookieManager?.clearCookies();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFFFFFFF),
          leading: NavigationControls(_controller.future),
          actionsIconTheme: const IconThemeData(
            color: Color(0x73000000),
          ),
          actions: const [
          //  SampleMenu(_controller.future, widget.cookieManager),
          ],
        ),
        body: SafeArea(
          bottom: false,
          child: WebView(
            initialCookies: [tesPro.sessionCookie!],
            gestureNavigationEnabled: true,
            onProgress: (progress) {},
            zoomEnabled: false,
            gestureRecognizers: {
              Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer()..onUpdate = (_) {},
              )
            },
            initialUrl: widget.link!,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
            navigationDelegate: (NavigationRequest request) async {
              if (request.url == "https://exams.iprep.in/") {
                debugPrint(request.url);
                webHeader();

                return NavigationDecision.navigate;
              } else if (request.url != "https://exams.iprep.in/") {
                webHeaderForFalse();

                return NavigationDecision.navigate;
              } else {
                return NavigationDecision.navigate;
              }
            },
          ),
        ),
      ),
    );
  }

  webHeader() {
    setState(() {
      isWebHeader = true;
    });

    debugPrint(isWebHeader.toString());
  }

  webHeaderForFalse() {
    setState(() {
      isWebHeader = false;
    });

    debugPrint(isWebHeader.toString());
  }

  Container webViewHeader(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .06,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(
        left: 16,
        bottom: 22,
      ),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () async {
              widget.cookieManager?.clearCookies().whenComplete(() {
                print("clear Cookies");
              });
              Navigator.pop(context);
            },
            icon: Image.asset(
              "assets/images/back_icon.png",
              height: 25,
              width: 25,
            ),
          ),

          // NavigationControls(_controller.future),
        ],
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture, {Key? key})
      : super(key: key);

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
        return Row(
          children: <Widget>[
            IconButton(
              icon: Image.asset(
                "assets/images/back_icon.png",
                height: 50,
                width: 50,
              ),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller!.canGoBack()) {
                        await controller.goBack();
                      } else {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('No back history item')),
                        // );
                        return Navigator.pop(context);
                      }
                    },
            ),
            // Flexible(
            //   child: IconButton(
            //     icon: const Icon(Icons.arrow_forward_ios),
            //     onPressed: !webViewReady
            //         ? null
            //         : () async {
            //             if (await controller!.canGoForward()) {
            //               await controller.goForward();
            //             } else {
            //               ScaffoldMessenger.of(context).showSnackBar(
            //                 const SnackBar(
            //                     content: Text('No forward history item')),
            //               );
            //               return;
            //             }
            //           },
            //   ),
            // ),
          ],
        );
      },
    );
  }
}

enum MenuOptions {
  showUserAgent,
  listCookies,
  clearCookies,
  addToCache,
  listCache,
  clearCache,
}

class SampleMenu extends StatelessWidget {
  SampleMenu(this.controller, CookieManager? cookieManager, {Key? key})
      : cookieManager = cookieManager ?? CookieManager(),
        super(key: key);

  final Future<WebViewController> controller;
  late final CookieManager cookieManager;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        return PopupMenuButton<MenuOptions>(
          key: const ValueKey<String>('ShowPopupMenu'),
          onSelected: (MenuOptions value) {
            switch (value) {
              case MenuOptions.showUserAgent:
                _onShowUserAgent(controller.data!, context);
                break;
              case MenuOptions.listCookies:
                _onListCookies(controller.data!, context);
                break;
              case MenuOptions.clearCookies:
                _onClearCookies(context);
                break;
              case MenuOptions.addToCache:
                _onAddToCache(controller.data!, context);
                break;
              case MenuOptions.listCache:
                _onListCache(controller.data!, context);
                break;
              case MenuOptions.clearCache:
                _onClearCache(controller.data!, context);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
            PopupMenuItem<MenuOptions>(
              value: MenuOptions.showUserAgent,
              enabled: controller.hasData,
              child: const Text('Show user agent'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.listCookies,
              child: Text('List cookies'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.clearCookies,
              child: Text('Clear cookies'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.addToCache,
              child: Text('Add to cache'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.listCache,
              child: Text('List cache'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.clearCache,
              child: Text('Clear cache'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onShowUserAgent(
      WebViewController controller, BuildContext context) async {
    // Send a message with the user agent string to the Toaster JavaScript channel we registered
    // with the WebView.
    await controller.runJavascript(
        'Toaster.postMessage("User Agent: " + navigator.userAgent);');
  }

  Future<void> _onListCookies(
      WebViewController controller, BuildContext context) async {
    final String cookies =
        await controller.runJavascriptReturningResult('document.cookie');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Cookies:'),
          _getCookieList(cookies),
        ],
      ),
    ));
  }

  Future<void> _onAddToCache(
      WebViewController controller, BuildContext context) async {
    await controller.runJavascript(
        'caches.open("test_caches_entry"); localStorage["test_localStorage"] = "dummy_entry";');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Added a test entry to cache.'),
    ));
  }

  Future<void> _onListCache(
      WebViewController controller, BuildContext context) async {
    await controller.runJavascript('caches.keys()'
        // ignore: missing_whitespace_between_adjacent_strings
        '.then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys, "localStorage" : localStorage}))'
        '.then((caches) => Toaster.postMessage(caches))');
  }

  Future<void> _onClearCache(
      WebViewController controller, BuildContext context) async {
    await controller.clearCache();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Cache cleared.'),
    ));
  }

  Future<void> _onClearCookies(BuildContext context) async {
    final bool hadCookies = await cookieManager.clearCookies();
    String message = 'There were cookies. Now, they are gone!';
    if (!hadCookies) {
      message = 'There are no cookies.';
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  Widget _getCookieList(String cookies) {
    if (cookies == null || cookies == '""') {
      return Container();
    }
    final List<String> cookieList = cookies.split(';');
    final Iterable<Text> cookieWidgets =
        cookieList.map((String cookie) => Text(cookie));
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: cookieWidgets.toList(),
    );
  }
}
