import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:zenesus/widgets/navbar.dart';
import 'package:zenesus/serializers/schedules.dart';

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
  Future<ScheduleCoursesDatas>? _futureScheduleCoursesData;

  @override
  Widget build(BuildContext context) {
    _futureScheduleCoursesData = createScheduleCoursesDatas(
        widget.email, widget.password, widget.school);
    return buildScheduleCoursesDatabuilder();
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(Meeting(
        'Conference', startTime, endTime, const Color(0xFF0F8644), false));
    return meetings;
  }

  FutureBuilder<ScheduleCoursesDatas> buildScheduleCoursesDatabuilder() {
    return FutureBuilder(
        future: _futureScheduleCoursesData,
        builder: (context, snapshot) {
          Widget child;
          if (snapshot.hasData) {
            try {
              child = SfCalendar(
                view: CalendarView.month,
                dataSource: MeetingDataSource(_getDataSource()),
                // by default the month appointment display mode set as Indicator, we can
                // change the display mode as appointment using the appointment display
                // mode property
                monthViewSettings: const MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment),
              );
            } catch (e) {
              print(e);
              child = Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child:
                          Text('Someone went wrong  - please refresh the app'),
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
            bottomNavigationBar: const Navbar(
              selectedIndex: 2,
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
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

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
