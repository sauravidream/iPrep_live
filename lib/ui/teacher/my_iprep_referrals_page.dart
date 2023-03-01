import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/custom_widgets/loader.dart';

class MyIprepReferralsPage extends StatefulWidget {
  const MyIprepReferralsPage({Key? key}) : super(key: key);

  @override
  _MyIprepReferralsPageState createState() => _MyIprepReferralsPageState();
}

class _MyIprepReferralsPageState extends State<MyIprepReferralsPage> {
  bool _dataLoaded = false;
  int? _totalIPrepCash;
  int? _totalInvitedPeopleCount;

  final TextStyle _textStyle = TextStyle(
    fontSize: 14,
    color: const Color(0xFF212121),
    fontFamily: GoogleFonts.inter().fontFamily,
  );

  Future _getReferralCode() async {
    String? _referralCode = await getStringValuesSF("referralCode");
    String? _userID = await getStringValuesSF("userID");

    if (_referralCode == null) {
      String? _userTypeNodeName = await (userRepository.getUserNodeName());
      var _referCode = await apiHandler.getAPICall(
          endPointURL: "referrals_scholarship_subscription_plans/"
              "referrals/"
              "$_userID/"
              "$_userTypeNodeName");
      _referralCode = _referCode["refer_code"];
      await userRepository.saveUserDetailToLocal(
          "referralCode", _referralCode!);
    }
    return _referralCode;
  }

