import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:idream/common/constants.dart';

import 'package:idream/common/references.dart';

class ViewProfilePhoto extends StatelessWidget {
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
                padding: EdgeInsets.only(
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
              "Profile Photo",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.values[5],
                color: Color(0xFF212121),
              ),
            ),
          ),
          body: Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: CachedNetworkImage(
              imageUrl: (appUser!.profilePhoto != null)
                  ? appUser!.profilePhoto!
                  : Constants.defaultProfileImagePath,
              fit: (appUser!.profilePhoto != null) ? BoxFit.fill : BoxFit.none,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                    strokeWidth: 0.5,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}
