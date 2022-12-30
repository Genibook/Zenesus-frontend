import 'package:flutter/material.dart';
import 'package:zenesus/classes/gpa_history.dart';
import 'package:zenesus/constants.dart';
import 'package:zenesus/utils/gpa_utils.dart';

class GpaHistoryPage extends StatefulWidget {
  const GpaHistoryPage({
    Key? key,
    required this.email,
    required this.password,
    required this.school,
  }) : super(key: key);
  final String email;
  final String password;
  final String school;

  @override
  State<StatefulWidget> createState() => GpaHistoryPageState();
}

class GpaHistoryPageState extends State<GpaHistoryPage> {
  Future<GPAHistorys>? _futureGPAhistorys;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (TEST_DATA) {
        _futureGPAhistorys = modelHistoryGpas();
      } else {
        _futureGPAhistorys = createHistoryGpas(
            widget.email, widget.password, widget.school, false);
      }
    });
    return buildGPAhistoryFutureBuilder();
  }

  FutureBuilder buildGPAhistoryFutureBuilder() {
    return FutureBuilder(
        future: _futureGPAhistorys,
        builder: (context, snapshot) {
          Widget child;
          if (snapshot.hasData) {
            int shift = 2;
            child = Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListView.separated(
                    separatorBuilder: (_, __) => const Divider(),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.datas.length + shift,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return ListTile(
                          title: const Text("Year",
                              style: TextStyle(fontSize: 25)),
                          subtitle: const Text("Grade"),
                          trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "Weighted GPA",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  "Unweighted GPA",
                                  style: TextStyle(
                                      color: Colors.grey[400], fontSize: 13),
                                )
                              ]),
                        );
                      } else if (index == 1) {
                        return ListTile(
                          title: const Text(
                            "All Years GPA",
                            style: TextStyle(fontSize: 18, color: primaryColor),
                          ),
                          subtitle: Text(
                            "From 9th grade and above",
                            style: TextStyle(color: primaryColor.shade600),
                          ),
                          trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${getTotalGpas(snapshot.data!)[0]}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: getColorFromGrade(
                                              "${getTotalGpas(snapshot.data!)[0]}",
                                            )),
                                      ),
                                      Text(
                                        "${getTotalGpas(snapshot.data!)[1]}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: getColorFromGrade(
                                              "${getTotalGpas(snapshot.data!)[1]}",
                                            ).shade600),
                                      )
                                    ]),
                              ]),
                        );
                      } else {
                        GPAHistory data = snapshot.data!.datas[index - shift];
                        return ListTile(
                          title: Text(
                            data.schoolYear,
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: primaryColor),
                          ),
                          subtitle: Text(
                            "${data.grade}th grade",
                            style: TextStyle(
                              color: primaryColor.shade600,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  "${data.weightedGPA}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: getColorFromGrade(
                                          data.unweightedGPA)),
                                ),
                              ),
                              Flexible(
                                  child: Text(
                                "${data.unweightedGPA}",
                                style: TextStyle(
                                    color: getColorFromGrade(data.unweightedGPA)
                                        .shade600),
                              )),
                            ],
                          ),
                          enabled: true,
                          selected: false,
                          onTap: () {},
                        );
                      }
                    })
              ],
            );
          } else if (snapshot.hasError) {
            child = Center(
                child: Column(
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
                      'Error: ${snapshot.error} \n Please report this to zenesus.gradebook@gmail.com',
                      textAlign: TextAlign.center,
                    ),
                  )
                ]));
          } else {
            child = const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
              //TODO maybe even add like a feature which would show the general trend for each year if you want
              appBar: AppBar(
                toolbarHeight: 40,
              ),
              body: child);
        });
  }
}
