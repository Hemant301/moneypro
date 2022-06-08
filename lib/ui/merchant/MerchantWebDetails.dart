import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/ui/models/Categories.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../utils/AppKeys.dart';
import '../../utils/Constants.dart';
import '../../utils/SharedPrefs.dart';

class MerchantWebDetails extends StatefulWidget {
  const MerchantWebDetails({Key? key}) : super(key: key);

  @override
  State<MerchantWebDetails> createState() => _MerchantWebDetailsState();
}

class _MerchantWebDetailsState extends State<MerchantWebDetails> {

  var screen = "Merchant Web Details";


  final qrDisplayNameController = new TextEditingController();
  final panController = new TextEditingController();
  TextEditingController panNameController = new TextEditingController();
  final gstController = new TextEditingController();
  final searchName = new TextEditingController();

  List<Category> categoriesList = [];
  List<Category> categoriesFilteredList = [];
  Category distL = new Category();
  var mccCode;
  var catName = "Select segment";
  var selectSegPos;
  var showFiltedContact = false;
  var loading = false;
  var loadPan = false;
  var name = "";
  var isValidPan = false;


  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    fetchUserAccountBalance();
    getCategoies();
  }

  @override
  void dispose() {
    qrDisplayNameController.dispose();
    panController.dispose();
    panNameController.dispose();
    gstController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
      child: Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: white,
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
      body: (loading)?Center(
        child: circularProgressLoading(40.0),
      ):SingleChildScrollView(
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
              const EdgeInsets.only(left: 25.0, top: 5, bottom: 0),
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
                        style: TextStyle(color: black, fontSize: inputFont.sp),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.done,
                        controller: gstController,
                        decoration: new InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10),
                          counterText: "",
                          label: Text("Enter GST Number"),
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 5),
              child: Text(
                "$gstEnable",
                style: TextStyle(color: lightBlue, fontSize: font10.sp),
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
              var qrDisplayName = qrDisplayNameController.text.toString();
              var gstNo = gstController.text.toString();

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
              }else if(gstNo.length!=0){
                if(gstNo.length!=15){
                  showToastMessage("Enter vaild 15-digit GST number.");
                  return;
                }
              }

              printMessage(screen, "PAN Number : $pan");
              printMessage(screen, "PAN Name : $panName");
              printMessage(screen, "QR Name : $qrDisplayName");
              printMessage(screen, "Business Cat : $selectSegPos");
              printMessage(screen, "MCC Code : $mccCode");
              printMessage(screen, "GST no. : $gstNo");

              submitDetails(gstNo,panName,qrDisplayName,mccCode);

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
        ),))
    );
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

  Future submitDetails(gstNo,panName, qrDisplayName, mccCode) async {

    var userToken = await getToken();

    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var body = {
      "token":"$userToken",
      "pan_name":"$panName",
      "gst_no":"$gstNo",
      "qr_display_name":"$qrDisplayName",
      "mcc_code":"$mccCode"
    };

    var header = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final response = await http.post(Uri.parse(userUpdateWebAPI), body: jsonEncode(body), headers: header);

    var data = json.decode(response.body);

    printMessage(screen, "Update respnse : $data");

    setState(() {
      Navigator.pop(context);
      if(data['status'].toString()=="1"){
        openPaymentOptions(context);
      }else{

      }

    });
  }


}
