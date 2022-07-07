import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:moneypro_new/ui/account/Profile.dart';
import 'package:moneypro_new/ui/account/UpdatePin.dart';
import 'package:moneypro_new/ui/aeps/aeps_sbm/aepsfino/AePSFinoBE.dart';
import 'package:moneypro_new/ui/aeps/aeps_sbm/aepsfino/AePSFinoLanding.dart';
import 'package:moneypro_new/ui/allsms/AllSMS.dart';
import 'package:moneypro_new/ui/atm/MATMProcess.dart';
import 'package:moneypro_new/ui/branches/BranchTransactions.dart';
import 'package:moneypro_new/ui/branches/BranchWithdrawal.dart';
import 'package:moneypro_new/ui/branches/ManagerBranchTranactions.dart';
import 'package:moneypro_new/ui/branches/MerchantBranch.dart';
import 'package:moneypro_new/ui/card/MyCardCongrats.dart';
import 'package:moneypro_new/ui/card/MyCardIntro.dart';
import 'package:moneypro_new/ui/card/MyCardIntroSecond.dart';
import 'package:moneypro_new/ui/card/MyCardKyc.dart';
import 'package:moneypro_new/ui/card/MyCardMobileVerify.dart';
import 'package:moneypro_new/ui/dmt/BeneficiaryTransaction.dart';
import 'package:moneypro_new/ui/employee/EMICalculator.dart';
import 'package:moneypro_new/ui/employee/EmpAssignQR.dart';
import 'package:moneypro_new/ui/employee/employeself/EmployeSelfService.dart';
import 'package:moneypro_new/ui/employee/EmployeeLanding.dart';
import 'package:moneypro_new/ui/employee/LoanCollection.dart';
import 'package:moneypro_new/ui/employee/MerchantList.dart';
import 'package:moneypro_new/ui/employee/MerchantQRWMsg.dart';
import 'package:moneypro_new/ui/employee/OverPaymentDue.dart';
import 'package:moneypro_new/ui/employee/investoronboarding/MerchantInvestorBank.dart';
import 'package:moneypro_new/ui/employee/investoronboarding/MerchantInvestorDoc.dart';
import 'package:moneypro_new/ui/employee/investoronboarding/MerchantInvestorMobile.dart';
import 'package:moneypro_new/ui/employee/investoronboarding/MerchantInvestorOnBoarding.dart';
import 'package:moneypro_new/ui/employee/merchantonboarding/EmpMerchantBankDetails.dart';
import 'package:moneypro_new/ui/employee/merchantonboarding/EmpMerchantBusinessDetails.dart';
import 'package:moneypro_new/ui/employee/merchantonboarding/EmpMerchantMapDetails.dart';
import 'package:moneypro_new/ui/employee/merchantonboarding/EmpMerchantPANDetails.dart';
import 'package:moneypro_new/ui/employee/merchantonboarding/EmpMerchantVerifyDetails.dart';
import 'package:moneypro_new/ui/employee/merchantonboarding/EmpViewMerchantQR.dart';
import 'package:moneypro_new/ui/footer/AllOffers.dart';
import 'package:moneypro_new/ui/footer/ShowCashback.dart';
import 'package:moneypro_new/ui/footer/TransPayoutRecipt.dart';
import 'package:moneypro_new/ui/footer/WalletRecipt.dart';
import 'package:moneypro_new/ui/merchant/MerchantWebDetails.dart';
import 'package:moneypro_new/ui/moneytransfer/AddNewAccount.dart';
import 'package:moneypro_new/ui/moneytransfer/AddNewUPIId.dart';
import 'package:moneypro_new/ui/moneytransfer/BeneficialTransHistory.dart';
import 'package:moneypro_new/ui/moneytransfer/MoneyTransferLanding.dart';
import 'package:moneypro_new/ui/moneytransfer/SelectBank.dart';
import 'package:moneypro_new/ui/moneytransfer/SendAccontMoney.dart';
import 'package:moneypro_new/ui/moneytransfer/SendUPIMoney.dart';
import 'package:moneypro_new/ui/qr/QRPayment.dart';
import 'package:moneypro_new/ui/qr/RequestQR.dart';
import 'package:moneypro_new/ui/recharge/dth/new_/DTHRechargeNew.dart';
import 'package:moneypro_new/ui/recharge/dth/new_/DTHSelectNew.dart';
import 'package:moneypro_new/ui/recharge/mobilerechange/MobilePaymentNew.dart';
import 'package:moneypro_new/ui/recharge/mobilerechange/MobileSelection.dart';
import 'package:moneypro_new/ui/recharge/mobilerechange/PayUMobilePlans.dart';
import 'package:moneypro_new/ui/recharge/wblight/WBElectricity.dart';
import 'package:moneypro_new/ui/sellnearn/CreditCardDetails.dart';
import 'package:moneypro_new/ui/sellnearn/DematDetails.dart';
import 'package:moneypro_new/ui/services/ApplyLoan.dart';
import 'package:moneypro_new/ui/services/AxisBankLanding.dart';
import 'package:moneypro_new/ui/services/BecameMerchant.dart';
import 'package:moneypro_new/ui/services/PancardLanding.dart';
import 'package:moneypro_new/ui/services/RewardsList.dart';
import 'package:moneypro_new/ui/services/ShowAds.dart';
import 'package:moneypro_new/ui/services/UpStoxLanding.dart';
import 'package:moneypro_new/ui/team/AddMember.dart';
import 'package:moneypro_new/ui/team/AddTeamIntro.dart';
import 'package:moneypro_new/ui/team/TeamMemberList.dart';
import 'package:moneypro_new/ui/wallet/AddMoneyToBank.dart';
import 'package:moneypro_new/ui/wallet/AddMoneyToWallet.dart';
import 'package:moneypro_new/ui/account/BankAccount.dart';
import 'package:moneypro_new/ui/account/ComplaintManagement.dart';
import 'package:moneypro_new/ui/account/MyAddress.dart';
import 'package:moneypro_new/ui/aeps/AEPSLanding.dart';
import 'package:moneypro_new/ui/aeps/AEPSMiniStatement.dart';
import 'package:moneypro_new/ui/aeps/AEPSReceipt.dart';
import 'package:moneypro_new/ui/aeps/aeps_sbm/AEPS_BalanceEnq.dart';
import 'package:moneypro_new/ui/aeps/aeps_sbm/AEPS_SBMOnboarding.dart';
import 'package:moneypro_new/ui/aeps/kycprocess/AEPSDocument.dart';
import 'package:moneypro_new/ui/aeps/kycprocess/AEPSVerifyMobile.dart';
import 'package:moneypro_new/ui/atm/ATMKycProcess.dart';
import 'package:moneypro_new/ui/atm/ATMOnBoarding.dart';
import 'package:moneypro_new/ui/contact/ContactList.dart';
import 'package:moneypro_new/ui/footer/MATMReceipt.dart';
import 'package:moneypro_new/ui/atm/TransactionRecepit.dart';
import 'package:moneypro_new/ui/dmt/AddBeneficiary.dart';
import 'package:moneypro_new/ui/dmt/AddSender.dart';
import 'package:moneypro_new/ui/dmt/BeneficiaryDetail.dart';
import 'package:moneypro_new/ui/dmt/ConfirmAuth.dart';
import 'package:moneypro_new/ui/dmt/ConfirmPayment.dart';
import 'package:moneypro_new/ui/dmt/DLTAllTransactions.dart';
import 'package:moneypro_new/ui/dmt/DMTLanding.dart';
import 'package:moneypro_new/ui/dmt/DMTRecipt.dart';
import 'package:moneypro_new/ui/dmt/FavouriteSenders.dart';
import 'package:moneypro_new/ui/dmt/TransferMoney.dart';
import 'package:moneypro_new/ui/employee/EmpSelfBankDetails.dart';
import 'package:moneypro_new/ui/employee/EmpSelfPanVerify.dart';
import 'package:moneypro_new/ui/footer/BBSPRecipt.dart';
import 'package:moneypro_new/ui/footer/RaisedTicket.dart';
import 'package:moneypro_new/ui/footer/TransactionHistory.dart';
import 'package:moneypro_new/ui/footer/TransactionHistoryEmpUser.dart';
import 'package:moneypro_new/ui/home/DummyClass.dart';
import 'package:moneypro_new/ui/home/MoreCategories.dart';
import 'package:moneypro_new/ui/home/ShowWebViews.dart';
import 'package:moneypro_new/ui/investment/InvestorLanding.dart';
import 'package:moneypro_new/ui/investment/InvestorPayment.dart';
import 'package:moneypro_new/ui/investment/InvestorStatement.dart';
import 'package:moneypro_new/ui/investment/InvestorWithdrawal.dart';
import 'package:moneypro_new/ui/investment/investoronboard/InvestorBankDetail.dart';
import 'package:moneypro_new/ui/investment/investoronboard/InvestorDocument.dart';
import 'package:moneypro_new/ui/investment/investoronboard/InvestorMobileVerify.dart';
import 'package:moneypro_new/ui/investment/investoronboard/InvestorOnboarding.dart';
import 'package:moneypro_new/ui/investment/investoronboard/InvestorPersonalDetail.dart';
import 'package:moneypro_new/ui/merchant/AddressByMap.dart';
import 'package:moneypro_new/ui/merchant/BankDetails.dart';
import 'package:moneypro_new/ui/merchant/BusinessDetails.dart';
import 'package:moneypro_new/ui/merchant/BusinessVerify.dart';
import 'package:moneypro_new/ui/merchant/MerchantDocument.dart';
import 'package:moneypro_new/ui/merchant/MerchantGetStarted.dart';
import 'package:moneypro_new/ui/merchant/PaymentOptions.dart';
import 'package:moneypro_new/ui/qr/QRDownload.dart';
import 'package:moneypro_new/ui/qr/ViewQRCode.dart';
import 'package:moneypro_new/ui/recharge/FastagRecharge.dart';
import 'package:moneypro_new/ui/recharge/MobileReceipt.dart';
import 'package:moneypro_new/ui/recharge/PaymentFailure.dart';
import 'package:moneypro_new/ui/recharge/PaymentSuccess.dart';
import 'package:moneypro_new/ui/recharge/RechargeFetchNo.dart';
import 'package:moneypro_new/ui/recharge/dth/DTHSelection.dart';
import 'package:moneypro_new/ui/recharge/lic/LICDetails.dart';
import 'package:moneypro_new/ui/recharge/mobile/MobilePayment.dart';
import 'package:moneypro_new/ui/recharge/mobile/PrepaidMobileRecharge.dart';
import 'package:moneypro_new/ui/recharge/RechargeFetchYes.dart';
import 'package:moneypro_new/ui/recharge/RechargeSelection.dart';
import 'package:moneypro_new/ui/auth/SetPin.dart';
import 'package:moneypro_new/ui/auth/SetPinFinger.dart';
import 'package:moneypro_new/ui/auth/SignIn.dart';
import 'package:moneypro_new/ui/auth/SignUp.dart';
import 'package:moneypro_new/ui/auth/VerifyMobile.dart';
import 'package:moneypro_new/ui/home/Perspective.dart';
import 'package:moneypro_new/ui/userboarding/UserBankDetails.dart';
import 'package:moneypro_new/ui/userboarding/UserPanVerify.dart';
import 'package:moneypro_new/ui/wallet/AppWallet.dart';
import 'package:moneypro_new/ui/wallet/Withdrwal.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/StateContainer.dart';
import 'package:path_provider/path_provider.dart';

