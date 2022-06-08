import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moneypro_new/ui/models/QRImages.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';



class RequestQR extends StatefulWidget {
  const RequestQR({Key? key}) : super(key: key);

  @override
  _RequestQRState createState() => _RequestQRState();
}

class _RequestQRState extends State<RequestQR> {
  var screen = "Request QR";

  List<String> accNames = [];
  var selectedAccName;
  var mobileNo = "";

  File customPicFile = new File("");

  var isFileSelected = false;

  int picIndex = -1;
  var pickImageURL = "";
  var pickImageId = "";

  List<Qrimage> qrimages = [];

  TextEditingController qrNumberController = new TextEditingController();

  var loading = false;

  var qrPrefs;

  @override
  void initState() {
    super.initState();
    getQRImages();
    getUserDetails();
  }

  getUserDetails() async {
    var shopName = await getComapanyName();
    var fName = await getFirstName();
    var fLame = await getLastName();
    var name;
    var mobile = await getMobile();

    printMessage(screen, "Shop  Name : $shopName");
    printMessage(screen, "First Name : $fName");
    printMessage(screen, "Last  Name : $fLame");
    printMessage(screen, "Mobile : $mobile");

    setState(() {
      name = "$fName $fLame";
      mobileNo = mobile;
      accNames = [
        "${shopName.toString().toUpperCase()}",
        "${name.toString().toUpperCase()}"
      ];
    });
  }

