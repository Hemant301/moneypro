import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../utils/Apis.dart';
import '../../../utils/AppKeys.dart';
import '../../../utils/Constants.dart';
import '../../../utils/CustomWidgets.dart';
import '../../../utils/Functions.dart';
import '../../../utils/SharedPrefs.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class EmpMarkAttendance extends StatefulWidget {
  const EmpMarkAttendance({Key? key}) : super(key: key);

  @override
  State<EmpMarkAttendance> createState() => _EmpMarkAttendanceState();
}

class _EmpMarkAttendanceState extends State<EmpMarkAttendance> {
  var screen = "Emp Mark Map";

  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;

  late GoogleMapController _googleMapController;

  double lat = 0.0;
  double lng = 0.0;

  List<Marker> markers = [];

  String actualDate = "";
  String actualTime = "";
  String passDate = "";

  var now = DateTime.now();
  var formatterDate = DateFormat('dd/MM/yy');
  var formatterPassDate = DateFormat('yyyy-MM-dd');
  var formatterTime = DateFormat('hh:mm a');

  var isInTime = false;
  var empInTime = "";
  var loading = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      actualDate = formatterDate.format(now);
      passDate = formatterPassDate.format(now);
      actualTime = formatterTime.format(now);
    });
    _determinePosition();
    checkAttendance(passDate);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => SafeArea(
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: appBarHome(context, "", 24.0.w),
                body: (loading)
                    ? Center(
                        child: circularProgressLoading(40.0),
                      )
                    : Stack(
                        children: [
                          GoogleMap(
                            onMapCreated: (GoogleMapController controller) {
                              _googleMapController = controller;
                            },
                            initialCameraPosition: CameraPosition(
                                target: LatLng(lat, lng), zoom: 14.0),
                            markers: Set.from(markers),
                            myLocationEnabled: true,
                            // onTap: handleTap,
                          ),
                          Positioned(
                              bottom: 1,
                              child: Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(
                                        left: padding,
                                        top: avatarRadius + padding,
                                        right: padding,
                                        bottom: padding),
                                    margin: EdgeInsets.only(top: avatarRadius),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: Colors.indigo,
                                        borderRadius:
                                            BorderRadius.circular(padding),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black,
                                              offset: Offset(0, 10),
                                              blurRadius: 10),
                                        ]),
                                    child: Column(
                                      children: [
                                        Text(
                                            (isInTime)
                                                ? "Punch OUT"
                                                : "Punch IN",
                                            style: TextStyle(
                                                color: white,
                                                fontSize: font16.sp,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Text(
                                          "$actualTime",
                                          style: TextStyle(
                                              color: white,
                                              fontSize: font16.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Divider(
                                          color: white,
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Today",
                                              style: TextStyle(
                                                  color: white,
                                                  fontSize: font14.sp,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            Spacer(),
                                            Text(
                                              "$actualDate",
                                              style: TextStyle(
                                                  color: white,
                                                  fontSize: font14.sp,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "In Time",
                                              style: TextStyle(
                                                  color: white,
                                                  fontSize: font13.sp,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Text(
                                              (isInTime)
                                                  ? "$empInTime"
                                                  : "$actualTime",
                                              style: TextStyle(
                                                  color: white,
                                                  fontSize: font15.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                            Text(
                                              "Out Time",
                                              style: TextStyle(
                                                  color: white,
                                                  fontSize: font13.sp,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Text(
                                              (isInTime) ? "$actualTime" : "NA",
                                              style: TextStyle(
                                                  color: white,
                                                  fontSize: font15.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Divider(
                                          color: white,
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Text(
                                          "Current Location",
                                          style: TextStyle(
                                              color: white,
                                              fontSize: font14.sp,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Latitude",
                                              style: TextStyle(
                                                  color: white,
                                                  fontSize: font14.sp,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Text(
                                              "$lat",
                                              style: TextStyle(
                                                  color: white,
                                                  fontSize: font14.sp,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            Spacer(),
                                            Text(
                                              "Longitude",
                                              style: TextStyle(
                                                  color: white,
                                                  fontSize: font14.sp,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Text(
                                              "$lng",
                                              style: TextStyle(
                                                  color: white,
                                                  fontSize: font14.sp,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: padding,
                                    right: padding,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: avatarRadius,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(avatarRadius)),
                                          child: InkWell(
                                              onTap: () {
                                                if (lat == 0 || lng == 0) {
                                                  showToastMessage(
                                                      "Please wait, while loading your GPS location");
                                                  _determinePosition();
                                                  return;
                                                }

                                                if (isInTime) {
                                                  markOutTimeAttendance(
                                                      actualTime);
                                                } else {
                                                  markInTimeAttendance(
                                                      actualTime);
                                                }
                                              },
                                              child: Image.asset(
                                                  "assets/pufingerprint-scan.png"))),
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ))));
  }

  Future _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    printMessage(screen, "Location 2 Permission : $permission");

    if (permission == LocationPermission.denied) {
      _determineSecondPosition();
      _getCurrentLocation();
    } else if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _getCurrentLocation();
    }
  }

  Future<Position> _determineSecondPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    printMessage(screen, "Location Permission : $serviceEnabled");

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    printMessage(screen, "Location 2 Permission : $permission");

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        lat = position.latitude;
        lng = position.longitude;
        printMessage(screen, "Get location : $lat $lng");
        getAddress(lat, lng);
        _moveCamera(lat, lng);
      });
    }).catchError((e) {
      print(e);
    });
  }

  getAddress(double lat, double lng) async {
    if (lat != 0) {
      printMessage(screen, "IN SIDE IF");
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.length != 0) {
        printMessage(screen, "name : ${placemarks[0].name}");
        printMessage(screen, "street : ${placemarks[0].street}");
        printMessage(
            screen, "isoCountryCode : ${placemarks[0].isoCountryCode}");
        printMessage(screen, "country : ${placemarks[0].country}");
        printMessage(screen, "postalCode : ${placemarks[0].postalCode}");
        printMessage(
            screen, "administrativeArea : ${placemarks[0].administrativeArea}");
        printMessage(screen,
            "subAdministrativeArea : ${placemarks[0].subAdministrativeArea}");
        printMessage(screen, "locality : ${placemarks[0].locality}");
        printMessage(screen, "subLocality : ${placemarks[0].subLocality}");
        printMessage(screen, "thoroughfare : ${placemarks[0].thoroughfare}");
        printMessage(
            screen, "subThoroughfare : ${placemarks[0].subThoroughfare}");

        var name = placemarks[0].name.toString();
        var street = placemarks[0].street.toString();
        var country = placemarks[0].country.toString();
        var postCode = placemarks[0].postalCode.toString();
        var district = placemarks[0].subAdministrativeArea.toString();
        var state = placemarks[0].administrativeArea.toString();
        var city = placemarks[0].locality.toString();

        var text1 = "$name $street";
      }
    }
  }

  _moveCamera(double lat, double lng) {
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 14.0),
    ));
  }

  Future checkAttendance(passDate) async {
    setState(() {
      loading = true;
    });

    var userToken = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": "$userToken",
      "from_date": "$passDate",
      "to_date": "$passDate",
    };

    printMessage(screen, "body qr : $body");

    final response = await http.post(Uri.parse(attendenceViewAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Attendance Check : $data");

      setState(() {
        loading = false;
        if (data['status'].toString() == "1") {
          isInTime = true;
          empInTime = data['attendence_data'][0]['intime'];
          var attenStatus = data['attendence_data'][0]
              ['atten_status']; //0 means punch in & 1 means punch out
        } else {
          isInTime = false;
        }
      });
    } else {
      setState(() {
        loading = false;
      });
      showToastMessage("$status500");
    }
  }

  Future markInTimeAttendance(intime) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var userToken = await getToken();
    var empid = await getEmployeeId();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": "$userToken",
      "empid": "$empid",
      "intime": "$intime",
      "inlat": "$lat",
      "inlong": "$lng",
      "outlat": "0",
      "outlong": "0",
      "outtime": "0"
    };

    printMessage(screen, "body qr : $body");

    final response = await http.post(Uri.parse(addAttendenceDataAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    Navigator.pop(context);

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Attendance Punch In : $data");

      setState(() {
        if (data['status'].toString() == "1") {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return showMessageDialog(
                    message: "${data['message'].toString()}", action: 5);
              });
        } else {
          showToastMessage(data['message'].toString());
        }
      });
    } else {
      setState(() {});
      showToastMessage("$status500");
    }
  }

  Future markOutTimeAttendance(intime) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var userToken = await getToken();
    var empid = await getEmployeeId();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": "$userToken",
      "empid": "$empid",
      "intime": "0",
      "inlat": "0",
      "inlong": "0",
      "outlat": "$lat",
      "outlong": "$lng",
      "outtime": "$intime"
    };

    printMessage(screen, "body qr : $body");

    final response = await http.post(Uri.parse(addAttendenceDataAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    Navigator.pop(context);

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Attendance Punch Out : $data");

      setState(() {
        if (data['status'].toString() == "1") {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return showMessageDialog(
                    message: "${data['message'].toString()}", action: 5);
              });
        } else {
          showToastMessage(data['message'].toString());
        }
      });
    } else {
      setState(() {});
      showToastMessage("$status500");
    }
  }
}
