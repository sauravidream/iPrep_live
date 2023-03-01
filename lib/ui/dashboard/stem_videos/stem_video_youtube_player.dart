// import 'package:flutter/material.dart';
// import 'package:idream/custom_packages/youtube_player/youtube_player_flutter.dart';
//
// class StemVideoYoutubePlayer extends StatefulWidget {
//   final String youtubeVideoID;
//
//   StemVideoYoutubePlayer({this.youtubeVideoID});
//   @override
//   _StemVideoYoutubePlayerState createState() => _StemVideoYoutubePlayerState();
// }
//
// class _StemVideoYoutubePlayerState extends State<StemVideoYoutubePlayer> {
//   YoutubePlayerController _controller;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _controller = YoutubePlayerController(
//       initialVideoId: widget.youtubeVideoID,
//       flags: YoutubePlayerFlags(
//         autoPlay: true,
//         mute: true,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: YoutubePlayer(
//         controller: _controller,
//         showVideoProgressIndicator: true,
//         progressIndicatorColor: Colors.amber,
//         progressColors: ProgressBarColors(
//           playedColor: Colors.amber,
//           handleColor: Colors.amberAccent,
//         ),
//         onReady: () {
//           // _controller.addListener(listener);
//         },
//       ),
//     );
//   }
// }
// // TODO: Youtube Player