import 'package:share_plus/share_plus.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ui/aeps/aeps_sbm/aepsfino/AePSFinoMiniStatement.dart';
import '../ui/aeps/aeps_sbm/aepsfino/AePSFinoTransaction.dart';
import '../ui/aeps/aeps_sbm/aepsfino/AePSMobileVerify.dart';
import '../ui/employee/employeself/EmpManageLeave.dart';
import '../ui/employee/employeself/EmpMarkAttendance.dart';
import '../ui/employee/employeself/EmpViewAttandance.dart';
import '../ui/employee/employeself/HolidayList.dart';
import '../ui/footer/SwitchDates.dart';
import '../ui/home/AppIntroScreen.dart';
import '../ui/sellnearn/OptoinsLists.dart';
import '../ui/sellnearn/SellDetails.dart';
import '../ui/sellnearn/SellEarnLanding.dart';
import '../ui/sellnearn/SellLeads.dart';
import '../ui/sellnearn/SellWallet.dart';
import '../ui/sellnearn/VideoPlayerScreen.dart';
import '../ui/services/ReferNEarn.dart';
import '../ui/services/YoutubeVdoPlayer.dart';
import 'Constants.dart';
import 'CustomWidgets.dart';

var formatString = NumberFormat("####", "en_US");
var formatNow = NumberFormat("###.##", "en_US");
var formatDecimal2Digit = NumberFormat("###.##", "en_US");

