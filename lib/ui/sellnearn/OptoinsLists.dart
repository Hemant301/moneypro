import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../utils/CustomWidgets.dart';
import '../../utils/Functions.dart';
import 'dart:convert';

class OptoinsLists extends StatefulWidget {
  final String passKey;
  const OptoinsLists({Key? key, required this.passKey}) : super(key: key);

  @override
  State<OptoinsLists> createState() => _OptoinsListsState();
}

class _OptoinsListsState extends State<OptoinsLists> {

  var screen = "Earn Details";

  var loading = false;

  var jsonResponse ;


  @override
  void initState() {
    super.initState();
    printMessage(screen, "Pass Key : ${widget.passKey}");
    setState(() {
      loading= true;
    });
    getData();
  }

  Future getData()async{
    jsonResponse = json.decode(await getJson());
    printMessage(screen, "MY Data : ${jsonResponse['${widget.passKey}']}");
    setState(() {
      loading=false;
    });
  }

  Future<String> getJson() {
    return rootBundle.loadString('assets/file/banklist.json');
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => SafeArea(
            child: Scaffold(
                appBar: appBarHome(context, "", 24.0.w),
                backgroundColor: boxBg,
                body:(loading)?Center(
                  child: circularProgressLoading(40.0),
                ): SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildListDetails(),
                      SizedBox(height: 20.h,),
                    ],
                  ),
                ))));
  }

  _buildListDetails(){
    return ListView.builder(
        itemCount: jsonResponse['${widget.passKey}'].length,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (context, index){
      return InkWell(
        onTap: (){

          if(jsonResponse['${widget.passKey}'][index]['action'].toString()=="1"){
            openSellDetails(context, jsonResponse['${widget.passKey}'][index]['bankJson'].toString());
          }else if(jsonResponse['${widget.passKey}'][index]['action'].toString()=="2"){
            openDematDetails(context, jsonResponse['${widget.passKey}'][index]['bankJson'].toString());
          } else if(jsonResponse['${widget.passKey}'][index]['action'].toString()=="3"){
            openCreditCardDetails(context, jsonResponse['${widget.passKey}'][index]['bankJson'].toString());
          }



        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
          color: white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100.h,
                  width: 120.w,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: greenLight,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/${jsonResponse['${widget.passKey}'][index]['bankLogo']}', height: 60.h,),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h,),
                      Text("${jsonResponse['${widget.passKey}'][index]['bankName']}", style: TextStyle(
                          color: black, fontWeight: FontWeight.bold,fontSize: font16.sp
                      ),),
                      SizedBox(height: 3.h,),
                      Text("${jsonResponse['${widget.passKey}'][index]['bankTag']}", style: TextStyle(
                          color: lightBlack, fontWeight: FontWeight.normal,fontSize: font14.sp
                      ),),
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 0, right: 10, bottom: 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)), border: Border.all(color: homeOrage)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 8, bottom: 8),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              "${jsonResponse['${widget.passKey}'][index]['bankEarn']}",
                              style: TextStyle(fontSize: font13.sp, color: homeOrage),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

}
