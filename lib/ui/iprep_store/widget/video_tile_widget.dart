import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:idream/ui/iprep_store/video_play_list_page.dart';
import '../../../common/global_variables.dart';
import '../../../custom_widgets/linear_percent_indicator.dart';
import '../../../model/iprep_store_model/video_model.dart';

class VideoTile extends StatelessWidget {
  const VideoTile({
    Key? key,
    required this.isPlaying,
    required this.videosListWidget,
    required this.video,
    this.index,
  }) : super(key: key);

  final ListView videosListWidget;
  final Video? video;
  final bool isPlaying;
  final int? index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: ListTile(
        selectedTileColor:
            Color(isPlaying ? 0xFF0077FF : 0xFF9A9A9A).withOpacity(.05),
        selected: isPlaying,
        leading: leading(),
        title: title(),
        subtitle: subtitle(),
        onTap: () {
          if (isVideoPlaying == null) {
            isVideoPlaying = index.toString();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VideoPlayListPage(
                          key: key,
                          videosListWidget: videosListWidget,
                        ))).then((value) {
              isVideoPlaying = null;
            });
          } else {
            print(isVideoPlaying);
          }
        },
      ),
    );
  }

  Widget? leading() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 100,
          minHeight: 260,
          maxWidth: 104,
          maxHeight: 264,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
        ),
        child: Stack(
          children: [
            CachedNetworkImage(
              width: 118,
              height: 90,
              imageUrl: video?.thumbnail ??
                  "https://i.vimeocdn.com/video/892052862-6a351faf9eb4c100812d318b7faef025b0368693622dffff26c406fbef8d6864-d_640",
              fit: BoxFit.fill,
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
              errorWidget: (context, url, error) =>
                  const Center(child: Icon(Icons.error)),
            ),
            Container(
              color: Colors.grey.withOpacity(0.2),
              child: Center(
                child: Image.asset(
                  "assets/images/play_icon.png",
                  height: 12,
                  width: 12,
                ),
              ),
            ),
            if (isPlaying) ...[
              Positioned(
                // width: 118,
                bottom: 0,
                left: 0,
                right: 0,
                child: LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  progressColor: const Color(0xFF0077FF),
                  percent: 50 / 100,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget? title() {
    return RichText(
      maxLines: 2,
      text: TextSpan(
        text: "Video ${index ?? 0}: ",
        style: TextStyle(
          color: const Color(0xFF212121),
          fontWeight: FontWeight.values[5],
          fontSize: 15,
        ),
        children: <TextSpan>[
          TextSpan(
            text: video?.name ?? "",
            style: const TextStyle(
              fontFamily: "Inter",
              color: Color(0xFF212121),
              fontWeight: FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget? subtitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Wrap(
        spacing: 10,
        children: [
          if (isPlaying) ...[
            SvgPicture.asset(
              "assets/image/pause.svg",
              width: 14,
              height: 14,
              color: const Color(0xFF0077FF),
            ),
          ],
          Text(
            "${video?.totalDuration ?? 0}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: "Inter",
              color: Color(isPlaying ? 0xFF0077FF : 0xFF9A9A9A),
              fontWeight: FontWeight.w400,
              fontSize: 11,
            ),
          )
        ],
      ),
    );
  }
}
