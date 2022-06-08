import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/Countdown.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


class AddSender extends StatefulWidget {
  final String mobile;

  const AddSender({Key? key, required this.mobile}) : super(key: key);

  @override
  _AddSenderState createState() => _AddSenderState();
}

class _AddSenderState extends State<AddSender> with TickerProviderStateMixin {
  var screen = "Add Sender";

  final nameController = new TextEditingController();
  final otpController = new TextEditingController();
  final addressController = new TextEditingController();
  TextEditingController mobileNoController = new TextEditingController();

  late AnimationController _controller;
  int levelClock = 20;

  var checkedValue = false;



  late File _image;

  var loading = false;

  var isImageAttached = false;

  double moneyProBalc = 0.0;

  @override
  void initState() {
    super.initState();
    printMessage(screen, "Mobile Number : ${widget.mobile}");
    updateATMStatus(context);
    fetchUserAccountBalance();
    setState(() {
      startTimer();
    });
    sendOTPTask();

    updateWalletBalances();

    setState(() {
      mobileNoController = TextEditingController(text: "${widget.mobile}");
    });
  }

  updateWalletBalances() async {
    var mpBalc = await getWalletBalance();
    var qrBalc = await getQRBalance();
    var walBalc = await getWelcomeAmt();
    double mX =0.0;
    double wX=0.0;




    final inheritedWidget = StateContainer.of(context);

    if (mpBalc == null || mpBalc == 0) {
      mpBalc = 0;
      inheritedWidget.updateMPBalc(value: mpBalc);
    } else {
      inheritedWidget.updateMPBalc(value: mpBalc);
    }

    if (qrBalc == null || qrBalc == 0) {
      qrBalc = 0;
      inheritedWidget.updateQRBalc(value: qrBalc);
    } else {
      inheritedWidget.updateQRBalc(value: qrBalc);
    }

    if (walBalc == null || walBalc == 0) {
      walBalc = 0;
      inheritedWidget.updateWelBalc(value: walBalc);
    } else {
      inheritedWidget.updateWelBalc(value: walBalc);
    }


    if (walBalc != null || walBalc != 0) {
      wX = double.parse(walBalc);
    }

    if (mpBalc != null || mpBalc != 0) {
      mX = double.parse(mpBalc);
    }
    setState(() {
      moneyProBalc = wX + mX;
    });

  }

  @override
  void dispose() {
    nameController.dispose();
    otpController.dispose();
    addressController.dispose();
    _controller.dispose();
    super.dispose();
  }