printMessage(screen, message) {
  print("$screen -=> $message");
}

closeKeyBoard(context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

closeCurrentPage(context) {
  Navigator.pop(context);
}

removeAllPages(context) {
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/perspective', (Route<dynamic> route) => false);
}

closeParticularPage(context, name) {
  Navigator.popAndPushNamed(context, '/$name');
}

showToastMessage(message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 4,
      backgroundColor: black,
      textColor: Colors.white,
      fontSize: font12);
}

openDialer() async {
  const url = "tel:03340443429";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

openMailOptions(msg) async {
  final Uri params = Uri(
    scheme: 'mailto',
    path: 'shanwal2009@gmail.com',
    query: 'subject=App ERROR&body=$msg',
  );

  var url = params.toString();
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

openBrowser(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

openSignUpScreen(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUp(),
      ));
}

openVerifyMobile(BuildContext context, mobile, action) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerifyMobile(mobile: mobile, action: action),
      ));
}

openSetPin(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetPin(),
      ));
}

openSignIn(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignIn(),
      ));
}

openPerspective(BuildContext context, isShowWelcome) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Perspective(isShowWelcome: isShowWelcome),
      ));
}

openSetPinFinger(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetPinFinger(),
      ));
}

openRechargeSelection(BuildContext context, category, searchBy, selectBy) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RechargeSelection(
            category: category, searchBy: searchBy, selectBy: selectBy),
      ));
}

