import 'package:flutter/material.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/custom_widgets/custom_tile.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: false,
            leadingWidth: 36,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 11,
                ),
                child: Image.asset(
                  "assets/images/back_icon.png",
                  height: 25,
                  width: 25,
                ),
              ),
            ),
            title: Text(
              "Contact us",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.values[5],
                color: const Color(0xFF212121),
              ),
            ),
          ),
          body: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 17,
                    bottom: 18,
                  ),
                  child: Image.asset(
                    "assets/images/contact_icon.png",
                    height: 164,
                    width: 179,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 24,
                  ),
                  child: Text(
                    "Please get in touch and we will be happy tohelp you.",
                    style: TextStyle(
                      color: const Color(0xFF212121),
                      fontSize: 14,
                      fontWeight: FontWeight.values[5],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 18,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/bullet_point.png",
                        height: 6,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Flexible(
                        child: Text(
                          "If you wish to ask any question about iPrep",
                          style: TextStyle(
                            color: const Color(0xFF212121),
                            fontSize: 14,
                            fontWeight: FontWeight.values[4],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 18,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/bullet_point.png",
                        height: 6,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Flexible(
                        child: Text(
                          "If you have an amazing idea to grow iPrep and its reach",
                          style: TextStyle(
                            color: const Color(0xFF212121),
                            fontSize: 14,
                            fontWeight: FontWeight.values[4],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/bullet_point.png",
                        height: 6,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Flexible(
                        child: Text(
                          "If you wish to share your feelings about iPrep",
                          style: TextStyle(
                            color: const Color(0xFF212121),
                            fontSize: 14,
                            fontWeight: FontWeight.values[4],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (await UrlLauncher.launch(Constants.supportMobileUrl)) {
                      await UrlLauncher.launch(Constants.supportMobileUrl);
                    } else {
                      SnackbarMessages.showErrorSnackbar(context,
                          error: Constants.dialerError);
                    }
                  },
                  child: CustomTileWidget(
                    selected: true,
                    streamText: "Call us",
                    selectedColor: 0xFF0077FF,
                    leadingWidgetRequired: true,
                    leadingImagePath: "assets/images/dialer.png",
                    trainingWidgetRequired: false,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    var _encodedUrl =
                        Uri.encodeFull(Constants.supportWhatsappUrl);
                    if (await UrlLauncher.launch(_encodedUrl)) {
                      await UrlLauncher.launch(_encodedUrl);
                    } else {
                      SnackbarMessages.showErrorSnackbar(context,
                          error: Constants.whatsappError);
                    }
                  },
                  child: CustomTileWidget(
                    selected: true,
                    streamText: "WhatsApp",
                    selectedColor: 0xFF4CAF50,
                    leadingWidgetRequired: true,
                    leadingImagePath: "assets/images/whatsapp.png",
                    trainingWidgetRequired: false,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final String _url = "mailto:${Constants.supportEmail}";
                    if (await UrlLauncher.launch(_url)) {
                      await UrlLauncher.launch(_url);
                    } else {
                      SnackbarMessages.showErrorSnackbar(context,
                          error: Constants.emailError);
                    }
                  },
                  child: CustomTileWidget(
                    selected: true,
                    streamText: "E-mail",
                    selectedColor: 0xFFFC3E04,
                    leadingWidgetRequired: true,
                    leadingImagePath: "assets/images/email.png",
                    trainingWidgetRequired: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
