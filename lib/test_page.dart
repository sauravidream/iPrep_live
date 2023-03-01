import 'package:flutter/material.dart';
import 'package:idream/provider/video_provider.dart';
import 'package:provider/provider.dart';

import 'bloc/presentation/components/video/video.dart';

class DevelopmentPage extends StatelessWidget {
  const DevelopmentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home page',
          ),
        ),
        body: Consumer<VideoPlayerPro>(
          builder: (context, videoPla, child) {
            return Container();
          },
          child: Column(
            children: [],
          ),
        ));
  }
}