  startTimer() {
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: levelClock));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final InheritedWidget = StateContainer.of(context);
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
            child: Scaffold(
                backgroundColor: white,
                appBar: AppBar(
                  elevation: 0,
                  centerTitle: false,
                  backgroundColor: white,
                  brightness: Brightness.light,
                  leading: InkWell(
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
                  titleSpacing: 0,
                  title: appLogo(),
                  actions: [
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: walletBg,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: walletBg)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 5, bottom: 5),
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
                                  //"${formatDecimal2Digit.format(moneyProBalc)}",
                                  "$moneyProBalc",
                                  style:
                                      TextStyle(color: white, fontSize: font15.sp),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    )
                  ],
                ),
                body:  (loading)
                    ? Center(
                  child: circularProgressLoading(40.0),
                )
                    : SingleChildScrollView(
                  child: Column(
                      children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 30, left: padding, right: padding),
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
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          controller: mobileNoController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: new InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 10),
                            counterText: "",
                            label: Text("Mobile Number"),
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
                          controller: nameController,
                          textCapitalization: TextCapitalization.characters,
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
                          keyboardType: TextInputType.streetAddress,
                          textInputAction: TextInputAction.next,
                          controller: addressController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: new InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 10),
                            counterText: "",
                            label: Text("Address"),
                          ),
                          maxLength: 100,
                        ),
                      ),
                    ),
                    Container(
                      height: 50.h,
                      margin: EdgeInsets.only(top: padding, left: padding, right: padding),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: editBg,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          border: Border.all(color: editBg, width: 2)),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                "Select PAN card photo to upload",
                                style: TextStyle(color: black, fontSize: font15.sp),
                              ),
                            ),
                          ),
                          Container(
                            height: 50.h,
                            width: 50.w,
                            child: InkWell(
                              onTap: () {
                                _showCameraGalleryOption();
                              },
                              child: Center(
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  color: lightBlue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    (isImageAttached)
                        ? Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 2),
                      child: Text(
                        "File attached",
                        style: TextStyle(
                          color: black,
                          fontSize: font13.sp,
                        ),
                      ),
                    )
                        : Container(),
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
                          controller: otpController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: new InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 10),
                            counterText: "",
                            label: Text("OTP"),
                          ),
                          maxLength: 6,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0, left: 20, top: 10),
                      child: Countdown(
                        animation: StepTween(
                          begin: levelClock, // THIS IS A USER ENTERED NUMBER
                          end: 0,
                        ).animate(_controller),
                      ),
                    )
                  ]),
                ),
            bottomNavigationBar: _buildBottomSection(),)));
  }

  _buildBottomSection() {
    return Wrap(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
                value: checkedValue,
                onChanged: (val) {
                  setState(() {
                    closeKeyBoard(context);
                    checkedValue = val!;
                  });
                }),
            Text(
              iAccept,
              style: TextStyle(fontSize: font15.sp, color: black),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            setState(() {
              saveDetails();
            });
          },
          child: Container(
            height: 50.h,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 15),
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Center(
              child: Text(
                submit.toUpperCase(),
                style: TextStyle(fontSize: font15.sp, color: white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future saveDetails() async {
    var name = nameController.text.toString();
    var address = addressController.text.toString();
    var otp = otpController.text.toString();

    if (name.length == 0) {
      showToastMessage("Enter name");
      return;
    } else if (address.length == 0) {
      showToastMessage("Enter address");
      return;
    }
    /* else if (!isImageAttached) {
      showToastMessage("Upload PAN card images");
      return;
    }*/
    else if (otp.length == 0) {
      showToastMessage("Enter otp");
      return;
    } else if (!checkedValue) {
      showToastMessage("Agree terms & condition");
      return;
    }

    if (isImageAttached) {
      _upload(_image);
    } else {
      uploadData();
    }
  }

  Future sendOTPTask() async {
    setState(() {
      loading = true;
    });

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {
      "mobile": widget.mobile,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(dmtMobileOTP),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "data : $data");

      setState(() {
        loading = false;
        var status = data['status'];
        if (status.toString() == "1") {
        }
        showToastMessage(data['message']);
      });
    }else{
      setState(() {
        loading = false;
      });
      showToastMessage(status500);
    }


  }

  _showCameraGalleryOption() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Wrap(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(50.0)),
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 10,
                        blurRadius: 10,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Center(
                        child: Container(
                          color: gray,
                          width: 50.w,
                          height: 5.h,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                          20,
                        ),
                        child: Text(
                          "Get image from",
                          style: TextStyle(color: black, fontSize: font16.sp),
                        ),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              getImage(ImageSource.gallery);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images.png',
                                    width: 40.w,
                                    height: 40.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Gallery",
                                      style: TextStyle(
                                          color: black, fontSize: font15.sp),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              getImage(ImageSource.camera);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/photo.png',
                                    width: 40.w,
                                    height: 40.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Camera",
                                      style: TextStyle(
                                          color: black, fontSize: font15.sp),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                    ],
                  ),
                )
              ],
            ));
  }

  Future getImage(ImageSource source) async {
    /*ImagePicker picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);*/

    ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile = await imagePicker.getImage(
      source: source,
      imageQuality: imageQuality,
    );

    var path = pickedFile!.path.toString();
    printMessage(screen, 'Path : ${path}');

    if (pickedFile != null) {
      setState(() {
        if (path != null) {
          isImageAttached = true;
        } else {
          isImageAttached = false;
        }
        File _image = File(pickedFile.path);
        cropImageFunction(_image);
      });
    }
  }

  cropImageFunction(File file) async{
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: '$cropImage',
            toolbarColor: lightBlue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );

    setState(() {
      _image=croppedFile!;
    });
  }

  void _upload(File file) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var m_id = await getMerchantID();
    var name = nameController.text.toString();
    var address = addressController.text.toString();
    var otp = otpController.text.toString();

    String fileName = file.path.split('/').last;
    FormData data = FormData.fromMap({
      "pan": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      "m_id": m_id,
      "name": name,
      "mobile": widget.mobile,
      "address": address,
      "otp": otp,
    });

    printMessage(screen, "Sending Data : $data");

    Dio dio = new Dio();
    dio
        .post(dmtAddCustomerAPI,
            data: data,
            options: Options(
              headers: {"Authorization": "$authHeader"},
            ))
        .then((response) {
      var msg = jsonDecode(response.toString());

      printMessage(screen, "Status Code : ${msg['message']}");
      Navigator.pop(context);
      if (response.statusCode == 200) {
        var msg = jsonDecode(response.toString());

        printMessage(screen, "Message : $msg");

        var status = msg['status'].toString();
        setState(() {});
        if (msg['status'].toString() == "1") {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return ThankYouDialog(
                  text: msg['message'].toString(),
                );
              });
        } else {
          showToastMessage(msg['message'].toString());
        }
      } else {
        printMessage(screen, "Error : ${response}");
        showToastMessage(status500);
      }
      setState(() {

      });
    }).catchError((error) => print(error));
  }

  Future uploadData() async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var m_id = await getMerchantID();
    var name = nameController.text.toString();
    var address = addressController.text.toString();
    var otp = otpController.text.toString();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "pan": '',
      "m_id": m_id,
      "name": name,
      "mobile": widget.mobile,
      "address": address,
      "otp": otp,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(dmtAddCustomerAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response All Senders : $data");
      Navigator.pop(context);
      setState(() {
        if (data['status'].toString() == "1") {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return ThankYouDialog(
                  text: data['message'].toString(),
                );
              });
        } else {
          showToastMessage(data['message'].toString());
        }

      });
    }else{
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }


  }
}
