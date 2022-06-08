import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final firstNameController = new TextEditingController();
  final lastNameController = new TextEditingController();
  final emailController = new TextEditingController();
  final phoneController = new TextEditingController();
  //int action = -1;
  var checkedValue = false;

  var screen ="Sign Up";
  //var userValue;
  var userValue = "1";
  var deviceId;

  int fnameLength =0;
  int lnameLength =0;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((token) {
      deviceId = token;
      printMessage(screen, "Device Id : $deviceId");
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
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
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            Center(
              child: Image.asset(
                'assets/appM_logo.png',
                height: 60.h,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              createAccount,
              style: TextStyle(
                  color: black, fontSize: font15.sp, fontWeight: FontWeight.bold),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: 50, left: padding, right: padding),
              decoration: BoxDecoration(
                color: editBg,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15, top: 10, bottom: 10),
                child: TextFormField(
                  style: TextStyle(color: black, fontSize: inputFont.sp),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  controller: firstNameController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: new InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10),
                    counterText: "",
                    label: Text("$firstName"),
                  ),
                  maxLength: 25,
                  onChanged: (val){
                    setState(() {
                      //fnameLength = firstNameController.text.length;
                    });
                  },
                ),
              ),
            ),
           /* Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 25, top: 2),
              child: Row(
                children: [
                  Spacer(),
                  Text("$fnameLength/16", style: TextStyle(
                    color: lightBlue, fontSize: font14
                  ),)
                ],
              ),
            ),*/
            Container(
              margin:
                  EdgeInsets.only(top: 15, left: padding, right: padding),
              decoration: BoxDecoration(
                color: editBg,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15, top: 10, bottom: 10),
                child: TextFormField(
                  style: TextStyle(color: black, fontSize: inputFont.sp),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  controller: lastNameController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: new InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10),
                    counterText: "",
                    label: Text("$lastName"),
                  ),
                  maxLength: 25,
                  onChanged: (val){
                    setState(() {
                     // lnameLength = lastNameController.text.length;
                    });
                  },
                ),
              ),
            ),
            /*Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 25, top: 2),
              child: Row(
                children: [
                  Spacer(),
                  Text("$lnameLength/4", style: TextStyle(
                      color: lightBlue, fontSize: font14
                  ),)
                ],
              ),
            ),*/
            Container(
              margin:
                  EdgeInsets.only(top: 15, left: padding, right: padding),
              decoration: BoxDecoration(
                color: editBg,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15, top: 10, bottom: 10),
                child: TextFormField(
                  style: TextStyle(color: black, fontSize: inputFont.sp),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  controller: emailController,
                  decoration: new InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10),
                    counterText: "",
                    label: Text("$email"),
                  ),
                  maxLength: 120,
                ),
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: 15, left: padding, right: padding),
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
                  controller: phoneController,
                  decoration: new InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10),
                    counterText: "",
                    label: Text("$phoneNumber"),
                  ),
                  maxLength: 10,
                ),
              ),
            ),
            SizedBox(height: 60.h,),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Row(
                children: [
                  Checkbox(
                      value: checkedValue,
                      onChanged: (val) {
                        setState(() {
                          closeKeyBoard(context);
                          checkedValue = val!;
                        });
                      }),
                  Image.asset('assets/whatsapp.png', height: 20.h,),
                  SizedBox(width: 10.w,),
                  Expanded(
                    flex:1,
                    child: Text("I accept all the Terms & Conditions. I also accepts Moneypro to send all communications to my Whatsapp number.", style: TextStyle(
                      color: black, fontSize: font13.sp
                    ),),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40.h,
              margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
              decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  border: Border.all(color: lightBlue)),
              child: InkWell(
                onTap: (){
                  registerUser();
                },
                child: Center(
                  child: Text("$signUp", style: TextStyle(
                    color: white, fontSize: font14.sp,
                  ),),
                ),
              ),
            ),
            SizedBox(height: 15.h,),
            InkWell(
              onTap: () {
                openSignIn(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    alreadyMember,
                    style: TextStyle(fontSize: font15.sp, color: black),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    signIn,
                    style: TextStyle(
                      fontSize: font15.sp,
                      color: lightBlue,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h,),
          ],
        ),
      ),
    )));
  }

  Future registerUser() async {

    var firstName = firstNameController.text.toString();
    var lastName = lastNameController.text.toString();
    var emailAddress = emailController.text.toString();
    var mobileNumber = phoneController.text.toString();

    if (firstName.length == 0) {
      showToastMessage("Please enter First Name");
      return;
    } else if (firstName.length < 2) {
      showToastMessage("First Name require at-least 2 characters");
      return;
    } else if (regExpName.hasMatch(firstName)) {
      showToastMessage(
          "Special characters or numbers are not allowed in first name");
      return;
    } else if (lastName.length == 0) {
      showToastMessage("Please enter Last Name");
      return;
    } else if (lastName.length < 2) {
      showToastMessage("Last Name require at-least 2 characters");
      return;
    } else if (regExpName.hasMatch(lastName)) {
      showToastMessage(
          "Special characters or numbers are not allowed in last name");
      return;
    } else if (emailAddress.length == 0) {
      showToastMessage("Please enter your Email");
      return;
    } else if (!emailPattern.hasMatch(emailAddress)) {
      showToastMessage("Invalid email");
      return;
    } else if (mobileNumber.length == 0) {
      showToastMessage("Please enter Mobile Number");
      return;
    } else if (mobileNumber.length != 10) {
      showToastMessage("Mobile number must 10 digits");
      return;
    } else if (!mobilePattern.hasMatch(mobileNumber)) {
      showToastMessage("Please enter valid Mobile Number");
      return;
    } /*else if (action == -1) {
      showToastMessage("Please select user role");
      return;
    }*/ else if (!checkedValue) {
      showToastMessage("Accept terms & conditions");
      return;
    }

    /*if (action == 1) {
      userValue = "3";
    } else if (action == 2) {
      userValue = "1";
    }*/


    if(firstName.length + lastName.length>20){

      if(firstName.length>20){
        setState(() {
          firstName = firstName
              .toString()
              .substring(0,  20);
          lastName = "NA";
        });
      }else{
        if(lastName.length>20){
          int x = firstName.length;
          int r = 20 - x;
          setState(() {
            lastName = lastName
                .toString()
                .substring(0, r);
          });
        }else{
          int x = firstName.length;
          int r = 20 - x;

          setState(() {
            lastName = lastName
                .toString()
                .substring(0,  r);
          });
        }
      }
    }

    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {
      "fname": firstName,
      "lname": lastName,
      "email": emailAddress,
      "mobile": mobileNumber,
      "role": userValue,
      "device_id":"$deviceId",
      "wp_msg":"Yes"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(registrationAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Register Response : $data");

      setState(() {
        Navigator.pop(context);
        var status = data['status'];
        if (status.toString() == "1") {
          closeCurrentPage(context);
          openVerifyMobile(context, mobileNumber, 0);
        }else{
          closeCurrentPage(context);
          openSignIn(context);
        }
        showToastMessage(data['message']);
      });
    }else{
      Navigator.pop(context);
      showToastMessage(status500);
    }


  }
}
