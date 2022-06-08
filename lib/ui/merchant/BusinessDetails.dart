import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moneypro_new/ui/models/Categories.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BusinessDetails extends StatefulWidget {
  const BusinessDetails({Key? key}) : super(key: key);

  @override
  _BusinessDetailsState createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetails> {
  var screen = "Business Details";

  var loading = false;

  var fileUploading = false;
  var isFileUploaded = false;

  final businessNameController = new TextEditingController();
  final qrDisplayNameController = new TextEditingController();
  final searchName = new TextEditingController();
  var showFiltedContact = false;

  var selectSegPos;

  late File imageResized;

  var _image;

  List<Category> categoriesList = [];
  List<Category> categoriesFilteredList = [];
  Category distL = new Category();
  var mccCode;
  var catName = "Select segment";

  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    fetchUserAccountBalance();
    getCategoies();
  }

  @override
  void dispose() {
    businessNameController.dispose();
    qrDisplayNameController.dispose();
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
        backgroundColor: (loading)?white:lightBlue,
        body: (loading)
            ? Center(
                child: circularProgressLoading(40.0),
              )
            : Column(
                children: [
                  _buildTopHeader(),
                  Expanded(
                    flex: 1,
                    child: _buildBusinessSection(),
                  ),

                ],
              ),
        bottomNavigationBar: Container(
          color: white,
          child: InkWell(
            onTap: () {
              setState(() {
                closeKeyBoard(context);

                if (!isFileUploaded) {
                  showToastMessage("Upload Store logo or Store image");
                  return;
                }
                saveData();
              });
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
        ),
      )),
    ));
  }

  _buildTopHeader() {
    return Container(
      color: lightBlue,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
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
              Spacer(),
              InkWell(
                onTap: () {
                  //closeCurrentPage(context);
                },
                child: Image.asset(
                  'assets/faq.png',
                  height: 24.h,
                  color: white,
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 20),
            child: Text(
              businessDetail,
              style: TextStyle(
                  color: white, fontWeight: FontWeight.bold, fontSize: font18.sp),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 5),
            child: Text(
              businessTag,
              style: TextStyle(color: white, fontSize: font13.sp),
            ),
          )
        ],
      ),
    );
  }

  _buildBusinessSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        color: white,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              padding: const EdgeInsets.only(left: 25.0, right: 25, top: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                        child: Text(
                      "$step1",
                      style: TextStyle(color: orange, fontSize: font14.sp),
                    )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                        child: Text(
                      "$step2",
                      style: TextStyle(color: black, fontSize: font14.sp),
                    )),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25, top: 10),
              child: Container(
                child: Stack(
                  children: [
                    Image.asset('assets/block_full.png'),
                    Padding(
                      padding: const EdgeInsets.only(top: 1.5),
                      child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Image.asset('assets/block_half.png')),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15, left: padding, right: padding),
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
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                  controller: businessNameController,
                  decoration: new InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10),
                    counterText: "",
                    label: Text("$businessName"),
                  ),
                  maxLength: 100,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 5),
              child: Text(
                "$customerWould (Special characters or numbers are not allowed in business name i.e &,#,@,1,2,3)",
                style: TextStyle(color: lightBlue, fontSize: font10.sp),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15, left: padding, right: padding),
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
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                  controller: qrDisplayNameController,
                  decoration: new InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10),
                    counterText: "",
                    label: Text("QR display name"),
                  ),
                  maxLength: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 5),
              child: Text(
                "This name will be printed on QR Sticker and will be visible to your Customers for Payment",
                style: TextStyle(color: lightBlue, fontSize: font10.sp),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              decoration: BoxDecoration(
                  color: editBg,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: editBg)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectSegPos,
                  style: TextStyle(color: black, fontSize: font16.sp),
                  items:
                      categories.map<DropdownMenuItem<String>>((String value) {
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
                      businessCat,
                      style: TextStyle(color: black, fontSize: font16.sp),
                    ),
                  ),
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Icon(
                      // Add this
                      Icons.keyboard_arrow_down, // Add this
                      color: lightBlue, // Add this
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectSegPos = value!;
                      FocusScope.of(context).requestFocus(new FocusNode());
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 5),
              child: Text(
                selectCat,
                style: TextStyle(color: lightBlue, fontSize: font10.sp),
              ),
            ),
            InkWell(
              onTap: () {
                _showSegmentList();
              },
              child: Container(
                margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                height: 45.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: editBg,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: editBg)),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 0),
                        child: Text(
                          "$catName",
                          style: TextStyle(
                            color: black,
                            fontSize: font16.sp,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Icon(
                        // Add this
                        Icons.keyboard_arrow_down, // Add this
                        color: lightBlue, // Add this
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 5),
              child: Text(
                selectCat,
                style: TextStyle(color: lightBlue, fontSize: font10.sp),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, left: padding, right: padding),
              child: DottedBorder(
                borderType: BorderType.RRect,
                color: lightBlue,
                radius: Radius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: editBg,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10),
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
                                businessLogo,
                                style: TextStyle(
                                    color: black,
                                    fontSize: font13.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 25.0, top: 2),
                              child: Text(
                                businessMake,
                                style: TextStyle(
                                  color: lightBlue,
                                  fontSize: font10.sp,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 25.0, top: 5),
                              child: Text(
                                dosNdont,
                                style: TextStyle(
                                    color: black,
                                    fontSize: font10.sp,
                                    fontWeight: FontWeight.bold),
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
                              color: invBoxBg),
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
                        (fileUploading)
                            ? Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: circularProgressLoading(20.0),
                              )
                            : Container(),
                        SizedBox(
                          width: 10.w,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.h,),
          ],
        ),
      ),
    );
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
                              getImage(
                                ImageSource.gallery,
                              );
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
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);

    printMessage(screen, 'Path : ${pickedFile!.path.toString()}');

    if (pickedFile != null) {
      setState(() {
        File _image = File(pickedFile.path);
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
      fileUploading = true;
    });

    var token = await getToken();

    String fileName = file.path.split('/').last;

    FormData data = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      "token": "$token",
      "doc_name": "StoreImage"
    });

    Dio dio = new Dio();

    dio.post(docUploadAPI, data: data).then((response) {
      var msg = jsonDecode(response.toString());

      printMessage(screen, "Status Code : ${msg['message']}");
      if (response.statusCode == 200) {
        var msg = jsonDecode(response.toString());
        showToastMessage(msg['message'].toString());
        setState(() {
          isFileUploaded = true;
        });
      } else {
        setState(() {
          isFileUploaded = false;
        });
        printMessage(screen, "Error : ${response}");
      }
      setState(() {
        fileUploading = false;
      });
    }).catchError((error) => print(error));
  }

  saveData() {
    var businessName = businessNameController.text.toString();
    var qrDisplayName = qrDisplayNameController.text.toString();

    if (businessName.length == 0) {
      showToastMessage("Enter your business name");
      return;
    } else if (regExpName.hasMatch(businessName)) {
      showToastMessage(
          "Special characters or numbers are not allowed in business name");
      return;
    } else if (qrDisplayName.length == 0) {
      showToastMessage("Enter name to display on QR");
      return;
    } else if (regExpName.hasMatch(qrDisplayName)) {
      showToastMessage(
          "Special characters or numbers are not allowed in QR name");
      return;
    } else if (selectSegPos.toString() == "null" ||
        selectSegPos.toString().length == 0) {
      showToastMessage("Select business category");
      return;
    } else if (mccCode.toString() == "null" || mccCode.toString() == "") {
      showToastMessage("Select business segment");
      return;
    }

    Map<String, String> itemResponse = {
      'businessName': businessName,
      'businessCat': selectSegPos,
      'businessSeg': catName,
      "mccCode": "$mccCode",
      "qrDisplayName": "$qrDisplayName"
    };

    printMessage(screen, "itemResponse : $itemResponse");
    openAddressByMap(context, itemResponse);
  }

  Future getCategoies() async {
    try {
      setState(() {
        loading = true;
      });

      var header = {"Content-Type": "application/json"};

      final response =
          await http.get(Uri.parse(companyCategoryListAPI), headers: header);

      int statusCode = response.statusCode;

      if(statusCode==200){
        var data = jsonDecode(utf8.decode(response.bodyBytes));

        printMessage(screen, "Response Loan : $data");

        setState(() {
          loading = false;
          var status = data['status'].toString();
          if (status == "1") {
            var result =
            Categories.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
            categoriesList = result.categories;

            /*Category category = new Category(
            id: "",
            status: "",
            categoryName: "Select segment",
            mccCode: "",
          );
          categoriesList.insert(0, category);*/
            distL = categoriesList[0];
          } else {
            showToastMessage(data['message'].toString());
          }
        });
      }else{
        setState(() {
          loading = false;
        });
        showToastMessage(status500);
      }


    } catch (e) {
      printMessage(screen, "Error : ${e.toString()}");
    }
  }

  _showSegmentList() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Wrap(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .9,
                  width: MediaQuery.of(context).size.width,
                  decoration: new BoxDecoration(
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
                      Container(
                        height: 4.h,
                        width: 50.w,
                        color: gray,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, top: 15),
                        child: Text(
                          "Select your segment",
                          style: TextStyle(
                              color: black,
                              fontSize: font16.sp,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Divider(
                        color: gray,
                      ),
                      _searchContact(),
                      (showFiltedContact)
                          ? Expanded(
                              flex: 1,
                              child: ListView.builder(
                                itemCount: categoriesFilteredList.length,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        catName = categoriesFilteredList[index]
                                            .categoryName;
                                        mccCode = categoriesFilteredList[index]
                                            .mccCode;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0,
                                                    top: 10,
                                                    bottom: 0,
                                                    right: 15),
                                                child: Text(
                                                  "${categoriesFilteredList[index].categoryName}",
                                                  style: TextStyle(
                                                      color: black,
                                                      fontSize: font14.sp,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : Expanded(
                              flex: 1,
                              child: ListView.builder(
                                itemCount: categoriesList.length,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        catName =
                                            categoriesList[index].categoryName;
                                        mccCode = categoriesList[index].mccCode;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0,
                                                    top: 10,
                                                    bottom: 0,
                                                    right: 15),
                                                child: Text(
                                                  "${categoriesList[index].categoryName}",
                                                  style: TextStyle(
                                                      color: black,
                                                      fontSize: font14.sp,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                )
              ],
            ));
  }

  _searchContact() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 15, right: 15, left: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          border: Border.all(color: editBg)),
      child: Row(
        children: [
          SizedBox(
            width: 15.w,
          ),
          Expanded(
            flex: 1,
            child: TextFormField(
              style: TextStyle(color: black, fontSize: inputFont.sp),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              controller: searchName,
              textCapitalization: TextCapitalization.characters,
              decoration: new InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10),
                counterText: "",
                hintText: "Search segment",
                hintStyle: TextStyle(color: black),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              maxLength: 20,
              onFieldSubmitted: (val) {
                onSearchNameChanged(val.toString());
              },
              onChanged: (val) {
                setState(() {
                  if (val.length == 0) {
                    showFiltedContact = false;
                  } else {
                    onSearchNameChanged(val.toString());
                  }
                });
              },
            ),
          ),
          SizedBox(
            width: 15.w,
          )
        ],
      ),
    );
  }

  onSearchNameChanged(String text) async {
    printMessage(screen, "Case 0 : $text");
    categoriesFilteredList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    categoriesList.forEach((userDetail) {
      if (userDetail.categoryName
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase())) {
        printMessage(screen, "Case 2 :");
        categoriesFilteredList.add(userDetail);
      }
    });

    setState(() {
      printMessage(screen, "Case 3 : ${categoriesFilteredList.length}");
      if (categoriesFilteredList.length != 0) {
        showFiltedContact = true;
      }
    });
  }
}
