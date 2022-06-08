import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddMember extends StatefulWidget {
  const AddMember({Key? key}) : super(key: key);

  @override
  _AddMemberState createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  var screen = "Add Member";

  TextEditingController mobileController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();

  var selectCatPos = "Select role";

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
      backgroundColor: white,
      appBar: appBarHome(context, "", 24.0),
      body: SingleChildScrollView(
        child: Column(
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
                    "assets/add_team_banner.png",
                    fit: BoxFit.fill,
                    height: 210.h,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              "Add Team Member",
              style: TextStyle(
                  color: black, fontSize: font16.sp, fontWeight: FontWeight.w500),
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
                  keyboardType: TextInputType.phone,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                  controller: mobileController,
                  decoration: new InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10),
                    counterText: "",
                    label: Text(
                      "Mobile number",
                      style: TextStyle(color: lightBlack),
                    ),
                  ),
                  maxLength: 10,
                ),
              ),
            ),
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
                  style: TextStyle(color: lightBlack, fontSize: font16.sp),
                  items:
                      memberRole.map<DropdownMenuItem<String>>((String value) {
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
                      style: TextStyle(color: lightBlack, fontSize: font16.sp),
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
                  style: TextStyle(color: black, fontSize: inputFont.sp),
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                  controller: nameController,
                  decoration: new InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10),
                    counterText: "",
                    label: Text(
                      "Name (Optional)",
                      style: TextStyle(color: lightBlack),
                    ),
                  ),
                  maxLength: 100,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBotton(),
    )));
  }

  _buildBotton() {
    return Wrap(
      children: [
        Center(
          child: Text(
            addTeamNote,
            style: TextStyle(color: black, fontSize: font14.sp),
          ),
        ),
        InkWell(
          onTap: () {
            var mobileNumber = mobileController.text.toString();
            var name = nameController.text.toString();
            printMessage(screen, "Role : $selectCatPos");

            if (mobileNumber.length == 0) {
              showToastMessage("Please enter Mobile Number");
              return;
            } else if (mobileNumber.length != 10) {
              showToastMessage("Mobile number must 10 digits");
              return;
            } else if (!mobilePattern.hasMatch(mobileNumber)) {
              showToastMessage("Please enter valid Mobile Number");
              return;
            } else if (selectCatPos.toString() == "Select role") {
              showToastMessage("Select role");
              return;
            }

            addNewMember(mobileNumber);
          },
          child: Container(
            height: 45.h,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 10),
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Center(
              child: Text(
                "Add Member",
                style: TextStyle(fontSize: font16.sp, color: white),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future addNewMember(mobile) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {"token": "$token", "mobile": "$mobile"};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(addTeamAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Add Team Response : $data");

      setState(() {
        Navigator.pop(context);
        if (data['status'].toString() == "1") {
          closeCurrentPage(context);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return showMessageDialog(
                  message: data['message'].toString(),
                  action: 1,
                );
              });
        } else {
          showToastMessage("${data['message'].toString()}");
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
