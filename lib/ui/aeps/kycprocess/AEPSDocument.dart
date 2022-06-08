import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/SharedPrefs.dart';

class AEPSDocument extends StatefulWidget {
  final String pancard;

  const AEPSDocument({Key? key, required this.pancard}) : super(key: key);

  @override
  _AEPSDocumentState createState() => _AEPSDocumentState();
}

class _AEPSDocumentState extends State<AEPSDocument> {
  var screen = "AEPS Document";

  TextEditingController panController = new TextEditingController();
  TextEditingController panNameController = new TextEditingController();

  var name = "";
  var docUploading = false;
  var loadPan = false;
  var isValidPan = false;
  var loading = false;
  late File _image;

  @override
  void initState() {
    super.initState();
    //userAEPSKyc();

   if(mounted)
     setPan();
  }

  setPan(){
    setState(() {
      if (widget.pancard.length == 10) {
        panController = TextEditingController(text: "${widget.pancard}");
        getPanCardDetails(widget.pancard.toUpperCase());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
      backgroundColor: white,
      appBar: appBarHome(
        context,
        "",
        24.0.w,
      ),
      body: (loading)
          ? Center(
              child: circularProgressLoading(40.0),
            )
          : SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Container(
                    margin:
                        EdgeInsets.only(top: 35, left: padding, right: padding),
                    decoration: BoxDecoration(
                      color: editBg,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15, top: 10, bottom: 10),
                            child: TextFormField(
                              enabled: false,
                              style:
                                  TextStyle(color: black, fontSize: inputFont.sp),
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.characters,
                              textInputAction: TextInputAction.next,
                              controller: panController,
                              decoration: new InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 10),
                                counterText: "",
                                label: Text("Enter your PAN card number"),
                              ),
                              maxLength: 10,
                            ),
                          ),
                        ),
                        (loadPan)
                            ? Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: circularProgressLoading(20.0),
                              )
                            : Container()
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(top: 15, left: padding, right: padding),
                    decoration: BoxDecoration(
                      color: editBg,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15, top: 10, bottom: 10),
                            child: TextFormField(
                              enabled: false,
                              style:
                                  TextStyle(color: black, fontSize: inputFont.sp),
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.characters,
                              textInputAction: TextInputAction.next,
                              controller: panNameController,
                              decoration: new InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 10),
                                counterText: "",
                                label: Text("Enter your PAN card name"),
                              ),
                              maxLength: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      color: lightBlue,
                      padding: EdgeInsets.only(
                          left: 5, right: 5, top: 15, bottom: 15),
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
                                    padding: const EdgeInsets.only(
                                        left: 25.0, top: 0),
                                    child: Text(
                                      "Upload the Aadhaar card",
                                      style: TextStyle(
                                          color: black,
                                          fontSize: font13.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25.0, top: 5),
                                    child: Text(
                                      mandatory,
                                      style: TextStyle(
                                          color: black,
                                          fontSize: font10.sp,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ],
                              )),
                              Container(
                                height: 50.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    border:
                                        Border.all(color: Colors.blueAccent)),
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
                              (docUploading)
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: circularProgressLoading(20.0),
                                    )
                                  : Container(),
                              SizedBox(
                                width: 20.w,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30.0, right: 30, top: 50),
                    child: Text(
                      "Note",
                      style: TextStyle(color: black, fontSize: font16.sp),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30.0, right: 30, top: 5),
                    child: Text(
                      note1,
                      style: TextStyle(color: black, fontSize: font13.sp),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30.0, right: 30, top: 5),
                    child: Text(
                      note2,
                      style: TextStyle(color: black, fontSize: font13.sp),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30.0, right: 30, top: 5),
                    child: Text(
                      note3,
                      style: TextStyle(color: black, fontSize: font13.sp),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30.0, right: 30, top: 5),
                    child: Text(
                      note4,
                      style: TextStyle(color: black, fontSize: font13.sp),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30.0, right: 30, top: 5),
                    child: InkWell(
                      onTap: () {
                        openShowWebViews(
                            context, "https://eaadhaar.uidai.gov.in/");
                      },
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: "5) Download MASKED E-Aadhaar from ",
                          style: TextStyle(color: black, fontSize: font13.sp),
                        ),
                        TextSpan(
                          text: "https://eaadhaar.uidai.gov.in",
                          style: TextStyle(
                            color: lightBlue,
                            fontSize: font14.sp,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                          text: " (not older than 3 days)",
                          style: TextStyle(color: black, fontSize: font13.sp),
                        )
                      ])),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30.0, right: 30, top: 5),
                    child: Text(
                      note6,
                      style: TextStyle(color: black, fontSize: font13.sp),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30.0, right: 30, top: 5),
                    child: Text(
                      note7,
                      style: TextStyle(color: black, fontSize: font13.sp),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ])),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 10),
        height: 50.h,
        child: InkWell(
          onTap: () {
            setState(() {
              closeKeyBoard(context);

              var panName = panNameController.text.toString();

              if (panName.length != 0) {
                if (_image != null)
                  _upload(_image);
                else
                  showToastMessage("Upload Aadhar card image");
              } else {
                showToastMessage("Enter PAN card name.");
              }
            });
          },
          child: Container(
            height: 50.h,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 0),
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Center(
              child: Text(
                submit,
                style: TextStyle(fontSize: font15.sp, color: white),
              ),
            ),
          ),
        ),
      ),
    )));
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

    printMessage(screen, 'Path : ${pickedFile!.path.toString()}');

    if (pickedFile != null) {
      setState(() {
        File _image = File(pickedFile.path);
        cropImageFunction(_image);
      });
    }
  }

  Future getPanCardDetails(pan) async {
    var id = DateTime.now().millisecondsSinceEpoch;

    setState(() {
      loadPan = true;
    });

    var userToken = await getToken();

    var body = {
      "user_token":"$userToken",
      "pan_number":"$pan",
    };

    var header = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final response = await http.post(Uri.parse(panVerify),
        body: jsonEncode(body),
        headers: header);

    var dataa = json.decode(response.body);

    setState(() {
      loadPan = false;
      printMessage(screen, "Pan Card dataa : $dataa");

      var status = dataa['data']['kycStatus'].toString();

      if (status.toString() == "SUCCESS") {
        setState(() {
          name = dataa['data']['kycResult']['name'];
          printMessage(screen, "Pan Card name : $name");
          isValidPan = true;
          panNameController = TextEditingController(text: name.toString());
        });
      } else {
        setState(() {
          name = "";
          isValidPan = false;
          panNameController = TextEditingController(text: name.toString());
        });
        if(dataa.toString().contains("error")){
          showToastMessage(dataa['data']['error']['message'].toString());
        }else{
          showToastMessage(dataa['data']['message'].toString());
        }
      }
    });
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

    var m_id = await getMerchantID();

    FormData data = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      "m_id": m_id,
      "pan": "${widget.pancard}"
    });

    Dio dio = new Dio();

    dio
        .post(uploadKycDocsAepsAPI,
            data: data,
            options: Options(
              headers: {"Authorization": "$authHeader"},
            ))
        .then((response) {
      var msg = jsonDecode(response.toString());

      printMessage(screen, "Status Code : ${msg['message']}");
      if (response.statusCode == 200) {
        Navigator.pop(context);
        var msg = jsonDecode(response.toString());
        printMessage(screen, "Outlet Id : $msg");
        showToastMessage(msg['message'].toString());
        var status = msg['status'].toString();
        setState(() {
          if (status == "1") {
            showToastMessage(msg['message'].toString());
            var outletId = msg['outlet_id'].toString();
            getAEPSURL(outletId);
          }
        });
      } else {
        showToastMessage(status500);
      }
    }).catchError((error) => print(error));
  }

  Future userAEPSKyc() async {
    setState(() {
      loading = true;
    });

    var m_id = await getMerchantID();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "m_id": m_id,
      "pan": widget.pancard,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(getKycAepsAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      setState(() {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        printMessage(screen, "Data : $data");
        if (data['status'].toString() == "1") {
          showToastMessage(data['status'].toString());
        } else {
          showToastMessage("${data['message'].toString()}");
        }

        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
      showToastMessage(status500);
    }
  }

  Future getAEPSURL(outletId) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var m_id = await getMerchantID();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "m_id": "$m_id",
      "outlet_id": "$outletId",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(getUrlAepsAPI),
        body: jsonEncode(body), headers: headers);

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    printMessage(screen, "data : $data");

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      setState(() {
        Navigator.pop(context);
        if (data['status'].toString() == "1") {
          //move to webview
          var tokenAeps = data['token_aeps'].toString();
          var url = "$apesWebUrl$tokenAeps";
          openShowWebViews(context, url);
        }
        showToastMessage(data['message']);
      });
    } else {
      setState(() {
        Navigator.pop(context);
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
