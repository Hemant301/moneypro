import 'package:flutter/material.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({Key? key}) : super(key: key);

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  var name = "";
  var email;
  var mobile;
  var address;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  getdata() async {
    String firstname = await getFirstName();
    String lastname = await getLastName();
    name = "${firstname} ${lastname}";
    email = await getEmail();
    mobile = await getMobile();
    address = await getCompanyAddress();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            title: Text(
              "Personal Details",
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black,
                  // letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )),
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
                            "Name",
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
                                "$name",
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
                            "Email",
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
                                "$email",
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
                            "Mobile Numaber",
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
                                "$mobile",
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
                            "Address",
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
                                "$address",
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
            ])));
  }
}
