import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/references.dart';
import 'package:idream/model/chat_model.dart';
import 'package:flutter/cupertino.dart';

class SnackbarMessages {
  static showErrorSnackbar(BuildContext context,
      {String? title, String error = ""}) {
    return Flushbar(
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 20,
      ),
      flushbarStyle: FlushbarStyle.FLOATING,
      // ignore: prefer_const_literals_to_create_immutables
      boxShadows: [
        const BoxShadow(
            color: Colors.grey, offset: Offset(0.0, 1.0), blurRadius: 2.0)
      ],
      title: title,
      message: error,
      backgroundColor: Colors.white,
      titleColor: const Color(0xFF212121),
      messageColor: const Color(0xFF212121),
      flushbarPosition: FlushbarPosition.BOTTOM,
      shouldIconPulse: false,
      leftBarIndicatorColor: const Color(0xFFff7475),
      icon: const Icon(
        Icons.error, //check_circle
        size: 35.0,
        color: Color(0xFFff7475), //0xFF80C241
      ),
      duration: const Duration(seconds: 5),
    )..show(context);
  }

  static showSuccessSnackbar(BuildContext context,
      {String? title, String message = "", IconData? icons}) {
    return Flushbar(
      // borderRadius: 10,
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 20,
      ),
      flushbarStyle: FlushbarStyle.FLOATING,
      boxShadows: const [
        BoxShadow(color: Colors.grey, offset: Offset(0.0, 1.0), blurRadius: 2.0)
      ],
      title: title,
      message: message,
      backgroundColor: Colors.white,
      titleColor: const Color(0xFF212121),
      messageColor: const Color(0xFF212121),
      flushbarPosition: FlushbarPosition.BOTTOM,
      shouldIconPulse: false,
      leftBarIndicatorColor: const Color(0xFF80C241),
      icon: Icon(
        icons ?? Icons.check_circle, //check_circle
        size: 35.0,
        color: const Color(0xFF80C241),
      ),
      duration: const Duration(seconds: 5),
    )..show(context);
  }

  static showInfoSnackbar(
      {required BuildContext context,
      String? title,
      String info = "",
      Widget? navigationPage,
      ChatModel? chatModel}) {
    return Flushbar(
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 20,
      ),
      flushbarStyle: FlushbarStyle.FLOATING,
      boxShadows: const [
        BoxShadow(color: Colors.grey, offset: Offset(0.0, 1.0), blurRadius: 2.0)
      ],
      title: title,
      message: info,
      backgroundColor: Colors.white,
      titleColor: const Color(0xFF212121),
      messageColor: const Color(0xFF212121),
      flushbarPosition: FlushbarPosition.BOTTOM,
      shouldIconPulse: false,
      leftBarIndicatorColor: const Color(0xFF3399FF),
      onTap: (value) async {
        if (chatModel != null && chatModel.id != null) {
          await helper.deleteReadMessage(chatId: chatModel.id);
        }
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (BuildContext context) => navigationPage!,
          ),
        );
      },
      icon: const Icon(
        Icons.info, //check_circle
        size: 35.0,
        color: Color(0xFF3399FF), //0xFF80C241
      ),
      duration: const Duration(seconds: 5),
    )..show(context);
  }
}
