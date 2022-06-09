import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';

class EmpMerchantMapDetails extends StatefulWidget {
  final Map itemResponse;
  final File storeImage;

  const EmpMerchantMapDetails(
      {Key? key, required this.itemResponse, required this.storeImage})
      : super(key: key);

  @override
  _EmpMerchantMapDetailsState createState() => _EmpMerchantMapDetailsState();
}

class _EmpMerchantMapDetailsState extends State<EmpMerchantMapDetails> {
  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;

  late GoogleMapController _googleMapController;

  double lat = 0.0;
  double lng = 0.0;

  TextEditingController addressController = new TextEditingController();
  TextEditingController pinController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController districtController = new TextEditingController();

  var screen = "Emp Map view";

  Map newItem = {};

  List<Marker> markers = [];

  var loading = false;

  var stateName = "";
  var districtName = "";

  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    fetchUserAccountBalance();
    setState(() {
      newItem = widget.itemResponse;
      _getCurrentLocation();
    });

    getLatLng();
  }

  @override
  void dispose() {
    addressController.dispose();
    pinController.dispose();
    cityController.dispose();
    stateController.dispose();
    districtController.dispose();
    super.dispose();
  }

  getLatLng() async {
    var lati = await getLatitude();
    var long = await getLongitude();

    setState(() {
      lat = lati;
      lng = long;
    });

    printMessage(screen, "Latitude: $lat");
    printMessage(screen, "Longitude: $lng");

    if (lat != 0) {
      Timer(Duration(seconds: 2), () {
        _moveCamera(lat, lng);
        getAddress(lat, lng);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => WillPopScope(
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
                body: Column(
                  children: [
                    _buildMap(),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      "Tap on map to load your selected location address",
                      style: TextStyle(color: lightBlack, fontSize: font14.sp),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildAddewssSection(),
                    )
                  ],
                ),
                bottomNavigationBar: InkWell(
                  onTap: () {
                    setState(() {
                      closeKeyBoard(context);

                      printMessage(screen, "State Name : $stateName");
                      printMessage(screen, "Dist Name : $districtName");

                      var address = addressController.text.toString();

                      var city = cityController.text.toString();

                      if (city.length > 15) {
                        city = city
                            .toString()
                            .substring(0, city.toString().length - 15);
                      }

                      var pin = pinController.text.toString();

                      stateName = stateController.text.toString();
                      districtName = districtController.text.toString();

                      if (address.length == 0) {
                        showToastMessage("Enter your flat number");
                        return;
                      } else if (stateName == "") {
                        showToastMessage("Select state");
                        return;
                      } else if (districtName == "") {
                        showToastMessage("Select district");
                        return;
                      } else if (city.length == 0) {
                        showToastMessage("Enter your city");
                        return;
                      } else if (pin.length != 6) {
                        showToastMessage("Enter 6-digit pincode");
                        return;
                      } else {
                        newItem['address'] = address.toString();
                        newItem['state'] = stateName.toString();
                        newItem['dist'] = districtName.toString();
                        newItem['city'] = city.toString();
                        newItem['pin'] = pin.toString();
                        printMessage(screen, "Updated Response : $newItem");

                        // openEmpMerBusinessVerify(context, newItem, widget.storeImage);
                        openEmpMerPanVerify(
                          context,
                          newItem,
                          widget.storeImage,
                          // selectedOtherFile,
                          // selectedAadharFrontFile,
                          // selectedAadharBackFile
                        );
                      }
                    });
                  },
                  child: Container(
                    height: 48.h,
                    width: 120.w,
                    margin: EdgeInsets.only(
                        top: 0, left: 25, right: 25, bottom: 10),
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
                ),
              )),
            ));
  }

  _buildMap() {
    return Container(
      height: 300.h,
      child: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _googleMapController = controller;
        },
        initialCameraPosition:
            CameraPosition(target: LatLng(lat, lng), zoom: 14.0),
        markers: Set.from(markers),
        myLocationEnabled: true,
        onTap: handleTap,
      ),
    );
  }

  _moveCamera(double lat, double lng) {
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 14.0),
    ));
  }

  handleTap(LatLng tappedPoint) async {
    setState(() {
      markers = [];
      markers.add(
        Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
        ),
      );

      _moveCamera(tappedPoint.latitude, tappedPoint.longitude);
      printMessage(screen,
          "Lat : ${tappedPoint.latitude} Lng : ${tappedPoint.longitude}");
      getAddress(tappedPoint.latitude, tappedPoint.longitude);
    });
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        lat = position.latitude;
        lng = position.longitude;
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

        setState(() {
          addressController =
              TextEditingController(text: "${text1.toString().toUpperCase()}");
          stateController =
              TextEditingController(text: "${state.toString().toUpperCase()}");
          districtController = TextEditingController(
              text: "${district.toString().toUpperCase()}");
          cityController =
              TextEditingController(text: "${city.toString().toUpperCase()}");
          pinController = TextEditingController(
              text: "${postCode.toString().toUpperCase()}");
        });
      }
    }
  }

  _buildAddewssSection() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
          color: white,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: Container(
                  color: gray,
                  width: 50.w,
                  height: 5.h,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 5),
                child: Text(
                  "${widget.itemResponse['businessName']}",
                  style: TextStyle(
                      fontSize: 18.sp,
                      color: green,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25, top: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                          child: Text(
                        "$step1",
                        style: TextStyle(color: black, fontSize: font14.sp),
                      )),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                          child: Text(
                        "$step2",
                        style: TextStyle(color: orange, fontSize: font14.sp),
                      )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25, top: 10),
                child: Container(
                  child: Stack(
                    children: [
                      Image.asset('assets/block_full.png'),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Image.asset('assets/block_half.png')),
                      ),
                    ],
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
                    keyboardType: TextInputType.streetAddress,
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.next,
                    controller: addressController,
                    decoration: new InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                      counterText: "",
                      label: Text("Address line 1"),
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
                    style: TextStyle(color: black, fontSize: inputFont.sp),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.next,
                    controller: stateController,
                    decoration: new InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                      counterText: "",
                      label: Text("State"),
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
                    style: TextStyle(color: black, fontSize: inputFont.sp),
                    keyboardType: TextInputType.streetAddress,
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.next,
                    controller: districtController,
                    decoration: new InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                      counterText: "",
                      label: Text("District"),
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
                    style: TextStyle(color: black, fontSize: inputFont.sp),
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
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.next,
                    controller: pinController,
                    decoration: new InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                      counterText: "",
                      label: Text("Pin"),
                    ),
                    maxLength: 6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
