/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:moneypro_new/ui/models/ReciveSMS.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

class AllSMS extends StatefulWidget {
  const AllSMS({Key? key}) : super(key: key);

  @override
  _AllSMSState createState() => _AllSMSState();
}

class _AllSMSState extends State<AllSMS> {
  var screen = "All SMS";

  final SmsQuery _query = SmsQuery();
  List<ReciveSMS> reciveSMSList = [];
  List<CreditCardSMS> customCardSMS = [];

  var loading = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return (loading)
        ? Center(
            child: circularProgressLoading(40.0),
          )
        : Scaffold(
            appBar: AppBar(
              title: InkWell(child: const Text('All SMS')),
            ),
            body: Container(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: reciveSMSList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        var msg = reciveSMSList[index].body;
                        breakMessage(msg);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${reciveSMSList[index].title}",
                            style: TextStyle(
                              color: black,
                              fontSize: font16,
                            ),
                          ),
                          Text(" ${reciveSMSList[index].body}",
                              style: TextStyle(
                                color: lightBlack,
                                fontSize: font14,
                              )),
                          Divider(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }

  Future<void> _checkPermission() async {
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
      getAllSMS();
    } else {
      await Permission.sms.request();
    }
  }

  Future getAllSMS() async {
    setState(() {
      loading = true;
    });

    final messages = await _query.querySms(
      kinds: [SmsQueryKind.inbox],
      count: 1000,
    );

    setState(() {
      for (int i = 0; i < messages.length; i++) {
        var body = messages[i].body;

        if (body.toString().toLowerCase().contains("credit card")) {
          if (body.toString().toLowerCase().contains("total amount") ||
              body.toString().toLowerCase().contains("minimum amount")) {
            ReciveSMS sms = new ReciveSMS(
              title: "${messages[i].address}",
              body: "${messages[i].body}",
              smsForm: "${messages[i].sender}",
            );

            reciveSMSList.add(sms);
          }
        }
      }
      printMessage(screen, "SMS length : ${reciveSMSList.length}");
      loading = false;
    });
  }


  breakMessage(mgs){
    printMessage(screen, "Coming Msg : $mgs");

    if(mgs.toString()==""){

    }



  }

}*/
