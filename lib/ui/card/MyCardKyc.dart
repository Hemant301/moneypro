import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


class MyCardKyc extends StatefulWidget {
  final String authToken;

  const MyCardKyc({Key? key, required this.authToken}) : super(key: key);

  @override
  _MyCardKycState createState() => _MyCardKycState();
}

class _MyCardKycState extends State<MyCardKyc> {
  var screen = "My Card Kyc";

  TextEditingController adharController = new TextEditingController();

  var adhaarNo = "";

  DateTime currentDate = DateTime.now();
  final f = new DateFormat('dd-MM-yyyy');
  final sendFormat = new DateFormat('yyyy-MM-dd');

  var cDate = "";

  String gender = "Male";

  GenderOptions _genderOptions = GenderOptions.male;

  @override
  void initState() {
    super.initState();
    getUserDetails();

    setState(() {});
  }

  getUserDetails() async {
    var adhNo = await getAdhar();

    setState(() {
      adhaarNo = adhNo;
      adharController = TextEditingController(text: adhaarNo);
    });
  }

  @override
  void dispose() {
    adharController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: white,
      appBar: appBarHome(context, "", 24.0),
      body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                "assets/mob_kyc_banner.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 35, left: padding, right: padding),
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
                    style: TextStyle(color: black, fontSize: inputFont),
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.next,
                    controller: adharController,
                    decoration: new InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                      counterText: "",
                      label: Text("Enter your Aadhar Card number"),
                    ),
                    maxLength: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            _selectFromDate(context);
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 5),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    (cDate.toString() == "")
                        ? "Select your DOB"
                        : f.format(currentDate),
                    style: TextStyle(color: black, fontSize: font14),
                  ),
                ),
                Spacer(),
                Image.asset(
                  'assets/calendar.png',
                  height: 24,
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: ListTile(
                dense: false,
                title: const Text('Male'),
                minLeadingWidth: 10.0,
                leading: Radio(
                    value: GenderOptions.male,
                    groupValue: _genderOptions,
                    onChanged: (value) {
                      setState(() {
                        _genderOptions = GenderOptions.male;
                        gender = "Male";
                      });
                    }),
              ),
            ),
            Expanded(
              flex: 1,
              child: ListTile(
                dense: false,
                title: const Text('Female'),
                minLeadingWidth: 10.0,
                leading: Radio(
                    value: GenderOptions.female,
                    groupValue: _genderOptions,
                    onChanged: (value) {
                      setState(() {
                        _genderOptions = GenderOptions.female;
                        gender = "Female";
                      });
                    }),
              ),
            ),
          ],
        ),
      ])),
      bottomNavigationBar: InkWell(
        onTap: () {
          var aadhar = adharController.text.toString();

          if (aadhar.length != 12) {
            showToastMessage("Enter 12-digit aadhar number");
            return;
          } else if (cDate.length == 0) {
            showToastMessage("Select your DOB");
            return;
          }

          var dob = sendFormat.format(currentDate).toString();

          submitRequest(gender, dob, aadhar);
        },
        child: Container(
          height: 45,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 10),
          decoration: BoxDecoration(
            color: lightBlue,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Center(
            child: Text(
              "$submit".toUpperCase(),
              style: TextStyle(fontSize: font16, color: white),
            ),
          ),
        ),
      ),
    ));
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1947),
        lastDate: DateTime.now());
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        cDate = pickedDate.toString();
      });
  }

  Future submitRequest(gender, dob, aadhaar) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var userToken = await getToken();
    var mobile = await getMobile();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": "$userToken",
      "mobile": "$mobile",
      "authToken": "${widget.authToken}",
      "gender": "$gender",
      "dob": "$dob",
      "aadhaar": "$aadhaar"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(userKycCardAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "data : $data");

      setState(() {
        Navigator.pop(context);
        if (data['status'].toString() == "1") {
          showToastMessage(data['message'].toString());
        } else {
          showToastMessage(data['message'].toString());
        }
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
  }
}
