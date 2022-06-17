import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Apicall.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';

class AddAccount extends StatefulWidget {
  const AddAccount({Key? key}) : super(key: key);

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  var name;
  var accountNo;
  var ifsc;
  var branch;
  var virtualAccountsId;
  var virtualAccountNumber;
  var virtualAccountIfscCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
    getBankList();
  }

  getData() async {
    name = await getFirstName();
    accountNo = await getAccountNumber();
    ifsc = await getIFSC();
    branch = await getBranchCity();
    virtualAccountsId = await getVirtualAccId();
    virtualAccountNumber = await getVirtualAccNo();
    virtualAccountIfscCode = await getVirtualAccIFSC();
    setState(() {});
  }

  getBankList() async {
    Map data = await homeapi.fetchBankList();
    print(data);
    setState(() {
      bankData = data;
    });
  }

  Map bankData = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // height: 60,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45.withOpacity(.1),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(1, 2), // changes position of shadow
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Primary Bank Account",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.grey[400],
                                  // letterSpacing: 1,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            Icon(
                              Icons.verified,
                              color: Colors.green,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Account Holder Name",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  // letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            Text(
                              "$name",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  // letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Account Number",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  // letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            Text(
                              "$accountNo",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  // letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "IFSC Code",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  // letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            Text(
                              "$ifsc",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  // letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Branch",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  // letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            Text(
                              "$branch",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  // letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ]),
                )),

            // _buildVirtualAccount(),
            SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // height: 60,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45.withOpacity(.1),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(1, 2), // changes position of shadow
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Bank Account",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.grey[400],
                                  // letterSpacing: 1,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            Icon(
                              Icons.verified,
                              color: Colors.green,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Account Holder Name",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  // letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            Text(
                              "$name",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  // letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Id",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  // letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            Text(
                              "$virtualAccountsId",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  // letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Accoun No",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  // letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            Text(
                              "$virtualAccountNumber",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  // letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "IFSC Code",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  // letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            Text(
                              "$virtualAccountIfscCode",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  // letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ]),
                )),

            SizedBox(
              height: 15,
            ),
            bankData.isEmpty
                ? CircularProgressIndicator()
                : bankData['accounts'].isEmpty
                    ? Container()
                    : Column(
                        children: List.generate(
                          bankData['accounts'].length,
                          (index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                // height: 60,
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black45.withOpacity(.1),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: Offset(
                                          1, 2), // changes position of shadow
                                    )
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Bank Account",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.grey[400],
                                                // letterSpacing: 1,
                                                // fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          Icon(
                                            Icons.verified,
                                            color: Colors.green,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Account Holder Name",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black,
                                                // letterSpacing: 1,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            bankData['accounts'][index]
                                                    ['holder_name'] ??
                                                "",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black,
                                                // letterSpacing: 1,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Account No",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black,
                                                // letterSpacing: 1,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            bankData['accounts'][index]
                                                    ['account'] ??
                                                "",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black,
                                                // letterSpacing: 1,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Account Type",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black,
                                                // letterSpacing: 1,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            bankData['accounts'][index]
                                                    ['acc_type'] ??
                                                "",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black,
                                                // letterSpacing: 1,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "IFSC Code",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black,
                                                // letterSpacing: 1,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            bankData['accounts'][index]
                                                    ['ifsc'] ??
                                                "",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black,
                                                // letterSpacing: 1,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Type",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black,
                                                // letterSpacing: 1,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            bankData['accounts'][index]
                                                    ['type'] ??
                                                "",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black,
                                                // letterSpacing: 1,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Branch",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black,
                                                // letterSpacing: 1,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            bankData['accounts'][index]
                                                    ['branch'] ??
                                                "",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black,
                                                // letterSpacing: 1,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ]),
                              )),
                        ),
                      ),
            SizedBox(
              height: 50,
            )
          ])),
      bottomSheet: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/addbankaccount');
        },
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          color: Colors.green,
          child: Center(
            child: Text(
              "Add New Account",
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.white,
                  // letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ),
      ),
    );
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
}