  Future getShareAndEarnData() async {
    var _response =
        await shareEarnRepository.fetchNumberOfInvitedPeopleAndEarnedAmount();
    debugPrint(_response.toString());
    if (_response != null) {
      _totalIPrepCash = int.tryParse(_response["balance"]["current_amount"]);
      _totalInvitedPeopleCount = ((_response["history"]["referred_to"] == null)
          ? 0
          : _response["history"]["referred_to"].length);
    } else {
      _totalIPrepCash = 0;
      _totalInvitedPeopleCount = 0;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _totalIPrepCash = 0;
    _totalInvitedPeopleCount = 0;
    getShareAndEarnData().then((value) {
      setState(() {
        _dataLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        leadingWidth: 36,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(
              left: 11,
            ),
            child: Image.asset(
              "assets/images/back_icon.png",
              height: 25,
              width: 25,
            ),
          ),
        ),
        title: Text(
          "My iPrep Referrals",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.values[5],
            color: const Color(0xFF212121),
          ),
        ),
        actions: [
          InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext context) => CoachReferralsHistoryPage(
                    iPrepCash: _totalIPrepCash,
                    invitedPeopleCount: _totalInvitedPeopleCount,
                  ),
                ),
              );
            },
            child: const Center(
              child: Padding(
                padding: EdgeInsets.only(
                  right: 16,
                ),
                child: Text(
                  "History",
                  style: TextStyle(
                    color: Color(0xFF0070FF),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: _dataLoaded
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: _textStyle,
                        children: const <TextSpan>[
                          TextSpan(text: 'You can share'),
                          TextSpan(
                            text: ' iPrep ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: "with your students in 2 ways:"),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    RichText(
                      text: TextSpan(
                        style: _textStyle,
                        children: const <TextSpan>[
                          TextSpan(text: '1. Create a batch and click on '),
                          TextSpan(
                            text: 'Invite Student Button',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    RichText(
                      text: TextSpan(
                        style: _textStyle,
                        children: const <TextSpan>[
                          TextSpan(text: '2. Click on '),
                          TextSpan(
                            text: 'Share and Earn',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text: " or share your code mentioned below"),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      constraints: const BoxConstraints(
                        minWidth: double.infinity,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FBFF),
                        border: Border.all(color: const Color(0xFF0077FF)),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              "Share and Earn",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.values[5],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          RichText(
                            text: TextSpan(
                              style: _textStyle,
                              children: const <TextSpan>[
                                TextSpan(
                                    text: 'Every student who subscribes to '),
                                TextSpan(
                                  text: 'iPrep',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: " through you,gets "),
                                TextSpan(
                                  text: 'Rs. 100',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: ' Discount. You shall '),
                                TextSpan(
                                  text: 'get 20%',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: ' of their '),
                                TextSpan(
                                  text: 'iPrep',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                    text:
                                        " Plan in your wallet, which you can redeem."),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Center(
                      child: Text(
                        "Unique Code",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.values[5],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () async {
                          var _deepLinkUrl = await shareEarnRepository
                              .prepareDeepLinkForAppDownload();
                          await shareEarnRepository.shareContent(
                              context: context,
                              content: _deepLinkUrl.toString());
                        },
                        child: Container(
                          constraints: const BoxConstraints(
                            minHeight: 41,
                            maxWidth: 165,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: const Color(0xFFDEDEDE)),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FutureBuilder(
                                  future: _getReferralCode(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      debugPrint(
                                          'itemNo in FutureBuilder: ${snapshot.data}');
                                      return Text(
                                        snapshot.data ?? '',
                                        style: TextStyle(
                                          color: const Color(0xFF212121),
                                          fontWeight: FontWeight.values[4],
                                          fontSize: 14,
                                        ),
                                      );
                                    } else {
                                      return const Text('Loading...');
                                    }
                                  },
                                ),
                                const Text(
                                  "Copy",
                                  style: TextStyle(
                                    color: Color(0xFF0070FF),
                                    // fontWeight: FontWeight.values[5],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 8,
                    // ),
                    // Center(
                    //   child: Text(
                    //     "Click on code to share with your students",
                    //     style: TextStyle(
                    //       fontSize: 12,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "iPrep Cash",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/rupee_icon.png",
                                    height: 12,
                                    width: 8,
                                    color: const Color(0xFF212121),
                                  ),
                                  const SizedBox(
                                    width: 5.5,
                                  ),
                                  Text(
                                    _totalIPrepCash.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.values[5],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Redeem",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: _totalIPrepCash == 0
                                  ? const Color(0xFF9E9E9E)
                                  : const Color(0xFF0070FF),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    RichText(
                      text: TextSpan(
                        style: _textStyle,
                        children: const <TextSpan>[
                          TextSpan(text: 'To get more discounted pricing of '),
                          TextSpan(
                            text: 'iPrep',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: " for your students, become a "),
                          TextSpan(
                            text: 'Growth Partner',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text:
                                  ' with us. Please fill the form and we will get in touch with you soon.'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    const Center(
                      child: Text(
                        "(Request your Partner Code)",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    InkWell(
                      onTap: () async {
                        var _deepLinkUrl = await shareEarnRepository
                            .prepareDeepLinkForAppDownload();
                        await shareEarnRepository.shareContent(
                            context: context, content: _deepLinkUrl.toString());
                      },
                      child: Container(
                        constraints: const BoxConstraints(
                          minHeight: 60,
                          minWidth: double.infinity,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF0077FF)),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Share iPrep",
                            style: TextStyle(
                              color: Color(0xFF0077FF),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    InkWell(
                      onTap: () async {
                        await showQuizRecapBottomSheet(context: context);
                      },
                      child: Container(
                        constraints: const BoxConstraints(
                          minHeight: 60,
                          minWidth: double.infinity,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0077FF),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Get Partner Code",
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Loader(),
              ),
      ),
    );
  }
}

Future showQuizRecapBottomSheet({
  required BuildContext context,
}) {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _mobileTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _organizationTextEditingController =
      TextEditingController();
  final TextEditingController _numberOfStudentsTextEditingController =
      TextEditingController();
  final TextEditingController _stateTextEditingController =
      TextEditingController();

  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        12,
      ),
    ),
    isScrollControlled: true,
    builder: (builder) {
      return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 20,
              ),
              child: Center(
                child: Image.asset(
                  "assets/images/line.png",
                  width: 40,
                ),
              ),
            ),
            const Center(
              child: Text(
                "Enter your details",
                style: TextStyle(color: Color(0xff666666), fontSize: 16),
              ),
            ),
            Flexible(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getCoachProfileLabelAndControlField(
                        hintName: "Name",
                        labelName: "Enter Name",
                        textEditingController: _nameTextEditingController,
                      ),
                      getCoachProfileLabelAndControlField(
                        hintName: "+9199999999",
                        labelName: "Enter Mobile",
                        textEditingController: _mobileTextEditingController,
                      ),
                      getCoachProfileLabelAndControlField(
                        hintName: "Enter E-mail",
                        labelName: "E-mail",
                        textEditingController: _emailTextEditingController,
                      ),
                      getCoachProfileLabelAndControlField(
                        hintName: "Organisation",
                        labelName: "Organisation",
                        textEditingController:
                            _organizationTextEditingController,
                      ),
                      getCoachProfileLabelAndControlField(
                        hintName: "Number of Students",
                        labelName: "Number of Students",
                        textEditingController:
                            _numberOfStudentsTextEditingController,
                      ),
                      getCoachProfileLabelAndControlField(
                        hintName: "State",
                        labelName: "State",
                        textEditingController: _stateTextEditingController,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 40),
              child: InkWell(
                onTap: () async {
                  if (_nameTextEditingController.text.isNotEmpty &&
                      _mobileTextEditingController.text.isNotEmpty &&
                      _emailTextEditingController.text.isNotEmpty &&
                      _organizationTextEditingController.text.isNotEmpty &&
                      _numberOfStudentsTextEditingController.text.isNotEmpty &&
                      _stateTextEditingController.text.isNotEmpty) {
                    var _response = await myIprepReferralsRepository
                        .saveDetailsForIprepReferrals(
                      name: _nameTextEditingController.text,
                      mobileNumber: _mobileTextEditingController.text,
                      email: _emailTextEditingController.text,
                      organisation: _organizationTextEditingController.text,
                      numberOfStudents:
                          _numberOfStudentsTextEditingController.text,
                      state: _stateTextEditingController.text,
                    );
                    if (_response) {
                      Navigator.pop(context);
                      SnackbarMessages.showSuccessSnackbar(context,
                          message: Constants.coachMyiPrepReferralSuccess);
                    } else {
                      SnackbarMessages.showErrorSnackbar(context,
                          error: Constants.coachMyiPrepReferralError);
                    }
                  } else {
                    SnackbarMessages.showErrorSnackbar(context,
                        error: Constants.coachMyiPrepReferralFillDetailAlert);
                  }
                },
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 60,
                    minWidth: double.infinity,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0077FF),
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

getCoachProfileLabelAndControlField(
    {required String labelName,
    String? hintName,
    TextEditingController? textEditingController}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(
        height: 20,
      ),
      Text(
        labelName,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF9E9E9E),
        ),
      ),
      const SizedBox(
        height: 8,
      ),
      CoachProfileTextWidget(
        placeholder: hintName,
        textController: textEditingController,
      ),
    ],
  );
}

class CoachProfileTextWidget extends StatelessWidget {
  final String? placeholder;
  final TextEditingController? textController;
  final bool enabled;
  final TextInputType? keyboardType;

  const CoachProfileTextWidget(
      {Key? key,
      this.placeholder,
      this.textController,
      this.enabled = true,
      this.keyboardType})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      enabled: enabled,
      keyboardType: keyboardType,
      controller: textController,
      cursorColor: Colors.black87,
      textCapitalization: TextCapitalization.sentences,
      onChanged: (value) {},
      style: TextStyle(
          color: const Color(0xFF212121),
          fontSize: 14,
          fontWeight: FontWeight.values[4]),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(
            height: 0,
            color: const Color(0xFF9E9E9E), //#212121
            fontSize: 12,
            fontWeight: FontWeight.values[4]),
        // floatingLabelBehavior: FloatingLabelBehavior.never,

        focusedBorder: Constants.inputTextOutlineFocus,
        enabledBorder: Constants.inputTextOutline,
        border: Constants.inputTextOutline,
      ),
    );
  }
}

class CoachReferralsHistoryPage extends StatefulWidget {
  final int? iPrepCash;
  final int? invitedPeopleCount;

  const CoachReferralsHistoryPage({
    Key? key,
    this.iPrepCash,
    this.invitedPeopleCount,
  }) : super(key: key);

  @override
  _CoachReferralsHistoryState createState() => _CoachReferralsHistoryState();
}

class _CoachReferralsHistoryState extends State<CoachReferralsHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: false,
            leadingWidth: 36,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 11,
                ),
                child: Image.asset(
                  "assets/images/back_icon.png",
                  height: 25,
                  width: 25,
                ),
              ),
            ),
            title: Text(
              "History",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.values[5],
                color: const Color(0xFF212121),
              ),
            ),
          ),
          body: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  margin: const EdgeInsets.only(
                    left: 54,
                    right: 54,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: double.infinity,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FBFF),
                    border: Border.all(color: const Color(0xFF0077FF)),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/earn.png",
                              height: 23,
                              width: 23,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Earned",
                              style: TextStyle(
                                color: const Color(0xFF9E9E9E),
                                fontSize: 12,
                                fontWeight: FontWeight.values[4],
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/rupee_icon.png",
                                  height: 12,
                                  width: 8,
                                  color: const Color(0xFF212121),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  widget.iPrepCash.toString(),
                                  style: TextStyle(
                                    color: const Color(0xFF212121),
                                    fontSize: 16,
                                    fontWeight: FontWeight.values[5],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 45,
                        color: const Color(0xFFDEDEDE),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/invitation.png",
                              height: 23,
                              width: 23,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Invited",
                              style: TextStyle(
                                color: const Color(0xFF9E9E9E),
                                fontSize: 12,
                                fontWeight: FontWeight.values[4],
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              widget.invitedPeopleCount.toString(),
                              style: TextStyle(
                                color: const Color(0xFF212121),
                                fontSize: 16,
                                fontWeight: FontWeight.values[5],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row shareStepWidget({String? imagePath, required String text}) {
    return Row(
      children: [
        Image.asset(
          "assets/images/$imagePath.png",
          height: 35,
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: const Color(0xFF212121),
              fontSize: 14,
              fontWeight: FontWeight.values[4],
            ),
          ),
        ),
      ],
    );
  }
}

shareAndEarnButton({BuildContext? context}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
        primary: const Color(0xFF0077FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        minimumSize: const Size(double.infinity, 60)),
    child: Text(
      "Share iPrep",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.values[4]),
    ),
    onPressed: () async {
      var _deepLinkUrl =
          await shareEarnRepository.prepareDeepLinkForAppDownload();
      await shareEarnRepository.shareContent(
          context: context, content: _deepLinkUrl.toString());
    },
  );
}