openRechargeFetchYes(BuildContext context, Map map) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RechargeFetchYes(map: map),
      ));
}

openRechargeFetchNo(BuildContext context, Map map) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RechargeFetchNo(map: map),
      ));
}

openPaymentFailure(BuildContext context, Map map) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentFailure(map: map),
      ));
}

openPaymentSuccess(BuildContext context, Map map, isShowDialog) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PaymentSuccess(map: map, isShowDialog: isShowDialog),
      ));
}

openMobileReceipt(BuildContext context, Map map, isShowDialog) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MobileReceipt(map: map, isShowDialog: isShowDialog),
      ));
}

openInvestorLanding(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvestorLanding(),
      ));
}

Future updateATMStatus(context) async {
  var headers = {
    "Content-Type": "application/json",
  };

  var token = await getToken();

  var body = {
    "token": token,
  };

  final response = await http.post(Uri.parse(atmServiceStatusAPI),
      body: jsonEncode(body), headers: headers);

  var data = jsonDecode(utf8.decode(response.bodyBytes));

  printMessage("updateATMStatus", "Status : $data");

  saveDmtStatus(data['user']['dmt'].toString());
  saveMatmStatus(data['user']['matm'].toString());
  saveAepsStatus(data['user']['aeps'].toString());

  var wB = "${data['user']['wallet_balance']}";
  if (wB.toString() == "null") {
    saveWalletBalance("0");
  } else {
    saveWalletBalance("${data['user']['wallet_balance']}");
  }

  saveQRtBalance(data['user']['qr_wallet']);

  var mpBalc = await getWalletBalance();
  var qrBalc = await getQRBalance();

  final inheritedWidget = StateContainer.of(context);

  inheritedWidget.updateMPBalc(value: mpBalc);
  if (mpBalc == null || mpBalc == "0" || mpBalc == "") {
    mpBalc = "0";
    final inheritedWidget = StateContainer.of(context);
    inheritedWidget.updateMPBalc(value: mpBalc);
  }

  inheritedWidget.updateQRBalc(value: qrBalc);
  if (qrBalc == null || qrBalc == "0" || qrBalc == "") {
    qrBalc = "0";
    final inheritedWidget = StateContainer.of(context);
    inheritedWidget.updateQRBalc(value: qrBalc);
  }
}

int randNumber() {
  Random random = new Random();
  int randomNumber = random.nextInt(999999 - 1000);
  return randomNumber;
}

Future fetchUserAccountBalance() async {
  final token = await getToken();

  var headers = {
    "Content-Type": "application/json",
  };
  final body = {
    "token": token,
  };

  final response = await http.post(Uri.parse(fatchAccountBalanceAPI),
      body: jsonEncode(body), headers: headers);

  var data = jsonDecode(utf8.decode(response.bodyBytes));

  printMessage("Account Balc Function", "data : $data");
}

removeAllPageForLogout(context) {
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/SignIn', (Route<dynamic> route) => false);
}

