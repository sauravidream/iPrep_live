import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/custom_widgets/loader.dart';
import 'package:idream/custom_widgets/web_view_page.dart';
import 'package:idream/pay/consumable_store.dart';
import 'package:idream/pay/in_app_purchase.dart';
import 'package:idream/repository/payment_repository.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/subscription_plan_code_model.dart';

const Set<String> _kIds = <String>{'98065', '1'};
int paymentTry = 0;

class UpgradePlan extends StatefulWidget {
  const UpgradePlan({Key? key}) : super(key: key);

  @override
  _UpgradePlanState createState() => _UpgradePlanState();
}

class _UpgradePlanState extends State<UpgradePlan> {
  // New Code For the inApp Purchase

  bool kAutoConsume = true;

  List<String> kProductIds = <String>[];

  //
  bool _dataLoaded = true;

  String? _appLevelLanguage;

  List iPrepPlanList = [0, 1];
  int? selectedIndex = 0;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<UserPlan> userPlanList = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  //
  late final ScrollController _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    getIosPlan();
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      debugPrint(error.toString());
      // handle error here.
    });
    initStoreInfo();
    //
  }

  getIosPlan() async {
    await apiHandler
        .getAPICall(
      endPointURL: 'user_plans/ios_plans',
    )
        .then((value) {
      value.forEach((element) {
        userPlanList.add(UserPlan.fromJson(element));
      });
    });
  }

  Widget _buildRestoreButton() {
    if (_loading) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              primary: Colors.white,
            ),
            onPressed: () => _inAppPurchase.restorePurchases(),
            child: const Text('Restore purchases'),
          ),
        ],
      ),
    );
  }

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _consumables = consumables;
    });
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.productID == 1) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      List<String> consumables = await ConsumableStore.load();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        setState(() {
          _dataLoaded = false;
        });
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          debugPrint('Payment error');
          setState(() {
            _dataLoaded = false;
          });
          Navigator.pop(context);
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            debugPrint('Payment Dome');
            if (!mounted) return;
            updatePlan(context, productDetails: userPlanList[selectedIndex!]);
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            debugPrint('Payment $purchaseDetails');
            return;
          }
        }
        if (Platform.isIOS) {
          if (purchaseDetails.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
        }
      }
    });
  }

  Future<void> confirmPriceChange(BuildContext context) async {
    if (Platform.isIOS) {
      var iapStoreKitPlatformAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (Platform.isIOS) {
      var iosPlatformAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      var iosPlatformAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
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
                  color: Colors.white,
                  height: 25,
                  width: 25,
                ),
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
                              horizontal: 10,
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
                                        _products.isEmpty
                                            ? const CupertinoActivityIndicator(
                                                color: Colors.blue,
                                              )
                                            : ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  bottom: 0,
                                                ),
                                                shrinkWrap: true,
                                                itemCount: _products.length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      if (selectedIndex ==
                                                          index) {
                                                        setState(() {
                                                          selectedIndex = index;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          selectedIndex = index;
                                                        });
                                                      }
                                                    },
                                                    child: Card(
                                                      elevation: 0,
                                                      shape: selectedIndex ==
                                                              index
                                                          ? RoundedRectangleBorder(
                                                              side: const BorderSide(
                                                                  color: Colors
                                                                      .blue,
                                                                  width: 1.0),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0))
                                                          : RoundedRectangleBorder(
                                                              side: const BorderSide(
                                                                  color: Color(
                                                                      0xFFdfdfdf),
                                                                  width: 1.0),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color:
                                                              selectedIndex ==
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
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20),
                                                                    child: Card(
                                                                      elevation:
                                                                          0,
                                                                      shape: selectedIndex ==
                                                                              index
                                                                          ? RoundedRectangleBorder(
                                                                              side: const BorderSide(color: Colors.blue, width: 1.0),
                                                                              borderRadius: BorderRadius.circular(25.0))
                                                                          : RoundedRectangleBorder(side: const BorderSide(color: Color(0xFFdfdfdf), width: 1.0), borderRadius: BorderRadius.circular(20.0)),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            40,
                                                                        width:
                                                                            40,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(25),
                                                                            color: Colors.white),
                                                                        child: selectedIndex ==
                                                                                index
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
                                                                    child: Text(
                                                                      _products[
                                                                              index]
                                                                          .title,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                                                                    width: 4,
                                                                  ),
                                                                  Text(
                                                                    _products
                                                                            .isEmpty
                                                                        ? ''
                                                                        : _products[index]
                                                                            .price,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .values[5],
                                                                      color: const Color(
                                                                          0xFF212121),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    (_appLevelLanguage ==
                                                                            "hindi")
                                                                        ? " / वर्ष"
                                                                        : "/yr",
                                                                    style:
                                                                        TextStyle(
                                                                      color: const Color(
                                                                              0xFF666666)
                                                                          .withOpacity(
                                                                              0.5),
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .values[5],
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
                                                }),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                getFeatureWidget(),
                                const SizedBox(
                                  height: 15,
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: Color(0xFFdfdfdf), width: 1.0),
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                          bottom: 17,
                                          left: 20,
                                          right: 17,
                                          top: 17),
                                      // height: size.height * .30,
                                      width: size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        children: [
                                          Platform.isAndroid
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    bottom: 20,
                                                  ),
                                                  child: Text(
                                                    (_appLevelLanguage ==
                                                            "hindi")
                                                        ? "बऑफ़र और लाभ"
                                                        : "Offers & benefits",
                                                    style: TextStyle(
                                                      color: const Color(
                                                          0xFF212121),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.values[6],
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 145,
                                                height: 30,
                                                child: Text(
                                                  (_appLevelLanguage == "hindi")
                                                      ? "यदि आपके कोई प्रश्न हैं तो\n हमसे संपर्क करें"
                                                      : "Contact us in case you\n have any questions",
                                                  style: const TextStyle(
                                                    color: Color(0xFF212121),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  if (await canLaunch(Constants
                                                      .supportMobileUrl)) {
                                                    await launch(Constants
                                                        .supportMobileUrl);
                                                  } else {
                                                    SnackbarMessages
                                                        .showErrorSnackbar(
                                                            context,
                                                            error: Constants
                                                                .dialerError);
                                                  }
                                                },
                                                child: Container(
                                                  width: 150,
                                                  height: 39,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xFF0077FF)),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    Constants
                                                        .contactUsForSpecialOffers,
                                                    style: TextStyle(
                                                      color: const Color(
                                                          0xFF666666),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.values[4],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: Color(0xFFdfdfdf), width: 1.0),
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                          bottom: 17,
                                          left: 20,
                                          right: 17,
                                          top: 17),
                                      // height: size.height * .30,
                                      width: size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            (_appLevelLanguage == "hindi")
                                                ? "बिलिंग विवरण"
                                                : "Billing Details",
                                            style: TextStyle(
                                              color: const Color(0xFF212121),
                                              fontSize: 18,
                                              fontWeight: FontWeight.values[6],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          paymentRow(
                                              text:
                                                  (_appLevelLanguage == "hindi")
                                                      ? "प्लान का कुल मूल्य"
                                                      : "Plan Total",
                                              amount: _products.isEmpty
                                                  ? ''
                                                  : _products[selectedIndex!
                                                          .toInt()]
                                                      .price),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.12,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.12,
                                              bottom: 16,
                                            ),
                                            child: Image.asset(
                                              "assets/images/line_1.png",
                                            ),
                                          ),
                                          totalPaymentRow(),
                                        ],
                                      )),
                                ),
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
                        child: getProceedApplePayButton(_controller, context,
                            selectedIndex!, _products, _inAppPurchase)),
                  ],
                )
              : const Center(
                  child: Loader(),
                ),
        ),
      ),
    );
  }

  Widget paymentRow(
      {required String text,
      required String amount,
      bool minusRequired = false}) {
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
              Text(
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
          _products.isEmpty
              ? const Text("")
              : Text(
                  _products[selectedIndex!].price,
                  style: TextStyle(
                    color: const Color(0xFF212121),
                    fontSize: 14,
                    fontWeight: FontWeight.values[5],
                  ),
                ),
        ],
      ),
    );
  }

  getFeatureWidget() {
    Size size = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFdfdfdf), width: 1.0),
          borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        // height: size.height * .60,
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 15, bottom: 10),
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
}

