import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/AppKeys.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../utils/Functions.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class EmpViewAttandance extends StatefulWidget {
  const EmpViewAttandance({Key? key}) : super(key: key);

  @override
  State<EmpViewAttandance> createState() => _EmpViewAttandanceState();
}

Map<DateTime, List<_Meeting>> _dataCollection = <DateTime, List<_Meeting>>{};

class _EmpViewAttandanceState extends State<EmpViewAttandance> {
  var screen = "View Attendance";

  _EmpViewAttandanceState();

  final _MeetingDataSource _events = _MeetingDataSource(<_Meeting>[]);
  final CalendarController _calendarController = CalendarController();
  CalendarView _view = CalendarView.month;

  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.workWeek,
    CalendarView.month,
    CalendarView.schedule,
    CalendarView.timelineDay,
    CalendarView.timelineWeek,
    CalendarView.timelineWorkWeek,
    CalendarView.timelineMonth,
  ];

  final ScrollController _controller = ScrollController();

  /// Global key used to maintain the state, when we change the parent of the
  /// widget
  final GlobalKey _globalKey = GlobalKey();

  var now = DateTime.now();
  var formatterPassDate = DateFormat('yyyy-MM-dd');
  var loading = false;

  @override
  void initState() {
    _calendarController.view = _view;
    //getLastDayMonth(now.month, now.year);

    var fDate = "${now.year}-04-01";
    var lDate = "${now.year + 1}-03-31";

    checkAttendance("$fDate", "$lDate");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: boxBg,
        appBar: appBarHome(context, "", 24.0),
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    height: 600,
                    color: white,
                    child: _getLoadMoreCalendar(_calendarController,
                        _onViewChanged, _events, _scheduleViewBuilder)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            color: Color(0xFF0F8644),
                            // border color
                            shape: BoxShape.circle,
                          )),
                      SizedBox(width: 10,),
                      Text(
                        "In-Time",
                        style: TextStyle(color: black, fontSize: font16),
                      ),
                      SizedBox(width: 10,),
                      Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            color: Color(0xFFD20100),
                            // border color
                            shape: BoxShape.circle,
                          )),
                      SizedBox(width: 10,),
                      Text(
                        "Out-Time",
                        style: TextStyle(color: black, fontSize: font16),
                      )
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    if (_view == _calendarController.view) {
      return;
    }
    _view = _calendarController.view!;
  }

  SfCalendar _getLoadMoreCalendar(
      [CalendarController? calendarController,
      ViewChangedCallback? viewChangedCallback,
      CalendarDataSource? calendarDataSource,
      dynamic scheduleViewBuilder]) {
    return SfCalendar(
        controller: calendarController,
        dataSource: calendarDataSource,
        allowedViews: _allowedViews,
        onViewChanged: viewChangedCallback,
        scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
        blackoutDatesTextStyle: TextStyle(
            decoration: TextDecoration.lineThrough, color: Colors.red),
        loadMoreWidgetBuilder:
            (BuildContext context, LoadMoreCallback loadMoreAppointments) {
          return FutureBuilder<void>(
            future: loadMoreAppointments(),
            builder: (BuildContext context, AsyncSnapshot<void> snapShot) {
              return Container(
                  height: _calendarController.view == CalendarView.schedule
                      ? 50
                      : double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color?>(lightBlue)));
            },
          );
        },
        monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            appointmentDisplayCount: 4),
        timeSlotViewSettings: const TimeSlotViewSettings(
            minimumAppointmentDuration: Duration(minutes: 60)));
  }

  getLastDayMonth(month, year) {
    var lastDayDateTime = (month < 12)
        ? new DateTime(year, month + 1, 0)
        : new DateTime(year + 1, 1, 0);
    print(lastDayDateTime.day);
  }

  Future checkAttendance(firstDate, lastDate) async {
    _dataCollection = <DateTime, List<_Meeting>>{};

    final List<Color> colorCollection = <Color>[];
    colorCollection.clear();
    colorCollection.add(const Color(0xFF0F8644));
    colorCollection.add(const Color(0xFFD20100));

    setState(() {
      //isDiffMonthGoes = false;
      //loading = true;
    });

    var userToken = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": "$userToken",
      "from_date": "$firstDate",
      "to_date": "$lastDate",
    };

    printMessage(screen, "body qr : $body");

    final response = await http.post(Uri.parse(attendenceViewAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response : $data");

      setState(() {
        //loading = false;
        if (data['status'].toString() == "1") {
          var attendenceData = data['attendence_data'];

          if (attendenceData.length != 0) {
            for (int i = 0; i < attendenceData.length; i++) {
              DateTime? parseDateIN = null;
              DateTime? parseDateOut = null;

              if (data['attendence_data'][i]['intime'].toString() != "0") {
                String dateIn = data['attendence_data'][i]['date'].toString();
                String timeIn = data['attendence_data'][i]['intime'].toString();
                var xx = "$dateIn";
                printMessage(screen, "Date IN - Time : $xx ");
                parseDateIN = new DateFormat("yyyy-MM-dd").parse(xx);
                final _Meeting meeting = _Meeting("$timeIn", parseDateIN,
                    parseDateIN, colorCollection[0], false);

                if (_dataCollection.containsKey(parseDateIN)) {
                  final List<_Meeting> meetings = _dataCollection[parseDateIN]!;
                  meetings.add(meeting);
                  _dataCollection[parseDateIN] = meetings;
                } else {
                  _dataCollection[parseDateIN] = <_Meeting>[meeting];
                }
                printMessage(screen,
                    "Data Collection Size In - ${_dataCollection.length}");
              }

              if (data['attendence_data'][i]['outtime'].toString() != "0") {
                String dateOut = data['attendence_data'][i]['date'].toString();
                String timeOut =
                    data['attendence_data'][i]['outtime'].toString();
                var xx = "$dateOut";
                printMessage(screen, "Date OUT-Time : $xx");
                parseDateOut = new DateFormat("yyyy-MM-dd").parse(xx);
                final _Meeting meeting = _Meeting("$timeOut", parseDateOut,
                    parseDateOut, colorCollection[1], false);
                if (_dataCollection.containsKey(parseDateOut)) {
                  final List<_Meeting> meetings =
                      _dataCollection[parseDateOut]!;
                  meetings.add(meeting);
                  _dataCollection[parseDateOut] = meetings;
                } else {
                  _dataCollection[parseDateOut] = <_Meeting>[meeting];
                }
                printMessage(screen,
                    "Data Collection Size Out - ${_dataCollection.length}");
              }
            }
          }
        }
      });
    } else {
      setState(() {
        // loading = false;
      });
      showToastMessage("$status500");
    }
  }
}

