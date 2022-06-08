import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';

class MerchantInvestorDoc extends StatefulWidget {
  final String pan;
  final String token;
  const MerchantInvestorDoc({Key? key,required this.pan,
    required this.token}) : super(key: key);

  @override
  _MerchantInvestorDocState createState() => _MerchantInvestorDocState();
}

class _MerchantInvestorDocState extends State<MerchantInvestorDoc> {
  var screen = "Investor Docs";
  var loading = false;

  var docUploading = false;
  var docOtherUploading = false;
  var selfiUploading = false;

  var isPANUploaded = false;
  var isOtherUploaded = false;
  var isSelfUpload = false;

  var selectDocType;

  late File selfiFile;

  List<String> docTypes = [
    "Adhaar card",
    "Voter Id",
    "Passport",
    "Driving Licence "
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        printMessage(screen, "Mobile back pressed");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return exitProcess();
            });
        return false;
      },
      child: SafeArea(
          child: Scaffold(
            backgroundColor: white,
            appBar:AppBar(
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
                        return exitProcess();
                      });
                },
                child: Container(
                  height: 60,
                  width: 60,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/back_arrow_bg.png',
                        height: 60,
                      ),
                      Positioned(
                        top: 16,
                        left: 12,
                        child: Image.asset(
                          'assets/back_arrow.png',
                          height: 16,
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
                  'assets/lendbox_head.png',
                  width: 60,
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
            body: SingleChildScrollView(
                child: Column(children: [
                  _buildPANSection(),
                  _buildAddressSection(),
                  _buildSelfiSection(),
                ])),
            bottomNavigationBar: InkWell(
              onTap: () {
                setState(() {
                  closeKeyBoard(context);
                  if (isPANUploaded && isOtherUploaded && isSelfUpload) {
                    removeAllPages(context);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return KycThankYouDialog(message: investorKycMsg,);
                        });
                  } else {
                    showToastMessage("Upload require documents");
                  }
                });
              },
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 30),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Center(
                  child: Text(
                    continue_.toUpperCase(),
                    style: TextStyle(fontSize: font13, color: white),
                  ),
                ),
              ),
            ),)),
    );
  }

  _buildPANSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
      decoration: BoxDecoration(
        color: invBoxBg,
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
            const EdgeInsets.only(left: 25, right: 15, top: 20, bottom: 5),
            child: Text(
              "PAN card",
              style: TextStyle(
                  color: black, fontSize: font14, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15, left: padding, right: padding),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 25.0, right: 15, top: 15, bottom: 15),
              child: Text(
                "${widget.pan}",
                style: TextStyle(color: black, fontSize: font13),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            margin: EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                children: [
                  Expanded(
                      child: InkWell(
                        onTap: () {
                          _showCameraGalleryOption(1, "pancard");
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0, top: 0),
                              child: Text(
                                "Upload PAN card Image",
                                style: TextStyle(color: black, fontSize: font14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0, top: 5),
                              child: Text(
                                mandatory,
                                style: TextStyle(
                                    color: lightBlack,
                                    fontSize: font11,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Container(
                    height: 50,
                    width: 50,
                    child: InkWell(
                      onTap: () {
                        _showCameraGalleryOption(1, "pancard");
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
                    width: 20,
                  )
                ],
              ),
            ),
          ),
          (isPANUploaded)
              ? Padding(
            padding: EdgeInsets.only(top: 5, left: 25, right: 15),
            child: Text(
              "File Uploaded.",
              style: TextStyle(color: black, fontSize: font12),
            ),
          )
              : Container(),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
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
              "Choose address proof document",
              style: TextStyle(
                  color: black, fontSize: font14, fontWeight: FontWeight.bold),
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
                style: TextStyle(color: black, fontSize: font14),
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
                    accountType,
                    style: TextStyle(color: lightBlack, fontSize: font14),
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
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
              ),
            ),
          ),
          (selectDocType.toString() == "null")
              ? Container()
              : Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            margin: EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                children: [
                  Expanded(
                      child: InkWell(
                        onTap: () {
                          _showCameraGalleryOption(2, selectDocType);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 25.0, top: 0),
                              child: Text(
                                "Upload ${selectDocType} Image",
                                style: TextStyle(
                                    color: black,
                                    fontSize: font14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 25.0, top: 5),
                              child: Text(
                                mandatory,
                                style: TextStyle(
                                    color: lightBlack,
                                    fontSize: font11,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Container(
                    height: 50,
                    width: 50,
                    child: InkWell(
                      onTap: () {
                        _showCameraGalleryOption(2, selectDocType);
                      },
                      child: Center(
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: lightBlue,
                        ),
                      ),
                    ),
                  ),
                  (docOtherUploading)
                      ? Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: circularProgressLoading(20.0),
                  )
                      : Container(),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
            ),
          ),
          (isOtherUploaded)
              ? Padding(
            padding: EdgeInsets.only(top: 5, left: 25, right: 15),
            child: Text(
              "File Uploaded.",
              style: TextStyle(
                  color: black, fontSize: font12),
            ),
          )
              : Container(),

          SizedBox(
            height: 30,
          ),
        ]));
  }

  _buildSelfiSection(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 0),
      decoration: BoxDecoration(
        color: invBoxBg,
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: editBg,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: editBg)),
            margin: EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                children: [
                  Expanded(
                      child: InkWell(
                        onTap: () {
                          _showCameraGalleryOption(3, "Selfi");
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 25.0, top: 0),
                              child: Text(
                                "Upload Selfi Image",
                                style: TextStyle(
                                    color: black,
                                    fontSize: font14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 25.0, top: 5),
                              child: Text(
                                mandatory,
                                style: TextStyle(
                                    color: lightBlack,
                                    fontSize: font11,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Container(
                    height: 50,
                    width: 50,
                    child: InkWell(
                      onTap: () {
                        _showCameraGalleryOption(3, selectDocType);
                      },
                      child: Center(
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: lightBlue,
                        ),
                      ),
                    ),
                  ),
                  (selfiUploading)
                      ? Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child:
                    circularProgressLoading(20.0),
                  )
                      : Container(),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
            ),
          ),
          (isSelfUpload)
              ? Padding(
            padding: EdgeInsets.only(top: 5, left: 25, right: 15),
            child: Text(
              "File Uploaded.",
              style: TextStyle(
                  color: black, fontSize: font12),
            ),
          )
              : Container(),
          (isSelfUpload)?
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 120,
                height: 120,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(File(selfiFile.path)),
                          fit: BoxFit.cover)),
                ),),
            ),
          ): Container(),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  _showCameraGalleryOption(action, docName) {
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
                          getImage(ImageSource.gallery, action, docName);
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
                          getImage(ImageSource.camera, action, docName);
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

  Future getImage(ImageSource source, action, docName) async {
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
        cropImageFunction(_image, action,docName);
      });
    }
  }

  void _uploadPan(File file, docName) async {
    setState(() {
      docUploading = true;
    });
    String fileName = file.path.split('/').last;



    FormData data = FormData.fromMap({
      "file_name": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      "token": "${widget.token}",
      "doc_type": "$docName"
    });

    Dio dio = new Dio();

    dio.post(investorDocsUploadAPI, data: data).then((response) {
      var msg = jsonDecode(response.toString());

      printMessage(screen, "Status Code : ${msg['message']}");
      if (response.statusCode == 200) {
        var msg = jsonDecode(response.toString());
        showToastMessage(msg['message'].toString());
        var status = msg['status'].toString();
        setState(() {
          if (status == "1") {
            isPANUploaded = true;
          } else {
            isPANUploaded = false;
          }
        });
      } else {
        printMessage(screen, "Error : ${response}");
      }
      setState(() {
        docUploading = false;
      });
    }).catchError((error) => print(error));
  }

  void _uploadAddressProof(File file, docName) async {
    setState(() {
      docOtherUploading = true;
    });
    String fileName = file.path.split('/').last;



    FormData data = FormData.fromMap({
      "file_name": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      "token": "${widget.token}",
      "doc_type": "$docName"
    });

    Dio dio = new Dio();

    dio.post(investorDocsUploadAPI, data: data).then((response) {
      var msg = jsonDecode(response.toString());

      printMessage(screen, "Status Code : ${msg['message']}");
      if (response.statusCode == 200) {
        var msg = jsonDecode(response.toString());
        showToastMessage(msg['message'].toString());
        var status = msg['status'].toString();
        setState(() {
          if (status == "1") {
            isOtherUploaded = true;
          } else {
            isOtherUploaded = false;
          }
        });
      } else {
        printMessage(screen, "Error : ${response}");
      }
      setState(() {
        docOtherUploading = false;
      });
    }).catchError((error) => print(error));
  }

  void _uploadSelfi(File file, docName) async {
    setState(() {
      selfiUploading = true;
    });
    String fileName = file.path.split('/').last;

    FormData data = FormData.fromMap({
      "file_name": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      "token": "${widget.token}",
      "doc_type": "$docName"
    });

    Dio dio = new Dio();

    dio.post(investorDocsUploadAPI, data: data).then((response) {
      var msg = jsonDecode(response.toString());

      printMessage(screen, "Status Code : ${msg['message']}");
      if (response.statusCode == 200) {
        isSelfUpload = true;
        selfiFile = file;
        var msg = jsonDecode(response.toString());
        showToastMessage(msg['message'].toString());
        var status = msg['status'].toString();
        setState(() {
          if (status == "1") {
            isSelfUpload = true;
          } else {
            isSelfUpload = false;
          }
        });
      } else {
        printMessage(screen, "Error : ${response}");
      }
      setState(() {
        selfiUploading = false;
      });
    }).catchError((error) => print(error));
  }

  cropImageFunction(File file, int action,docName) async{
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
      if (action == 1) _uploadPan(croppedFile!, docName);

      if (action == 2) _uploadAddressProof(croppedFile!, docName);

      if (action == 3) _uploadSelfi(croppedFile!, docName);
    });
  }
}
