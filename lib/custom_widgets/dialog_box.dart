import 'package:flutter/material.dart';

class AlertPopUp {
  final BuildContext context;
  final Image? image;
  final String title;
  final String? desc;
  final Widget? content;
  final List<Widget>? buttons;
  final Function? closeFunction;

  AlertPopUp({
    required this.context,
    this.image,
    required this.title,
    this.desc,
    this.content,
    this.buttons,
    this.closeFunction,
  });

  Future<dynamic> show() async {
    return await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return _buildDialog();
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(seconds: 1),
      transitionBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) =>
          _showAnimation(animation, secondaryAnimation, child),
    );
  }

  // Alert dialog content widget
  Widget _buildDialog() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints.expand(
            width: double.infinity, height: double.infinity),
        child: Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              backgroundColor: Theme.of(context).dialogBackgroundColor,
              shape: _defaultShape(),
              titlePadding: const EdgeInsets.all(0.0),
              title: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Text(
                            title,
                            style: TextStyle(
                              color: const Color(0xFF212121),
                              fontWeight: FontWeight.values[5],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: desc == null ? 5 : 15,
                          ),
                          desc == null
                              ? Container()
                              : Text(
                                  desc!,
                                  style: const TextStyle(
                                      fontSize: 16, color: Color(0xFF212121)),
                                  textAlign: TextAlign.center,
                                ),
                          content ?? Container(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _getButtons(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Returns alert default border style
  ShapeBorder _defaultShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: const BorderSide(
        color: Colors.white,
      ),
    );
  }

  // Returns defined buttons. Default: Cancel Button
  List<Widget> _getButtons() {
    List<Widget> expandedButtons = [];
    if (buttons != null) {
      buttons!.forEach(
        (button) {
          var buttonWidget = Padding(
            padding: const EdgeInsets.only(left: 2, right: 2),
            child: button,
          );
          if (buttons!.length == 1) {
            expandedButtons.add(buttonWidget);
          } else {
            expandedButtons.add(Expanded(
              child: buttonWidget,
            ));
          }
        },
      );
    } else {
      expandedButtons.add(
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: const Center(
                child: Text(
                  "CANCEL",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return expandedButtons;
  }

  _showAnimation(animation, secondaryAnimation, child) {
    {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, -1.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    }
  }
}

class DialogButton extends StatelessWidget {
  final Widget child;
  final double? width;
  final double height;
  final Color? color;
  final Gradient? gradient;
  final BorderRadius? radius;
  void Function() onPressed;

  /// DialogButton constructor
  DialogButton({
    Key? key,
    required this.child,
    this.width,
    this.height = 40.0,
    this.color,
    this.gradient,
    this.radius,
    required this.onPressed,
  }) : super(key: key);

  /// Creates alert buttons based on constructor params
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).accentColor,
        gradient: gradient,
        borderRadius: radius ?? BorderRadius.circular(6),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