  @override
  void dispose() {
    qrNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
      backgroundColor: white,
      appBar: appBarHome(context, "", 24.0),
      body: (loading)
          ? Center(
              child: circularProgressLoading(40.0),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                        color: editBg,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: editBg)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedAccName,
                        style: TextStyle(
                            color: black,
                            fontSize: font16.sp,
                            fontWeight: FontWeight.bold),
                        items: accNames
                            .map<DropdownMenuItem<String>>((String value) {
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
                            "Select account name",
                            style:
                                TextStyle(color: lightBlack, fontSize: font16.sp),
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
                            selectedAccName = value!;
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
                        EdgeInsets.only(top: 15, left: padding, right: padding),
                    decoration: BoxDecoration(
                      color: editBg,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, top: 15, bottom: 15),
                      child: Text(
                        mobileNo,
                        style: TextStyle(
                            color: black,
                            fontSize: font16.sp,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, top: 2),
                    child: Text(
                      "Customer will call or SMS you",
                      style: TextStyle(color: lightBlack, fontSize: font12.sp),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0, top: 15),
                      child: Row(
                        children: [
                          Text(
                            "Create your own QR ID",
                            style: TextStyle(
                                color: black,
                                fontSize: font16.sp,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            " (Optional)",
                            style: TextStyle(color: black, fontSize: font14.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(top: 5, left: padding, right: padding),
                    decoration: BoxDecoration(
                      color: editBg,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15, top: 15, bottom: 15),
                      child: TextFormField(
                        style: TextStyle(color: black, fontSize: inputFont.sp),
                        keyboardType: TextInputType.number,
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.next,
                        controller: qrNumberController,
                        decoration: new InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10, right: 10),
                          counterText: "",
                          prefix: Text(
                            "MPQR ",
                            style: TextStyle(color: black, fontSize: inputFont.sp),
                          ),
                          suffix: Text(
                            "@indus ",
                            style: TextStyle(color: black, fontSize: inputFont.sp),
                          ),
                        ),
                        maxLength: 8,
                        onChanged: (val) {
                          if (val.length == 8) {
                            closeKeyBoard(context);
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, top: 2),
                    child: Text(
                      "You may enter any desired 8-digit number",
                      style: TextStyle(color: lightBlack, fontSize: font12.sp),
                    ),
                  ),
                  Container(
                    height: 50.h,
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                        color: editBg,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: editBg)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: qrPrefs,
                        style: TextStyle(color: black, fontSize: font16.sp),
                        items: qrPrefsList
                            .map<DropdownMenuItem<String>>((String value) {
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
                            "Select QR preferences",
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
                            qrPrefs = value!;
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25, top: 20, bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Add Photo",
                              style: TextStyle(
                                  color: black,
                                  fontSize: font16.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0, top: 2),
                              child: Text(
                                "File size upto 5 MB",
                                style: TextStyle(
                                    color: lightBlack, fontSize: font12.sp),
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
                        )
                      ],
                    ),
                  ),
                  (isFileSelected)
                      ? Center(
                          child: Container(
                            width: 130.w,
                            height: 130.h,
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: invBoxBg,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: FileImage(
                                                  File(customPicFile.path)),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    right: 0,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isFileSelected = false;
                                          });
                                        },
                                        child: Image.asset(
                                          'assets/close_menu.png',
                                          height: 40.h,
                                        ))),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, top: 10),
                    child: Text(
                      "Or select single photo from below",
                      style: TextStyle(color: black, fontSize: font16.sp),
                    ),
                  ),
                  _buildCustomImageGrid(),
                ],
              ),
            ),
      bottomNavigationBar: _buildBotton(),
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
        customPicFile = File(pickedFile.path);
        cropImageFunction(customPicFile);
      });
    } else {
      setState(() {
        isFileSelected = false;
      });
    }
  }

  _buildCustomImageGrid() {
    return Container(
      height: 360.h,
      margin: EdgeInsets.only(left: 25, right: 25, top: 10),
      child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          children: List.generate(qrimages.length, (index) {
            return InkWell(
              onTap: () {
                printMessage(screen, "Clicked Index : $index");
                setState(() {
                  picIndex = index;
                  isFileSelected = false;
                  pickImageURL = "$qrImagePath${qrimages[index].image}";
                  pickImageId = "${qrimages[index].id}";
                });
              },
              child: Center(
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Stack(
                            children: [
                              Image.network(
                                  "$qrImagePath${qrimages[index].image}"),
                              (picIndex == index)
                                  ? Positioned(
                                      right: 5,
                                      top: 5,
                                      child: Image.asset(
                                        'assets/checked.png',
                                        height: 16.h,
                                      ))
                                  : Container()
                            ],
                          ))),
                ),
              ),
            );
          })),
    );
  }

  _buildBotton() {
    return InkWell(
      onTap: () {
        if (selectedAccName == null || selectedAccName == "null") {
          showToastMessage("Select your account name");
          return;
        } else if (qrPrefs.toString() == "null") {
          showToastMessage("Select QR preferences");
          return;
        }

        printMessage(screen, "File length : ${customPicFile.path.length}");

        if (customPicFile.path.length == 0) {
          generateQRWithoutFile();
        } else {
          generateQRWithFile(customPicFile);
        }
      },
      child: Container(
        height: 45.h,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 10),
        decoration: BoxDecoration(
          color: lightBlue,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Center(
          child: Text(
            "QR Preview",
            style: TextStyle(fontSize: font16.sp, color: white),
          ),
        ),
      ),
    );
  }

  Future generateQRWithoutFile() async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var token = await getToken();
    var qrNo = qrNumberController.text.toString();
    var finalQR = "MPAQ$qrNo@indus";

    if (selectedAccName.length > 20) {
      selectedAccName = selectedAccName
          .toString()
          .substring(0, selectedAccName.toString().length - 20);
    }

    printMessage(screen, "Compant Name : $selectedAccName");

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "token": "$token",
      "company_name": "$selectedAccName",
      "image_id": "",
      "vpa": (qrNo.length == 0) ? "" : "MPQR$qrNo",
      "size": "$qrPrefs",
    };

    printMessage(screen, "headers : $body");

    final response = await http.post(Uri.parse(generateCustomQRAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Generate QR : $data");

      setState(() {
        Navigator.pop(context);
        if (data['status'].toString() == "1") {
          if (data.toString().contains("qrString")) {
            var qrString = "${data['qrString'].toString()}";

            qrString = qrString.replaceAll(RegExp('data:image/png;base64,'), '');

            var vpa = "${data['vpa'].toString()}";

            printMessage(screen, "VPA--> : $vpa");

            Map map = {
              "name": "$selectedAccName",
              "mobile": "$mobileNo",
              "custQR": "$vpa",
              "qrNo": "$qrNo",
              "pickImage": (picIndex != -1) ? "$pickImageURL" : "",
              "qrString": "$qrString",
              "pickImageId": "$pickImageId"
            };
            printMessage(screen, "Pass data : $map");
            openQRPayment(context, map, customPicFile);
          }else{
            showToastMessage(data['message'].toString());
          }
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return showMessageDialog(
                    message: data['message'].toString(), action: 0);
              });
        }
      });
    }else{
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }


  }

  void generateQRWithFile(File file) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    String fileName = file.path.split('/').last;

    var qrNo = qrNumberController.text.toString();
    var finalQR = "MPAQ$qrNo@indus";

    if (selectedAccName.length > 20) {
      selectedAccName = selectedAccName
          .toString()
          .substring(0, selectedAccName.toString().length - 20);
    }

    printMessage(screen, "Compant Name : $selectedAccName");

    var token = await getToken();

    FormData data = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      "token": "$token",
      "company_name": "$selectedAccName",
      "image_id": "",
      "vpa": (qrNo.length == 0) ? "" : "MPQR$qrNo",
      "size": "$qrPrefs",
    });

    Dio dio = new Dio();
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = "$authHeader";

    printMessage(screen, "Data : ${data.fields}");
    printMessage(screen, "Files : ${data.files}");

    dio.post(generateCustomQRAPI, data: data).then((response) {
      Navigator.pop(context);

      if (response.statusCode == 200) {
        var msg = jsonDecode(response.toString());
        var status = msg['status'].toString();
        printMessage(screen, "Status Code : ${msg}");
        setState(() {
          if (status == "1") {
            var qrString = "${msg['qrString'].toString()}";
            qrString =
                qrString.replaceAll(RegExp('data:image/png;base64,'), '');

            var vpa = "${msg['vpa'].toString()}";

            printMessage(screen, "VPA : $vpa");

            Map map = {
              "name": "$selectedAccName",
              "mobile": "$mobileNo",
              "custQR": "$vpa",
              "qrNo": "$qrNo",
              "pickImage": (picIndex != -1) ? "$pickImageURL" : "",
              "qrString": "$qrString",
              "pickImageId": "$pickImageId"
            };
            openQRPayment(context, map, customPicFile);
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return showMessageDialog(
                      message: msg['message'].toString(), action: 0);
                });
          }
        });
      } else {
        printMessage(screen, "Error : ${response}");
        showToastMessage(status500);
      }
    }).catchError((error) => print(error));
  }

  Future getQRImages() async {
    setState(() {
      loading = true;
    });

    final response = await http.post(
      Uri.parse(getImagesQrAPI),
    );

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Generate QR : $data");

      setState(() {
        loading = false;
        if (data['status'].toString() == "1") {
          var result =
          QrImages.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          qrimages = result.qrimages;
        }
      });
    }else{
      setState(() {
        loading = false;
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
      isFileSelected = true;
      picIndex = -1;
      customPicFile = croppedFile!;
    });
  }
}
