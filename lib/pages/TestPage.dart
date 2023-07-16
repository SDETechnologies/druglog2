import 'package:flutter/material.dart';
import 'package:druglog2/models/DrugLog.dart';
import 'package:druglog2/components/DrugLogPreview.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  // List<DrugLog> drugLogs = [];

  static DrugLog testDrugLog = DrugLog(title: 'test');
  List<DrugLog> drugLogs = <DrugLog>[testDrugLog];
  // drugLogs.insert(testDrugLog);

  getDrugLogs() async {
    await DrugLog.insertDrugLog('test');
    drugLogs = await DrugLog.getDrugLogs();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // getDrugLogs();
    print('drugLogs: ');
    print(drugLogs);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  TextEditingController logTitleTextController =
                      TextEditingController();
                  return Column(children: [
                    TextFormField(
                        decoration: new InputDecoration(
                          hintText: "Title",
                          border: OutlineInputBorder(),
                        ),
                        controller: logTitleTextController),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       String dateString = DateFormat('MM-dd-yyyy kk:mm')
                    //           .format(DateTime.now());
                    //       DatabaseHelper.instance.insertLog(
                    //           logTitleTextController.text, dateString);
                    //     },
                    //     child: Text('Add Log'))
                  ]);
                });
          }),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20.0),
          child: Text('Old/Test Home Page'),
        ),
        Container(
          padding: const EdgeInsets.all(20.0),
          child: DrugLogPreview(),
        ),
      ]),
    );
  }
}
