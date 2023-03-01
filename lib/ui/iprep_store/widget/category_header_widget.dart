import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CategoryDTLHeaderWidget extends StatelessWidget {
  const CategoryDTLHeaderWidget({Key? key, this.coverImage, this.name})
      : super(key: key);
  final String? coverImage;
  final String? name;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Stack(children: [
        CachedNetworkImage(
          height: 256,
          imageUrl: coverImage ??
              "https://firebasestorage.googleapis.com/v0/b/flutter-firebase-ddd-ac130.appspot.com/o/badminton.png?alt=media&token=ae0b7ff9-fd0d-4c32-bf87-0f644cbbde06",
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: IconButton(
            icon: SvgPicture.asset("assets/image/backward_arrow.svg",
                height: 19, width: 19, color: const Color(0xFFFFFFFF)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Positioned(
            bottom: 64,
            left: 29,
            child: Text(
              name ?? "",
              style: const TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 29,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFFFFFF)),
            ))
      ]),
    );
  }
}
