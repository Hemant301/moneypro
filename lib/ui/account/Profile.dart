import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';

class Profile extends StatefulWidget {
  final String profilePic;
  final String profilePicId;

  const Profile(
      {Key? key, required this.profilePic, required this.profilePicId})
      : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var screen = "Profile Pic";

  var userProfilePic = "";
  var userProfileId = "";
  var name;
  var mobile;

  var accountNo;
  var ifsc;
  var branch;
  var virtualAccountsId;
  var virtualAccountNumber;
  var virtualAccountIfscCode;

  var invVirtualAccount;
  var invIFSC;
  var invBankName;
  var invHolderName;
  var invBranch;
  var invAccountType;

  var completeAddress;
  var companyName;
  var _audioSound = false;
  var _fingerPrint = false;
  var _WhatsAppEnable = false;

  var loading = false;

  var email;

  var isInvestAcc = false;

  var selectCatPos;
  var lngConvt = "en";

  @override
  void initState() {
    super.initState();

    setState(() {
      userProfilePic = widget.profilePic;
      userProfileId = widget.profilePicId;
    });

    printMessage(screen, "userProfilePic :$userProfilePic");
    getUserDetails();
    getInvestorKycStatus();
  }

  getUserDetails() async {
    mobile = await getMobile();
    var fname = await getFirstName();
    var lname = await getLastName();
    email = await getEmail();
    var pan = await getPANNo();
    var adhar = await getAdhar();

    var dob = await getDOB();
    var address = await getCompanyAddress();
    var city = await getCity();
    var district = await getDistrict();
    var state = await getState();
    var pin = await getPinCode();

    companyName = await getComapanyName();

    var contactName = await getContactName();
    accountNo = await getAccountNumber();
    ifsc = await getIFSC();
    branch = await getBranchCity();

    virtualAccountsId = await getVirtualAccId();
    virtualAccountNumber = await getVirtualAccNo();
    virtualAccountIfscCode = await getVirtualAccIFSC();

    var adVal = await getAudioSound();
    var scVal = await getfingerprint();
    var wmVal = await getWhastAppValue();

    if (address.toString() == "" || address.toString() == "null") {
      setState(() {
        completeAddress = "";
      });
    } else {
      setState(() {
        completeAddress = "$address $district $city $state $pin";
      });
    }

    if (contactName.toString() == "" || contactName.toString() == "null") {
      name = "$fname $lname";
    } else {
      name = "$contactName";
    }

    var lTy = await getLngType();

    if (lTy.toString().toLowerCase() == "en") {
      setState(() {
        selectCatPos = "English";
      });
    } else if (lTy.toString().toLowerCase() == "hi") {
      setState(() {
        selectCatPos = "Hindi";
      });
    } else if (lTy.toString().toLowerCase() == "bn") {
      setState(() {
        selectCatPos = "Bengali";
      });
    }

    printMessage(screen, "WhatsApp : $wmVal");

    setState(() {
      _audioSound = adVal;
      _fingerPrint = scVal;

      if (wmVal.toString() == "No") {
        _WhatsAppEnable = false;
      } else {
        _WhatsAppEnable = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => WillPopScope(
              onWillPop: () async {
                printMessage(screen, "Mobile back pressed");
                removeAllPages(context);
                return true;
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
                            removeAllPages(context);
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
                      ),
                      body: (loading)
                          ? Center(
                              child: circularProgressLoading(40.0),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                  SizedBox(
                                    height: 20.h.h,
                                  ),
                                  (userProfilePic.toString() == "")
                                      ? InkWell(
                                          onTap: () {
                                            _showCameraGalleryOption();
                                          },
                                          child: Container(
                                            width: 150.0.w,
                                            height: 150.0.h,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/ic_dummy_user.png'),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(80.0)),
                                              border: Border.all(
                                                color: blue,
                                                width: 4.0.w,
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  bottom: 1,
                                                  right: 60,
                                                  child: Image.asset(
                                                    'assets/ic_user.png',
                                                    height: 24.h,
                                                    color: white,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            _showCameraGalleryOption();
                                          },
                                          child: Container(
                                            width: 150.0.w,
                                            height: 150.0.h,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff7c94b6),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    userProfilePic),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(80.0)),
                                              border: Border.all(
                                                color: blue,
                                                width: 4.0.w,
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  bottom: 1,
                                                  right: 60,
                                                  child: Image.asset(
                                                    'assets/ic_user.png',
                                                    height: 24.h,
                                                    color: white,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                  _navigateToPeronaldetail(),
                                  _navigateToBusinessdetail(),
                                  _navigateTobanckacdetail(),
                                  // _buildPersolDetails(),
                                  // _buildPrimaryAccount(),
                                  // _buildVirtualAccount(),
                                  (isInvestAcc)
                                      ? _buildInvestorAccount()
                                      : Container(),
                                  _buildNotification(),
                                ])))),
            ));
  }

  _navigateToPeronaldetail() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/personaldetail');
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width - 30,
        margin: EdgeInsets.only(top: 15, left: padding, right: padding),
        decoration: BoxDecoration(
          color: editBg,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Personal Details",
                style: TextStyle(
                    color: black,
                    fontSize: font18.sp,
                    fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 15,
              )
            ],
          ),
        ),
      ),
    );
  }

  _navigateToBusinessdetail() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/businessprofile');
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width - 30,
        margin: EdgeInsets.only(top: 15, left: padding, right: padding),
        decoration: BoxDecoration(
          color: editBg,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Business Details",
                style: TextStyle(
                    color: black,
                    fontSize: font18.sp,
                    fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 15,
              )
            ],
          ),
        ),
      ),
    );
  }

  _navigateTobanckacdetail() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/addaccount');
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width - 30,
        margin: EdgeInsets.only(top: 15, left: padding, right: padding),
        decoration: BoxDecoration(
          color: editBg,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Bank Account Details",
                style: TextStyle(
                    color: black,
                    fontSize: font18.sp,
                    fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 15,
              )
            ],
          ),
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
                        height: 20.h.h,
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
        printMessage(screen,
            "File Size Before : ${getFileSizeString(bytes: _image.lengthSync())}");
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
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(
                message: "Please wait, while uploading your profile picture.");
          });
    });

    String fileName = file.path.split('/').last;

    var token = await getToken();

    FormData data = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      "token": token,
      "id": "$userProfileId"
    });

    printMessage(screen, "Passing Fields data : ${data.fields}");
    printMessage(screen, "Passing data : ${data.files}");

    Dio dio = new Dio();

    dio.post(profileUpdateAPI, data: data).then((response) {
      var msg = jsonDecode(response.toString());

      printMessage(screen, "Status Code : ${msg['message']}");
      if (response.statusCode == 200) {
        var msg = jsonDecode(response.toString());

        printMessage(screen, "Profile response : $msg");

        showToastMessage(msg['message'].toString());
        var status = msg['status'].toString();
        setState(() {
          getUserProfilePic();
        });
      } else {
        printMessage(screen, "Error : ${response}");
        showToastMessage(status500);
      }
      setState(() {
        Navigator.pop(context);
      });
    }).catchError((error) => print(error));
  }

  Future getUserProfilePic() async {
    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {
      "token": "$token",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(getUserProfileAPI),
        body: jsonEncode(body), headers: headers);

    setState(() {
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        printMessage(screen, "Profile Image : ${data}");
        if (data['status'].toString() == "1") {
          var img = data['selfi'].toString();
          var picId = data['id'].toString();
          if (img.toString() != "" && img.toString() != "null") {
            userProfilePic = "$profilePicBase$img";
            userProfileId = picId;
          }
        }
      }
    });

    //createWalletList();
  }

  Future getInvestorKycStatus() async {
    setState(() {
      loading = true;
    });

    var mobile = await getMobile();
    var pan = await getPANNo();

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {
      "mobile": mobile,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(investorKycStatusAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response statusCode : ${data}");

      setState(() {
        loading = false;

        if (data['status'].toString() == "1") {
          invVirtualAccount =
              data['profile_data']['virtual_account'].toString();
          invIFSC = data['profile_data']['IFSC'].toString();
          invBankName = data['profile_data']['bank_name'].toString();
          invHolderName = data['profile_data']['holder_name'].toString();
          invBranch = data['profile_data']['branch'].toString();
          invAccountType = data['profile_data']['account_type'].toString();
          isInvestAcc = true;
        } else {
          isInvestAcc = false;
        }
      });
    } else {
      setState(() {
        loading = false;
        showToastMessage(status500);
      });
    }
  }

  _buildPersolDetails() {
    return Container(
        margin: EdgeInsets.only(top: 15, left: padding, right: padding),
        width: MediaQuery.of(context).size.width - 50,
        decoration: BoxDecoration(
          color: editBg,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: ExpansionTile(
              title: Text(
                "Personal Details",
                style: TextStyle(
                    color: black,
                    fontSize: font18.sp,
                    fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.h.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Name",
                              style: TextStyle(
                                  color: black, fontSize: font14.sp.sp),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              "$name",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: black,
                                  fontSize: font14.sp.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        thickness: 0.5,
                        color: gray,
                      ),
                      SizedBox(
                        height: 20.h.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Email",
                              style:
                                  TextStyle(color: black, fontSize: font14.sp),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              "$email",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: black,
                                  fontSize: font14.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: gray,
                        thickness: 0.5,
                      ),
                      SizedBox(
                        height: 20.h.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Mobile",
                              style:
                                  TextStyle(color: black, fontSize: font14.sp),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              "$mobile",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: black,
                                  fontSize: font14.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: gray,
                        thickness: 0.5,
                      ),
                      SizedBox(
                        height: 20.h.h,
                      ),
                      (companyName.toString() == "null" ||
                              companyName.toString() == "")
                          ? Container()
                          : Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Company Name",
                                    style: TextStyle(
                                        color: black, fontSize: font14.sp),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "$companyName",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: black,
                                        fontSize: font14.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                      (companyName.toString() == "null" ||
                              companyName.toString() == "")
                          ? Container()
                          : Divider(
                              color: gray,
                              thickness: 0.5,
                            ),
                      SizedBox(
                        height: 20.h.h,
                      ),
                      (completeAddress.toString() == "null" ||
                              completeAddress.toString() == "")
                          ? Container()
                          : Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Address",
                                    style: TextStyle(
                                        color: black, fontSize: font14.sp),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "$completeAddress",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: black,
                                        fontSize: font14.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                      (completeAddress.toString() == "null" ||
                              completeAddress.toString() == "")
                          ? Container()
                          : Divider(
                              color: gray,
                              thickness: 0.5,
                            ),
                    ],
                  ),
                )
              ],
            )));
  }

  _buildPrimaryAccount() {
    return Container(
        margin: EdgeInsets.only(top: 15, left: padding, right: padding),
        decoration: BoxDecoration(
          color: editBg,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: ExpansionTile(
              title: Text(
                "Primary Account Details",
                style: TextStyle(
                    color: black,
                    fontSize: font18.sp,
                    fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.h.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Name",
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "$name",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font14.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: gray,
                          ),
                          SizedBox(
                            height: 20.h.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Account No",
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "$accountNo",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font14.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: gray,
                          ),
                          SizedBox(
                            height: 20.h.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "IFSC Code",
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "$ifsc",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font14.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: gray,
                          ),
                          SizedBox(
                            height: 20.h.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Branch",
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "$branch",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font14.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: gray,
                          ),
                        ]))
              ],
            )));
  }

  _buildVirtualAccount() {
    return Container(
        margin: EdgeInsets.only(top: 15, left: padding, right: padding),
        decoration: BoxDecoration(
          color: editBg,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: ExpansionTile(
              title: Text(
                "Account Details",
                style: TextStyle(
                    color: black,
                    fontSize: font18.sp,
                    fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.h.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Name",
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "$name",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font14.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: gray,
                          ),
                          SizedBox(
                            height: 20.h.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Id",
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "$virtualAccountsId",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font14.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: gray,
                          ),
                          SizedBox(
                            height: 20.h.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Account No",
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "$virtualAccountNumber",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font14.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: gray,
                          ),
                          SizedBox(
                            height: 20.h.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "IFSC Code",
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "$virtualAccountIfscCode",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font14.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: gray,
                          ),
                        ]))
              ],
            )));
  }

  _buildInvestorAccount() {
    return Container(
        margin: EdgeInsets.only(top: 15, left: padding, right: padding),
        decoration: BoxDecoration(
          color: editBg,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: ExpansionTile(
              title: Text(
                "Investor Account Details",
                style: TextStyle(
                    color: black,
                    fontSize: font18.sp,
                    fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Name",
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "$invHolderName",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font14.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: gray,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Bank Name",
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "$invBankName",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font14.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: gray,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Account No",
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "$invVirtualAccount",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font14.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: gray,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "IFSC Code",
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "$invIFSC",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font14.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: gray,
                          ),
                        ]))
              ],
            )));
  }

  _buildNotification() {
    return Container(
      margin: EdgeInsets.only(top: 15, left: padding, right: padding),
      decoration: BoxDecoration(
        color: editBg,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20, bottom: 20),
            child: Text(
              "Settings",
              style: TextStyle(
                  color: black,
                  fontSize: font18.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 0, bottom: 20),
            child: Row(
              children: [
                Image.asset(
                  'assets/audio_alert.png',
                  height: 20.h,
                  width: 20.w,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  audioAlert,
                  style: TextStyle(color: black, fontSize: font15.sp),
                ),
                Spacer(),
                FlutterSwitch(
                    width: 55.0.w,
                    height: 24.0.h,
                    valueFontSize: 14.0.sp,
                    toggleSize: 24.0,
                    activeText: "",
                    inactiveText: "",
                    value: _audioSound,
                    borderRadius: 30.0,
                    padding: 4.0,
                    showOnOff: true,
                    onToggle: (value) {
                      setState(() {
                        _audioSound = value;
                        saveAudioSound(_audioSound);
                      });
                    }),
                SizedBox(
                  width: 15.w,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 0, bottom: 20),
            child: Row(
              children: [
                Image.asset(
                  'assets/fingerprint.png',
                  height: 20.h,
                  width: 20.w,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  screenLock,
                  style: TextStyle(color: black, fontSize: font15.sp),
                ),
                Spacer(),
                FlutterSwitch(
                    width: 55.0.w,
                    height: 24.0.h,
                    valueFontSize: 14.0.sp,
                    toggleSize: 24.0,
                    activeText: "",
                    inactiveText: "",
                    value: _fingerPrint,
                    borderRadius: 30.0,
                    padding: 4.0,
                    showOnOff: true,
                    onToggle: (value) {
                      setState(() {
                        _fingerPrint = value;
                        saveFingerprint(_fingerPrint);
                      });
                    }),
                SizedBox(
                  width: 15.w,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 0, bottom: 0),
            child: Row(
              children: [
                Image.asset(
                  'assets/whatsapp.png',
                  height: 20.h,
                  width: 20.w,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "WhatsApp Notifications",
                    style: TextStyle(color: black, fontSize: font15.sp),
                  ),
                ),
                FlutterSwitch(
                    width: 55.0.w,
                    height: 24.0.h,
                    valueFontSize: 14.0.sp,
                    toggleSize: 24.0,
                    activeText: "",
                    inactiveText: "",
                    value: _WhatsAppEnable,
                    borderRadius: 30.0,
                    padding: 4.0,
                    showOnOff: true,
                    onToggle: (value) {
                      setState(() {
                        _WhatsAppEnable = value;
                        // changeWhatsAppStats();

                        printMessage(screen, "Value : $_WhatsAppEnable");

                        if (_WhatsAppEnable) {
                          WhatsAppOptIn();
                        } else {
                          WhatsAppOptOut();
                        }
                      });
                    }),
                SizedBox(
                  width: 15.w,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20, top: 0, bottom: 20),
            child: Row(
              children: [
                Image.asset(
                  'assets/lang_transle.png',
                  height: 20.h,
                  width: 20.w,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectCatPos,
                        style: TextStyle(color: black, fontSize: font16.sp),
                        items: notificationSound
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text(
                                value,
                                style: TextStyle(color: black),
                              ),
                            ),
                          );
                        }).toList(),
                        hint: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Text(
                            "Select Language",
                            style: TextStyle(
                                color: lightBlack, fontSize: font16.sp),
                          ),
                        ),
                        icon: Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: Icon(
                            Icons.keyboard_arrow_down, // Add this
                            color: lightBlue, // Add this
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectCatPos = value!;
                            printMessage(
                                screen, "Selected lang : $selectCatPos");
                            if (selectCatPos.toString() == "English") {
                              saveLngType("en");
                            } else if (selectCatPos.toString() == "Hindi") {
                              saveLngType("hi");
                            } else if (selectCatPos.toString() == "Bengali") {
                              saveLngType("bn");
                            } else {
                              saveLngType("en");
                            }

                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future WhatsAppOptIn() async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var mobile = await getMobile();
    var userToken = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {"mobile": mobile, "user_token": "$userToken"};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(optInWpAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;
    Navigator.pop(context);
    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      printMessage(screen, "Whats Data : $data");

      if (data['status'].toString() == "1") {
        saveWhastAppValue("Yes");
      }
    } else {
      setState(() {});
      showToastMessage(status500);
    }
  }

  Future WhatsAppOptOut() async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var mobile = await getMobile();
    var userToken = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {"mobile": mobile, "user_token": "$userToken"};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(optOutWpAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;
    Navigator.pop(context);
    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      printMessage(screen, "Whats Data : $data");

      if (data['status'].toString() == "1") {
        saveWhastAppValue("No");
      }
    } else {
      setState(() {});
      showToastMessage(status500);
    }
  }
}