shareTransReceipt(_printKey, name) async {
  RenderRepaintBoundary boundary =
      _printKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
  ui.Image image = await boundary.toImage();
  final directory = (await getApplicationDocumentsDirectory()).path;
  ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  Uint8List? pngBytes = byteData?.buffer.asUint8List();
  // print(pngBytes);
  File imgFile = new File('$directory/screenshot.png');
  imgFile.writeAsBytes(pngBytes!);

  Share.shareFiles([imgFile.path]);
}

Future<void> downloadReceiptAsPDF(_printKey) async {
  Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
    final doc = pw.Document();

    final image = await WidgetWraper.fromKey(
      key: _printKey,
      pixelRatio: 2.0,
    );

    doc.addPage(pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Expanded(
              child: pw.Image(image),
            ),
          );
        }));

    return doc.save();
  });
}

generateXFormat(String value) async {
  if (value.length > 4) {
    int a = value.length;
    value = value.substring(value.length - 4);
    int b = value.length;
    int c = a - b;
    for (int i = 0; i < c; i++) {
      value = "X" + value;
    }
  }
  return value;
}

openInvestorWithdrawal(BuildContext context, maxAmt) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvestorWithdrawal(maxAmt: maxAmt),
      ));
}

openInvestorStatement(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvestorStatement(),
      ));
}

openInvestorDocument(BuildContext context, pan) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvestorDocument(pan: pan),
      ));
}

openInvestorOnboarding(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvestorOnboarding(),
      ));
}

openInvestorMobileVerify(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvestorMobileVerify(),
      ));
}

openInvestorPersonalDetail(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvestorPersonalDetail(),
      ));
}

openInvestorBankDetail(BuildContext context, pan) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvestorBankDetail(pan: pan),
      ));
}

openInvestorPayment(BuildContext context, amount) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvestorPayment(amount: amount),
      ));
}

openMerchantGetStarted(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MerchantGetStarted(),
      ));
}

openBusinessDetails(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusinessDetails(),
      ));
}

openAddressByMap(BuildContext context, Map itemResponse) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressByMap(itemResponse: itemResponse),
      ));
}

openBusinessVerify(BuildContext context, Map itemResponse) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusinessVerify(itemResponse: itemResponse),
      ));
}

openMerchantDocument(BuildContext context, Map itemResponse) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MerchantDocument(itemResponse: itemResponse),
      ));
}

openBankDetails(BuildContext context, Map itemResponse) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BankDetails(itemResponse: itemResponse),
      ));
}

openPaymentOptions(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentOptions(),
      ));
}

openQRDownload(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRDownload(),
      ));
}

openViewQRCode(BuildContext context, action) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewQRCode(action: action),
      ));
}

openMoreCategories(BuildContext context, lat, lng) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoreCategories(lat: lat, lng: lng),
      ));
}

openFastagRecharge(context, Map map) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FastagRecharge(map: map),
      ));
}

/*openPrepaidMobileRecharge(context, mobileNo) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrepaidMobileRecharge(
          mobileNo: mobileNo,
        ),`
      ));
}

openMobilePayment(context, Map map) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MobilePayment(map: map),
      ));
}*/

openTransactionHistory(BuildContext context, fromDate, toDate) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TransactionHistory(fromDate: fromDate, toDate: toDate),
      ));
}

openTransactionHistoryEmpUser(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionHistoryEmpUser(),
      ));
}

openDTHSelection(BuildContext context, category, searchBy, selectBy) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DTHSelectNew(
            category: category, searchBy: searchBy, selectBy: selectBy),
      ));
}

openDTHRecharge(context, Map map) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DTHRechargeNew(map: map),
      ));
}

openBBSPRecipt(context, Map map) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BBSPRecipt(map: map),
      ));
}

openAppWallet(context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppWallet(),
      ));
}

openLICDetails(context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LICDetails(),
      ));
}

/*openUserPanVerify(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserPanVerify(),
      ));
}

openUserBankDetails(BuildContext context, Map itemResponse) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserBankDetails(itemResponse: itemResponse),
      ));
}*/

openEmpSelfPanVerify(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmpSelfPanVerify(),
      ));
}

openEmpSelfBankDetails(BuildContext context, Map itemResponse) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmpSelfBankDetails(itemResponse: itemResponse),
      ));
}

openDMTLanding(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DMTLanding(),
      ));
}

