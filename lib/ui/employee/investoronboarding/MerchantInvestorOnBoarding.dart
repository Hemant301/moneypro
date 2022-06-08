import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


import 'package:moneypro_new/utils/SharedPrefs.dart';

class MerchantInvestorOnBoarding extends StatefulWidget {
  final String token;
  const MerchantInvestorOnBoarding({Key? key,required this.token}) : super(key: key);

  @override
  _MerchantInvestorOnBoardingState createState() => _MerchantInvestorOnBoardingState();
}

class _MerchantInvestorOnBoardingState extends State<MerchantInvestorOnBoarding> {

  var screen = "Emp Investor PD";

  TextEditingController fNameController = new TextEditingController();
  TextEditingController lNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController pancardController = new TextEditingController();
  TextEditingController adhaarController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();

  TextEditingController cityController = new TextEditingController();
  TextEditingController street1Controller = new TextEditingController();
  TextEditingController street2Controller = new TextEditingController();
  TextEditingController pinController = new TextEditingController();

  DateTime currentDate = DateTime.now();
  final f = new DateFormat('yyyy-MM-dd');

  var enableAdhar = true;

  var cDate = "";

  var dateSelected = false;

  var selectCatPos = "Select title";

  var loading = false;

  Map map = {};

  @override
  void initState() {
    super.initState();

    fetchUserAccountBalance();
    updateATMStatus(context);
    getUserAllDetails();
  }

