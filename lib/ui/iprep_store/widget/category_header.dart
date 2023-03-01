import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryHeader extends StatelessWidget {
  const CategoryHeader({Key? key, this.headerName, this.onTap})
      : super(key: key);
  final String? headerName;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headerName ?? "",
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
              fontStyle: FontStyle.normal,
            ),
          ),
          if (onTap != null) ...[
            InkResponse(
              borderRadius: BorderRadius.circular(2),
              onTap: onTap,
              child: SvgPicture.asset(
                "assets/image/forward_arrow 4.svg",
                height: 19,
                width: 19,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
