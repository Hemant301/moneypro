import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/SharedPrefs.dart';


class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final phoneController = new TextEditingController();

  var screen = "Sign In";

  var isValid = false;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
            backgroundColor: white,
            appBar: AppBar(
              elevation: 0,
              centerTitle: false,
              backgroundColor: white,
              leading: IconButton(
                icon: backArrow(),
                onPressed: () {
                  closeCurrentPage(context);
                },
              ),
            ),
            body: SingleChildScrollView(
                child: Column(children: [
                  SizedBox(
                    height: 15.h,
                  ),
                  Center(
                      child: Image.asset(
                        'assets/login_bg.png',
                        height: 250.h,
                      )),
                  SizedBox(
                    height: 40.h,
                  ),
                  Text(
                    login,
                    style: TextStyle(
                        color: black,
                        fontSize: font15.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, right: 40, top: 0),
                    child: Text(
                      loginMsg,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: lightBlack,
                          fontSize: font15.sp,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(
                    height: 80.h,
                  ),
                  Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: EdgeInsets.only(top: 20, left: 15, right: 15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin:
                              EdgeInsets.only(top: padding, left: padding, right: padding),
                              decoration: BoxDecoration(
                                color: editBg,
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15, top: 15, bottom: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(mobileCode,
                                        style: TextStyle(color: black, fontSize: font16.sp),),
                                    Expanded(
                                      flex:1,
                                      child: TextFormField(
                                        style: TextStyle(color: black, fontSize: inputFont.sp),
                                        keyboardType: TextInputType.phone,
                                        textInputAction: TextInputAction.next,
                                        controller: phoneController,
                                        decoration: new InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.only(left: 10, bottom: 0),
                                          counterText: "",
                                          floatingLabelBehavior: FloatingLabelBehavior.never,
                                        ),
                                        maxLength: 10,
                                        onChanged: (val){
                                          if(val.length==10){
                                            if (!mobilePattern.hasMatch(val.toString())) {
                                              showToastMessage("Please enter valid Mobile Number");
                                              setState(() {
                                                isValid=false;
                                              });
                                            }else{
                                              setState(() {
                                                isValid = true;
                                              });
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                    (isValid)?Image.asset('assets/green_tick.png', height: 20.h,):Container()
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 45.h,
                              margin: EdgeInsets.only(
                                  left: 40, right: 40, top: 20, bottom: 20),
                              decoration: BoxDecoration(
                                  color: lightBlue,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                                  border: Border.all(color: lightBlue)),
                              child: InkWell(
                                onTap: () {
                                  var phone = phoneController.text.toString();

                                  if (phone.toString().length == 0) {
                                    showToastMessage("Please enter Mobile Number");
                                    return;
                                  } else if (phone.toString().length != 10) {
                                    showToastMessage("Mobile number must 10 digits");
                                    return;
                                  } else if (!mobilePattern.hasMatch(phone.toString())) {
                                    showToastMessage("Please enter valid Mobile Number");
                                    return;
                                  }
                                  closeCurrentPage(context);
                                  openVerifyMobile(context,phone,1);
                                },
                                child: Center(
                                  child: Text(
                                    "$continue_",
                                    style: TextStyle(
                                      color: white,
                                      fontSize: font14.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ])),
                  SizedBox(
                    height: 40.h,
                  ),
                  InkWell(
                    onTap: () {
                      openSignUpScreen(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dntHavAcc,
                          style: TextStyle(fontSize: font15.sp, color: black),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          signUp,
                          style: TextStyle(
                              fontSize: font15.sp,
                              color: lightBlue,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ])))));
  }


}