openBeneficiaryDetail(BuildContext context, custId, senderName, senderMobile) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BeneficiaryDetail(
            custId: custId, senderName: senderName, senderMobile: senderMobile),
      ));
}

openAddBeneficiary(BuildContext context, custId) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBeneficiary(custId: custId),
      ));
}

openDLTTransactions(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DLTAllTransactions(),
      ));
}

openDMTRecipt(BuildContext context, Map map) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DMTRecipt(map: map),
      ));
}

openTransferMoney(BuildContext context, Map map) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransferMoney(map: map),
      ));
}

openConfirmAuth(BuildContext context, Map itemResponse) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmAuth(
          itemResponse: itemResponse,
        ),
      ));
}

openConfirmPayment(BuildContext context, Map itemResponse) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmPayment(itemResponse: itemResponse),
      ));
}

openAddSender(BuildContext context, mobile) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSender(
          mobile: mobile,
        ),
      ));
}

openFavouriteBeneficiary(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavouriteSenders(),
      ));
}

openDummyClass(BuildContext context, response) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DummyClass(response: response),
      ));
}

/*openAEPSVerifyMobile(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AEPSVerifyMobile(),
      ));
}*/

openAEPSDocument(BuildContext context, pancard) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AEPSDocument(pancard: pancard),
      ));
}

openShowWebViews(BuildContext context, url) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowWebViews(
          url: url,
        ),
      ));
}

openAEPS_SBMOnboarding(BuildContext context, pipe) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AEPS_SBMOnboarding(pipe: pipe),
      ));
}

openAEPSLanding(BuildContext context, pipe) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AEPSLanding(pipe: pipe),
      ));
}

openAEPS_BalanceEnq(BuildContext context, Map map) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AEPS_BalanceEnq(map: map),
      ));
}

openAEPSReceipt(BuildContext context, Map map, isShowDialog) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AEPSReceipt(map: map, isShowDialog: isShowDialog),
      ));
}

openAEPSMiniStatement(BuildContext context, response) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AEPSMiniStatement(response: response),
      ));
}

openATMOnBoarding(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ATMOnBoarding(),
      ));
}

openATMKycProcess(BuildContext context, authToken, mATMId) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ATMKycProcess(authToken: authToken, mATMId: mATMId),
      ));
}

openTransactionRecpit(BuildContext context, Map map) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionRecepit(map: map),
      ));
}

openMATMReceipt(BuildContext context, Map map) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MATMReceipt(map: map),
      ));
}

/*openMyAddress(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyAddress(),
      ));
}

openBankAccount(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BankAccount(),
      ));
}*/

openRaisedTicket(BuildContext context, txnId, amount, txnStatus, mode, opName,
    category, pgAmt) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RaisedTicket(
            txnId: txnId,
            amount: amount,
            txnStatus: txnStatus,
            mode: mode,
            opName: opName,
            category: category,
            pgAmt: pgAmt),
      ));
}

openContactList(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactList(),
      ));
}

openComplaintManagement(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComplaintManagement(),
      ));
}

openAddMoneyToWallet(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMoneyToWallet(),
      ));
}

openAddMoneyToBank(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMoneyToBank(),
      ));
}

openAddTeamIntro(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTeamIntro(),
      ));
}

openTeamMemberList(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamMemberList(),
      ));
}

openAddMember(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMember(),
      ));
}

openUpdatePin(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdatePin(),
      ));
}

openAllOffers(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllOffers(),
      ));
}

openPancardLanding(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PancardLanding(),
      ));
}

openBeneficiaryTransaction(BuildContext context, custId, mobile) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BeneficiaryTransaction(
          custId: custId,
          mobile: mobile,
        ),
      ));
}

openEmployeeLanding(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeLanding(),
      ));
}

openMerchantList(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MerchantList(),
      ));
}

openEmpMerchantBusinessDetails(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmpMerchantBusinessDetails(),
      ));
}

openEmpMerAddressByMap(BuildContext context, itemResponse, File storeImage) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmpMerchantMapDetails(
            itemResponse: itemResponse, storeImage: storeImage),
      ));
}

openEmpMerBusinessVerify(BuildContext context, itemResponse, File storeImage) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmpMerchantVerifyDetails(
            itemResponse: itemResponse, storeImage: storeImage),
      ));
}

