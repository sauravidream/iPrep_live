import 'dart:async';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/custom_widgets/loader.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/constants.dart';
import '../../common/references.dart';
import '../../common/shared_preference.dart';
import '../../custom_widgets/web_view_page.dart';
import '../../model/subscription_plan_code_model.dart';
import '../../repository/payment_repository.dart';

class AndroidSubscriptionPlan extends StatefulWidget {
  const AndroidSubscriptionPlan({Key? key}) : super(key: key);

  @override
  State<AndroidSubscriptionPlan> createState() =>
      _AndroidSubscriptionPlanState();
}

class _AndroidSubscriptionPlanState extends State<AndroidSubscriptionPlan> {
  bool _dataLoaded = false;
  bool _useIPrepCash = false;
  bool cashApply = false;
  int? androidPlanAmount;
  int? androidIPrepCashAmount;
  int? androidIPrepCashAmountRemain = 0;
  int? paymentAmount = 0;
  int? localPaymentAmount = 0;
  int? iPrepRemainingAmount = 0;
  int? discountAmountByCode;
  bool? discountCodeApplied = false;
  bool codeApplied = false;
  List _products = [];
  late final ScrollController _controller = ScrollController();
  final TextEditingController _discountEditingController =
      TextEditingController();
  String? _appLevelLanguage;
  int selectedIndex = 0;
  late Future androidPlanData;

  Future? userPlan;
  @override
  void initState() {
    getPlanData();
    _discountEditingController.text = "";
    super.initState();
  }

  getPlanData() async {
    _appLevelLanguage = await getStringValuesSF('language');
    userPlan = getAndroidPlan().then((userPlanData) {
      setState(() {
        _dataLoaded = true;
        androidPlanAmount = userPlanData[selectedIndex]['rawPrice'];
        paymentAmount = userPlanData[selectedIndex]['rawPrice'];
      });
      shareEarnRepository
          .fetchNumberOfInvitedPeopleAndEarnedAmount()
          .then((value) {
        if (value != null && value["balance"] != null) {
          setState(() {
            // Check alternate for try parse
            // Hint: Check about Regex;
            androidIPrepCashAmount =
                int.tryParse(value["balance"]["current_amount"]);
            androidIPrepCashAmountRemain =
                int.tryParse(value["balance"]["current_amount"]);
          });
        } else {
          setState(() {
            androidIPrepCashAmount = 0;
            androidIPrepCashAmountRemain = 0;
          });
        }
      });
      return userPlanData;
    });
  }

  Future getAndroidPlan() async {
    return await apiHandler.getAPICall(
      endPointURL: 'user_plans/android_plans',
    );
  }

  // For the new plan

