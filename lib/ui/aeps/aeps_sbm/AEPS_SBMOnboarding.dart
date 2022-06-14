import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/ui/models/District.dart';
import 'package:moneypro_new/ui/models/States.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/AppKeys.dart';

class AEPS_SBMOnboarding extends StatefulWidget {
  final String pipe;
  const AEPS_SBMOnboarding({Key? key, required this.pipe}) : super(key: key);

  @override
  _AEPS_SBMOnboardingState createState() => _AEPS_SBMOnboardingState();
}

class _AEPS_SBMOnboardingState extends State<AEPS_SBMOnboarding> {
  var screen = "AEPS on Boarding";

  TextEditingController merchatController = new TextEditingController();
  TextEditingController customerController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController pinController = new TextEditingController();
  TextEditingController aadharController = new TextEditingController();

  var loading = false;

  var isImageAttached = false;

  late File _image;

  var loadingDist = false;

  List<Datum> stateLists = [];
  List<DistrictList> districtList = [];

  Datum dState = new Datum();
  DistrictList distL = new DistrictList();

  var authToken;

  var stateName = "";
  var districtName = "";
  var stateId = "";
  var districtId = "";

  var enable1 = true;
  var enable2 = true;
  var enable3 = true;
  var enable4 = true;
  var enable5 = true;
  var enable6 = true;

  var ekycPrimaryKeyId;
  var ekycTxnId;

  var loadresend = false;

