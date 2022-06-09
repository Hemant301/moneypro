import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:moneypro_new/ui/account/BankAccount.dart';
import 'package:moneypro_new/ui/account/ComplaintManagement.dart';
import 'package:moneypro_new/ui/account/MyAddress.dart';
import 'package:moneypro_new/ui/account/Profile.dart';
import 'package:moneypro_new/ui/account/UpdatePin.dart';
import 'package:moneypro_new/ui/aeps/AEPSLanding.dart';
import 'package:moneypro_new/ui/aeps/AEPSMiniStatement.dart';
import 'package:moneypro_new/ui/aeps/AEPSReceipt.dart';
import 'package:moneypro_new/ui/aeps/aeps_sbm/AEPS_BalanceEnq.dart';
import 'package:moneypro_new/ui/aeps/aeps_sbm/AEPS_SBMOnboarding.dart';
import 'package:moneypro_new/ui/aeps/kycprocess/AEPSDocument.dart';
import 'package:moneypro_new/ui/aeps/kycprocess/AEPSVerifyMobile.dart';
import 'package:moneypro_new/ui/atm/ATMKycProcess.dart';
import 'package:moneypro_new/ui/atm/ATMOnBoarding.dart';
import 'package:moneypro_new/ui/atm/TransactionRecepit.dart';
import 'package:moneypro_new/ui/auth/SetPin.dart';
import 'package:moneypro_new/ui/auth/SetPinFinger.dart';
import 'package:moneypro_new/ui/auth/SignIn.dart';
import 'package:moneypro_new/ui/auth/SignUp.dart';
import 'package:moneypro_new/ui/auth/VerifyMobile.dart';
import 'package:moneypro_new/ui/branches/BranchTransactions.dart';
import 'package:moneypro_new/ui/card/MyCardCongrats.dart';
import 'package:moneypro_new/ui/card/MyCardIntro.dart';
import 'package:moneypro_new/ui/contact/ContactList.dart';
import 'package:moneypro_new/ui/dmt/AddBeneficiary.dart';
import 'package:moneypro_new/ui/dmt/AddSender.dart';
import 'package:moneypro_new/ui/dmt/BeneficiaryDetail.dart';
import 'package:moneypro_new/ui/dmt/BeneficiaryTransaction.dart';
import 'package:moneypro_new/ui/dmt/ConfirmAuth.dart';
import 'package:moneypro_new/ui/dmt/ConfirmPayment.dart';
import 'package:moneypro_new/ui/dmt/DLTAllTransactions.dart';
import 'package:moneypro_new/ui/dmt/DMTLanding.dart';
import 'package:moneypro_new/ui/dmt/DMTRecipt.dart';
import 'package:moneypro_new/ui/dmt/FavouriteSenders.dart';
import 'package:moneypro_new/ui/dmt/TransferMoney.dart';
import 'package:moneypro_new/ui/employee/EMICalculator.dart';
import 'package:moneypro_new/ui/employee/EmpAssignQR.dart';
import 'package:moneypro_new/ui/employee/EmpSelfBankDetails.dart';
import 'package:moneypro_new/ui/employee/EmpSelfPanVerify.dart';
import 'package:moneypro_new/ui/employee/EmployeeLanding.dart';
import 'package:moneypro_new/ui/employee/LoanCollection.dart';
import 'package:moneypro_new/ui/employee/MerchantList.dart';
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
import 'package:moneypro_new/ui/footer/BBSPRecipt.dart';
import 'package:moneypro_new/ui/footer/MATMReceipt.dart';
import 'package:moneypro_new/ui/footer/RaisedTicket.dart';
import 'package:moneypro_new/ui/footer/ShowCashback.dart';
import 'package:moneypro_new/ui/footer/TransactionHistory.dart';
import 'package:moneypro_new/ui/footer/TransactionHistoryEmpUser.dart';
import 'package:moneypro_new/ui/footer/WelcomeOfferPopup.dart';
import 'package:moneypro_new/ui/home/DummyClass.dart';
import 'package:moneypro_new/ui/home/MoreCategories.dart';
import 'package:moneypro_new/ui/home/Perspective.dart';
import 'package:moneypro_new/ui/home/ShowWebViews.dart';
import 'package:moneypro_new/ui/home/splash.dart';
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
import 'package:moneypro_new/ui/qr/QRPayment.dart';
import 'package:moneypro_new/ui/qr/RequestQR.dart';
import 'package:moneypro_new/ui/qr/ViewQRCode.dart';
import 'package:moneypro_new/ui/recharge/FastagRecharge.dart';
import 'package:moneypro_new/ui/recharge/MobileReceipt.dart';
import 'package:moneypro_new/ui/recharge/PaymentFailure.dart';
import 'package:moneypro_new/ui/recharge/PaymentSuccess.dart';
import 'package:moneypro_new/ui/recharge/RechargeFetchNo.dart';
import 'package:moneypro_new/ui/recharge/RechargeFetchYes.dart';
import 'package:moneypro_new/ui/recharge/RechargeSelection.dart';
import 'package:moneypro_new/ui/recharge/dth/DTHRecharge.dart';
import 'package:moneypro_new/ui/recharge/dth/DTHSelection.dart';
import 'package:moneypro_new/ui/recharge/dth/new_/DTHRechargeNew.dart';
import 'package:moneypro_new/ui/recharge/dth/new_/DTHSelectNew.dart';
import 'package:moneypro_new/ui/recharge/lic/LICDetails.dart';
import 'package:moneypro_new/ui/recharge/mobile/MobilePayment.dart';
import 'package:moneypro_new/ui/recharge/mobile/PrepaidMobileRecharge.dart';
import 'package:moneypro_new/ui/services/AxisBankLanding.dart';
import 'package:moneypro_new/ui/services/PancardLanding.dart';
import 'package:moneypro_new/ui/services/RewardsList.dart';
import 'package:moneypro_new/ui/services/UpStoxLanding.dart';
import 'package:moneypro_new/ui/team/AddMember.dart';
import 'package:moneypro_new/ui/team/AddTeamIntro.dart';
import 'package:moneypro_new/ui/team/TeamMemberList.dart';
import 'package:moneypro_new/ui/userboarding/UserBankDetails.dart';
import 'package:moneypro_new/ui/userboarding/UserPanVerify.dart';
import 'package:moneypro_new/ui/wallet/AddMoneyToBank.dart';
import 'package:moneypro_new/ui/wallet/AddMoneyToWallet.dart';
import 'package:moneypro_new/ui/wallet/AppWallet.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('onBackgroundMessage data: ${message.data.length}');
  var adVal = await getAudioSound();
  String? title = message.notification?.title.toString();
  String? msg = message.notification?.body.toString();
  showNotification(title, msg, adVal);
}

