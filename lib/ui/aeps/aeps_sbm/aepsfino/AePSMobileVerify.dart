import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/Functions.dart';

import '../../../../utils/CustomWidgets.dart';

class AePSMobileVerify extends StatefulWidget {
  final String txnType;
  final String lat;
  final String lng;
  const AePSMobileVerify({Key? key, required this.txnType,
    required this.lat, required this.lng}) : super(key: key);

  @override
  State<AePSMobileVerify> createState() => _AePSMobileVerifyState();
}

class _AePSMobileVerifyState extends State<AePSMobileVerify> {


  var screen = "AePS mobile";
  final mobileController = new TextEditingController();
  final nameController = new TextEditingController();
  final pincodeController = new TextEditingController();

  var enableBtn =false;

  var isValidUser = true;


  @override
  void dispose() {
    mobileController.dispose();
    nameController.dispose();
    pincodeController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => SafeArea(
                child: Scaffold(
              backgroundColor: white,
              appBar: AppBar(
                elevation: 10,
                centerTitle: false,
                backgroundColor: white,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: black,
                  ),
                  onPressed: () {
                    closeKeyBoard(context);
                    closeCurrentPage(context);
                  },
                ),
                titleSpacing: 0,
                title: Container(
                  child: Center(
                    child: Image.asset(
                      'assets/app_splash_logo.png',
                      width: 120,
                    ),
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                      child: Text(
                        "AePS Customer Mobile Number",
                        style: TextStyle(
                            color: black,
                            fontSize: font18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                      child: Image.asset('assets/aeps_land.png', height: 160.h,),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 25, left: padding, right: padding),
                      decoration: BoxDecoration(
                        color: editBg,
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                          border: Border.all(color: walletBg)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(width: 10.w,),
                            Icon(Icons.phone_android_rounded),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                style: TextStyle(color: black, fontSize: inputFont),
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                                controller: mobileController,
                                decoration: new InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 10),
                                  counterText: "",
                                  label: Text("Mobile Number"),
                                ),
                                maxLength: 10,
                                onChanged: (val){
                                  if(val.length==10){
                                    setState(() {
                                      enableBtn= true;
                                    });
                                  }else{
                                    setState(() {
                                      enableBtn=false;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    (isValidUser)?Container(): Container(
                      margin: EdgeInsets.only(
                          top: 25, left: padding, right: padding),
                      decoration: BoxDecoration(
                          color: editBg,
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          border: Border.all(color: walletBg)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(width: 10.w,),
                            Icon(Icons.account_circle_outlined),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                style: TextStyle(color: black, fontSize: inputFont),
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.done,
                                controller: nameController,
                                decoration: new InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 10),
                                  counterText: "",
                                  label: Text("Name"),
                                ),
                                maxLength: 100,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    (isValidUser)?Container():Container(
                      margin: EdgeInsets.only(
                          top: 25, left: padding, right: padding),
                      decoration: BoxDecoration(
                          color: editBg,
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          border: Border.all(color: walletBg)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(width: 10.w,),
                            Icon(Icons.crop_portrait_sharp),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                style: TextStyle(color: black, fontSize: inputFont),
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                                controller: mobileController,
                                decoration: new InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 10),
                                  counterText: "",
                                  label: Text("Pincode"),
                                ),
                                maxLength: 6,

                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        var mobileNumber = mobileController.text.toString();

                        if (mobileNumber.length == 0) {
                          showToastMessage("Please enter Mobile Number");
                          return;
                        } else if (mobileNumber.length != 10) {
                          showToastMessage("Mobile number must 10 digits");
                          return;
                        } else if (!mobilePattern.hasMatch(mobileNumber)) {
                          showToastMessage("Please enter valid Mobile Number");
                          return;
                        }

                        if(!isValidUser){
                          var name = nameController.text.toString();
                          var pincode = nameController.text.toString();
                          if (name.length == 0) {
                            showToastMessage("Please enter name");
                            return;
                          } else if (pincode.length != 10) {
                            showToastMessage("Enter 6 digit pin code");
                            return;
                          }
                        }

                        //openAePSFinoTransaction(context, mobileNumber, widget.txnType, widget.lat, widget.lng);
                      },
                      child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 30),
                        decoration: BoxDecoration(
                          color:  (enableBtn)?green:gray,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Center(
                          child: Text(
                            "NEXT".toUpperCase(),
                            style: TextStyle(fontSize: font13, color: white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
