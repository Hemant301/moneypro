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
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'dart:convert';

class EmpMerchantVerifyDetails extends StatefulWidget {
  final Map itemResponse;
  final File storeImage;

  const EmpMerchantVerifyDetails(
      {Key? key, required this.itemResponse, required this.storeImage})
      : super(key: key);

  @override
  _EmpMerchantVerifyDetailsState createState() =>
      _EmpMerchantVerifyDetailsState();
}

class _EmpMerchantVerifyDetailsState extends State<EmpMerchantVerifyDetails> {
  Map newItem = {};

  var screen = "Emp Verify Business";

  var selectDocType;

  List<String> docTypes = [
    "Aadhar Card",
    "Trade License",
    "GST Certificate",
    "Food license",
    "Drug License",
    "PTax",
    "Shop Establishment Certificate",
    "Others"
  ];

  File selectedOtherFile = new File("");
  File selectedAadharFrontFile = new File("");
  File selectedAadharBackFile = new File("");

  var isOtherFileUploaded = false;
  var isAadharFrontFileUploaded = false;
  var isAadharBackFileUploaded = false;

  var docUploading = false;

  final gstController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      newItem = widget.itemResponse;
    });
    fetchUserAccountBalance();
    updateATMStatus(context);
  }

  @override
  void dispose() {
    gstController.dispose();
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
              child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 30, right: 25),
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: verifyBusiness1,
                      style: TextStyle(
                          color: black,
                          fontSize: font14.sp,
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: widget.itemResponse['businessName'].toString(),
                          style: TextStyle(
                              color: green,
                              fontSize: font14.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: " "),
                        TextSpan(
                          text: verifyBusiness2,
                          style: TextStyle(
                              color: black,
                              fontSize: font14.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ])),
            ),
            _buildAddressSection(),
            SizedBox(
              height: 20.h,
            ),
            _buildShowNotes(),
          ])),
          bottomNavigationBar: InkWell(
            onTap: () {
              closeKeyBoard(context);
              var gst = "";
              var docName = "";

              if (selectDocType.toString() == "GST Certificate") {
                gst = gstController.text.toString();
                if (gst.length != 15) {
                  showToastMessage("Enter valid 15-digit GSTIN number");
                  return;
                } else {
                  newItem['gstValue'] = gst.toString();
                  newItem['docName'] = "";
                }
              }

              if (selectDocType.toString() == "Aadhar Card") {
                if (!isAadharFrontFileUploaded || !isAadharBackFileUploaded) {
                  showToastMessage(
                      "Upload both aadhar front and back side to server");
                  return;
                } else {
                  newItem['docName'] = selectDocType.toString();
                  newItem['gstValue'] = "";
                }
              }

              if (selectDocType.toString() != "GST Certificate" &&
                  selectDocType.toString() != "Aadhar Card") {
                if (!isOtherFileUploaded) {
                  showToastMessage("Upload $selectDocType to server");
                  return;
                } else {
                  newItem['docName'] = selectDocType.toString();
                  newItem['gstValue'] = "";
                }
              }

              printMessage(screen, "Map value : $newItem");

              openEmpMerPanVerify(
                  context,
                  newItem,
                  widget.storeImage,
                  selectedOtherFile,
                  selectedAadharFrontFile,
                  selectedAadharBackFile);
            },
            child: Container(
              height: 48.h,
              width: 120.w,
              margin: EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 10),
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

  _buildAddressSection() {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 0),
        decoration: BoxDecoration(
          color: invBoxBg,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 25, right: 15, top: 20, bottom: 5),
            child: Text(
              "Choose document",
              style: TextStyle(
                  color: black, fontSize: font14.sp, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15, left: 15, right: 15),
            decoration: BoxDecoration(
                color: editBg,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: editBg)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectDocType,
                style: TextStyle(color: black, fontSize: font14.sp),
                items: docTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        value,
                        style: TextStyle(color: black),
                      ),
                    ),
                  );
                }).toList(),
                hint: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Document",
                    style: TextStyle(color: lightBlack, fontSize: font14.sp),
                  ),
                ),
                icon: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Icon(
                    // Add this
                    Icons.keyboard_arrow_down, // Add this
                    color: lightBlue,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectDocType = value!;
                    printMessage(screen, "Doc Type : $selectDocType");

                    if (selectDocType.toString() == "Aadhar Card") {
                      setState(() {
                        isOtherFileUploaded = false;
                      });
                    }
                    if (selectDocType.toString() == "GST Certificate") {
                      setState(() {
                        isOtherFileUploaded = false;
                        isAadharFrontFileUploaded = false;
                        isAadharBackFileUploaded = false;
                      });
                    } else {
                      setState(() {
                        isAadharFrontFileUploaded = false;
                        isAadharBackFileUploaded = false;
                      });
                    }

                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
              ),
            ),
          ),
          (selectDocType.toString() == "null")
              ? Container()
              : (selectDocType.toString() == "Aadhar Card")
                  ? Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 20),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                color: lightBlue,
                                radius: Radius.circular(20),
                                child: InkWell(
                                  onTap: () {
                                    _showCameraGalleryOption(2, "Aadhar front");
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 120.h,
                                    child: (isAadharFrontFileUploaded)
                                        ? Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25)),
                                                image: DecorationImage(
                                                    image: FileImage(File(
                                                        selectedAadharFrontFile
                                                            .path)),
                                                    fit: BoxFit.cover)),
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.upload_rounded,
                                                color: lightBlue,
                                              ),
                                              Text(
                                                "Upload Front Side",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font16.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Expanded(
                              flex: 1,
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                color: lightBlue,
                                radius: Radius.circular(20),
                                child: InkWell(
                                  onTap: () {
                                    _showCameraGalleryOption(2, "Aadhar back");
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 120.h,
                                    child: (isAadharBackFileUploaded)
                                        ? Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25)),
                                                image: DecorationImage(
                                                    image: FileImage(File(
                                                        selectedAadharBackFile
                                                            .path)),
                                                    fit: BoxFit.cover)),
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.upload_rounded,
                                                color: lightBlue,
                                              ),
                                              Text(
                                                "Upload Back Side",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font16.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
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
                    )
                  : (selectDocType.toString() == "GST Certificate")
                      ? _buildGSTSection()
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: editBg,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                            child: Row(
                              children: [
                                Expanded(
                                    child: InkWell(
                                  onTap: () {
                                    _showCameraGalleryOption(2, selectDocType);
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25.0, top: 0),
                                        child: Text(
                                          "Upload ${selectDocType} Image",
                                          style: TextStyle(
                                              color: black,
                                              fontSize: font14.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25.0, top: 5),
                                        child: Text(
                                          mandatory,
                                          style: TextStyle(
                                              color: lightBlack,
                                              fontSize: font11.sp,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                Container(
                                  height: 50.h,
                                  width: 50.w,
                                  child: InkWell(
                                    onTap: () {
                                      _showCameraGalleryOption(
                                          2, selectDocType);
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
                                  width: 20.w,
                                )
                              ],
                            ),
                          ),
                        ),
          (docUploading)
              ? Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Center(child: circularProgressLoading(20.0)),
                )
              : Container(),
          SizedBox(
            height: 30.h,
          ),
        ]));
  }

  _buildGSTSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 0),
      decoration: BoxDecoration(
        color: invBoxBg,
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 45.h,
            margin: EdgeInsets.only(top: 5, left: 0, right: 0),
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15, top: 10, bottom: 10),
                child: TextFormField(
                  style: TextStyle(color: black, fontSize: inputFont.sp),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.characters,
                  controller: gstController,
                  decoration: new InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10),
                    hintText: enterGSTno,
                    counterText: "",
                  ),
                  maxLength: 15,
                  onChanged: (val) {
                    setState(() {
                      if (val.length == 15) {
                        closeKeyBoard(context);
                      }
                    });
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, top: 5),
            child: Text(
              "$gstEnable",
              style: TextStyle(
                  color: black,
                  fontSize: font11.sp,
                  fontWeight: FontWeight.normal),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }

  _showCameraGalleryOption(filename, selectDocType) {
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
                              getImage(
                                  ImageSource.gallery, filename, selectDocType);
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
                              getImage(
                                  ImageSource.camera, filename, selectDocType);
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

  Future getImage(ImageSource source, filename, docType) async {
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);
    printMessage(screen, 'Path : ${pickedFile!.path.toString()}');

    if (pickedFile != null) {
      setState(() {
        File _image = File(pickedFile.path);
        cropImageFunction(_image, filename, docType);
      });
    }
  }

  cropImageFunction(File file, filename, docType) async {
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
      if (docType.toString() == "Aadhar front") {
        selectedAadharFrontFile = croppedFile!;
        isAadharFrontFileUploaded = true;
      } else if (docType.toString() == "Aadhar back") {
        selectedAadharBackFile = croppedFile!;
        isAadharBackFileUploaded = true;
      } else {
        selectedOtherFile = croppedFile!;
        isOtherFileUploaded = true;
      }
    });
  }

  _buildShowNotes() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.h,
          ),
          Text(
            "Notes:-",
            style: TextStyle(
                color: black, fontSize: font16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "1. ",
                style: TextStyle(
                    color: black,
                    fontSize: font14.sp,
                    fontWeight: FontWeight.w500),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "You should upload the clear $selectDocType. Xerox copies not allowed.",
                  style: TextStyle(
                    color: black,
                    fontSize: font14.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "2. ",
                style: TextStyle(
                    color: black,
                    fontSize: font14.sp,
                    fontWeight: FontWeight.w500),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "Ensure that you are capturing the image in proper light and the image background should be white.",
                  style: TextStyle(
                    color: black,
                    fontSize: font14.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
