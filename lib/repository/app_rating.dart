import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idream/common/constants.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:url_launcher/url_launcher.dart';

class AppRatingRepository {
  static rateApp(RateMyApp _rateMyApp, BuildContext context,
      {double rating = 0.0, ignoreNativeAppRating = true}) {
    return _rateMyApp.showStarRateDialog(
      context,
      title: 'Enjoying iPrep App?',
      message: 'Please leave a rating!',
      dialogStyle: DialogStyle(
        titleStyle: TextStyle(
            fontFamily: GoogleFonts.roboto().fontFamily,
            letterSpacing: 0.2,
            fontWeight: FontWeight.w600),
        messageStyle: TextStyle(
          fontFamily: GoogleFonts.roboto().fontFamily,
          letterSpacing: 0.14,
        ),
        titleAlign: TextAlign.center,
        messageAlign: TextAlign.center,
        messagePadding: EdgeInsets.only(bottom: 30),
        dialogShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        ),
        contentPadding: EdgeInsets.all(20),
      ),
      actionsBuilder: (context, stars) {
        return [
          // Return a list of actions (that will be shown at the bottom of the dialog).
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.5,
                    color: Color(0xFFBDBDBD),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.white,
                      ),
                      child: Text(
                        'RATE',
                        style: TextStyle(
                          color: Color(0xFF0077FF),
                        ),
                      ),
                      onPressed: () async {
                        print('Thanks for the ' +
                            (stars == null ? '0' : stars.round().toString()) +
                            ' star(s) !');
                        // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
                        // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
                        /*await _rateMyApp
                            .callEvent(RateMyAppEventType.rateButtonPressed);
                        Navigator.pop<RateMyAppDialogButton>(
                            context, RateMyAppDialogButton.rate);*/

                        if (Platform.isAndroid)
                          _launchURL(Constants.playStoreUrl);
                        else
                          _launchURL(Constants.appStoreUrl);
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.white,
                      ),
                      child: Text(
                        'May be later',
                        style: TextStyle(
                          color: Color(0xFF0077FF),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ];
      },
      onDismissed: () =>
          _rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
      ignoreNativeDialog:
          true /*Platform.isAndroid ? true : ignoreNativeAppRating*/,
      starRatingOptions: StarRatingOptions(
        initialRating: rating,
      ),
    );
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
