import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zenesus/screens/schedule.dart';

const String _heroAddTodo = 'add-todo-hero';

class ScheduleInfosPopup extends StatelessWidget {
  const ScheduleInfosPopup(
      {Key? key, required this.oneAss, required this.appointmentDetails})
      : super(key: key);
  final Meeting oneAss;
  final List<Meeting> appointmentDetails;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroAddTodo,
          child: Material(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assignments due on ${DateFormat('MMMM dd, yyyy').format(oneAss.from).toString()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: genLongPressed(appointmentDetails, context),
                        )),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.of(context).pop();
                    //     },
                    //     child: const Text('close'))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<Widget> genLongPressed(List<Meeting> meetings, dynamic context) {
  List<Widget> widgets = [];

  for (Meeting meeting in meetings) {
    Widget widget = ListTile(
      enabled: true,
      selected: false,
      title: Text(meeting.eventName),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.blue, width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      trailing: Text(meeting.notes.split("|||||")[0]),
      subtitle: Text(meeting.notes.split("|||||")[1]),
      onTap: () {
        String _points = meeting.notes.split("|||||")[0];
        String _subjectText = meeting.eventName;
        String _date =
            DateFormat('MMMM dd, yyyy').format(meeting.from).toString();
        String _assignment = meeting.notes.split("|||||")[1];
        String _description = meeting.notes.split("|||||")[2];

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
                      _subjectText,
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
                      _points,
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
      },
    );

    widgets.add(widget);
  }

  return widgets;
}
