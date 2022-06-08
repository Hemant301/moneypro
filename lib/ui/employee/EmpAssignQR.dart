import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/AppKeys.dart';


class EmpAssignQR extends StatefulWidget {
  final String token;
  final String mobile;

  const EmpAssignQR({Key? key, required this.token, required this.mobile})
      : super(key: key);

  @override
  _EmpAssignQRState createState() => _EmpAssignQRState();
}

class _EmpAssignQRState extends State<EmpAssignQR> {
  final qrController = new TextEditingController();

  var screen = "Assign QR";

  var isSelfUploaded = false;

  var _switchValue = false;

  var isShow = false;

  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    fetchUserAccountBalance();
    printMessage(screen, "M Token : ${widget.token}");
  }

  @override
  void dispose() {
    qrController.dispose();
    super.dispose();
  }

  getQRStatus() async {
    var status = await getQRInvestor();

    printMessage(screen, "Value of Status : $status");

    setState(() {
      if (status.toString().toLowerCase() == "yes") {
        _switchValue = true;
      } else {
        _switchValue = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: white,
      appBar: appBarHome(context, "", 24.0),
      body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Card(
          margin: EdgeInsets.only(left: 10, right: 10, top: 8),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                "assets/assign_qr_banner.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
          child: DottedBorder(
            borderType: BorderType.RRect,
            color: lightBlue,
            padding: EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 15),
            radius: Radius.circular(20),
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 0, left: 0, right: 0),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0, top: 0),
                          child: Text(
                            selfiContact,
                            style: TextStyle(
                                color: black,
                                fontSize: font13,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0, top: 5),
                          child: Text(
                            mandatory,
                            style: TextStyle(
                                color: black,
                                fontSize: font10,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    )),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: Colors.blueAccent)),
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
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 45,
          margin: EdgeInsets.only(top: 15, left: padding, right: padding),
          decoration: BoxDecoration(
            color: editBg,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(
            child: TextFormField(
              style: TextStyle(color: black, fontSize: inputFont),
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.next,
              controller: qrController,
              decoration: new InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 20),
                counterText: "",
                label: Text("Enter QR code"),
              ),
              maxLength: 16,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, left: 25, right: 25),
          child: Row(
            children: [
              Text(
                autoInvest,
                style: TextStyle(
                    color: black,
                    fontSize: font13,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              FlutterSwitch(
                  width: 60.0,
                  height: 26.0,
                  valueFontSize: 14.0,
                  toggleSize: 24.0,
                  activeText: "Y",
                  inactiveText: "N",
                  value: _switchValue,
                  borderRadius: 30.0,
                  padding: 4.0,
                  showOnOff: true,
                  onToggle: (value) {
                    setState(() {
                      _switchValue = value;
                      if (value) {
                        autoInvestEnable("Yes");
                      } else {
                        autoInvestEnable("No");
                      }
                    });
                  }),
            ],
          ),
        ),
      ])),
      bottomNavigationBar: (isSelfUploaded)
          ? InkWell(
              onTap: () {
                setState(() {
                  closeKeyBoard(context);
                  var qId = qrController.text.toString();

                  if (qId.length == 0) {
                    showToastMessage("Enter QR code id");
                  } else {
                    assignQR(qId);
                  }
                });
              },
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                margin:
                    EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Center(
                  child: Text(
                    submit.toUpperCase(),
                    style: TextStyle(fontSize: font13, color: white),
                  ),
                ),
              ),
            )
          : Container(
              height: 1,
            ),
    ));
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
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          color: gray,
                          width: 50,
                          height: 5,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                          20,
                        ),
                        child: Text(
                          "Get image from",
                          style: TextStyle(color: black, fontSize: font16),
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
                                    width: 40,
                                    height: 40,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Gallery",
                                      style: TextStyle(
                                          color: black, fontSize: font15),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
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
                                    width: 40,
                                    height: 40,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Camera",
                                      style: TextStyle(
                                          color: black, fontSize: font15),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
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

    printMessage(screen, 'Path : ${pickedFile!.path.toString()}');

    if (pickedFile != null) {
      setState(() {
        File _image = File(pickedFile.path);
        cropImageFunction(_image);
      });
    }
  }

  void _upload(File file) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(
                message: "Please wait, while we are uploading your document");
          });
    });
    String fileName = file.path.split('/').last;

    FormData data = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      "token": "${widget.token}",
      "doc_name": "selfi"
    });

    printMessage(screen, "TOKEN PASS : ${widget.token}");

    Dio dio = new Dio();

    dio.post(marchantDocsEmpAPI, data: data).then((response) {
      var msg = jsonDecode(response.toString());

      if (response.statusCode == 200) {
        var msg = jsonDecode(response.toString());
        showToastMessage(msg['message'].toString());
        var status = msg['status'].toString();
        setState(() {
          if (status == "1") {
            isSelfUploaded = true;
          } else {
            isSelfUploaded = false;
          }
        });
      } else {
        showToastMessage(status500);
      }
      setState(() {
        Navigator.pop(context);
      });
    }).catchError((error) => print(error));
  }

  Future autoInvestEnable(vale) async {
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
      "Authorization": "$authHeader",
    };

    final body = {"token": "${widget.token}", "qr_money_invst": "$vale"};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(marchantQrAutoInvestAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response On : $data");

      setState(() {
        Navigator.pop(context);
        if (data['status'].toString() == "1") {
          showToastMessage(data['message'].toString());
          //openMerchantInvestorMobile(context, widget.token.toString(), widget.mobile.toString());
        } else if (data['status'].toString() == "4") {
          showToastMessage(data['message'].toString());
        } else {
          showToastMessage(data['message'].toString());
        }
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
  }

  Future assignQR(qrId) async {
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
      "Authorization": "$authHeader",
    };

    final body = {
      "token": "${widget.token}",
      "qr_id": "$qrId",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(marchantQrAssignAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response Settelment : $data");

      setState(() {
        Navigator.pop(context);
        if (data['status'].toString() == "1") {
          isShow = true;
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return ThankYouDialog(
                  text: "QR Code : $qrId\n${data['message'].toString()}",
                  isCloseAll: "0".toString(),
                );
              });
        } else {
          isShow = false;
          showToastMessage(data['message'].toString());
        }
      });
    } else {
      setState(() {
        Navigator.pop(context);
        isShow = false;
      });
      showToastMessage(status500);
    }
  }

  cropImageFunction(File file) async {
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
        ));

    setState(() {
      _upload(croppedFile!);
    });
  }
}