  calculateAllAmount() async {
    /*debugPrint(discountAmountByCode.toString());
    debugPrint(androidIPrepCashAmount.toString());
    debugPrint(androidIPrepCashAmountRemain.toString());
    debugPrint(paymentAmount.toString());*/

    if (discountCodeApplied == true && _useIPrepCash == false) {
      paymentAmount = androidPlanAmount! - discountAmountByCode!;
    } else if (discountCodeApplied == true && _useIPrepCash == true) {
      androidIPrepCashAmountRemain = androidIPrepCashAmount;

      if (androidPlanAmount! -
              discountAmountByCode! -
              androidIPrepCashAmountRemain! <
          0) {
        androidIPrepCashAmountRemain = androidPlanAmount! -
            discountAmountByCode! -
            androidIPrepCashAmountRemain!;
        androidIPrepCashAmountRemain =
            androidIPrepCashAmountRemain! - androidIPrepCashAmountRemain!;
        paymentAmount = androidPlanAmount! -
            discountAmountByCode! -
            androidIPrepCashAmountRemain!;
      } else if (androidPlanAmount == discountAmountByCode &&
          androidIPrepCashAmountRemain == 0) {
        androidIPrepCashAmountRemain = androidPlanAmount! -
            discountAmountByCode! -
            androidIPrepCashAmountRemain!;
        androidIPrepCashAmountRemain =
            androidIPrepCashAmountRemain! - androidIPrepCashAmountRemain!;
        paymentAmount = androidPlanAmount! -
            discountAmountByCode! -
            androidIPrepCashAmountRemain!;
      } else {
        androidIPrepCashAmountRemain = androidPlanAmount! -
            discountAmountByCode! -
            androidIPrepCashAmountRemain!;
        paymentAmount = androidPlanAmount! -
            discountAmountByCode! -
            androidIPrepCashAmountRemain!;
      }
    } else if (discountCodeApplied == false && _useIPrepCash == true) {
      androidIPrepCashAmountRemain = androidIPrepCashAmount;

      if (androidPlanAmount! - androidIPrepCashAmountRemain! < 0) {
        androidIPrepCashAmountRemain =
            androidPlanAmount! - androidIPrepCashAmountRemain!;
        androidIPrepCashAmountRemain =
            androidIPrepCashAmount! + androidIPrepCashAmountRemain!;

        paymentAmount = androidPlanAmount! - androidIPrepCashAmountRemain!;
      } else {
        androidIPrepCashAmountRemain = androidIPrepCashAmount;

        paymentAmount = androidPlanAmount! - androidIPrepCashAmountRemain!;
      }
    } else if (discountCodeApplied == true && _useIPrepCash == true) {
      paymentAmount = androidPlanAmount! - discountAmountByCode!;
    } else if (discountCodeApplied == true && _useIPrepCash == true) {
      androidIPrepCashAmountRemain = androidIPrepCashAmount;

      if (androidPlanAmount! -
              discountAmountByCode! -
              androidIPrepCashAmountRemain! <
          0) {
        androidIPrepCashAmountRemain = androidPlanAmount! -
            discountAmountByCode! -
            androidIPrepCashAmountRemain!;
        androidIPrepCashAmountRemain =
            androidIPrepCashAmountRemain! - androidIPrepCashAmountRemain!;
        paymentAmount = androidPlanAmount! -
            discountAmountByCode! -
            androidIPrepCashAmountRemain!;
      }
    } else if (_useIPrepCash == false) {
      androidIPrepCashAmountRemain = androidIPrepCashAmount;
      paymentAmount = 0;
      paymentAmount = androidPlanAmount;
    }

    /* debugPrint(discountAmountByCode.toString());
    debugPrint(androidIPrepCashAmount.toString());
    debugPrint(androidIPrepCashAmountRemain.toString());
    debugPrint(paymentAmount.toString());*/
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: const Color(0xFF0077FF),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xFF0077FF),
            centerTitle: false,
            leadingWidth: 36,
            leading: IconButton(
              iconSize: 100,
              padding: const EdgeInsets.only(
                left: 10,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset(
                "assets/images/back_icon.png",
                color: Colors.white,
                height: 100,
                width: 100,
              ),
            ),
          ),
          body: _dataLoaded
              ? Stack(
                  children: [
                    SingleChildScrollView(
                      controller: _controller,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            margin: const EdgeInsets.only(
                              bottom: 150,
                              top: 110,
                            ),
                            child: Column(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: Color(0xFFdfdfdf), width: 1.0),
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Container(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    // height: size.height * .30,
                                    width: size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              top: 15, bottom: 10),
                                          child: Text(
                                            'Subscription plans',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ),
                                        FutureBuilder(
                                            future: userPlan,
                                            builder: (context, snapshot) {
                                              List<Widget> children;
                                              if (snapshot.hasData) {
                                                _products = snapshot.data
                                                    as List<dynamic>;
                                                children = <Widget>[
                                                  ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      bottom: 0,
                                                    ),
                                                    shrinkWrap: true,
                                                    itemCount: _products.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedIndex =
                                                                index;
                                                            androidPlanAmount =
                                                                _products[index]
                                                                    [
                                                                    "rawPrice"];
                                                            paymentAmount =
                                                                _products[index]
                                                                    [
                                                                    "rawPrice"];
                                                          });
                                                          discountAmountByCode =
                                                              0;
                                                          androidIPrepCashAmountRemain =
                                                              0;
                                                          discountCodeApplied =
                                                              false;
                                                          _useIPrepCash = false;
                                                          calculateAllAmount();
                                                        },
                                                        child: Card(
                                                          elevation: 0,
                                                          shape: selectedIndex ==
                                                                  index
                                                              ? RoundedRectangleBorder(
                                                                  side: const BorderSide(
                                                                      color: Colors
                                                                          .blue,
                                                                      width:
                                                                          1.0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20.0))
                                                              : RoundedRectangleBorder(
                                                                  side: const BorderSide(
                                                                      color: Color(
                                                                          0xFFdfdfdf),
                                                                      width:
                                                                          1.0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20.0)),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              color: selectedIndex ==
                                                                      index
                                                                  ? Colors
                                                                      .blue[50]
                                                                  : Colors.grey
                                                                      .shade50,
                                                            ),
                                                            height: 70,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Flexible(
                                                                  flex: 2,
                                                                  child: Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                20,
                                                                            right:
                                                                                20),
                                                                        child:
                                                                            Card(
                                                                          elevation:
                                                                              0,
                                                                          shape: selectedIndex == index
                                                                              ? RoundedRectangleBorder(side: const BorderSide(color: Colors.blue, width: 1.0), borderRadius: BorderRadius.circular(25.0))
                                                                              : RoundedRectangleBorder(side: const BorderSide(color: Color(0xFFdfdfdf), width: 1.0), borderRadius: BorderRadius.circular(20.0)),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                40,
                                                                            width:
                                                                                40,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.white),
                                                                            child: selectedIndex == index
                                                                                ? Image.asset(
                                                                                    "assets/images/checke.png",
                                                                                    height: 40,
                                                                                    width: 40,
                                                                                    scale: 0.7,
                                                                                  )
                                                                                : const SizedBox(),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Flexible(
                                                                        flex: 1,
                                                                        child:
                                                                            Text(
                                                                          _products[index]
                                                                              [
                                                                              "title"],
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.values[5],
                                                                            color:
                                                                                const Color(
                                                                              0xFF212121,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Flexible(
                                                                  flex: 1,
                                                                  child: Row(
                                                                    children: [
                                                                      const SizedBox(
                                                                        width:
                                                                            4,
                                                                      ),
                                                                      Text(
                                                                        _products.isEmpty
                                                                            ? ''
                                                                            : _products[index]["price"],
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.values[5],
                                                                          color:
                                                                              const Color(0xFF212121),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        (_appLevelLanguage ==
                                                                                "hindi")
                                                                            ? " / वर्ष"
                                                                            : "/yr",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              const Color(0xFF666666).withOpacity(0.5),
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.values[5],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  )
                                                ];
                                              } else if (snapshot.hasError) {
                                                children = <Widget>[
                                                  const Icon(
                                                    Icons.error_outline,
                                                    size: 60,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 16),
                                                    child: Text(
                                                        'Error: ${snapshot.error}'),
                                                  )
                                                ];
                                              } else {
                                                children = const <Widget>[
                                                  SizedBox(
                                                    width: 60,
                                                    height: 60,
                                                    child: Loader(),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 16),
                                                    child: Text(
                                                        'Awaiting Plan...'),
                                                  )
                                                ];
                                              }

                                              return Column(
                                                children: children,
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                getFeatureWidget(
                                    size: size,
                                    appLevelLanguage: _appLevelLanguage),
                                const SizedBox(
                                  height: 10,
                                ),
                                getOffersAndBenefitWidget(
                                    size: size,
                                    appLevelLanguage: _appLevelLanguage),
                                const SizedBox(
                                  height: 10,
                                ),
                                getBillDetailWidget(
                                    size: size,
                                    appLevelLanguage: _appLevelLanguage,
                                    payableAmount: paymentAmount),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 13,
                                  ),
                                  child: InkWell(
                                    child: RichText(
                                      text: const TextSpan(
                                        text:
                                            'By paying for iPrep, you acknowledge to have read and agree to ',
                                        style: TextStyle(
                                            color: Color(0xFF212121),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12),
                                        children: [
                                          TextSpan(
                                              text: 'terms and conditions',
                                              style: TextStyle(
                                                  color: Color(0xFF0077FF))),
                                          TextSpan(text: ' , '),
                                          TextSpan(
                                              text: 'privacy policy',
                                              style: TextStyle(
                                                  color: Color(0xFF0077FF))),
                                          TextSpan(text: 'for iPrep.in'),
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      final Uri url = Uri.parse(
                                          'https://learn.iprep.in/TermsAndConditions');
                                      if (await canLaunchUrl(url)) {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                const WebViewPage(
                                              link:
                                                  "https://learn.iprep.in/TermsAndConditions",
                                            ),
                                          ),
                                        );
                                      } else {
                                        SnackbarMessages.showErrorSnackbar(
                                            context,
                                            error: Constants.dialerError);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: 90,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF0077FF),
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(80)),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 0,
                        ),
                        child: Text(
                          (_appLevelLanguage == "hindi")
                              ? "iPrep का सब्सक्रिप्शन लें\nएवं असीमित शिक्षा प्राप्त करें"
                              : "Get iPrep Subscription and\n Learn Unlimited",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.values[5],
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child:
                          // Platform.isAndroid
                          //     ?
                          getProceedGooglePayButton(context, paymentAmount!,
                              _discountEditingController.text, _controller,
                              mounted: mounted,
                              electedIndex: selectedIndex,
                              planList: _products,
                              discountCodeApplied: discountCodeApplied,
                              androidIPrepCashAmountRemain:
                                  androidIPrepCashAmountRemain,
                              iPrepCashApply: _useIPrepCash),
                    )
                  ],
                )
              : const Center(child: Loader()),

          /*ModalProgressHUD(
            inAsyncCall: _discountCodeVerified,
            child: Container(
              alignment: Alignment.center,
              color: Colors.white,
              child:
            ),
          ),*/
        ),
      ),
    );
  }

  Widget paymentRow(
      {required String text, String? amount, bool minusRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              color: const Color(0xFF666666),
              fontSize: 12,
              fontWeight: FontWeight.values[4],
            ),
          ),
          Row(
            children: [
              if (minusRequired)
                Text(
                  "-",
                  style: TextStyle(
                    color: const Color(0xFF666666),
                    fontSize: 12,
                    fontWeight: FontWeight.values[4],
                  ),
                ),
              Image.asset(
                "assets/images/rupee_icon.png",
                height: 10,
                width: 10,
                color: const Color(0xFF666666),
              ),
              amount == null
                  ? Loader()
                  : Text(
                      amount,
                      style: TextStyle(
                        color: const Color(0xFF666666),
                        fontSize: 12,
                        fontWeight: FontWeight.values[4],
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget totalPaymentRow() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            (_appLevelLanguage == "hindi") ? "कुल देय राशि" : "Total Payable",
            style: TextStyle(
              color: const Color(0xFF212121),
              fontSize: 14,
              fontWeight: FontWeight.values[5],
            ),
          ),
          Row(
            children: [
              Image.asset(
                "assets/images/rupee_icon.png",
                height: 12,
                width: 12,
                color: const Color(0xFF212121),
              ),
              Text(
                paymentAmount.toString(),
                style: TextStyle(
                  color: const Color(0xFF212121),
                  fontSize: 14,
                  fontWeight: FontWeight.values[5],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getIPrepCashRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 20,
        top: 0,
      ),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Material(
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    setState(() {
                      _useIPrepCash = !_useIPrepCash;
                      calculateAllAmount();
                    });
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12, width: 1),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                    ),
                    child: _useIPrepCash
                        ? Image.asset(
                            "assets/images/checked_image_blue.png",
                            height: 20,
                            width: 20,
                          )
                        : const SizedBox(
                            height: 20,
                            width: 20,
                          ),
                  ),
                ),
              ),
              const SizedBox(
                width: 7.77,
              ),
              Text(
                (_appLevelLanguage == "hindi")
                    ? "iPrep कैश का उपयोग करें"
                    : "Use iPrep Cash",
                style: TextStyle(
                    color: const Color(0xFF212121),
                    fontSize: 14,
                    fontWeight: FontWeight.values[4]),
              ),
              const SizedBox(
                width: 4,
              ),
              Image.asset(
                "assets/images/info.png",
                height: 12,
                width: 12,
                color: const Color(0xFF212121),
              ),
            ],
          ),
          Row(
            children: [
              Image.asset(
                "assets/images/rupee_icon.png",
                height: 11,
                width: 7,
                color: const Color(0xFF212121),
              ),
              const SizedBox(
                width: 3.5,
              ),
              Text(
                androidIPrepCashAmount.toString(),
                style: TextStyle(
                    color: const Color(0xFF212121),
                    fontSize: 14,
                    fontWeight: FontWeight.values[5]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  getBillDetailWidget(
      {required Size size, String? appLevelLanguage, int? payableAmount}) {
    return Card(
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFdfdfdf), width: 1.0),
          borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: 15,
                  bottom: 10,
                ),
                child: Text(
                  'Billing Details',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              paymentRow(
                  text: (_appLevelLanguage == "hindi")
                      ? "प्लान का कुल मूल्य"
                      : "Plan Total",
                  amount: androidPlanAmount.toString()),
              if (_useIPrepCash)
                paymentRow(
                    text: (_appLevelLanguage == "hindi")
                        ? "iPrep कैश"
                        : "iPrep Cash",
                    amount: (androidIPrepCashAmountRemain!).toString(),
                    minusRequired: true),
              if (discountCodeApplied!)
                paymentRow(
                    text: (_appLevelLanguage == "hindi")
                        ? "छूट प्राप्त करने हेतु कोड"
                        : "Discount Code**",
                    amount: discountAmountByCode.toString(),
                    minusRequired: true),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.12,
                  right: MediaQuery.of(context).size.width * 0.12,
                  bottom: 16,
                ),
                child: Image.asset(
                  "assets/images/line_1.png",
                ),
              ),
              totalPaymentRow(),
            ],
          ),
        ),
      ),
    );
  }

  getOffersAndBenefitWidget({required Size size, String? appLevelLanguage}) {
    return Card(
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFdfdfdf), width: 1.0),
          borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: 15,
                  bottom: 10,
                ),
                child: Text(
                  'Offers & Benefit',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              getIPrepCashRow(context),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 20,
                ),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(8),
                  color: const Color(0xFFDEDEDE),
                  dashPattern: const [6, 4],
                  padding: const EdgeInsets.all(
                    12,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.6,
                            ),
                            child: TextFormField(
                              controller: _discountEditingController,
                              autocorrect: false,
                              // textCapitalization: TextCapitalization.characters,
                              cursorColor: Colors.black87,
                              textAlignVertical: TextAlignVertical.top,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(12, 0, 0, 0),
                                hintText: (_appLevelLanguage == "hindi")
                                    ? "छूट प्राप्त करने हेतु कोड"
                                    : "Discount Code**",
                                isDense: true,
                                border: InputBorder.none,
                                hintStyle: const TextStyle(),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Material(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 50,
                                width: 90,
                                decoration: BoxDecoration(
                                    color: discountCodeApplied!
                                        ? Colors.red[50]
                                        : Colors.green[100],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    discountCodeApplied! ? "Remove" : "Add",
                                    style: TextStyle(
                                        color: discountCodeApplied!
                                            ? const Color(0xFFFF7575)
                                            : Colors.green,
                                        fontSize: 14,
                                        fontWeight: FontWeight.values[4]),
                                  ),
                                ),
                              ),
                              onTap: () async {
                                // if (discountCodeApplied!) {
                                //   _discountEditingController.clear();
                                // }

                                await upgradePlanRepository
                                    .applyDiscountCode(
                                        mounted: mounted,
                                        context: context,
                                        discountEditingController:
                                            _discountEditingController,
                                        index: selectedIndex,
                                        products: _products)
                                    .then((value) {
                                  if (value != null) {
                                    setState(() {
                                      discountAmountByCode = value;

                                      discountCodeApplied =
                                          !discountCodeApplied!;
                                    });
                                  } else {
                                    SnackbarMessages.showErrorSnackbar(context,
                                        error: "Invalid Discount Code");
                                    _discountEditingController.text = "";
                                    setState(() {
                                      discountCodeApplied = false;
                                      discountAmountByCode = 0;
                                    });
                                  }
                                });

                                calculateAllAmount();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Contact us in case you \nhave any questions",
                    style: TextStyle(
                      color: const Color(0xFF666666),
                      fontSize: 12,
                      fontWeight: FontWeight.values[4],
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 39,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF0077FF)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      Constants.contactUsForSpecialOffers,
                      style: TextStyle(
                        color: const Color(0xFF666666),
                        fontSize: 12,
                        fontWeight: FontWeight.values[4],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

getFeatureWidget({required Size size, String? appLevelLanguage}) {
  String? _appLevelLanguage = appLevelLanguage;
  return Card(
    shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFFdfdfdf), width: 1.0),
        borderRadius: BorderRadius.circular(20.0)),
    child: Container(
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: 15,
              bottom: 10,
            ),
            child: Text(
              'Features for Subscribers only',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          getFeatureTile(
            imagePath: "assets/images/payment_page_1.png",
            title: (_appLevelLanguage == "hindi")
                ? "कक्षाएं स्विच करेंं"
                : "Switch Classes",
            subtitle: (_appLevelLanguage == "hindi")
                ? "वर्ष के भीतर कभी भी कक्षा बदलें"
                : "Change class anytime within the year",
          ),
          getFeatureTile(
            imagePath: "assets/images/payment_page_2.png",
            title: (_appLevelLanguage == "hindi")
                ? "आप सभी पहुँच प्राप्त करें"
                : "You get all access",
            subtitle: (_appLevelLanguage == "hindi")
                ? "वीडियो पाठ, पाठ्यक्रम पुस्तकें, नोट्स"
                : "Video lessons, syllabus books, notes",
          ),
          getFeatureTile(
            imagePath: "assets/images/payment_page_3.png",
            title: (_appLevelLanguage == "hindi")
                ? "असीमित अभ्यास"
                : "Unlimited Practice",
            subtitle: (_appLevelLanguage == "hindi")
                ? "महारत हासिल करें और अपने स्कोर में सुधार करें"
                : "Build mastery & improve your score",
          ),
          getFeatureTile(
            imagePath: "assets/images/payment_page_4.png",
            title: (_appLevelLanguage == "hindi")
                ? "अतिरिक्त सामग्री का अन्वेषण करें"
                : "Explore Additional Content",
            subtitle: (_appLevelLanguage == "hindi")
                ? "जैसे की स्टेम के प्रयोग, कहानियाँ, कविताएँ, जीवनियाँ "
                : "DIY projects, stories, poems, biographies",
          ),
        ],
      ),
    ),
  );
}

