import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';

class TransferMoney extends StatefulWidget {
  final Map map;

  const TransferMoney({Key? key, required this.map}) : super(key: key);

  @override
  _TransferMoneyState createState() => _TransferMoneyState();
}

class _TransferMoneyState extends State<TransferMoney> {
  var screen = "Transfer Money";

  final amountController = new TextEditingController();
  TextEditingController accNoController = new TextEditingController();
  TextEditingController ifscCodeController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  final remarksController = new TextEditingController();

  var isIMPS = true;
  var isNEFT = false;

  var loading = false;
  var mode;

  var beneName = "";
  var senderName = "";

  var accountNoText;
  var ifscCodeText;
  var mobile;
  var isMobileEdit = false;

  Map result = {};


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserAccountBalance();
    updateATMStatus(context);

    setState(() {
      isIMPS = true;
      isNEFT = false;
      result = widget.map;

      if (result['holderName'].toString().contains(" ")) {
        var parts = result['holderName'].toString().split(' ');
        var fChar = parts[0][0];
        var lChar = parts[1][0];
        beneName = "$fChar$lChar";
        printMessage(screen, "Contain Space : $beneName");
      } else {
        beneName = result['holderName'].toString()[0];
        printMessage(screen, "Not Contain Space : $beneName");
      }

      if (result['senderName'].toString().contains(" ")) {
        var parts = result['senderName'].toString().split(' ');
        var fChar = parts[0][0];
        var lChar = parts[1][0];
        senderName = "$fChar$lChar";
        printMessage(screen, "Contain Space : $senderName");
      } else {
        senderName = result['senderName'].toString()[0];
        printMessage(screen, "Not Contain Space : $senderName");
      }

      accountNoText = result['accountNumber'].toString();
      ifscCodeText = result['ifsc'].toString();
      mobile = result['mobile'].toString();

      if (mobile.toString() == "null") {
        mobileController = TextEditingController(text: "");
        isMobileEdit = true;
      } else {
        mobileController =
            TextEditingController(text: "${result['mobile'].toString()}");
        isMobileEdit = false;
      }

      accNoController = TextEditingController(text: "$accountNoText");
      ifscCodeController = TextEditingController(text: "$ifscCodeText");
      printMessage(screen, "Mobile Edit : $isMobileEdit");
    });