String _getMonthDate(int month) {
  if (month == 01) {
    return 'January';
  } else if (month == 02) {
    return 'February';
  } else if (month == 03) {
    return 'March';
  } else if (month == 04) {
    return 'April';
  } else if (month == 05) {
    return 'May';
  } else if (month == 06) {
    return 'June';
  } else if (month == 07) {
    return 'July';
  } else if (month == 08) {
    return 'August';
  } else if (month == 09) {
    return 'September';
  } else if (month == 10) {
    return 'October';
  } else if (month == 11) {
    return 'November';
  } else {
    return 'December';
  }
}

Widget _scheduleViewBuilder(
    BuildContext buildContext, ScheduleViewMonthHeaderDetails details) {
  final String monthName = _getMonthDate(details.date.month);
  return Stack(
    children: <Widget>[
      Image(
          image: ExactAssetImage('images/' + monthName + '.png'),
          fit: BoxFit.cover,
          width: details.bounds.width,
          height: details.bounds.height),
      Positioned(
        left: 55,
        right: 0,
        top: 20,
        bottom: 0,
        child: Text(
          monthName + ' ' + details.date.year.toString(),
          style: const TextStyle(fontSize: 18),
        ),
      )
    ],
  );
}

class _MeetingDataSource extends CalendarDataSource {
  _MeetingDataSource(this.source);

  List<_Meeting> source;

  @override
  List<dynamic> get appointments => source;

  @override
  DateTime getStartTime(int index) {
    return source[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return source[index].to;
  }

  @override
  bool isAllDay(int index) {
    return source[index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return source[index].eventName;
  }

  @override
  Color getColor(int index) {
    return source[index].background;
  }

  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
    await Future<dynamic>.delayed(const Duration(seconds: 1));
    final List<_Meeting> meetings = <_Meeting>[];
    DateTime date = DateTime(startDate.year, startDate.month, startDate.day);
    final DateTime appEndDate =
        DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
    while (date.isBefore(appEndDate)) {
      final List<_Meeting>? data = _dataCollection[date];
      if (data == null) {
        date = date.add(const Duration(days: 1));
        continue;
      }

      for (final _Meeting meeting in data) {
        if (appointments.contains(meeting)) {
          continue;
        }

        meetings.add(meeting);
      }
      date = date.add(const Duration(days: 1));
    }

    appointments.addAll(meetings);
    notifyListeners(CalendarDataSourceAction.add, meetings);
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class _Meeting {
  _Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
