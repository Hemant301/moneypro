import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/AppKeys.dart';


class MerchantDocument extends StatefulWidget {
  final Map itemResponse;

  const MerchantDocument({Key? key, required this.itemResponse})
      : super(key: key);

  @override
  _MerchantDocumentState createState() => _MerchantDocumentState();
}

class _MerchantDocumentState extends State<MerchantDocument> {
  final panController = new TextEditingController();
  TextEditingController panNameController = new TextEditingController();
  final adharController = new TextEditingController();

  var screen = "PAN Card";

  Map newItem = {};

  var loadPan = false;

  var docUploading = false;

  var isSelfUploaded = false;

  var name = "";

  DateTime currentDate = DateTime.now();
  final f = new DateFormat('dd-MM-yyyy');

  var cDate;

  var isValidPan = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      newItem = widget.itemResponse;
      cDate = f.format(currentDate);
    });
    updateATMStatus(context);
    fetchUserAccountBalance();
  }

  @override
  void dispose() {
    panController.dispose();
    adharController.dispose();
    panNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>WillPopScope(
        onWillPop: () async {
          printMessage(screen, "Mobile back pressed");
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return NoExitDialog();
              });
          return false;
        },
        child: SafeArea(
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
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return NoExitDialog();
                    });
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
              Image.asset(
                'assets/faq.png',
                width: 24.w,
                color: orange,
              ),
              SizedBox(
                width: 10.w,
              )
            ],
          ),
          body: SingleChildScrollView(
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
                            style: TextStyle(color: black, fontSize: inputFont.sp),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.next,
                            controller: panController,
                            decoration: new InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 10),
                              counterText: "",
                              label: Text("Enter your PAN number to verify *"),
                            ),
                            maxLength: 10,
                            onChanged: (val) {
                              setState(() {
                                if (val.length == 10) {
                                  closeKeyBoard(context);
                                  getPanCardDetails(val.toUpperCase());
                                }
                              });
                            },
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
                Padding(
                  padding:
                      const EdgeInsets.only(left: 25.0, top: 5, bottom: 10),
                  child: Text(
                    panWillVerify,
                    style: TextStyle(
                        color: lightBlue,
                        fontSize: font10.sp,
                        fontWeight: FontWeight.normal),
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
                            style: TextStyle(color: black, fontSize: inputFont.sp),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.next,
                            controller: panNameController,
                            decoration: new InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 10),
                              counterText: "",
                              label: Text("Enter your PAN name"),
                            ),
                            maxLength: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 5),
                  child: Text(
                    nameAppear,
                    style: TextStyle(
                        color: lightBlue,
                        fontSize: font10.sp,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _selectFromDate(context);
                  },
                  child: Container(
                    height: 50.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: editBg,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    margin: EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 5),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            (cDate.toString() ==
                                    f.format(currentDate).toString())
                                ? "$dob"
                                : f.format(currentDate),
                            style: TextStyle(color: black, fontSize: font14.sp),
                          ),
                        ),
                        Spacer(),
                        Image.asset(
                          'assets/calendar.png',
                          height: 24.h,
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: 20, left: padding, right: padding),
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
                            style: TextStyle(color: black, fontSize: inputFont.sp),
                            keyboardType: TextInputType.number,
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.next,
                            controller: adharController,
                            decoration: new InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 10),
                              counterText: "",
                              label: Text("Enter your Aadhar Card number"),
                            ),
                            maxLength: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 20),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    color: lightBlue,
                    padding:
                        EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 15),
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
                                  padding:
                                      const EdgeInsets.only(left: 25.0, top: 0),
                                  child: Text(
                                    selfiContact,
                                    style: TextStyle(
                                        color: black,
                                        fontSize: font13.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 25.0, top: 5),
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
              ],
            ),
          ),
          bottomNavigationBar: InkWell(
            onTap: () {
              setState(() {
                closeKeyBoard(context);

                var pan = panController.text.toString();
                var panName = panNameController.text.toString();
                var aadhar = adharController.text.toString();

                if (pan.length == 0) {
                  showToastMessage("Enter your PAN number");
                  return;
                } else if (!panCardPattern.hasMatch(pan.toString())) {
                  showToastMessage("Enter vaild PAN card number");
                  return;
                } else if (panName.length == 0) {
                  showToastMessage("Enter PAN card name");
                  return;
                } else if (regExpName.hasMatch(panName)) {
                  showToastMessage(
                      "Special characters or numbers are not allowed in PAN card name");
                  return;
                } else if (!isSelfUploaded) {
                  showToastMessage("Selfi is mandatory");
                  return;
                } else if (aadhar.length > 1) {
                  if (aadhar.length != 12) {
                    showToastMessage("Enter 12-digit aadhar number");
                    return;
                  }
                }
                newItem['pan'] = pan.toString();
                newItem['client_nam'] = panName.toString();
                newItem['dob'] = f.format(currentDate).toString();
                newItem['adhar'] = aadhar.toString();

                openBankDetails(context, newItem);
              });
            },
            child: Container(
              height: 45.h,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 30),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Center(
                child: Text(
                  continue_.toUpperCase(),
                  style: TextStyle(fontSize: font13.sp, color: white),
                ),
              ),
            ),
          ),
        ))));
  }

//calendar.png
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

  Future getPanCardDetails(pan) async {
    var id = DateTime.now().millisecondsSinceEpoch;

    var userToken = await getToken();

    setState(() {
      loadPan = true;
    });

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

  Future getImage(ImageSource source) async {
    /*ImagePicker picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source, imageQuality: 25);*/

    ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile = await imagePicker.getImage(
      source: source,
      imageQuality: imageQuality,
    );

    printMessage(screen, 'Path : ${pickedFile!.path.toString()}');

    if (pickedFile != null) {
      setState(() {
        File _image = File(pickedFile.path);
        printMessage(screen,
            "After Size ${getFileSizeString(bytes: _image.lengthSync())}");
        cropImageFunction(_image);
      });
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

  void _upload(File file) async {
    setState(() {
      docUploading = true;
    });
    String fileName = file.path.split('/').last;

    var token = await getToken();

    FormData data = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      "token": token,
      "doc_name": "selfi"
    });

    Dio dio = new Dio();

    dio.post(docUploadAPI, data: data).then((response) {
      var msg = jsonDecode(response.toString());

      printMessage(screen, "Status Code : ${msg['message']}");
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
        //getImagePath();
      } else {
        printMessage(screen, "Error : ${response}");
      }
      setState(() {
        docUploading = false;
      });
    }).catchError((error) => print(error));
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1947),
        lastDate: DateTime.now());
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
      });
  }
}
