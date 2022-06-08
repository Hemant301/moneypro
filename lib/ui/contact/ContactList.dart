import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:moneypro_new/ui/models/MPContacts.dart';
import 'package:moneypro_new/ui/models/MyContacts.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:moneypro_new/utils/AppKeys.dart';


class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  var screen = "Contact Screen";

  List<Contact> _contacts = [];

  var loading = false;

  var isCrossShow = false;

  var iOSLocalizedLabels = false;

  List<MyContacts> myContacts = [];

  List<MyContacts> verifiedContacts = [];
  List<Contact> searcheddContacts = [];

  List<Map<String, bool>> phoneListn = [];

  TextEditingController searchName = new TextEditingController();

  var showFiltedContact = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    _askContactPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: white,
          body: (loading)
              ? Center(child: circularProgressLoading(40.0))
              : Stack(
                  children: [
                    _buildTopHeader(),
                     _allContacts(),
                  ],
                )),
    );
  }

  _buildTopHeader() {
    return Container(
      color: lightBlue,
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  closeCurrentPage(context);
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
            ],
          ),
          _searchContact(),
          (verifiedContacts.length==0)?Container():  _verifiedContacts(),
        ],
      ),
    );
  }

  _allContacts() {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 230),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
          color: white,
        ),
        child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
            ), Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 10),
                  child: Text(
                    "All contacts",
                    style: TextStyle(color: black, fontSize: font16, fontWeight: FontWeight.bold),
                  ),
                ),
                (showFiltedContact)? Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15, top: 10, bottom: 10),
                  child: ListView.builder(
                    itemCount: searcheddContacts.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return (searcheddContacts[index].displayName.toString() !=
                          "null" &&
                          searcheddContacts[index].phones?.length != 0)
                          ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            List<Item>? _items = searcheddContacts[index].phones;

                            if (_items?.length != 0) {
                              String? number =
                              _items?[0].value.toString();

                              if (number.toString().contains("-")) {
                                number = number?.replaceAll("-", "");
                              }

                              if (number.toString().contains(" ")) {
                                number = number?.replaceAll(" ", "");
                              }

                              if (number.toString().contains("+")) {
                                number = number.toString().substring(
                                    3, number.toString().length);
                              }

                              if (number.toString().length > 10) {
                                number = number.toString().substring(
                                    1, number.toString().length);
                              }

                              printMessage(
                                  screen, "Phone Number : $number");
                              setState(() {
                                openMobileSelection(context,"$number");
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: lightBlue,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: lightBlue, width: 3)),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image.asset('assets/user.png'),
                                  )/*Text(
                                    "${shortName(searcheddContacts[index].displayName.toString())}"
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )*/,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                searcheddContacts[index].displayName ?? "",
                                style: TextStyle(
                                    color: black,
                                    fontSize: font16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      )
                          : Container();
                    },
                  ),
                ): Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15, top: 10, bottom: 10),
                  child: ListView.builder(
                    itemCount: _contacts.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return (_contacts[index].displayName.toString() !=
                          "null" &&
                          _contacts[index].phones?.length != 0)
                          ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            List<Item>? _items = _contacts[index].phones;

                            if (_items?.length != 0) {
                              String? number =
                              _items?[0].value.toString();

                              if (number.toString().contains("-")) {
                                number = number?.replaceAll("-", "");
                              }

                              if (number.toString().contains(" ")) {
                                number = number?.replaceAll(" ", "");
                              }

                              if (number.toString().contains("+")) {
                                number = number.toString().substring(
                                    3, number.toString().length);
                              }

                              if (number.toString().length > 10) {
                                number = number.toString().substring(
                                    1, number.toString().length);
                              }

                              printMessage(
                                  screen, "Phone Number : $number");
                              setState(() {
                                openMobileSelection(context,"$number");
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: lightBlue,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: lightBlue, width: 3)),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Image.asset('assets/user.png',),
                                  )/*Text(
                                    "${shortName(_contacts[index].displayName.toString())}"
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )*/,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                _contacts[index].displayName ?? "",
                                style: TextStyle(
                                    color: black,
                                    fontSize: font16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      )
                          : Container();
                    },
                  ),
                )
              ])));}

  _searchContact() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 15, right: 15, left: 15),
      height: 50,
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.all(Radius.circular(25)),
          border: Border.all(color: white)),
      child: Row(
        children: [
          SizedBox(
            width: 15,
          ),
          Expanded(
            flex: 1,
            child: TextFormField(
              style: TextStyle(color: black, fontSize: inputFont),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              controller: searchName,
              textCapitalization: TextCapitalization.characters,
              decoration: new InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10),
                counterText: "",
                hintText: "Search contact by name",
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
                    isCrossShow = false;
                  } else {
                    isCrossShow = true;
                    showFiltedContact = true;
                    onSearchNameChanged(val.toString());
                  }
                });
              },
            ),
          ),
          (isCrossShow)?InkWell(
            onTap: (){
              setState(() {
                searchName = TextEditingController(text: "");
                showFiltedContact = false;
                isCrossShow = false;
              });
            },
            child: Image.asset('assets/close_menu.png', height: 40,),
          ):Container(),
          SizedBox(
            width: 15,
          )
        ],
      ),
    );
  }

  _verifiedContacts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 10),
          child: Text(
            "Verified contacts with MoneyPro",
            style: TextStyle(color: white, fontSize: font16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 5),
          child: Container(
            height: 80,
            child: ListView.builder(
                itemCount: verifiedContacts.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      var number = verifiedContacts[index].phone;
                      openMobileSelection(context,"$number");
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: white,
                              shape: BoxShape.circle,
                              border: Border.all(color: white, width: 3)),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Image.asset('assets/user.png', color: lightBlue,),
                            )/*Text(
                              "${shortName(verifiedContacts[index].name.toString())}"
                                  .toUpperCase(),
                              style: TextStyle(
                                  color: lightBlue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )*/,
                          ),
                        ),
                        SizedBox(
                            child: Text(
                              verifiedContacts[index].name,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: white),
                              maxLines: 1,
                            ),
                            width: 60),
                      ],
                    ),
                  );
                }),
          ),
        )
      ],
    );
  }

  Future<void> _askContactPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      refreshContacts();
    } else {
      setState(() {
        loading = false;
      });
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<void> refreshContacts() async {
    var contacts = (await ContactsService.getContacts(
            withThumbnails: false, iOSLocalizedLabels: iOSLocalizedLabels))
        .toList();
    setState(() {
      _contacts.clear();
      _contacts = contacts;
      checkMpContacts();
    });
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    setState(() {
      loading = false;
    });
  }

  String shortName(name) {
    String sName = "";

    if (name.toString().contains(" ")) {
      var parts = name.toString().split(' ');
      var fChar = parts[0][0];
      var lChar = parts[1][0];
      sName = "$fChar$lChar";
    } else {
      sName = name.toString()[0];
    }

    return sName;
  }

  checkMpContacts() async {
    printMessage(screen, "Lenth of Contacts : ${_contacts.length}");

    for (int p = 0; p < _contacts.length; p++) {
      if (_contacts[p].phones!.length != 0) {
        var phone = _contacts[p].phones![0].value.toString();
        if (phone.toString().contains("-")) {
          phone = phone.replaceAll("-", "");
        }

        if (phone.toString().contains(" ")) {
          phone = phone.replaceAll(" ", "");
        }

        if (phone.toString().contains("+")) {
          phone = phone.toString().substring(3, phone.toString().length);
        }

        if (phone.toString().length > 10) {
          phone = phone.toString().substring(1, phone.toString().length);
        }

        if (phone.toString().length == 10) {
          var name = _contacts[p].displayName;
          //printMessage(screen,"Name : $name and Number : $phone");
          MyContacts cont = new MyContacts(name: "$name", phone: "$phone");
          myContacts.add(cont);
        }
      }
    }
    printMessage(screen, "My Contact length - : ${myContacts.length}");

    saveContactCount(myContacts.length);

    int count = await getContactCount();

    //printMessage(screen, "Shared Contact length - : $count");

    if (count != 0) {
      checkMobile();
      if (count == myContacts.length) {
        printMessage(screen, "No contact update");
      } else {
        printMessage(screen, "New contact found");
      }
    }
  }

  Future checkMobile() async {
    var token = await getToken();
    try {
      var headers = {
        "Authorization": "$authHeader",
        "userToken": "$token",
        "Content-Type": "application/x-www-form-urlencoded"
      };

      var body = {"phoneData": myContacts};

      final jsonString = json.encode(body);

      final response = await http.post(Uri.parse(checkMobileAPI),
          body: jsonString, headers: headers);

      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Contact Response : $data");

      setState(() {
        if (data['status'].toString() == "1") {
          var result =
              MpContacts.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          phoneListn = result.phoneList;

          printMessage(screen, "Map : ${phoneListn}");

          for (int i = 0; i < phoneListn.length; i++) {

            printMessage(screen, "I Count : $i");

            var phone = phoneListn[i].keys.toString();
            var values = phoneListn[i].values;

            if (phone.toString().contains("("))
              phone = phone.replaceAll("(", "");

            if (phone.toString().contains(")"))
              phone = phone.replaceAll(")", "");

            for (int h = 0; h < myContacts.length; h++) {
              var myName = myContacts[h].name;
              var myPhone = myContacts[h].phone;

              printMessage(screen, "H Count : $h");

              if (myPhone == phone) {
                MyContacts cont = new MyContacts(name: "$myName", phone: "$phone", isMP: "true");
                verifiedContacts.add(cont);
                break;
              }
            }
          }

        }
      });
      setState(() {
        loading = false;
        verifiedContacts = verifiedContacts.toSet().toList();
      });

    } catch (e) {
      setState(() {
        loading = false;
      });
      printMessage(screen, "Error : ${e.toString()}");
    }
  }//714 602 224

  onSearchNameChanged(String text) async {
    printMessage(screen, "Case 0 : $text");
    searcheddContacts.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _contacts.forEach((userDetail) {
      if (userDetail.displayName
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase())) {
        printMessage(screen, "Case 2 :");
        searcheddContacts.add(userDetail);
      }
    });

    setState(() {
      printMessage(screen, "Case 3 : ${searcheddContacts.length}");
      if (searcheddContacts.length != 0) {
        showFiltedContact = true;
      }
    });
  }
}
