import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VideoPlayListPage extends StatelessWidget {
  const VideoPlayListPage({Key? key, this.videosListWidget}) : super(key: key);
  final ListView? videosListWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Container(
            height: 256,
            color: const Color(0xFF9A9A9A),
          ),
          if (videosListWidget != null)
            SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(children: [videosListWidget!])),
        ],
      ),
    );
  }

  PreferredSizeWidget appBar(context) {
    return AppBar(
      elevation: 5,
      backgroundColor: const Color(0xFFFFFFFF),
      centerTitle: false,
      leading: IconButton(
        icon: SvgPicture.asset(
          "assets/image/backward_arrow.svg",
          height: 19,
          width: 19,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
