import 'package:flutter/material.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';

class MyAddress extends StatefulWidget {
  const MyAddress({Key? key}) : super(key: key);

  @override
  _MyAddressState createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {

  var screen = "My Address";

  var mobile;
  var fname;
  var lname;
  var email;
  var pan;
  var adhar;
  var token;
  var dob;
  var address;
  var city;
  var district;
  var state;
  var pin;
  var completeAddress;
  var companyName;

  @override
  void initState() {
    super.initState();
    fetchUserAccountBalance();
    updateATMStatus(context);
    getUserDetails();
  }

  getUserDetails() async {
    mobile = await getMobile();
    fname = await getFirstName();
    lname = await getLastName();
    email = await getEmail();
    pan = await getPANNo();
    adhar = await getAdhar();
    token = await getToken();
    dob = await getDOB();
    address = await getCompanyAddress();
    city = await getCity();
    district = await getDistrict();
    state = await getState();
    pin = await getPinCode();
    companyName = await getComapanyName();

    if (address.toString() == "" || address.toString() == "null") {
      adhar = "";
      setState(() {
        completeAddress = "";
      });
    } else {
      setState(() {
        completeAddress = "$address $district $city $state $pin";
      });
    }

    printMessage(
        screen,
        "First Name : $fname\n"
            "Last Name : $lname\n"
            "Mobile : $mobile\n"
            "Email : $email\n"
            "PAN : $pan\n"
            "Adhar : $adhar\n"
            "Token : $token\n"
            "DOB ; $dob\n"
            "Address : $address\n"
            "City : $city\n"
            "District : $district\n"
            "State : $state\n"
            "PIN : $pin\n"
            "Complete Address : $completeAddress");

    setState(() {});
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
        body: Column(
          children: [
            Card(
              margin: EdgeInsets.only(left: 10, right: 10, top: 8),
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    "assets/banner_1.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 20.0, right: 20, top: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Name",
                      style: TextStyle(
                          color: black, fontSize: font14),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      "$fname $lname",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: black,
                          fontSize: font14,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 15.0, right: 15, top: 0),
              child: Divider(
                thickness: 0.5,
                color: gray,
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 20.0, right: 20, top: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Email",
                      style: TextStyle(
                          color: black, fontSize: font14),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      "$email",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: black,
                          fontSize: font14,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 15.0, right: 15, top: 0),
              child: Divider(
                color: gray,
                thickness: 0.5,
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 20.0, right: 20, top: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Mobile",
                      style: TextStyle(
                          color: black, fontSize: font14),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      "$mobile",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: black,
                          fontSize: font14,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 15.0, right: 15, top: 0),
              child: Divider(
                color: gray,
                thickness: 0.5,
              ),
            ),
            (companyName.toString() == "null" ||
                companyName.toString() == "")
                ? Container()
                : Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Company Name",
                      style: TextStyle(
                          color: black, fontSize: font14),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      "$companyName",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: black,
                          fontSize: font14,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
            (companyName.toString() == "null" ||
                companyName.toString() == "")
                ? Container()
                : Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15, top: 0),
              child: Divider(
                color: gray,
                thickness: 0.5,
              ),
            ),
            (completeAddress.toString() == "null" ||
                completeAddress.toString() == "")
                ? Container()
                : Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Address",
                      style: TextStyle(
                          color: black, fontSize: font14),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      "$completeAddress",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: black,
                          fontSize: font14,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
            (completeAddress.toString() == "null" ||
                completeAddress.toString() == "")
                ? Container()
                : Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15, top: 0),
              child: Divider(
                color: gray,
                thickness: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