FirebaseAnalytics analytics = FirebaseAnalytics();
FirebaseAnalyticsObserver observer =
    FirebaseAnalyticsObserver(analytics: analytics);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  /*SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.blue, // navigation bar color
    statusBarColor: lightBlue, // status bar color
  ));*/

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(StateContainer(
    child: MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      navigatorKey: StateContainer.navigatorKey,
      theme: ThemeData(
        primaryColor: blue,
      ),
      home: Splash(analytics: analytics, observer: observer),
      routes: <String, WidgetBuilder>{
        //account
        '/BankAccount': (BuildContext context) => new BankAccount(),
        '/ComplaintManagement': (BuildContext context) =>
            new ComplaintManagement(),
        '/MyAddress': (BuildContext context) => new MyAddress(),
        '/UpdatePin': (BuildContext context) => new UpdatePin(),
        '/Profile': (BuildContext context) => new Profile(
              profilePic: '',
              profilePicId: '',
            ),

        //aeps
        '/AEPS_BalanceEnq': (BuildContext context) =>
            new AEPS_BalanceEnq(map: {}),
        '/AEPS_SBMOnboarding': (BuildContext context) => new AEPS_SBMOnboarding(
              pipe: '',
            ),
        '/AEPSDocument': (BuildContext context) => new AEPSDocument(
              pancard: '',
            ),
        '/AEPSVerifyMobile': (BuildContext context) => new AEPSVerifyMobile(),
        '/AEPSLanding': (BuildContext context) => new AEPSLanding(
              pipe: '',
            ),
        '/AEPSMiniStatement': (BuildContext context) => new AEPSMiniStatement(
              response: '',
            ),
        '/AEPSReceipt': (BuildContext context) => new AEPSReceipt(
              map: {},
              isShowDialog: false,
            ),

        //atm
        '/ATMKycProcess': (BuildContext context) => new ATMKycProcess(
              authToken: '',
              mATMId: '',
            ),
        '/ATMOnBoarding': (BuildContext context) => new ATMOnBoarding(),
        '/TransactionRecepit': (BuildContext context) => new TransactionRecepit(
              map: {},
            ),

        //auth
        '/SetPin': (BuildContext context) => new SetPin(),
        '/SetPinFinger': (BuildContext context) => new SetPinFinger(),
        '/SignIn': (BuildContext context) => new SignIn(),
        '/SignUp': (BuildContext context) => new SignUp(),
        '/VerifyMobile': (BuildContext context) => new VerifyMobile(
              action: 0,
              mobile: '',
            ),

        //card
        '/MyCardCongrats': (BuildContext context) => new MyCardCongrats(),
        '/MyCardIntro': (BuildContext context) => new MyCardIntro(),

        //contact
        '/ContactList': (BuildContext context) => new ContactList(),

        //dmt
        '/AddBeneficiary': (BuildContext context) => new AddBeneficiary(
              custId: '',
            ),
        '/AddSender': (BuildContext context) => new AddSender(
              mobile: '',
            ),
        '/BeneficiaryDetail': (BuildContext context) => new BeneficiaryDetail(
              custId: '',
              senderMobile: '',
              senderName: '',
            ),
        '/BeneficiaryTransaction': (BuildContext context) =>
            new BeneficiaryTransaction(
              custId: '',
              mobile: '',
            ),
        '/ConfirmAuth': (BuildContext context) => new ConfirmAuth(
              itemResponse: {},
            ),
        '/ConfirmPayment': (BuildContext context) => new ConfirmPayment(
              itemResponse: {},
            ),
        '/DLTAllTransactions': (BuildContext context) =>
            new DLTAllTransactions(),
        '/DMTLanding': (BuildContext context) => new DMTLanding(),
        '/DMTRecipt': (BuildContext context) => new DMTRecipt(
              map: {},
            ),
        '/FavouriteSenders': (BuildContext context) => new FavouriteSenders(),
        '/TransferMoney': (BuildContext context) => new TransferMoney(
              map: {},
            ),

        //employee//investoroboarding
        '/MerchantInvestorBank': (BuildContext context) =>
            new MerchantInvestorBank(
              map: {},
            ),
        '/MerchantInvestorDoc': (BuildContext context) =>
            new MerchantInvestorDoc(
              pan: '',
              token: '',
            ),
        '/MerchantInvestorMobile': (BuildContext context) =>
            new MerchantInvestorMobile(
              token: '',
              mobile: '',
            ),
        '/MerchantInvestorOnBoarding': (BuildContext context) =>
            new MerchantInvestorOnBoarding(
              token: '',
            ),

        //employee/merchantonboarding
        '/EmpMerchantBankDetails': (BuildContext context) =>
            new EmpMerchantBankDetails(
              itemResponse: {}, storeImage: new File(""),
              //  docImage: new File(""),
              selfiImage: new File(""),
              //adhFront: new File(""),adhBack: new File("")
            ),
        '/EmpMerchantBusinessDetails': (BuildContext context) =>
            new EmpMerchantBusinessDetails(),
        '/EmpMerchantMapDetails': (BuildContext context) =>
            new EmpMerchantMapDetails(
              itemResponse: {},
              storeImage: new File(""),
            ),
        '/EmpMerchantPANDetails': (BuildContext context) =>
            new EmpMerchantPANDetails(itemResponse: {}, storeImage: new File("")
                // ,docImage:new File("") ,adhFront: new File(""), adhBack: new File("")
                ),
        '/EmpMerchantVerifyDetails': (BuildContext context) =>
            new EmpMerchantVerifyDetails(
              itemResponse: {},
              storeImage: new File(""),
            ),
        '/EmpViewMerchantQR': (BuildContext context) => new EmpViewMerchantQR(
              mToken: '',
            ),

        //employee
        '/EMICalculator': (BuildContext context) => new EMICalculator(),
        '/EmpAssignQR': (BuildContext context) => new EmpAssignQR(
              token: '',
              mobile: '',
            ),
        '/EmployeeLanding': (BuildContext context) => new EmployeeLanding(),
        '/EmpSelfBankDetails': (BuildContext context) => new EmpSelfBankDetails(
              itemResponse: {},
            ),
        '/EmpSelfPanVerify': (BuildContext context) => new EmpSelfPanVerify(),
        '/LoanCollection': (BuildContext context) => new LoanCollection(),
        '/MerchantList': (BuildContext context) => new MerchantList(),
        '/OverPaymentDue': (BuildContext context) => new OverPaymentDue(
              loanId: '',
            ),

        //footer
        '/AllOffers': (BuildContext context) => new AllOffers(),
        '/BBSPRecipt': (BuildContext context) => new BBSPRecipt(
              map: {},
            ),
        '/MATMReceipt': (BuildContext context) => new MATMReceipt(
              map: {},
            ),
        '/RaisedTicket': (BuildContext context) => new RaisedTicket(
              amount: '',
              category: '',
              mode: '',
              opName: '',
              pgAmt: '',
              txnId: '',
              txnStatus: '',
            ),
        '/ShowCashback': (BuildContext context) => new ShowCashback(
              commission: '',
              id: '',
            ),
        '/TransactionHistory': (BuildContext context) =>
            new TransactionHistory(fromDate: '', toDate: ''),
        '/TransactionHistoryEmpUser': (BuildContext context) =>
            new TransactionHistoryEmpUser(),
        '/WelcomeOfferPopup': (BuildContext context) => new WelcomeOfferPopup(
              action: 0,
            ),

        //home
        '/DummyClass': (BuildContext context) => new DummyClass(
              response: '',
            ),
        '/MoreCategories': (BuildContext context) => new MoreCategories(
              lat: 0.0,
              lng: 0.0,
            ),
        '/splash': (BuildContext context) =>
            Splash(analytics: analytics, observer: observer),
        '/perspective': (BuildContext context) => new Perspective(
              isShowWelcome: false,
            ),
        '/ShowWebViews': (BuildContext context) => new ShowWebViews(
              url: '',
            ),

        //investment/onboarding
        '/InvestorBankDetail': (BuildContext context) => new InvestorBankDetail(
              pan: '',
            ),
        '/InvestorDocument': (BuildContext context) => new InvestorDocument(
              pan: '',
            ),
        '/InvestorMobileVerify': (BuildContext context) =>
            new InvestorMobileVerify(),
        '/InvestorOnboarding': (BuildContext context) =>
            new InvestorOnboarding(),
        '/InvestorPersonalDetail': (BuildContext context) =>
            new InvestorPersonalDetail(),

        //investment
        '/InvestorLanding': (BuildContext context) => new InvestorLanding(),
        '/InvestorPayment': (BuildContext context) => new InvestorPayment(
              amount: '',
            ),
        '/InvestorStatement': (BuildContext context) => new InvestorStatement(),
        '/InvestorWithdrawal': (BuildContext context) => new InvestorWithdrawal(
              maxAmt: 0.0,
            ),

        //merchant
        '/AddressByMap': (BuildContext context) => new AddressByMap(
              itemResponse: {},
            ),
        '/BankDetails': (BuildContext context) => new BankDetails(
              itemResponse: {},
            ),
        '/BusinessDetails': (BuildContext context) => new BusinessDetails(),
        '/BusinessVerify': (BuildContext context) => new BusinessVerify(
              itemResponse: {},
            ),
        '/MerchantDocument': (BuildContext context) => new MerchantDocument(
              itemResponse: {},
            ),
        '/MerchantGetStarted': (BuildContext context) =>
            new MerchantGetStarted(),
        '/PaymentOptions': (BuildContext context) => new PaymentOptions(),

        //qr
        '/QRDownload': (BuildContext context) => new QRDownload(),
        '/QRPayment': (BuildContext context) => new QRPayment(
              map: {},
              file: new File(""),
            ),
        '/RequestQR': (BuildContext context) => new RequestQR(),
        '/ViewQRCode': (BuildContext context) => new ViewQRCode(action: 0),

        //recharge/dth
        '/DTHRecharge': (BuildContext context) => new DTHRechargeNew(
              map: {},
            ),
        '/DTHSelection': (BuildContext context) => new DTHSelectNew(
              category: '',
              searchBy: '',
              selectBy: '',
            ),

        //recharge/lic
        '/LICDetails': (BuildContext context) => new LICDetails(),

        //recharge/mobile
        '/MobilePayment': (BuildContext context) => new MobilePayment(
              map: {},
            ),
        '/PrepaidMobileRecharge': (BuildContext context) =>
            new PrepaidMobileRecharge(
              mobileNo: '',
            ),

        //recharge
        '/FastagRecharge': (BuildContext context) => new FastagRecharge(
              map: {},
            ),
        '/MobileReceipt': (BuildContext context) => new MobileReceipt(
              map: {},
              isShowDialog: false,
            ),
        '/PaymentFailure': (BuildContext context) => new PaymentFailure(
              map: {},
            ),
        '/PaymentSuccess': (BuildContext context) => new PaymentSuccess(
              map: {},
              isShowDialog: false,
            ),
        '/RechargeFetchNo': (BuildContext context) =>
            new RechargeFetchNo(map: {}),
        '/RechargeFetchYes': (BuildContext context) =>
            new RechargeFetchYes(map: {}),
        '/RechargeSelection': (BuildContext context) => new RechargeSelection(
              selectBy: '',
              searchBy: '',
              category: '',
            ),

        //services
        '/AxisBankLanding': (BuildContext context) => new AxisBankLanding(),
        '/PancardLanding': (BuildContext context) => new PancardLanding(),
        '/UpStoxLanding': (BuildContext context) => new UpStoxLanding(),
        '/RewardsList': (BuildContext context) => new RewardsList(),

        //team
        '/TeamMemberList': (BuildContext context) => new TeamMemberList(),
        '/AddMember': (BuildContext context) => new AddMember(),
        '/AddTeamIntro': (BuildContext context) => new AddTeamIntro(),

        //useronboarding
        '/UserBankDetails': (BuildContext context) => new UserBankDetails(
              itemResponse: {},
            ),
        '/UserPanVerify': (BuildContext context) => new UserPanVerify(),

        //wallete
        '/AddMoneyToBank': (BuildContext context) => new AddMoneyToBank(),
        '/AddMoneyToWallet': (BuildContext context) => new AddMoneyToWallet(),
        '/AppWallet': (BuildContext context) => new AppWallet(),
      },
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    ),
  ));
}
