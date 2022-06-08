import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/ui/models/TeamMember.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeamMemberList extends StatefulWidget {
  const TeamMemberList({Key? key}) : super(key: key);

  @override
  _TeamMemberListState createState() => _TeamMemberListState();
}

class _TeamMemberListState extends State<TeamMemberList> {
  var screen = "Team Members";

  var loading = false;

  List<Team> teams = [];

  @override
  void initState() {
    super.initState();
    getTeamList();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
            backgroundColor: white,
            appBar: appBarHome(context, "", 24.0),
            body: (loading)
                ? Center(
                    child: circularProgressLoading(40.0),
                  )
                : SingleChildScrollView(
              child: Column(
                children: [
                  (teams.length == 0) ?Container():Card(
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
                          "assets/team_banner.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h,),
                  (teams.length == 0)
                      ? _emptyData()
                      : buildTeamSections()
                ],
              ),
            ),
            floatingActionButton: new FloatingActionButton(
                elevation: 0.0,
                child: new Icon(Icons.add_rounded),
                backgroundColor: lightBlue,
                onPressed: () {
                  openAddMember(context);
                }))));
  }

  _emptyData() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 150.h,
          ),
          Image.asset(
            'assets/no_member.png',
            height: 210.h,
          ),
          Text(
            "No team member added yet",
            style: TextStyle(
                color: black, fontSize: font16.sp, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Future getTeamList() async {
    setState(() {
      loading = true;
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {
      "token": "$token",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(memberListAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode ==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Add Team Response : $data");

      setState(() {
        loading = false;
        if (data['status'].toString() == "1") {
          var result =
          TeamMember.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          teams = result.teams;
        }
      });
    }else{
      setState(() {
        loading = false;
      });
      showToastMessage(status500);
    }
  }

  buildTeamSections() {
    return ListView.builder(
       itemCount: teams.length,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
      return Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        padding: EdgeInsets.only(left: 15, top: 10, bottom: 10, right: 15),
        decoration: BoxDecoration(
          color: editBg,
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        child: Row(
          children: [
            Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                  color: lightBlue,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: lightBlue, width: 3.w)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset('assets/user.png'),
                ),
              ),
            ),
            SizedBox(width: 10.w,),
            Expanded(
              flex:1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${teams[index].firstName} ${teams[index].lastName}", style: TextStyle(
                    color: black, fontSize: font16.sp
                  ),),
                  Text("${teams[index].mobile}", style: TextStyle(
                      color: black,fontSize: font14.sp
                  ),),
                ],
              ),
            ),
            SizedBox(width: 10.w,),
          ],
        ),
      );
    });
  }
}
