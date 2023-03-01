import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../common/constants.dart';
import '../common/global_variables.dart';
import '../common/references.dart';
import '../common/snackbar_messages.dart';
import '../model/app_language.dart';

class CustomTileWidget extends StatelessWidget {
  final bool selected;
  final String? streamText;
  final bool leadingWidgetRequired;
  final String? subtitle;
  final String? leadingImagePath;
  final int selectedColor;
  final bool trainingWidgetRequired;
  final String? dynamicLeadingImagePath;
  final double topMargin;
  final String? checkImagePath;

  const CustomTileWidget({
    Key? key,
    this.selected = false,
    this.streamText,
    this.leadingWidgetRequired = false,
    this.subtitle,
    this.leadingImagePath,
    this.selectedColor = 0xFF0077FF,
    this.trainingWidgetRequired = true,
    this.dynamicLeadingImagePath,
    this.topMargin = 20.0,
    this.checkImagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: topMargin,
      ),
      constraints: const BoxConstraints(
        minWidth: 338,
        minHeight: 68,
      ),
      decoration: BoxDecoration(
        color: selected
            ? Color(selectedColor).withOpacity(0.05)
            : const Color(0xFFFFFFFF),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(
          12,
        ),
        border: Border.all(
            color: selected ? Color(selectedColor) : const Color(0xFFDEDEDE)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (leadingWidgetRequired && dynamicLeadingImagePath == null)
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16,
                  right: 13,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF2121210D)
                      : const Color(0xFFDBDBDB),
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: leadingImagePath != null ? 0 : 1,
                      color: const Color(0xFF212121)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    leadingImagePath != null ? 0 : 12,
                  ),
                  child: (leadingImagePath != null)
                      ? Image.asset(
                          leadingImagePath!,
                          height: 38,
                          width: 38,
                        )
                      : const Icon(
                          Icons.account_balance,
                          color: Color(0xFF212121),
                          size: 15,
                        ),
                ),
              ),
            ),
          if (leadingWidgetRequired && dynamicLeadingImagePath != null)
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16,
                  right: 13,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF2121210D)
                      : const Color(0xFFDBDBDB),
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: dynamicLeadingImagePath != null ? 0 : 1,
                      color: const Color(0xFF212121)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    dynamicLeadingImagePath != null ? 0 : 12,
                  ),
                  child: (dynamicLeadingImagePath != null)
                      ? CachedNetworkImage(
                          imageUrl: dynamicLeadingImagePath!,
                          height: 38,
                          width: 38,
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
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )
                      : const Icon(
                          Icons.account_balance,
                          color: const Color(0xFF212121),
                          size: 15,
                        ),
                ),
              ),
            ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.only(
                left: leadingWidgetRequired ? 0 : 0,
              ),
              child: Text(
                streamText!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF212121),
                  fontWeight: FontWeight.values[selected ? 5 : 4],
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 20,
              ),
              child: (selected && trainingWidgetRequired)
                  ? Image.asset(
                      checkImagePath ??
                          ((selectedColor == 0xFF22C59B)
                              ? "assets/images/checked_image.png"
                              : (selectedColor == 0xFF46B6E9)
                                  ? "assets/images/checked_image_light_blue.png"
                                  : "assets/images/checked_image_blue.png"),
                      height: 20,
                    )
                  : Container(
                      width: double.maxFinite,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTile extends StatelessWidget {
  final bool selected;
  final String? streamText;
  final bool leadingWidgetRequired;
  final String? subtitle;
  final String? leadingImagePath;
  final int selectedColor;
  final bool trainingWidgetRequired;
  final String? dynamicLeadingImagePath;
  final double topMargin;
  final String? checkImagePath;

  const CustomTile({
    Key? key,
    this.selected = false,
    this.streamText,
    this.leadingWidgetRequired = false,
    this.subtitle,
    this.leadingImagePath,
    this.selectedColor = 0xFF0077FF,
    this.trainingWidgetRequired = true,
    this.dynamicLeadingImagePath,
    this.topMargin = 20.0,
    this.checkImagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: topMargin,
      ),
      constraints: const BoxConstraints(
        minWidth: 338,
        minHeight: 68,
      ),
      decoration: BoxDecoration(
        color: selected
            ? Color(selectedColor).withOpacity(0.05)
            : const Color(0xFFFFFFFF),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(
          12,
        ),
        border: Border.all(
            color: selected ? Color(selectedColor) : const Color(0xFFDEDEDE)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (leadingWidgetRequired && dynamicLeadingImagePath == null)
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF212121)
                      : const Color(0xFFDBDBDB),
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: leadingImagePath != null ? 0 : 1,
                      color: const Color(0xFF212121)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    leadingImagePath != null ? 0 : 12,
                  ),
                  child: (leadingImagePath != null)
                      ? Image.asset(
                          leadingImagePath!,
                          height: 38,
                          width: 38,
                        )
                      : const Icon(
                          Icons.account_balance,
                          color: Color(0xFF212121),
                          size: 15,
                        ),
                ),
              ),
            ),
          if (leadingWidgetRequired && dynamicLeadingImagePath != null)
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16,
                  right: 13,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF212121)
                      : const Color(0xFFDBDBDB),
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: dynamicLeadingImagePath != null ? 0 : 1,
                      color: const Color(0xFF212121)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    dynamicLeadingImagePath != null ? 0 : 12,
                  ),
                  child: (dynamicLeadingImagePath != null)
                      ? CachedNetworkImage(
                          imageUrl: dynamicLeadingImagePath!,
                          height: 38,
                          width: 38,
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
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )
                      : const Icon(
                          Icons.account_balance,
                          color: Color(0xFF212121),
                          size: 15,
                        ),
                ),
              ),
            ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.only(
                left: leadingWidgetRequired ? 0 : 0,
              ),
              child: Text(
                streamText ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF212121),
                  fontWeight: FontWeight.values[selected ? 5 : 4],
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 20,
              ),
              child: (selected && trainingWidgetRequired)
                  ? CachedNetworkImage(
                      imageUrl: dynamicLeadingImagePath!,
                      height: 38,
                      width: 38,
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
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                  : Container(
                      width: double.maxFinite,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageTile extends StatefulWidget {
  const LanguageTile({
    Key? key,
    this.selectedLanguage,
    required this.language,
    this.isOnBoarding = true,
  }) : super(key: key);
  final List<Language>? language;
  final String? selectedLanguage;
  final bool isOnBoarding;

  @override
  State<LanguageTile> createState() => _LanguageTileState();
}

class _LanguageTileState extends State<LanguageTile> {
  @override
  Widget build(BuildContext context) {
    //true.svg
    return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        itemCount: widget.language!.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: InkWell(
              onTap: () async {
                setState(() {
                  selectedAppLanguage = widget.language![index].id;
                });

                if (selectedAppLanguage != null &&
                    widget.isOnBoarding != true) {
                  await userRepository.saveUserDetailToLocal(
                      'language', selectedAppLanguage!.toLowerCase());

                  appUser!.language = selectedAppLanguage!.toLowerCase();
                  await userRepository.updateUserProfileWithSelectedLanguage(
                      language: selectedAppLanguage!.toLowerCase());

                  Navigator.pop(context);
                  return;
                } else if (widget.isOnBoarding == true) {
                } else {
                  SnackbarMessages.showErrorSnackbar(context,
                      error: Constants.languageSelectionAlert);
                }
              },
              child: Container(
                // margin: const EdgeInsets.only(
                //   top: 20,
                // ),
                constraints: const BoxConstraints(
                  minWidth: 338,
                  minHeight: 68,
                ),
                padding: const EdgeInsets.only(left: 1),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedAppLanguage == widget.language![index].id
                        ? Color((int.parse(
                                widget.language![index].color!.substring(1, 7),
                                radix: 16) +
                            0xFF000000))
                        : const Color(0xFFDEDEDE),
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: selectedAppLanguage == widget.language![index].id
                      ? Color((int.parse(
                                  widget.language![index].color!
                                      .substring(1, 7),
                                  radix: 16) +
                              0xFF000000))
                          .withOpacity(.1)
                      : Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 16,
                          right: 13,
                        ),
                        child: CachedNetworkImage(
                          height: 38,
                          width: 38,
                          imageUrl: widget.language![index].icon!,
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
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            widget.language![index].name!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Kohinoor Devanagari',
                              fontSize: 16,
                              fontWeight: widget.selectedLanguage ==
                                      widget.language![index].id
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: const Color(0xFF212121),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (selectedAppLanguage == widget.language![index].id) ...[
                      Container(
                        height: 30,
                        width: 30,
                        padding: const EdgeInsets.all(9.0),
                        decoration: BoxDecoration(
                          color: Color((int.parse(
                                      widget.language![index].color!
                                          .substring(1, 7),
                                      radix: 16) +
                                  0xFF000000))
                              .withOpacity(.2),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: SvgPicture.asset(
                          "assets/image/true.svg",
                          color: Color((int.parse(
                                      widget.language![index].color!
                                          .substring(1, 7),
                                      radix: 16) +
                                  0xFF000000))
                              .withOpacity(.4),
                          height: 20,
                          width: 20,
                          // height: 24,
                          // width: 24,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          );
        });
  }
}
