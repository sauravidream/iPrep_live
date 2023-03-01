import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPayment extends StatefulWidget {
  const InAppPayment({Key? key}) : super(key: key);

  @override
  _InAppPaymentState createState() => _InAppPaymentState();
}

final InAppPurchase _inAppPurchase = InAppPurchase.instance;
late StreamSubscription<List<PurchaseDetails>> _subscription;

class _InAppPaymentState extends State<InAppPayment> {
  @override
  void initState() {
    // TODO: implement initState
    initStoreInfo().then((value) => inAppPurchase());

    super.initState();
  }

  inAppPurchase() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;

    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchsaeUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      debugPrint(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:  Text('hello'),
    );
  }
}

void _listenToPurchsaeUpdated(List<PurchaseDetails> purchaseDetailsList) {
  purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      debugPrint("Showing Ui pending");
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        debugPrint("Showing Ui error");
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        bool valid = await _verifyPurchase(purchaseDetails);
        if (valid) {
          debugPrint("Showing Ui payment done");
        } else {
          debugPrint("Showing Ui invalid purchase");
          return;
        }
      }
    }
  });
}

Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
  return Future.value(true);
}

Future initStoreInfo() async {
  final bool isAvalable = await _inAppPurchase.isAvailable();
  const String _kConsumableId = '98065';
  const List<String> _kProductIds = <String>[_kConsumableId];
  if (isAvalable) {
    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());

    if (response.notFoundIDs.isEmpty) {
      debugPrint('handle the error');
    }
    List<ProductDetails> product = response.productDetails;
    debugPrint(product.toString());
  }
}