  @override
  void dispose() {
    fNameController.dispose();
    lNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    pancardController.dispose();
    adhaarController.dispose();
    pinController.dispose();

    cityController.dispose();
    street1Controller.dispose();
    street2Controller.dispose();
    addressController.dispose();
    super.dispose();
  }

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
            body: (loading)?Center(
              child: circularProgressLoading(40.0),
            ):SingleChildScrollView(
              child: Column(children: [
                Container(
                  margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                  decoration: BoxDecoration(
                      color: editBg,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: editBg)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectCatPos,
                      style: TextStyle(color: black, fontSize: font16),
                      items: investorTitle
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
                          selectCatPos,
                          style: TextStyle(color: lightBlack, fontSize: font16),
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
                          selectCatPos = value!;
                          FocusScope.of(context).requestFocus(new FocusNode());
                        });
                      },
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
                      enabled: false,
                      style: TextStyle(color: black, fontSize: inputFont),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      controller: fNameController,
                      decoration: new InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                        counterText: "",
                        label: Text("First name"),
                      ),
                      maxLength: 100,
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
                      enabled: false,
                      style: TextStyle(color: black, fontSize: inputFont),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      controller: lNameController,
                      decoration: new InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                        counterText: "",
                        label: Text("Last name"),
                      ),
                      maxLength: 40,
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
                      style: TextStyle(color: black, fontSize: inputFont),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      controller: emailController,
                      decoration: new InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                        counterText: "",
                        label: Text("$email"),
                      ),
                      maxLength: 120,
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
                      enabled: false,
                      style: TextStyle(color: black, fontSize: inputFont),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      controller: mobileController,
                      decoration: new InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                        counterText: "",
                        label: Text("Mobile number"),
                      ),
                      maxLength: 10,
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
                      enabled: false,
                      style: TextStyle(color: black, fontSize: inputFont),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.characters,
                      controller: pancardController,
                      decoration: new InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                        counterText: "",
                        label: Text("PAN number"),
                      ),
                      maxLength: 10,
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
                      enabled: enableAdhar,
                      style: TextStyle(color: black, fontSize: inputFont),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      controller: adhaarController,
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
                InkWell(
                  onTap: () {
                    _selectFromDate(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 15, left: padding, right: padding),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: editBg,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 15, top: 10, bottom: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "DOB",
                            style: TextStyle(color: lightBlack, fontSize: font10),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            (dateSelected) ? f.format(currentDate) : cDate,
                            style: TextStyle(color: black, fontSize: font14),
                          ),
                        ],
                      ),
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
                      style: TextStyle(color: black, fontSize: inputFont),
                      keyboardType: TextInputType.streetAddress,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.characters,
                      controller: addressController,
                      decoration: new InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                        counterText: "",
                        label: Text("Address"),
                      ),
                      maxLength: 120,
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
                      style: TextStyle(color: black, fontSize: inputFont),
                      keyboardType: TextInputType.streetAddress,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.characters,
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
                  margin: EdgeInsets.only(top: 15, left: padding, right: padding),
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
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.characters,
                      controller: street1Controller,
                      decoration: new InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                        counterText: "",
                        label: Text("District"),
                      ),
                      maxLength: 120,
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
                      style: TextStyle(color: black, fontSize: inputFont),
                      keyboardType: TextInputType.streetAddress,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.characters,
                      controller: street2Controller,
                      decoration: new InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                        counterText: "",
                        label: Text("State"),
                      ),
                      maxLength: 120,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 15, left: padding, right: padding, bottom: 10),
                  decoration: BoxDecoration(
                    color: editBg,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15, top: 10, bottom: 10),
                    child: TextFormField(
                      style: TextStyle(color: black, fontSize: inputFont),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.characters,
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
              ]),
            ),
            bottomNavigationBar: InkWell(
              onTap: () {
                var dob = "";

                var firstName = fNameController.text.toString();
                var lastName = lNameController.text.toString();

                var emailAddress = emailController.text.toString();
                var mobileNumber = mobileController.text.toString();

                var pancard = pancardController.text.toString();
                var adhar = adhaarController.text.toString();

                var address = addressController.text.toString();

                var street1 = street1Controller.text.toString();
                var street2 = street2Controller.text.toString();
                var city = cityController.text.toString();
                var pin = pinController.text.toString();

                if (city.length > 15) {
                  city = city
                      .toString()
                      .substring(0, city.toString().length - 15);
                }

                if (selectCatPos.toString() == "Select title") {
                  showToastMessage("Please select title");
                  return;
                } else if (firstName.length == 0) {
                  showToastMessage("Please enter First Name");
                  return;
                } else if (firstName.length < 2) {
                  showToastMessage("First Name require at-least 2 characters");
                  return;
                } else if (regExpName.hasMatch(firstName)) {
                  showToastMessage(
                      "Special characters or numbers are not allowed in first name");
                  return;
                } else if (lastName.length == 0) {
                  showToastMessage("Please enter Last Name");
                  return;
                }else if (regExpName.hasMatch(lastName)) {
                  showToastMessage(
                      "Special characters or numbers are not allowed in last name");
                  return;
                } else if (emailAddress.length == 0) {
                  showToastMessage("Please enter your Email");
                  return;
                } else if (!emailPattern.hasMatch(emailAddress)) {
                  showToastMessage("Invalid email");
                  return;
                } else if (mobileNumber.length == 0) {
                  showToastMessage("Please enter Mobile Number");
                  return;
                } else if (mobileNumber.length != 10) {
                  showToastMessage("Mobile number must 10 digits");
                  return;
                } else if (!mobilePattern.hasMatch(mobileNumber)) {
                  showToastMessage("Please enter valid Mobile Number");
                  return;
                } else if (pancard.length != 10) {
                  showToastMessage("Please enter valid 10 digit PAN card number");
                  return;
                } else if (adhar.length != 12) {
                  showToastMessage(
                      "Please enter valid 12 digit Adhaar card number");
                  return;
                } else if (address.length == 0) {
                  showToastMessage("Please enter your complete address");
                  return;
                } else if (city.length == 0) {
                  showToastMessage("Please enter your city");
                  return;
                } else if (street1.length == 0) {
                  showToastMessage("Please enter your district");
                  return;
                } else if (street2.length == 0) {
                  showToastMessage("Please enter your state");
                  return;
                } else if (pin.length != 6) {
                  showToastMessage("Please enter your pin");
                  return;
                }

                if (dateSelected) {
                  dob = f.format(currentDate);
                } else {
                  if (cDate.toString() == "Select DOB") {
                    showToastMessage("select your DOB");
                    return;
                  }

                  DateTime parseDate = new DateFormat("dd-MM-yyyy").parse(cDate);
                  var inputDate = DateTime.parse(parseDate.toString());
                  var outputFormat = DateFormat('yyyy-MM-dd');
                  dob = outputFormat.format(inputDate);
                }

                printMessage(screen, "firstName : $firstName");
                printMessage(screen, "lastName : $lastName");
                printMessage(screen, "mobileNumber : $mobileNumber");
                printMessage(screen, "emailAddress : $emailAddress");
                printMessage(screen, "pancard : $pancard");
                printMessage(screen, "adhar : $adhar");

                printMessage(screen, "dob : $dob");
                printMessage(screen, "address : $address");

                saveInvestorPersonalDetails(
                    selectCatPos,
                    mobileNumber,
                    firstName,
                    lastName,
                    emailAddress,
                    pancard,
                    adhar,
                    dob,
                    address,
                    street1,
                    street2,
                    city,
                    pin);
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 10),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Center(
                  child: Text(
                    continue_.toUpperCase(),
                    style: TextStyle(fontSize: font14, color: white),
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Future getUserAllDetails() async {
    setState(() {
      loading = true;
    });

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {
      "token": "${widget.token}",
    };

    printMessage(screen, "All detail : $body");

    final response = await http.post(Uri.parse(userDetailAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "data : ${data}");

      setState(() {
        loading = false;

        var completeAddress = "";
        var fname = "${data['user']['first_name'].toString()}";
        var lname = "${data['user']['last_name'].toString()}";
        var email = "${data['user']['email'].toString()}";
        var mobile = "${data['user']['mobile'].toString()}";
        var pan = "${data['user']['pan_no'].toString()}";
        var adhar = "${data['user']['adhar'].toString()}";
        var dob = "${data['user']['dob'].toString()}";

        var address = "${data['user']['company_address'].toString()}";
        var city = "${data['user']['city'].toString()}";
        var district = "${data['user']['district'].toString()}";
        var state = "${data['user']['state'].toString()}";
        var pin = "${data['user']['pin'].toString()}";

        var accountNumber = "${data['user']['account_no'].toString()}";
        var ifsc = "${data['user']['ifsc'].toString()}";
        var accountName = "${data['user']['contact_name'].toString()}";

        map = {
          "token": "${widget.token}",
          "accountNumber": "$accountNumber",
          "ifsc": "$ifsc",
          "fname": "$fname",
          "lname": "$lname",
          "pan": "$pan",
          "accountName": "$accountName"
        };

        if (dob.toString() == "" || dob.toString() == "null") {
          setState(() {
            dob = "Select DOB";
          });
        }

        fNameController = TextEditingController(text: "${fname.toString()}");
        lNameController = TextEditingController(text: "${lname.toString()}");
        emailController = TextEditingController(text: "${email.toString()}");
        mobileController = TextEditingController(text: "${mobile.toString()}");
        pancardController = TextEditingController(text: "${pan.toString()}");
        adhaarController = TextEditingController(text: "${adhar.toString()}");
        cDate = dob.toString();
        addressController = TextEditingController(text: "${address.toString()}");


        cityController = TextEditingController(text: "${city.toString()}");
        street1Controller = TextEditingController(text: "${district.toString()}");
        street2Controller = TextEditingController(text: "${state.toString()}");
        pinController = TextEditingController(text: "${pin.toString()}");
      });
    }else{
      setState(() {
        loading = false;
      });
      showToastMessage(status500);
    }


  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1947),
        lastDate: currentDate);
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        dateSelected = true;
        currentDate = pickedDate;
      });
  }

  Future saveInvestorPersonalDetails(title,mobile, fname, lname, email, pan, adhar,
      dob, address, street1, street2, city, pin) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var role = await getRole();
    var empId = await getEmployeeId();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "token": "${widget.token}",
      "title":"$title",
      "mobile": "$mobile",
      "fname": "$fname",
      "lname": "$lname",
      "email": "$email",
      "pan": "$pan",
      "adhar": "$adhar",
      "dob": "$dob",
      "address": "$address",
      "reg_by": (role.toString() == "2") ? "$empId" : "Self",
      "street1": "$street1",
      "street2": "$street2",
      "city": "$city",
      "pin": "$pin",
    };

    printMessage(screen, "Passing body : $body");

    final response = await http.post(Uri.parse(investorRegistorAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Status Code: ${response.statusCode}");
      printMessage(screen, "Response : $data");

      setState(() {
        Navigator.pop(context);
        if (data['status'].toString() == "1") {
          showToastMessage(data['message'].toString());
          openMerchantInvestorBank(context, map);
        } else if (data['status'].toString() == "5") {
          showToastMessage(data['message'].toString());
          openMerchantInvestorBank(context, map);
        } else if (data['status'].toString() == "3") {
          showToastMessage(data['message'].toString());
          openMerchantInvestorBank(context, map);
        } else {
          showToastMessage(data['message'].toString());
        }
      });
    }else{
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }


  }
}
