class PaymentModel {
  String? amount;
  String? date;
  bool? firstTimePaymentDone;
  String? planDuration;
  String? planID;
  String? planName;
  String? referalAmount;
  String? referalBetween;
  String? referalCode;
  String? referalTransactionType;
  String? referalUserID;
  String? remark;
  String? remarkReferal;
  String? transactionID;
  String? type;
  String? userID;
  String? userName;
  bool? walletApplied;
  String? userType;
  String? userEmail;
  String? userMobile;
  String? discountCode;

  PaymentModel.fromJson(Map<String, dynamic> json)
      : amount = json['amount'],
        date = json['date'],
        firstTimePaymentDone = json['first_time_payment_done'],
        planDuration = json['plan_duration'],
        planID = json['plan_id'],
        planName = json['plan_name'],
        referalAmount = json['referal_amount'],
        referalBetween = json['referal_between'],
        referalCode = json['referal_code'],
        referalTransactionType = json['referal_transaction_type'],
        referalUserID = json['referal_user_id'],
        remark = json['remark'],
        remarkReferal = json['remark_referal'],
        transactionID = json['transaction_id'],
        type = json['type'],
        userID = json['user_id'],
        userName = json['user_name'],
        walletApplied = json['wallet_applied'],
        userType = json['user_type'],
        userEmail = json['user_email'],
        userMobile = json['user_mobile'],
        discountCode = json['discount_code'];

  Map<String, dynamic> toJson() => {
        if (amount != null) 'amount': amount,
        if (date != null) 'date': date,
        if (firstTimePaymentDone != null)
          'first_time_payment_done': firstTimePaymentDone,
        if (planDuration != null) 'plan_duration': planDuration,
        if (planID != null) 'plan_id': planID,
        if (planName != null) 'plan_name': planName,
        if (referalAmount != null) 'referal_amount': referalAmount,
        if (referalBetween != null) 'referal_between': referalBetween,
        if (referalCode != null) 'referal_code': referalCode,
        if (referalTransactionType != null)
          'referal_transaction_type': referalTransactionType,
        if (referalUserID != null) 'referal_user_id': referalUserID,
        if (remark != null) 'remark': remark,
        if (remarkReferal != null) 'remark_referal': remarkReferal,
        if (transactionID != null) 'transaction_id': transactionID,
        if (type != null) 'type': type,
        if (userID != null) 'user_id': userID,
        if (userName != null) 'user_name': userName,
        if (walletApplied != null) 'wallet_applied': walletApplied,
        if (userType != null) 'user_type': userType,
        if (userEmail != null) 'user_email': userEmail,
        if (userMobile != null) 'user_mobile': userMobile,
    if (discountCode != null) 'discount_code': discountCode,
      };

  PaymentModel({
    this.amount,
    this.date,
    this.firstTimePaymentDone,
    this.planDuration,
    this.planID,
    this.planName,
    this.referalAmount,
    this.referalBetween,
    this.referalCode,
    this.referalTransactionType,
    this.referalUserID,
    this.remark,
    this.remarkReferal,
    this.transactionID,
    this.type,
    this.userID,
    this.userName,
    this.walletApplied,
    this.userType,
    this.userEmail,
    this.userMobile,
    this.discountCode,
  });
}
