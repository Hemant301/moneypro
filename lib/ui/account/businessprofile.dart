import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/ui/home/Perspective.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';

class BusinessProfile extends StatefulWidget {
  const BusinessProfile({Key? key}) : super(key: key);

  @override
  State<BusinessProfile> createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile> {
  var businessName;
  var category;
  var companyaddress;
  var phone;
  var gstin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    businessName = await getComapanyName();
    category = await getBusinessSegment();
    companyaddress = await getCompanyAddress();
    phone = await getMobile();
    gstin = await getGSTNo();
    setState(() {});
  }

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
                      Text(
                        "Business Name",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.grey[400],
                            // letterSpacing: 1,
                            // fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$businessName",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.black,
                                // letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          Icon(Icons.edit)
                        ],
                      ),
                    ]),
              )),
          SizedBox(
            height: 15,
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
                      Text(
                        "Category",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.grey[400],
                            // letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$category",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.black,
                                // letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          Icon(Icons.edit)
                        ],
                      ),
                    ]),
              )),
          SizedBox(
            height: 15,
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
                      Text(
                        "Payment Options",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.grey[400],
                            // letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(Icons.money),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            "All BHIM UPI app",
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
                      Text(
                        "Business Details",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.grey[400],
                            // letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Icon(Icons.call),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "$phone",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.black,
                                // letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_city),
                          Container(
                            width: MediaQuery.of(context).size.width / 2 + 40,
                            child: Text(
                              "$companyaddress",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  // letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                          Icon(Icons.edit),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.money),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              "GSTIN",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  // letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                          Text(
                            "Update",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.blue,
                                // letterSpacing: 1,
                                // fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey,
                      )
                    ]),
              )),
          SizedBox(
            height: 15,
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
                      Text(
                        "Store Image",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.grey[400],
                            // letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                              "https://www.moneyprowealth.in/moneypay/upload/docs/$storeimg",
                              width: MediaQuery.of(context).size.width / 2,
                              fit: BoxFit.fitWidth,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.network(
                                    'https://cdn4.vectorstock.com/i/1000x1000/70/83/shop-store-icon-vector-30737083.jpg',
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    fit: BoxFit.fitWidth,
                                  )),
                          SizedBox(
                            width: 30,
                          ),
                          Icon(Icons.edit)
                        ],
                      ),
                    ]),
              )),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 30,
          ),
        ]),
      ),
    );
  }
}
