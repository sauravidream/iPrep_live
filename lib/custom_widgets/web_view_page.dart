import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/references.dart';
import 'package:idream/custom_widgets/loader.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String link;

   const WebViewPage({Key? key, required this.link}) : super(key: key);

  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  Animation<Offset>? _offsetAnimation;
  bool isLoading = true;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: Colors.white,
      duration: const Duration(milliseconds: 400),
      child: Padding(
        padding: EdgeInsets.only(
            bottom: (MediaQuery.of(context).viewInsets.bottom >= 40.0
                ? MediaQuery.of(context).viewInsets.bottom - 40.0
                : MediaQuery.of(context).viewInsets.bottom)),
        /*child: SlideTransition(
          position: _offsetAnimation,*/
        child: SafeArea(
          child: Material(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                webViewHeader(context),
                Flexible(
                  child: Stack(
                    children: [
                      PageView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: <Widget>[
                          WebView(
                            // ignore: prefer_collection_literals
                            gestureRecognizers: [
                              Factory<VerticalDragGestureRecognizer>(
                                () => VerticalDragGestureRecognizer()
                                  ..onUpdate = (_) {},
                              )
                            ].toSet(),
                            initialUrl: widget.link,
                            javascriptMode: JavascriptMode.unrestricted,
                            onWebResourceError: (WebResourceError webViewError) {
                            debugPrint("Handle your Error Page here: $webViewError");
                          },
                            onPageFinished: (finish) {
                              setState(() {
                                isLoading = false;
                              });
                            },
                            navigationDelegate:
                                (NavigationRequest request) async {
                                  debugPrint(request.url.toString());
                              if (request.url ==
                                  "https://ipreppayment.herokuapp.com/success") {
                                await upgradePlanRepository
                                    .checkUserSubscriptionPlan();

                                Navigator.pop(context, "success");
                                Navigator.pop(context);
                                return NavigationDecision.prevent;
                              } else if (request.url ==
                                  "https://ipreppayment.herokuapp.com/failure") {
                                Navigator.pop(context, "failure");
                                return NavigationDecision.prevent;
                              } else {
                                return NavigationDecision.navigate;
                              }
                            },
                          ),
                        ],
                      ),
                      isLoading
                          ? const Center(
                              child: Loader(),
                            )
                          : Stack(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        /*),*/
      ),
    );
  }

  Container webViewHeader(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(
        left: 16,
        bottom: 16,
      ),
      decoration: const BoxDecoration(
          // borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
          color: Colors.white
          // color: Color(0xFF1A101F)
//        gradient: LinearGradient(
//            begin: Alignment.topCenter,
//            end: Alignment.bottomCenter,
//            colors: [Color(0xFF1A101F), Colors.white]),
          ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              "assets/images/back_icon.png",
              height: 25,
              width: 25,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Text(
              "Payment Page",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFF212121),
                fontWeight: FontWeight.values[5],
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