void updatePlan(context, {UserPlan? productDetails}) async {
  String? userID = await getStringValuesSF("userID");
  String? userTypeNodeName = await (getUserNodeName());
  dbRef.child("users/$userTypeNodeName/$userID/users_plans").update({
    "date_started": DateTime.now().toUtc().toString(),
    "plan_duration": productDetails!.planDuration.toString(),
    "status": productDetails.description,
  }).then((value) async {
    DatabaseReference updateProjectRef =
        firebaseDatabase.ref("/reports/app_reports/$userID/");
    await updateProjectRef.update({
      "project_id": "retail",
      "school_id": "retail",
    });
    String? userType = await getStringValuesSF("UserType");
    DatabaseReference updateProjectIdInUserIDRef =
        firebaseDatabase.ref("/users/${userType!.toLowerCase()}s/$userID");
    await updateProjectIdInUserIDRef.update({
      "project_id": "retail",
      "school_id": "retail",
    });

    debugPrint('Plan Update Successful');
    Navigator.pop(context);
  });
}

Widget getProceedApplePayButton(
  controller,
  BuildContext context,
  int selectedIndex,
  List<ProductDetails> products,
  InAppPurchase inAppPurchase,
) {
  Size size = MediaQuery.of(context).size;
  return Card(
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
                  products.isEmpty
                      ? const CupertinoActivityIndicator(
                          radius: 5,
                          color: Color(0xFF0077FF),
                        )
                      : Text(products[selectedIndex].price,
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
                        controller = controller;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          controller
                              .animateTo(controller.position.maxScrollExtent,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.ease)
                              .then((value) async {
                            await Future.delayed(const Duration(seconds: 2));
                            controller.animateTo(
                                controller.position.minScrollExtent,
                                duration: const Duration(seconds: 1),
                                curve: Curves.ease);
                          });
                        });
                      }),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 0,
                  left: 30,
                  top: 11,
                  right: 10,
                ),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF0077FF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: const Size(344, 56),
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
                        Flexible(
                          flex: 1,
                          child: Image.asset(
                            "assets/images/proceed_icon.png",
                            height: 16,
                            width: 16,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () async {
                      late PurchaseParam purchaseParam;

                      String? fullName = await getStringValuesSF("fullName");

                      if (Platform.isIOS) {
                        var iapStoreKitPlatformAddition =
                            inAppPurchase.getPlatformAddition<
                                InAppPurchaseStoreKitPlatformAddition>();
                        await iapStoreKitPlatformAddition
                            .showPriceConsentIfNeeded();
                        purchaseParam = PurchaseParam(
                          productDetails: products[selectedIndex],
                          applicationUserName: fullName,
                        );
                      }

                      {
                        inAppPurchase.buyNonConsumable(
                            purchaseParam: purchaseParam);
                      }
                    })),
          ),
        ],
      ),
    ),
  );
}

Widget getFeatureTile(
    {required String imagePath,
    required String title,
    required String subtitle}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 24, left: 32),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Image.asset(
            imagePath,
            alignment: Alignment.centerLeft,
            height: 62,
            width: 62,
            // scale: .7,
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
                  fontWeight: FontWeight.values[4],
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

class IOSPlanUpgrade extends StatefulWidget {
  const IOSPlanUpgrade({Key? key}) : super(key: key);

  @override
  State<IOSPlanUpgrade> createState() => _IOSPlanUpgradeState();
}

class _IOSPlanUpgradeState extends State<IOSPlanUpgrade> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.grey,
    );
  }
}