  var regType = "";

  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    getATMAuthToken();
    getUserDetails();
    fetchUserAccountBalance();
  }

  getUserDetails() async {
    var mName = await getComapanyName();
    var cFName = await getFirstName();
    var cLName = await getLastName();
    var cEmail = await getEmail();
    var cAdd = await getCompanyAddress();
    var cPin = await getPinCode();
    var cAdhar = await getAdhar();

    var rType = await getUserType();

    printMessage(
        screen,
        "Merchant Name : $mName\n"
        "First Name : $cFName\n"
        "Last Name : $cLName\n"
        "Email : $cEmail\n"
        "Address : $cAdd\n"
        "Pin : $cPin\n"
        "Adhar : $cAdhar");

    setState(() {
      if (mName.toString() == "") {
        enable1 = true;
      }
      if (cFName.toString() == "") {
        enable2 = true;
      }
      if (cEmail.toString() == "") {
        enable3 = true;
      }
      if (cAdd.toString() == "") {
        enable4 = true;
      }
      if (cPin.toString() == "") {
        enable5 = true;
      }
      if (cAdhar.toString() == "") {
        enable6 = true;
      }

      regType = rType;

      merchatController = TextEditingController(text: "${mName.toString()}");
      customerController = TextEditingController(
          text: "${cFName.toString()} ${cLName.toString()}");
      emailController = TextEditingController(text: "${cEmail.toString()}");
      addressController = TextEditingController(text: "${cAdd.toString()}");
      pinController = TextEditingController(text: "${cPin.toString()}");
      aadharController = TextEditingController(text: "${cAdhar.toString()}");
    });
  }

  @override
  void dispose() {
    merchatController.dispose();
    customerController.dispose();
    emailController.dispose();
    addressController.dispose();
    cityController.dispose();
    pinController.dispose();
    aadharController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: white,
      appBar: appBarHome(
        context,
        "",
        24.0,
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
                        EdgeInsets.only(top: 15, left: padding, right: padding),
                    decoration: BoxDecoration(
                      color: editBg,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15, top: 10, bottom: 10),
                      child: TextFormField(
                        enabled: enable1,
                        style: TextStyle(color: black, fontSize: inputFont),
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.next,
                        controller: merchatController,
                        decoration: new InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10),
                          counterText: "",
                          label: Text("Merchant name"),
                        ),
                        maxLength: 100,
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(top: 15, left: padding, right: padding),
                    decoration: BoxDecoration(
                      color: editBg,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15, top: 10, bottom: 10),
                      child: TextFormField(
                        enabled: enable2,
                        style: TextStyle(color: black, fontSize: inputFont),
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.next,
                        controller: customerController,
                        decoration: new InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10),
                          counterText: "",
                          label: Text("Customer name"),
                        ),
                        maxLength: 100,
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(top: 15, left: padding, right: padding),
                    decoration: BoxDecoration(
                      color: editBg,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15, top: 10, bottom: 10),
                      child: TextFormField(
                        enabled: enable3,
                        style: TextStyle(color: black, fontSize: inputFont),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        controller: emailController,
                        decoration: new InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10),
                          counterText: "",
                          label: Text("Email"),
                        ),
                        maxLength: 100,
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(top: 15, left: padding, right: padding),
                    decoration: BoxDecoration(
                      color: editBg,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15, top: 10, bottom: 10),
                      child: TextFormField(
                        enabled: enable4,
                        style: TextStyle(color: black, fontSize: inputFont),
                        keyboardType: TextInputType.streetAddress,
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.next,
                        controller: addressController,
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
                    margin:
                        EdgeInsets.only(top: 15, left: padding, right: padding),
                    decoration: BoxDecoration(
                      color: editBg,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Datum>(
                        isExpanded: true,
                        value: dState,
                        style: TextStyle(color: black, fontSize: font16),
                        items: stateLists
                            .map<DropdownMenuItem<Datum>>((Datum value) {
                          return DropdownMenuItem<Datum>(
                            value: value,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    value.value,
                                    style: TextStyle(
                                        color: black,
                                        fontSize: font16,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        icon: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Icon(
                            // Add this
                            Icons.keyboard_arrow_down, // Add this
                            color: Colors.blue, // Add this
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            closeKeyBoard(context);
                            dState = value!;
                            stateName = dState.value;
                            stateId = dState.key;
                            _getCryptString(dState.key.toString());
                          });
                        },
                      ),
                    ),
                  ),
                  (loadingDist)
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: circularProgressLoading(20.0),
                          ),
                        )
                      : Container(),
                  Container(
                    height: 45,
                    margin:
                        EdgeInsets.only(top: 15, left: padding, right: padding),
                    decoration: BoxDecoration(
                      color: editBg,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<DistrictList>(
                        isExpanded: true,
                        value: distL,
                        style: TextStyle(color: black, fontSize: font16),
                        items: districtList.map<DropdownMenuItem<DistrictList>>(
                            (DistrictList value) {
                          return DropdownMenuItem<DistrictList>(
                            value: value,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    value.value,
                                    style: TextStyle(
                                        color: black,
                                        fontSize: font16,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        icon: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Icon(
                            // Add this
                            Icons.keyboard_arrow_down, // Add this
                            color: Colors.blue, // Add this
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            closeKeyBoard(context);
                            distL = value!;
                            districtId = distL.key;
                            districtName = distL.value;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(top: 15, left: padding, right: padding),
                    decoration: BoxDecoration(
                      color: editBg,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15, top: 10, bottom: 10),
                      child: TextFormField(
                        style: TextStyle(color: black, fontSize: inputFont),
                        keyboardType: TextInputType.streetAddress,
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.next,
                        controller: cityController,
                        decoration: new InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10),
                          counterText: "",
                          label: Text("City"),
                        ),
                        maxLength: 15,
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(top: 15, left: padding, right: padding),
                    decoration: BoxDecoration(
                      color: editBg,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15, top: 10, bottom: 10),
                      child: TextFormField(
                        enabled: enable4,
                        style: TextStyle(color: black, fontSize: inputFont),
                        keyboardType: TextInputType.streetAddress,
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.next,
                        controller: pinController,
                        decoration: new InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10),
                          counterText: "",
                          label: Text("Pincode"),
                        ),
                        maxLength: 6,
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(top: 15, left: padding, right: padding),
                    decoration: BoxDecoration(
                      color: editBg,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15, top: 10, bottom: 10),
                      child: TextFormField(
                        enabled: enable4,
                        style: TextStyle(color: black, fontSize: inputFont),
                        keyboardType: TextInputType.streetAddress,
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.next,
                        controller: aadharController,
                        decoration: new InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10),
                          counterText: "",
                          label: Text("Adhaar number"),
                        ),
                        maxLength: 12,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: InkWell(
                      onTap: () {
                        _showCameraGalleryOption();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 20, bottom: 20),
                        child: Row(
                          children: [
                            Text(
                              uploadFile_,
                              style: TextStyle(color: black, fontSize: font16),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.file_upload,
                              color: black,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              upto5,
                              style: TextStyle(color: black, fontSize: font16),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            (isImageAttached)
                                ? Text(
                                    "File Attached",
                                    style: TextStyle(
                                        color: black, fontSize: font16),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                  ),
                ])),
      bottomNavigationBar: _buildBottomSection(),
    ));
  }

  _buildBottomSection() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              var mId = await getMATMMerchantId();
              setState(() {
                if (isImageAttached) {
                  closeKeyBoard(context);
                  submitATMData(_image);
                } else {
                  showToastMessage("Select aadhar card copy");
                }
              });
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 0),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Center(
                child: Text(
                  submit.toUpperCase(),
                  style: TextStyle(fontSize: font16, color: white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getATMAuthToken() async {
    setState(() {
      loading = true;
    });

    var header = {
      "secretKey": "$atmSecrettKey",
      "saltKey": "$atmSaltKey",
      "encryptdecryptKey": "$atmEncDecKey"
    };

    final response = await http.post(Uri.parse(authUrl), headers: header);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "TOKEN Data : $data");

    setState(() {
      if (data['isSuccess'].toString() == "true") {
        authToken = data['data']['token'].toString();
        printMessage(screen, "AUTH : $authToken");
        getStateList(authToken);
      } else {
        loading = false;
      }
    });
  }

  Future getStateList(token) async {
    var header = {
      "Authorization": "Bearer $token",
    };

    final response = await http.get(Uri.parse(stateUrl), headers: header);

    var result = States.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "State Data : $data");

    setState(() {
      if (result.isSuccess) {
        Datum dState1 = new Datum(key: "0", value: "Select state");
        stateLists = result.data;
        stateLists.insert(0, dState1);
        dState = stateLists[0];
      }
      loading = false;
    });
  }

  Future _getCryptString(stateId) async {
    String result = "";
    setState(() {
      loadingDist = true;
    });

    printMessage(screen, "State Id : $stateId");

    if (Platform.isAndroid) {
      const platform = const MethodChannel("MICRO_ATM_CHANNEL");

      var arr = {
        "stateId": "$stateId",
      };

      result = await platform.invokeMethod("keyCrypt", arr);
      printMessage(screen, "District Result : $result");
    }

    setState(() {});

    var header = {
      "Authorization": "Bearer $authToken",
      "Content-Type": "application/json"
    };

    printMessage(screen, "Header : $header");

    final response = await http.post(Uri.parse(districtUrl),
        headers: header, body: (result), encoding: Encoding.getByName("utf-8"));

    var d = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "District Response : $d");

    var dataRes =
        District.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

    printMessage(screen, "District Result : $result");

    setState(() {
      if (dataRes.isSuccess) {
        districtList.clear();
        DistrictList dState1 =
            new DistrictList(key: "0", value: "Select district");
        districtList = dataRes.data;
        districtList.insert(0, dState1);
        distL = districtList[0];
      }
      loadingDist = false;
    });
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
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);

    var path = pickedFile!.path.toString();

    if (pickedFile != null) {
      setState(() {
        if (path != null) {
          isImageAttached = true;
          File _image = File(pickedFile.path);
          cropImageFunction(_image);
        } else {
          isImageAttached = false;
        }
      });
    }
  }

  Future submitATMData(File file) async {
    var merchantName = merchatController.text.toString();
    var customerName = customerController.text.toString();
    var email = emailController.text.toString();
    var address = addressController.text.toString();

    var city = cityController.text.toString();

    var pincode = pinController.text.toString();
    var aadharno = aadharController.text.toString();

    if (city.length > 15) {
      city = city.toString().substring(0, city.toString().length - 15);
    }

    if (merchantName.length == 0) {
      showToastMessage("Enter merchant name");
      return;
    } else if (regExpName.hasMatch(merchantName)) {
      showToastMessage(
          "Special characters or numbers are not allowed in merchant name");
      return;
    } else if (customerName.length == 0) {
      showToastMessage("Enter customer name");
      return;
    } else if (regExpName.hasMatch(customerName)) {
      showToastMessage(
          "Special characters or numbers are not allowed in customer name");
      return;
    } else if (email.length == 0) {
      showToastMessage("Enter email address");
      return;
    } else if (!emailPattern.hasMatch(email)) {
      showToastMessage("Invalid email");
      return;
    } else if (address.length == 0) {
      showToastMessage("Enter address");
      return;
    } else if (districtName == "") {
      showToastMessage("Enter your district ");
      return;
    } else if (city.length == 0) {
      showToastMessage("Enter your city");
      return;
    } else if (stateName == "") {
      showToastMessage("Enter your state");
      return;
    } else if (pincode.length != 6) {
      showToastMessage("Enter 6-digit pincode");
      return;
    } else if (aadharno.length != 12) {
      showToastMessage("Enter 12-digit aadhar number");
      return;
    }

    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var m_id = await getMerchantID();

    String fileName = file.path.split('/').last;
    FormData data = FormData.fromMap({
      "adhar": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      "m_id": m_id,
      "adhar_no": aadharno,
      "pin": pincode,
      "state": stateName,
      "district": districtName,
      "city": city,
      "type": "Aeps",
    });

    Dio dio = new Dio();
    dio
        .post(microatmCustomerOnboardingAPI,
            data: data,
            options: Options(
              headers: {"Authorization": "$authHeader"},
            ))
        .then((response) {
      var msg = jsonDecode(response.toString());

      if (response.statusCode == 200) {
        var msg = jsonDecode(response.toString());
        Navigator.pop(context);
        setState(() {});
        if (msg['status'].toString() == "1") {
          _getCryptRegister();
        } else {
          setState(() {
            Navigator.pop(context);
          });
        }
        showToastMessage(msg['message'].toString());
      } else {
        setState(() {
          Navigator.pop(context);
        });
        showToastMessage(status500);
      }
    }).catchError((error) => print(error));
  }

  Future _getCryptRegister() async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var customerName = customerController.text.toString();
    var email = emailController.text.toString();
    var address = addressController.text.toString();
    var panNo = await getPANNo();
    var pincode = pinController.text.toString();
    var aadharno = aadharController.text.toString();
    var mobileNo = await getMobile();
    var shopName = await getComapanyName();

    if (Platform.isAndroid) {
      const platform = const MethodChannel("MICRO_ATM_CHANNEL");
      //"mobileNo": "$mobileNo",

      var arr = {
        "name": "$customerName",
        "email": "$email",
        "mobileNo": "$mobileNo",
        "shopName": "$shopName",
        "address1": "$address",
        "address2": "",
        "pincode": "$pincode",
        "aadhaarNo": "$aadharno",
        "panNo": "$panNo",
        "stateId": "$stateId",
        "districtId": "$districtId"
      };
      String result = await platform.invokeMethod("regCrypt", arr);
      printMessage(screen, "Reg Result : $result");
      print('=========santosh from here');

      var header = {
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/json"
      };

      final response = await http.post(Uri.parse(atmFinalUrl),
          headers: header,
          body: (result),
          encoding: Encoding.getByName("utf-8"));

      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Respi Dtaa : $data");
      print('===marchant id here====');

      setState(() {
        Navigator.pop(context);

        if (data['isSuccess'].toString() == "true") {
          var id = data['data']['merchant_Id'].toString();
          saveAEPSMerchantId('id');

          if (regType.toString().toLowerCase() == "app") {
            rbpUserOnBoarding();
          }
          addMId(id);
        } else {
          //var id = data['data']['merchant_Id'].toString();
          showToastMessage(data['message'].toString());
          //addMId(id);
          rbpUserOnBoarding();
        }
      });
    }
  }

  Future addMId(id) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });
    var mId = await getMerchantID();

    var body = {"m_id": mId, "merchant_id": id, "type": "Aeps"};

    final response =
        await http.post(Uri.parse(microatmMerchantIdAPI), body: body);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Value of Add id : $data");

      setState(() {
        Navigator.pop(context);
        showToastMessage(data['message'].toString());
        removeAllPages(context);
        openAEPSLanding(context, widget.pipe.toString());
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
  }

  Future rbpUserOnBoarding() async {
    setState(() {});

    var userToken = await getToken();
    var mId = await getMerchantID();

    //user_token,stateId,districtId,merchant_id

    var header = {
      "Authorization": "$authHeader",
      "Content-Type": "application/json"
    };

    var body = {
      "user_token": "$userToken",
      "stateId": "$stateId",
      "districtId": "$districtId",
      "merchant_id": "$mId"
    };

    printMessage(screen, "Body On board: $body");

    final response = await http.post(Uri.parse(aepsRbpOnboardingAPI),
        body: jsonEncode(body), headers: header);

    printMessage(screen, "URL: $aepsRbpOnboardingAPI");

    int statusCode = response.statusCode;
    printMessage(screen, "Status code On board : $statusCode");
    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      printMessage(screen, "Value of Add id : $data");
    } else {
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
      _image = croppedFile!;
    });
  }
}
