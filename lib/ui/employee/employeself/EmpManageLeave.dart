import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

import '../../../utils/Constants.dart';
import '../../../utils/CustomWidgets.dart';

class EmpManageLeave extends StatefulWidget {
  const EmpManageLeave({Key? key}) : super(key: key);

  @override
  State<EmpManageLeave> createState() => _EmpManageLeaveState();
}

class _EmpManageLeaveState extends State<EmpManageLeave> {

  var screen = "Manage Leave";

  DateTime currentFromDate = DateTime.now();
  DateTime currentToDate = DateTime.now();
  final f = new DateFormat('dd-MM-yyyy');

  var cDate;

  var selectLeaveType;

  final msgController = TextEditingController();

  var isFromDateSelected = false;
  var isToDateSelected = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      cDate = f.format(currentFromDate);

    });
  }

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => SafeArea(
                child: Scaffold(
              backgroundColor: boxBg,
              appBar: appBarHome(context, "", 24.0.w),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 20),
                      child: Text(
                        "Leave Balance",
                        style: TextStyle(
                            color: black,
                            fontSize: font18.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 120.w,
                          height: 80.h,
                          margin: EdgeInsets.only(
                              top: 20, left: 10, right: 10, bottom: 0),
                          decoration: BoxDecoration(
                            color: black,
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, top: 15, bottom: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "6",
                                  style: TextStyle(
                                      fontSize: font18.sp,
                                      color: white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  "Casual Leave",
                                  style: TextStyle(
                                      fontSize: font16.sp, color: white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 120.w,
                          height: 80.h,
                          margin: EdgeInsets.only(
                              top: 20, left: 10, right: 10, bottom: 0),
                          decoration: BoxDecoration(
                            color: homeOrage,
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, top: 15, bottom: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "2",
                                  style: TextStyle(
                                      fontSize: font18.sp,
                                      color: white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  "Medical Leave",
                                  style: TextStyle(
                                      fontSize: font16.sp, color: white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 120.w,
                          height: 80.h,
                          margin: EdgeInsets.only(
                              top: 20, left: 10, right: 10, bottom: 0),
                          decoration: BoxDecoration(
                            color: homeOrage,
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, top: 15, bottom: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "4",
                                  style: TextStyle(
                                      fontSize: font18.sp,
                                      color: white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  "Maternity Leave",
                                  style: TextStyle(
                                      fontSize: font16.sp, color: white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 120.w,
                          height: 80.h,
                          margin: EdgeInsets.only(
                              top: 20, left: 10, right: 10, bottom: 0),
                          decoration: BoxDecoration(
                            color: black,
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, top: 15, bottom: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "12",
                                  style: TextStyle(
                                      fontSize: font18.sp,
                                      color: white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  "Mandatory Leave",
                                  style: TextStyle(
                                      fontSize: font16.sp, color: white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    _buildApplyLeaveSection(),
                  ],
                ),
              ),
            )));
  }

  _buildApplyLeaveSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 20, right: 20),
      child: Container(
        padding: EdgeInsets.all(15.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10),
              child: Text(
                "Apply Leave",
                style: TextStyle(
                    color: black,
                    fontSize: font18.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            /*SizedBox(height: 10.h,),
            Row(
              children: [
                SizedBox(width: 15.w,),
                Expanded(
                  flex: 1,
                  child: Text(
                   "From Date",
                    style: TextStyle(color: black, fontSize: font14.sp),
                  ),
                ),
                SizedBox(width: 15.w,),
                Expanded(
                  flex: 1,
                  child: Text(
                    "To Date",
                    style: TextStyle(color: black, fontSize: font14.sp),
                  ),
                ),
                SizedBox(width: 15.w,),
              ],
            ),*/
            SizedBox(height: 10.h,),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      _selectFromDate(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: editBg,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          (cDate.toString() ==
                              f.format(currentFromDate).toString())
                              ? "Select from date"
                              : f.format(currentFromDate),
                          style: TextStyle(color: black, fontSize: font14.sp),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15.w,),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      _selectToDate(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: editBg,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          (cDate.toString() ==
                              f.format(currentToDate).toString())
                              ? "Select to date"
                              : f.format(currentToDate),
                          style: TextStyle(color: black, fontSize: font14.sp),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h,),
            Container(
              margin: EdgeInsets.only(top: 10, left: 0, right: 0),
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  color: editBg,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: editBg)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectLeaveType,
                  style: TextStyle(color: black, fontSize: font16.sp),
                  items:
                  leaveTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: black),
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    "Select leave type",
                    style: TextStyle(color: black, fontSize: font16.sp),
                  ),
                  icon: Icon(
                    // Add this
                    Icons.keyboard_arrow_down, // Add this
                    color: lightBlue, // Add this
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectLeaveType = value!;
                      FocusScope.of(context).requestFocus(new FocusNode());
                    });
                  },
                ),
              ),
            ),
            Container(
        height: 90,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 0, right: 0, top: 15),
        decoration: BoxDecoration(
            color: boxBg,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: boxBg)),
        child: TextFormField(
          style: TextStyle(color: black, fontSize: font15),
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          textCapitalization: TextCapitalization.characters,
          controller: msgController,
          decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: "Reason for leave",
            hintStyle: TextStyle(color: lightBlack),
            contentPadding: EdgeInsets.only(left: 20),
            counterText: "",
          ),
          maxLength: 200,
        ),
      ),
            InkWell(
              onTap: () {

              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin:
                EdgeInsets.only(top: 20, left: 0, right: 0, bottom: 10),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      submit.toUpperCase(),
                      style: TextStyle(fontSize: font15, color: white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentFromDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2023));
    if (pickedDate != null && pickedDate != currentFromDate){
      setState(() {
        currentFromDate = pickedDate;
        isFromDateSelected = true;
      });
    }else{
      setState(() {
        isFromDateSelected = false;
      });
    }

  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentToDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2023));
    if (pickedDate != null && pickedDate != currentToDate)
      {
        setState(() {
          currentToDate = pickedDate;
          isToDateSelected = true;
        });
      }else{
      setState(() {
        isToDateSelected = false;
      });
    }
  }
}
