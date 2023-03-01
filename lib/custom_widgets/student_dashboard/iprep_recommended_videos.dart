import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class IprepRecommendedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 158,
      margin: EdgeInsets.only(
        right: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            child: Stack(
              children: [
                Container(
                  color: Colors.grey.shade300,
                  width: 158,
                  height: 93,
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://i.picsum.photos/id/42/200/300.jpg?hmac=RFAv_ervDAXQ4uM8dhocFa6_hkOkoBLeRR35gF8OHgs",
                    fit: BoxFit.fill,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
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
                Padding(
                  padding: EdgeInsets.only(
                    top: 37,
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/images/play_icon.png",
                      height: 12,
                      width: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "Intro- Knowing Our Number",
            style: TextStyle(
                color: Color(0xFF212121),
                fontSize: 13,
                fontWeight: FontWeight.values[5]),
          ),
          SizedBox(
            height: 8,
          ),
          Flexible(
            child: Row(
              children: [
                Text(
                  "03:24",
                  style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 10,
                      fontWeight: FontWeight.values[5]),
                ),
                SizedBox(
                  width: 6,
                ),
                Image.asset(
                  "assets/images/dot.png",
                  height: 4,
                  width: 4,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  "Biology",
                  style: TextStyle(
                      color: Color(0xFF3C663E),
                      fontSize: 10,
                      fontWeight: FontWeight.values[4]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