Widget getAmountContainer(BuildContext context, String _appLevelLanguage) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 22,
    ),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: const Color(0xFF0077FF).withOpacity(0.1),
        side: const BorderSide(
          color: Color(0xFF0077FF),
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        minimumSize: const Size(344, 70),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            (_appLevelLanguage == "hindi") ? "वार्षिक" : "Annual",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.values[5],
              color: const Color(0xFF212121),
            ),
          ),
          Row(
            children: [
              if ((_appLevelLanguage != "Hindi"))
                Image.asset(
                  "assets/images/rupee_icon.png",
                  height: 14,
                  width: 14,
                  color: const Color(0xFF212121),
                ),
              if ((_appLevelLanguage == "hindi"))
                Text(
                  "रु",
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.values[5]),
                ),
              const SizedBox(
                width: 4,
              ),
              Text(
                "3,000",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.values[5],
                  color: const Color(0xFF212121),
                ),
              ),
              Text(
                (_appLevelLanguage == "hindi") ? " / वर्ष" : "/yr",
                style: TextStyle(
                  color: const Color(0xFF666666).withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.values[5],
                ),
              ),
            ],
          ),
        ],
      ),
      onPressed: () async {},
    ),
  );
}

Widget getProceedGooglePayButton(
    BuildContext context, int payableAmount, String? discountCode, _controller,
    {required bool mounted,
    bool? discountCodeApplied,
    List? planList,
    required int electedIndex,
    int? androidIPrepCashAmountRemain,
    bool? iPrepCashApply}) {
  Size size = MediaQuery.of(context).size;
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 22,
      left: 16,
      right: 16,
    ),
    child: Card(
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFdfdfdf), width: 1.0),
          borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        height: size.height * .12,
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 21.0, top: 13),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text(
                          "Total Payable",
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    payableAmount == null
                        ? const Loader()
                        : Text(payableAmount.toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w600)),
                    InkWell(
                      child: const Text(
                        'View Bill Details',
                        style: TextStyle(
                            color: Color(0xFF0077FF),
                            fontFamily: 'inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                      onTap: () {
                        _controller = _controller;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _controller
                              .animateTo(_controller.position.maxScrollExtent,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.ease)
                              .then((value) async {
                            await Future.delayed(const Duration(seconds: 2));
                            _controller.animateTo(
                                _controller.position.minScrollExtent,
                                duration: const Duration(seconds: 1),
                                curve: Curves.ease);
                          });
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0077FF),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  minimumSize: Size(10, size.height * .06),
                ),
                child: Row(
                  children: [
                    Text(
                      "Proceed",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.values[5]),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Image.asset(
                      "assets/images/proceed_icon.png",
                      height: 16,
                      width: 16,
                    ),
                  ],
                ),
                onPressed: () async {
                  String? userID = await getStringValuesSF("userID");
                  String? userTypeNode =
                      await (userRepository.getUserNodeName());
                  CodeInfoModel? codeInfoModel;
                  if (discountCodeApplied == true)
                    codeInfoModel = await upgradePlanRepository
                        .checkDiscountValidation(discountCode: discountCode);

                  await createRequest(
                    context: context,
                    planDuration: discountCodeApplied == false
                        ? planList![electedIndex]["plan_duration"].toString()
                        : codeInfoModel?.userPlan?.planDuration.toString(),
                    planID: discountCodeApplied == false
                        ? planList![electedIndex]["id"]
                        : codeInfoModel?.userPlan?.id.toString(),
                    planName: discountCodeApplied == false
                        ? planList![electedIndex]["title"]
                        : codeInfoModel?.userPlan?.title.toString(),
                    payableAmount: payableAmount.toInt(),
                    userType: userTypeNode,
                    discountCode: discountCode,
                    walletApplied: iPrepCashApply,
                  );

                  if (!mounted) return;
                  String? response = await Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => WebViewPage(
                        link:
                            "https://ipreppayment.herokuapp.com/?userId=$userID&userType=$userTypeNode",
                      ),
                    ),
                  );
                  if (!mounted) return;
                  Navigator.pop(
                    context,
                  );
                  if (response != null && response == "success") {
                    restrictUser = false;
                    SnackbarMessages.showSuccessSnackbar(context,
                        message: Constants.paymentSuccess);
                    await userPlanActivate(
                      payableAmount: payableAmount,
                      usedPrepaidCode: discountCode ?? '',
                      userID: userID!,

                      planDuration: discountCodeApplied == false
                          ? planList![electedIndex]["plan_duration"]
                          : codeInfoModel?.userPlan?.planDuration.toString(),
                      planID: discountCodeApplied == false
                          ? planList![electedIndex]["id"]
                          : codeInfoModel?.userPlan?.id.toString(),
                      planName: discountCodeApplied == false
                          ? planList![electedIndex]["title"]
                          : codeInfoModel?.userPlan?.title.toString(),

                      // planDuration: planList[electedIndex]["plan_duration"].toString(),
                      // planID: planList[electedIndex]["id"],
                      // planName: planList[electedIndex]["title"],
                      walletApplied: iPrepCashApply!,
                    );

                    // This Process is apply in the last when the payment is completed

                    if (iPrepCashApply == true) {
                      await shareEarnRepository
                          .depositEarningAmountInReferUser(
                              electedIndex: electedIndex, planList: planList)
                          .then((value) async {
                        await shareEarnRepository.debitEarningAmountFromUser(
                            androidIPrepCashAmountRemain);
                      });
                    }

                    if (discountCodeApplied == true) {
                      debugPrint(discountCodeApplied.toString());
                      await upgradePlanRepository.userAndCodeRelation(
                          discountCode: discountCode);
                    } else {
                      DatabaseReference updateProjectIdInReportRef =
                          firebaseDatabase.ref("/reports/app_reports/$userID/");
                      await updateProjectIdInReportRef.update({
                        "project_id": "retail",
                        "school_id": "retail",
                      });
                    }
                    if (discountCodeApplied != true) {
                      String? userType = await getStringValuesSF("UserType");
                      DatabaseReference updateProjectIdInUserIDRef =
                          firebaseDatabase.ref(
                              "/users/${userType!.toLowerCase()}s/$userID");
                      await updateProjectIdInUserIDRef.update({
                        "project_id": "retail",
                        "school_id": "retail",
                      });
                    }
                  } else if (response != null && response == "failure") {
                    SnackbarMessages.showErrorSnackbar(context,
                        error: Constants.paymentFailedError);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ),
    /* ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: const Color(0xFF0077FF),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          minimumSize: const Size(344, 56),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/images/rupee_icon.png",
                      height: 12,
                      width: 8,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      payableAmount.toString(),
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.values[4]),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  "Total Payable",
                  style:
                      TextStyle(fontSize: 10, fontWeight: FontWeight.values[4]),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Proceed",
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.values[5]),
                ),
                const SizedBox(
                  width: 12,
                ),
                Image.asset(
                  "assets/images/proceed_icon.png",
                  height: 16,
                  width: 16,
                ),
              ],
            ),
          ],
        ),
        onPressed: () async {
          String? _userID = await getStringValuesSF("userID");
          String? _userTypeNode = await (userRepository.getUserNodeName());
          await createRequest(
              context: context,
              payableAmount: payableAmount,
              userType: _userTypeNode,
              discountCode: discountCode);

          if (Platform.isIOS) {
            if (await canLaunch(
                "https://ipreppayment.herokuapp.com/?userId=$_userID&userType=$_userTypeNode")) {
              await launch(
                  "https://ipreppayment.herokuapp.com/?userId=$_userID&userType=$_userTypeNode");
            }
            // Navigator.push(context,
            //     CupertinoPageRoute(builder: (context) => const InApp()));

            return;
          }

          String? response = await Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => WebViewPage(
                link:
                    "https://ipreppayment.herokuapp.com/?userId=$_userID&userType=$_userTypeNode",
              ),
            ),
          );
          Navigator.pop(
            context,
          );
          if (response != null && response == "success") {
            //Show success snackbar
            restrictUser = false;
            SnackbarMessages.showSuccessSnackbar(context,
                message: Constants.paymentSuccess);
            usedPrepaidCode(
              payableAmount: payableAmount,
              usedPrepaidCode: discountCode,
              userID: _userID!,
            );
          } else if (response != null && response == "failure") {
            //Show failure snackbar
            SnackbarMessages.showErrorSnackbar(context,
                error: Constants.paymentFailedError);
          }

          //https://ipreppayment.herokuapp.com/api/payment/order?amount=1000
        },
      )*/
  );
}

Widget getFeatureTile({
  required String imagePath,
  required String title,
  required String subtitle,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 24, left: 24),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Image.asset(
            imagePath,
            alignment: Alignment.centerLeft,
            height: 62,
            width: 62,
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF212121),
                  fontSize: 14,
                  fontWeight: FontWeight.values[6],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: const Color(0xFF666666),
                  fontSize: 12,
                  fontWeight: FontWeight.values[4],
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
