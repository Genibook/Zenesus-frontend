import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:zenesus/constants.dart';
import 'package:zenesus/widgets/navbar.dart';
import 'package:zenesus/classes/schedules.dart';
import 'package:zenesus/screens/error.dart';
import 'dart:math' as math;
import "package:zenesus/routes/hero_dialog_route.dart";
import 'package:zenesus/widgets/schedule_info.dart';

class Schedule extends StatefulWidget {
  /// Creates the home page to display teh calendar widget.
  const Schedule({
    Key? key,
    required this.email,
    required this.password,
    required this.school,
  }) : super(key: key);
  final String email;
  final String password;
  final String school;

  @override
  // ignore: library_private_types_in_public_api
  _Calender createState() => _Calender();
}

class _Calender extends State<Schedule> {
  final CalendarController _calendarController = CalendarController();
  Future<ScheduleCoursesDatas>? _futureScheduleCoursesData;
  String? _subjectText, _points, _assignment, _date, _description = '';
  Color? _viewHeaderColor;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _futureScheduleCoursesData = createScheduleCoursesDatas(
          widget.email, widget.password, widget.school, false);
    });

    return buildScheduleCoursesDatabuilder();
  }

  List<Meeting> _getDataSource(AsyncSnapshot<ScheduleCoursesDatas> snapshot) {
    final List<Meeting> meetings = <Meeting>[];
    //List<CalendarResource> resources = <CalendarResource>[];
    final DateTime today = DateTime.now();
    for (int i = 0; i < snapshot.data!.schedulesLength(); i++) {
      for (int j = 0; j < snapshot.data!.oneScheduleLength(i); j++) {
        ScheduleCoursesData oneSchedule = snapshot.data!.datas[i][j];
        if (oneSchedule.date == "") {
          continue;
        }
        final DateTime startTime = DateTime(
            today.year,
            int.parse(oneSchedule.date.split("/")[0]),
            int.parse(oneSchedule.date.split("/")[1]));
        final DateTime endTime = startTime.add(const Duration(hours: 2));

        meetings.add(Meeting(
            oneSchedule.courseName,
            startTime,
            endTime,
            Colors.primaries[math.Random().nextInt(Colors.primaries.length)],
            true,
            "Points: ${oneSchedule.points}|||||${oneSchedule.assignment}|||||${oneSchedule.description}"));
      }
    }
    // final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    // final DateTime endTime = startTime.add(const Duration(hours: 2));
    // meetings.add(Meeting(
    //     'Conference', startTime, endTime, const Color(0xFF0F8644), true));
    return meetings;
  }

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Meeting appointmentDetails = details.appointments![0];
      _subjectText = appointmentDetails.eventName;
      _assignment = appointmentDetails.notes.split("|||||")[1];
      _points = appointmentDetails.notes.split("|||||")[0];
      _description = appointmentDetails.notes.split("|||||")[2];
      _date = DateFormat('MMMM dd, yyyy')
          .format(appointmentDetails.from)
          .toString();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '$_subjectText',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  Text(
                    'Assignment: $_assignment',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(),
                  Text(
                    "Date: $_date",
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(),
                  Text(
                    "$_points",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(),
                  Text(
                    "$_description",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 13),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            );
          });
    } else if (details.targetElement == CalendarElement.calendarCell) {
      final List<Meeting> appointmentDetails =
          details.appointments!.cast<Meeting>();
      if (appointmentDetails.isEmpty) {
        return;
      }
      final Meeting oneAss = details.appointments![0];
      Navigator.of(context).push(HeroDialogRoute(builder: (context) {
        return ScheduleInfosPopup(
          oneAss: oneAss,
          appointmentDetails: appointmentDetails,
        );
      }));
    }
  }

  FutureBuilder<ScheduleCoursesDatas> buildScheduleCoursesDatabuilder() {
    return FutureBuilder(
        future: _futureScheduleCoursesData,
        builder: (context, snapshot) {
          Widget child;
          if (snapshot.hasData) {
            try {
              MeetingDataSource datasource =
                  MeetingDataSource(_getDataSource(snapshot));
              child = Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Expanded(
                    flex: 15,
                    child: SfCalendar(
                      controller: _calendarController,
                      onTap: calendarTapped,
                      view: CalendarView.month,
                      allowedViews: const [
                        CalendarView.week,
                        CalendarView.month,
                      ],
                      dataSource: datasource,
                      viewHeaderStyle:
                          ViewHeaderStyle(backgroundColor: _viewHeaderColor),
                      // by default the month appointment display mode set as Indicator, we can
                      // change the display mode as appointment using the appointment display
                      // mode property
                      monthViewSettings: const MonthViewSettings(
                          appointmentDisplayMode:
                              MonthAppointmentDisplayMode.appointment),
                    ),
                  )
                ],
              );
              try {
                if (snapshot.data!.datas[0][0].courseName == "N/A" &&
                    snapshot.data!.datas[0][0].date == "N/A") {
                  child = Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Center(child: createErrorPage(context))]);
                }
              } catch (e) {
                child = Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'Someone went wrong  - please contact us \n Error - $e',
                          textAlign: TextAlign.center,
                        ),
                      )
                    ]));
              }
            } catch (e) {
              //print(e);
              child = Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Someone went wrong  - please contact us \n Error - $e',
                        textAlign: TextAlign.center,
                      ),
                    )
                  ]));
            }
          } else if (snapshot.hasError) {
            child = Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  )
                ]));
          } else {
            child = Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Fetching your information...'),
                  )
                ]));
          }
          return Scaffold(
            body: child,
            bottomNavigationBar: Navbar(
              selectedIndex: scheduleNavNum,
            ),
          );
        });
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar

  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  @override
  String getNotes(int index) {
    return _getMeetingData(index).notes;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay,
      this.notes);

  String notes;

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
