import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UnderstandMasteryBottomSheetPage extends StatelessWidget {
  final String? appLevelLanguage;
  const UnderstandMasteryBottomSheetPage({Key? key, this.appLevelLanguage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return contentBox(context);
  }

  contentBox(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
            top: 12,
          ),
          color: Colors.white,
          child: Image.asset(
            "assets/images/line.png",
            width: 40,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 37,
          ),
          // margin: EdgeInsets.only(top: 12),
          constraints: const BoxConstraints(
            minHeight: 325,
            minWidth: 287,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                "assets/images/file.png",
                height: 75,
                width: 66,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Understand Mastery",
                style: TextStyle(
                    color: const Color(0xFF212121),
                    fontSize: 16,
                    fontWeight: FontWeight.values[5]),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                appLevelLanguage == "Hindi"
                    ? "iPrep अध्ययन के सभी विषयों के अध्यायों में निपुण बनने का एक उन्नत एवं अत्यंत सहयोगी उपक्रम है|"
                    : "iPrep is designed to help you achieve subject wise and topic wise mastery.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF212121),
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                appLevelLanguage == "Hindi"
                    ? "किसी अध्याय के प्रश्नों के अभ्यास में, आपके उत्तर के आधार पर आपकी निपुणता ऊपर या नीची होती दिखेगी, जिसे आप प्रश्नों को हल करते समय ऊपर दिए गए बार में देख सकते हैं|"
                    : "When you start practicing on any topic, based on how you respond to a question, your mastery will go up or down, which will show on a bar on the top of your screen.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF212121),
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                appLevelLanguage == "Hindi"
                    ? "आप अध्याय के अभ्यास में पूर्णतः निपुण होने तक अभ्यास जारी रख सकते है, जब तक की आपकी निपुणता 100% न हो जाए |"
                    : "You can keep practicing till you master the topic. Once you do, your mastery level will reach 100%.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF212121),
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                appLevelLanguage == "Hindi"
                    ? "निरंतर अभ्यास द्वारा स्वयं को बेहतर बनाते रहे |"
                    : "Keep Practicing and keep getting better.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: const Color(0xFF212121),
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 27,
              ),
              okayButton(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget okayButton(context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 48,
            maxWidth: 130,
          ),
          decoration: const BoxDecoration(
            color: const Color(0xFF0077FF),
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Center(
            child: Text(
              "Okay Got it",
              style: TextStyle(
                color: const Color(0xFFFFFFFF),
                fontWeight: FontWeight.values[4],
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