openEmpMerPanVerify(
  BuildContext context,
  itemResponse,
  File storeImage,
  // File docImage, File adhFront, File adhBack
) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmpMerchantPANDetails(
          itemResponse: itemResponse,
          storeImage: storeImage,
          // docImage: docImage,
          // adhFront: adhFront,
          // adhBack: adhBack
        ),
      ));
}

openEmpMerBankDetails(
  BuildContext context,
  itemResponse,
  File storeImage,
  // File docImage,
  File selfiImage,
  //  File adhFront, File adhBack
) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmpMerchantBankDetails(
          itemResponse: itemResponse,
          storeImage: storeImage,
          // docImage: docImage,
          selfiImage: selfiImage,
          // adhFront: adhFront,
          // adhBack: adhBack
        ),
      ));
}

openEmpAssignQR(BuildContext context, token, mobile) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmpAssignQR(token: token, mobile: mobile),
      ));
}

/*openShowCashback(BuildContext context, commission) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowCashback(commission: commission),
      ));
}*/

openAxisBankLanding(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AxisBankLanding(),
      ));
}

openUpStoxLanding(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpStoxLanding(),
      ));
}

openLoanCollection(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoanCollection(),
      ));
}

openOverPaymentDue(BuildContext context, loanId) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OverPaymentDue(loanId: loanId),
      ));
}

openMerchantInvestorMobile(BuildContext context, token, mobile) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MerchantInvestorMobile(token: token, mobile: mobile),
      ));
}

openMerchantInvestorOnBoarding(BuildContext context, token) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MerchantInvestorOnBoarding(token: token),
      ));
}

openMerchantInvestorBank(BuildContext context, Map map) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MerchantInvestorBank(map: map),
      ));
}

openMerchantInvestorDoc(BuildContext context, pan, token) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MerchantInvestorDoc(pan: pan, token: token),
      ));
}

openRequestQR(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequestQR(),
      ));
}

openQRPayment(BuildContext context, Map map, File file) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRPayment(map: map, file: file),
      ));
}

openMyCardIntro(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyCardIntro(),
      ));
}

openMyCardCongrats(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyCardCongrats(),
      ));
}

openEMICalculator(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EMICalculator(),
      ));
}

openEmpViewMerchantQR(BuildContext context, mToken) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmpViewMerchantQR(
          mToken: mToken,
        ),
      ));
}

Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('www.google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}

openApplyLoan(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplyLoan(),
      ));
}

openWalletRecipt(BuildContext context, Map map) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WalletRecipt(map: map),
      ));
}

opneMyCardIntroSecond(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyCardIntroSecond(),
      ));
}

openMyCardMobileVerify(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyCardMobileVerify(),
      ));
}

openMyCardKyc(BuildContext context, authToken) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyCardKyc(authToken: authToken),
      ));
}

openRewardsList(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RewardsList(),
      ));
}

openProfile(BuildContext context, profilePic, profilePicId) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Profile(profilePic: profilePic, profilePicId: profilePicId),
      ));
}

openMATMProcess(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MATMProcess(),
      ));
}

openWBElectricity(BuildContext context, Map map) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WBElectricity(
          map: map,
        ),
      ));
}

openMerchantQRWMsg(
    BuildContext context, mToken, name, mobile, companyName, qrDisplayName) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MerchantQRWMsg(
            mToken: mToken,
            name: name,
            mobile: mobile,
            companyName: companyName,
            qrDisplayName: qrDisplayName),
      ));
}

openMoneyTransferLanding(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoneyTransferLanding(),
      ));
}

openAddNewAccount(BuildContext context, bankName, bankLogo) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNewAccount(
          bankName: bankName,
          bankLogo: bankLogo,
        ),
      ));
}

openSelectBank(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectBank(),
      ));
}

openSendAccontMoney(BuildContext context, name, ifsc, accNo, logo) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SendAccontMoney(name: name, ifsc: ifsc, accNo: accNo, logo: logo),
      ));
}

openTransPayoutRecipt(BuildContext context, Map map) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransPayoutRecipt(map: map),
      ));
}

openBeneficialTransHistory(BuildContext context, accNo) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BeneficialTransHistory(accNo: accNo),
      ));
}

openAddNewUPIId(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNewUPIId(),
      ));
}

openSendUPIMoney(BuildContext context, name, vpa, isAddNew) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SendUPIMoney(
          name: name,
          vpa: vpa,
          isAddNew: isAddNew,
        ),
      ));
}

/*openAllSMS(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllSMS(),
      ));
}*/

