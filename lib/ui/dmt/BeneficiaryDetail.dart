import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


class BeneficiaryDetail extends StatefulWidget {
  final String custId;
  final String senderName;
  final String senderMobile;

  const BeneficiaryDetail(
      {Key? key,
      required this.custId,
      required this.senderName,
      required this.senderMobile})
      : super(key: key);

  @override
  _BeneficiaryDetailState createState() => _BeneficiaryDetailState();
}

class _BeneficiaryDetailState extends State<BeneficiaryDetail> {
  var screen = "Beneficiary";

  var mobile = "";
  final searchController = new TextEditingController();
  var loading = false;
  var searchLoading = false;
  var favrateLoading = false;
  var isSearchCalled = false;
  var isFavrate = false;

  var favourit = "";
  var kyc = "";
  var limit = "";
  var name = "";

  Map customerDetail = {};

  var fChar; // = fname[0];
  var lChar; // = lname[0];

  double moneyProBalc = 0.0;

  var isDataFound = false;

  @override
  void initState() {
    super.initState();
    printMessage(screen, "Cust Id : ${widget.custId}");
    getUserDetail();
    updateATMStatus(context);
    updateWalletBalances();
    fetchUserAccountBalance();
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
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
            backgroundColor: white,
          resizeToAvoidBottomInset: false,
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
                    padding:
                        const EdgeInsets.only(left: 10.0, top: 5, bottom: 5),
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
                              style: TextStyle(color: white, fontSize: font15.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
            body: (loading)
                ? Center(
                    child: circularProgressLoading(40.0),
                  )
                : Column(
                children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    _buildUserProfileSection(),
              (favrateLoading)
                  ? Center(
                child:
                circularProgressLoading( 20.0),
              )
                  : Container(),
                    Expanded(
                        flex: 1,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(top: 30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(50.0)),
                            color: white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 10,
                                blurRadius: 10,
                                offset:
                                    Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20.h,
                                ),
                                Container(
                                  height: 4.h,
                                  width: 50.w,
                                  color: gray,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 20, left: 20, right: 20),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: planBg,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      border: Border.all(color: planBg)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 20,
                                        top: 10,
                                        bottom: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                            height: 45.h,
                                            width: 45.w,
                                            decoration: BoxDecoration(
                                              color: lightBlue, // border color
                                              shape: BoxShape.circle,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                'assets/wallet_white.png',
                                              ),
                                            )),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "BC Limit",
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: font15.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text("$rupeeSymbol $limit",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font18.sp,
                                                    fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, top: 15),
                                      child: InkWell(
                                        onTap: () {
                                          openBeneficiaryTransaction(context, widget.custId, mobile);
                                        },
                                        child: Text(
                                          viewTransaction,
                                          style: TextStyle(
                                              color: black,
                                              fontSize: font16.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                _buildSearchSection(),
                                _buildSearchResult(),
                                SizedBox(height: 20,),
                              ],
                            ),
                          ),
                        ))
                  ]),
        bottomNavigationBar: _buildButtonSection(),)));
  }

  _buildUserProfileSection() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: 20.0, top: 10, bottom: 10, right: 10),
            height: 70.h,
            width: 70.w,
            decoration: BoxDecoration(color: lightBlue, shape: BoxShape.circle),
            child: Center(
              child: Text(
                "$name".toUpperCase(),
                style: TextStyle(color: white, fontSize: 30.sp),
              ),
            ),
          ),
          (mobile.toString() == "")
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "+91-${mobile}",
                    style: TextStyle(
                        color: black,
                        fontSize: font16.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      (isFavrate) ? null : addBeneficiaryToFavrate();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 0, right: 0, left: 0),
                      height: 50.h,
                      decoration: BoxDecoration(
                          color: lightBlue,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          border: Border.all(color: lightBlue)),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/dmtfavourite.png',
                              height: 20.h,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              (isFavrate) ? favourite : addFavourite,
                              style: TextStyle(color: white, fontSize: font14.sp),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      if (kyc == "Approved") {
                        showToastMessage("Your KYC already approved.");
                      } else {
                        _showCameraGalleryOption();
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 0, right: 0, left: 0),
                      height: 50.h,
                      decoration: BoxDecoration(
                          color: dividerSplash,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          border: Border.all(color: lightBlue)),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/dmtTrans.png',
                              height: 20.h,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              (kyc == "Approved") ? "Approved" : upgradeKyc,
                              style:
                                  TextStyle(color: lightBlue, fontSize: font14.sp),
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
        ],
      ),
    );
  }

  getUserDetail() async {
    setState(() {
      loading = true;
    });

    var mechantId = await getMerchantID();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "m_id": mechantId,
      "customer_id": widget.custId,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(dmtSingleCustomerAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        printMessage(screen, "data : $data");

        if (data['status'].toString() == "1") {
          isDataFound = true;
          mobile = data['customer']['mobile'].toString();
          favourit = data['customer']['favourit'].toString();
          kyc = data['customer']['kyc'].toString();
          limit = data['customer']['limit'].toString();
          var customer_name = data['customer']['customer_name'].toString();

          if (favourit.toString() == "1") {
            isFavrate = true;
          } else {
            isFavrate = false;
          }

          if (customer_name.contains(" ")) {
            var parts = customer_name.split(' ');
            fChar = parts[0][0];
            lChar = parts[1][0];
            name = "$fChar$lChar";
            printMessage(screen, "Contain Space : $name");
          } else {
            name = customer_name[0];
            printMessage(screen, "Not Contain Space : $name");
          }
        } else {
          isDataFound = false;
        }
        loading = false;
      });
    }else{
      setState(() {
        isDataFound = false;
        loading = false;
      });
      showToastMessage(status500);
    }


  }

  _buildButtonSection() {
    return InkWell(
      onTap: () {
        openAddBeneficiary(context, widget.custId);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 0, left: 14, right: 15, bottom: 10),
        height: 50.h,
        decoration: BoxDecoration(
            color: lightBlue,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            border: Border.all(color: lightBlue)),
        child: Center(
          child: Text(
            addBeneficiary,
            style: TextStyle(color: white, fontSize: font16.sp),
          ),
        ),
      ),
    );
  }

  _buildSearchSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 20, left: 15, right: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          border: Border.all(color: dividerSplash)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Icon(
              // Add this
              Icons.search,
            ),
          ),
          SizedBox(
            width: 4.w,
          ),
          Expanded(
            flex: 1,
            child: TextFormField(
              textAlign: TextAlign.start,
              style: TextStyle(color: black, fontSize: inputFont.sp),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              controller: searchController,
              decoration: new InputDecoration(
                border: InputBorder.none,
                counterText: "",
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: searchBeneficiary,
                hintStyle: TextStyle(
                  color: lightBlack,
                ),
              ),
              maxLength: 100,
              onFieldSubmitted: (val) {
                printMessage(screen, "Search Text : $val");
                searchBeneficiaryTask(val);
              },
            ),
          ),
          (searchLoading)
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: circularProgressLoading(20.0),
                )
              : Container(),
        ],
      ),
    );
  }

  _buildSearchResult() {
    return (isSearchCalled)
        ? InkWell(
            onTap: () {
              customerDetail['senderName'] = widget.senderName;
              customerDetail['senderMobile'] = widget.senderMobile;
              customerDetail['custId'] = widget.custId;
               openTransferMoney(context, customerDetail);
            },
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  border: Border.all(color: gray)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                        height: 36.h,
                        width: 36.w,
                        decoration: BoxDecoration(
                          color: invBoxBg, // border color
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/user.png',
                            color: lightBlue,
                          ),
                        )),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              "${customerDetail['holderName'].toString()}",
                              style: TextStyle(color: black, fontSize: font15.sp),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              "${customerDetail['accountNumber'].toString()}",
                              style: TextStyle(
                                  color: lightBlack, fontSize: font13.sp),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                          ],
                        )),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: black,
                      size: 16,
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container();
  }

  Future searchBeneficiaryTask(account_no) async {
    setState(() {
      searchLoading = true;
    });

    var mechantId = await getMerchantID();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "m_id": mechantId,
      "customer_id": widget.custId,
      "account_no": account_no,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(dmtSerachBeneficialAPI),
        body: jsonEncode(body), headers: headers);
    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response : $data");

      setState(() {
        searchLoading = false;
        if (data['status'].toString() == "2") {
          showToastMessage(data['message'].toString());
          isSearchCalled = false;
        }
        if (data['status'].toString() == "1") {
          isSearchCalled = true;

          customerDetail['accountNumber'] =
              data['bene_data']['accountNumber'].toString();

          customerDetail['holderName'] =
              data['bene_data']['holderName'].toString();

          customerDetail['mobile'] = data['bene_data']['mobile'].toString();

          customerDetail['ifsc'] = data['bene_data']['ifsc'].toString();

          customerDetail['beneficiary_id'] =
              data['bene_data']['beneficiary_id'].toString();
        }
      });
    }else{
      setState(() {
        searchLoading = false;
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
      _upload(croppedFile!);
    });
  }

  void _upload(File file) async {
    setState(() {
      favrateLoading = true;
    });

    var m_id = await getMerchantID();

    String fileName = file.path.split('/').last;
    FormData data = FormData.fromMap({
      "pan": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      "m_id": m_id,
      "customer_id": widget.custId,
    });

    printMessage(screen, "Sending Data : $data");

    Dio dio = new Dio();
    dio.post(updateKycDmtAPI, data: data,)
        .then((response) {
      var msg = jsonDecode(response.toString());

      printMessage(screen, "Status Code : ${msg['message']}");
      if (response.statusCode == 200) {
        var msg = jsonDecode(response.toString());

        printMessage(screen, "Message : $msg");

        var status = msg['status'].toString();
        setState(() {});
        if (msg['status'].toString() == "1") {
          kyc = "Approved";
        }
        showToastMessage(msg['message'].toString());
      } else {
        printMessage(screen, "Error : ${response}");
      }
      setState(() {
        favrateLoading = false;
      });
    }).catchError((error) => print(error));
  }

  Future addBeneficiaryToFavrate() async {
    setState(() {
      favrateLoading = true;
    });

    var mechantId = await getMerchantID();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "m_id": mechantId,
      "customer_id": widget.custId,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(dmtFavouritCustomerAPI),
        body: jsonEncode(body), headers: headers);
    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response Favrate : $data");

      setState(() {
        favrateLoading = false;
        if (data['status'].toString() == "1") {
          isFavrate = true;
        } else {
          isFavrate = false;
        }
        showToastMessage(data['message'].toString());
      });
    }else{
      setState(() {
        favrateLoading = false;
        isFavrate = false;
      });
      showToastMessage(status500);
    }
//50100045658576

  }
}