    updateWalletBalances();
  }

  updateWalletBalances() async {
    var mpBalc = await getWalletBalance();
    var qrBalc = await getQRBalance();

    final inheritedWidget = StateContainer.of(context);

    inheritedWidget.updateMPBalc(value: mpBalc);
    if (mpBalc == null || mpBalc == 0) {
      mpBalc = 0;
      final inheritedWidget = StateContainer.of(context);
      inheritedWidget.updateMPBalc(value: mpBalc);
    }

    inheritedWidget.updateQRBalc(value: qrBalc);
    if (qrBalc == null || qrBalc == 0) {
      qrBalc = 0;
      final inheritedWidget = StateContainer.of(context);
      inheritedWidget.updateQRBalc(value: qrBalc);
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    mobileController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final InheritedWidget = StateContainer.of(context);
    var moneyProBalc = InheritedWidget.mpBalc;
    var mproBalc = InheritedWidget.qrBalc;
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Image.asset('assets/dmt_bg.png'),
          Container(
            height: 55.h,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    closeKeyBoard(context);
                    closeCurrentPage(context);
                  },
                  child: Container(
                    height: 60.h,
                    width: 60.w,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/back_arrow_bg.png',
                          height: 60.h,
                        ),
                        Positioned(
                          top: 16,
                          left: 12,
                          child: Image.asset(
                            'assets/back_arrow.png',
                            height: 16.h,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                appLogo(),
                Spacer(),
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: walletBg,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: walletBg)),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, top: 5, bottom: 5),
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: [
                        Image.asset(
                          "assets/wallet.png",
                          height: 20.h,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, top: 5),
                            child: Text(
                              moneyProBalc,
                              style: TextStyle(color: white, fontSize: font15.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 180),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 90.h,
                    width: MediaQuery.of(context).size.width * .8,
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        border: Border.all(color: gray)),
                    child: _buildProfileSection(),
                  ),
                  _buildTabSection(),
                  _buildFormSection(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomSection(),
    )));
  }

  _buildProfileSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            height: 50.h,
            width: 50.w,
            decoration: BoxDecoration(
                color: lightBlue,
                shape: BoxShape.circle,
                border: Border.all(color: lightBlue, width: 3)),
            child: Center(
              child: Text(
                "$senderName".toUpperCase(),
                style: TextStyle(
                    color: white, fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Image.asset(
          'assets/shaped_arrow.png',
          height: 20.h,
        ),
        SizedBox(
          width: 5,
        ),
        Center(
          child: Container(
            height: 50.h,
            width: 50.w,
            decoration: BoxDecoration(
                color: lightBlue,
                shape: BoxShape.circle,
                border: Border.all(color: lightBlue, width: 3)),
            child: Center(
              child: Text(
                "$beneName".toUpperCase(),
                style: TextStyle(
                    color: white, fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
      ],
    );
  }

  _buildTabSection() {
    return Container(
      width: MediaQuery.of(context).size.width * .8,
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.all(Radius.circular(60)),
          border: Border.all(color: lightBlue)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                setState(() {
                  isIMPS = true;
                  isNEFT = false;
                });
              },
              child: Container(
                height: 40.h,
                decoration: BoxDecoration(
                  color: (isIMPS) ? lightBlue : white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Center(
                  child: Text(
                    imps,
                    style: TextStyle(
                        color: (isIMPS) ? white : lightBlue, fontSize: font15.sp),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                setState(() {
                  isIMPS = false;
                  isNEFT = true;
                });
              },
              child: Container(
                height: 40.h,
                decoration: BoxDecoration(
                  color: (isNEFT) ? lightBlue : white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Center(
                  child: Text(
                    neft,
                    style: TextStyle(
                        color: (isNEFT) ? white : lightBlue, fontSize: font15.sp),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildFormSection() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: padding, left: padding, right: padding),
          decoration: BoxDecoration(
            color: editBg,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15, top: 10, bottom: 10),
            child: TextFormField(
              enabled: false,
              style: TextStyle(color: black, fontSize: inputFont.sp),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              controller: accNoController,
              textCapitalization: TextCapitalization.characters,
              decoration: new InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10),
                counterText: "",
                label: Text("Account Number"),
              ),
              maxLength: 20,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: padding, left: padding, right: padding),
          decoration: BoxDecoration(
            color: editBg,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15, top: 10, bottom: 10),
            child: TextFormField(
              enabled: false,
              style: TextStyle(color: black, fontSize: inputFont.sp),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              controller: ifscCodeController,
              textCapitalization: TextCapitalization.characters,
              decoration: new InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10),
                counterText: "",
                label: Text("IFSC Code"),
              ),
              maxLength: 11,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: padding, left: padding, right: padding),
          decoration: BoxDecoration(
            color: editBg,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15, top: 10, bottom: 10),
            child: TextFormField(
              style: TextStyle(color: black, fontSize: inputFont.sp),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              controller: amountController,
              textCapitalization: TextCapitalization.characters,
              decoration: new InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10),
                counterText: "",
                label: Text("Amount"),
              ),
              maxLength: 6,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: padding, left: padding, right: padding),
          decoration: BoxDecoration(
            color: editBg,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15, top: 10, bottom: 10),
            child: TextFormField(
              style: TextStyle(color: black, fontSize: inputFont.sp),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              controller: mobileController,
              textCapitalization: TextCapitalization.characters,
              decoration: new InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10),
                counterText: "",
                label: Text("Mobile No."),
              ),
              maxLength: 10,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: padding, left: padding, right: padding),
          decoration: BoxDecoration(
            color: editBg,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15, top: 10, bottom: 10),
            child: TextFormField(
              style: TextStyle(color: black, fontSize: inputFont.sp),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              controller: remarksController,
              textCapitalization: TextCapitalization.characters,
              decoration: new InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10),
                counterText: "",
                label: Text("Remarks (Optional)"),
              ),
              maxLength: 80,
            ),
          ),
        ),
      ],
    );
  }

  _buildBottomSection() {
    return Container(
      height: 45.h,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 10),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
             transferMoneyTask();
          });
        },
        child: Center(
          child: Text(
            transferMoney,
            style: TextStyle(fontSize: font15.sp, color: white),
          ),
        ),
      ),
    );
  }

  Future transferMoneyTask() async {

    int a;
    var amount = amountController.text.toString();
    var mobile = mobileController.text.toString();

    if(amount.length == 0){
      a = 0;
    }else{
      a = int.parse(amount);
    }

    if (amount.length == 0) {
      showToastMessage("Enter amount");
      return;
    } else if (a < 99) {
      showToastMessage("Minimum amount for transerfer is $rupeeSymbol 100/-");
      return;
    } else if (mobile.length == 0) {
      showToastMessage("Please enter Mobile Number");
      return;
    } else if (mobile.length != 10) {
      showToastMessage("Mobile number must 10 digits");
      return;
    } else if (!mobilePattern.hasMatch(mobile)) {
      showToastMessage("Please enter valid Mobile Number");
      return;
    }

    if (isIMPS && !isNEFT) {
      mode = "IMPS";
    }

    if (!isIMPS && isNEFT) {
      mode = "NEFT";
    }

    setState(() {
      Map customerDetail = {};
      customerDetail['beneficiaryId'] = result['beneficiary_id'].toString();
      customerDetail['holderName'] = result['holderName'].toString();
      customerDetail['accountNo'] = accountNoText;
      customerDetail['ifsc'] = ifscCodeText;
      customerDetail['amount'] = amount;
      customerDetail['mobile'] = mobile;
      customerDetail['mode'] = mode;
      customerDetail['sendName'] = result['senderName'].toString();
      customerDetail['sendMobile'] = result['senderMobile'].toString();
      customerDetail['senderCustId'] = result['custId'].toString();

      printMessage(screen, "Details : $customerDetail}");

      openConfirmAuth(context, customerDetail);
    });
  }
}