openBecameMerchant(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BecameMerchant(),
      ));
}

openMobileSelection(BuildContext context, mobileNo) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MobileSelection(mobileNo: mobileNo),
      ));
}

openMobilePaymentNew(context, Map map) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MobilePaymentNew(map: map),
      ));
}

openMerchantBranch(BuildContext context, isManagerShow) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MerchantBranch(isManagerShow: isManagerShow),
      ));
}

openBranchTransactions(
    BuildContext context, branchId, mobile, branchWallet, fromDate, toDate) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BranchTransactions(
          branchId: branchId,
          mobile: mobile,
          branchWallet: branchWallet,
          fromDate: fromDate,
          toDate: toDate,
        ),
      ));
}

openBranchWithdrawal(BuildContext context, ablAmt, qrId, branchId, branchName,
    mobile, photo, isManagerShow) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BranchWithdrawal(
            ablAmt: ablAmt,
            qrId: qrId,
            branchId: branchId,
            branchName: branchName,
            mobile: mobile,
            photo: photo,
            isManagerShow: isManagerShow),
      ));
}

openManagerBranchTranactions(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManagerBranchTranactions(),
      ));
}

openPayUMobilePlans(
    BuildContext context, mobileNo, List<Contact> contacts, String spKey) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PayUMobilePlans(
          mobileNo: mobileNo,
          contacts: contacts,
          spKey: spKey,
        ),
      ));
}

openReferNEarn(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReferNEarn(),
      ));
}

openSellEarnLanding(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SellEarnLanding(),
      ));
}

openOptoinsLists(BuildContext context, passKey) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OptoinsLists(passKey: passKey),
      ));
}

openSellDetails(BuildContext context, fileName) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SellDetails(fileName: fileName),
      ));
}

openDematDetails(BuildContext context, fileName) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DematDetails(fileName: fileName),
      ));
}

openCreditCardDetails(BuildContext context, fileName) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreditCardDetails(fileName: fileName),
      ));
}

openSellWallet(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SellWallet(),
      ));
}

openSellLeads(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SellLeads(),
      ));
}

openYoutubeVdoPlayer(BuildContext context, vId) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YoutubeVdoPlayer(vId: vId),
      ));
}

openEmployeSelfService(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeSelfService(),
      ));
}

openEmpMarkAttendance(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmpMarkAttendance(),
      ));
}

openHolidayList(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HolidayList(),
      ));
}

openEmpViewAttandance(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmpViewAttandance(),
      ));
}

openEmpManageLeave(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => EmpManageLeave()));
}

openMerchantWebDetails(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => MerchantWebDetails()));
}

openAePSMobileVerify(BuildContext context, txnType, lat, lng) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AePSMobileVerify(txnType: txnType, lat: lat, lng: lng)));
}

openAePSFinoTransaction(BuildContext context, txnType, lat, lng) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AePSFinoTransaction(txnType: txnType, lat: lat, lng: lng)));
}

openAePSFinoBE(BuildContext context, Map map) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => AePSFinoBE(map: map)));
}

openAePSFinoLanding(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => AePSFinoLanding()));
}

openAePSFinoMiniStatement(BuildContext context, Map response) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AePSFinoMiniStatement(response: response)));
}

openWithdrwal(BuildContext context, isMWalletShow, isInvestShow, maxAmt) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Withdrwal(
              isMWalletShow: isMWalletShow,
              isInvestShow: isInvestShow,
              maxAmt: maxAmt)));
}

openStoreApp(BuildContext context) {
  //Navigator.push(context, MaterialPageRoute(builder: (context) => Splash()));
  //Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
}

openSwitchDates(BuildContext context, action, branchId, mobile, branchWallet) {
  //Navigator.push(context, MaterialPageRoute(builder: (context)=> SwitchDates()));
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false, // set to false
      pageBuilder: (_, __, ___) => SwitchDates(
          action: action,
          branchId: branchId,
          mobile: mobile,
          branchWallet: branchWallet),
    ),
  );
}

cashbackPopup(context, commission, id) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => ShowCashback(
            commission: commission.toString(),
            id: id,
          ));
}

trackScreens(screen) {
  FirebaseAnalytics().setCurrentScreen(screenName: screen);
}

String getFileSizeString({required int bytes, int decimals = 0}) {
  const suffixes = ["b", "kb", "mb", "gb", "tb"];
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
}
