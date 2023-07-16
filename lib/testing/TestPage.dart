import 'package:flutter/material.dart';
import 'package:druglog2/models/DrugLog.dart';
import 'package:druglog2/models/Drug.dart';
import 'package:druglog2/components/DrugLogPreview.dart';
import 'package:druglog2/components/DrugButton.dart';
import 'package:druglog2/components/RoaDropdown.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  // List<DrugLog> drugLogs = [];

  var state = {'selected_roa': null};
  String selectedRoa = '';

  static Drug testDrug1 = Drug(name: 'amphetamine');
  static DrugLog testDrugLog1 = DrugLog(title: 'test drug log 1');
  static DrugLog testDrugLog2 = DrugLog(title: 'test drug log 2');
  // drugLogs.add(1,testDrugLog1);
  List<DrugLog> drugLogs = <DrugLog>[testDrugLog1, testDrugLog2];
  // drugLogs.insert(testDrugLog);

  getDrugLogs() async {
    await DrugLog.insertDrugLog('test');
    drugLogs = await DrugLog.getDrugLogs();

    setState(() {});
  }

  getSelectedRoa(String roa) {
    print('getSelectedRoa() in parent');
    selectedRoa = roa;
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
          child: DrugLogPreview(drugLog: testDrugLog1),
        ),
        Container(
          padding: const EdgeInsets.all(20.0),
          child: DrugLogPreview(drugLog: testDrugLog2),
        ),
        DrugButton(drug: testDrug1),
        RoaDropdown(parentCallback: (roa) {
          getSelectedRoa(roa);
        }),
        Text('Selected Roa: ${selectedRoa}'),
      ]),
    );
  }
}
