import 'package:druglog2/models/DrugLog.dart';
import 'package:druglog2/components/AddDrugLogDialog.dart';
import 'package:flutter/material.dart';
import 'package:druglog2/components/DrugLogButton.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _DrugLogsPageState();
}

class _DrugLogsPageState extends State<Home> {
  List<DrugLog> drugLogs = [];
  bool loading = true;

  TextEditingController notesEditingController = TextEditingController();
  TextEditingController doseEditingController = TextEditingController();

  getDrugLogs() async {
    drugLogs = await DrugLog.getDrugLogs();
    loading = false;
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!
        .addPostFrameCallback((_) async => await getDrugLogs());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.all(4),
          //   child: Container(
          //     child: (drugLogs.length != 0)
          //         ? DrugLogListView(drugLogList: drugLogs)
          //         : Text('No current logs'),
          //   ),
          // ),
          FutureBuilder<List<DrugLog>>(
              future: DrugLog.getDrugLogs(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<DrugLog>> snapshot) {
                if (!snapshot.hasData) {
                  return Text('Loading...');
                }
                return snapshot.data!.isEmpty
                    ? Center(child: Text("Logs will show up here"))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          DrugLog tempLog = snapshot.data![index];
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                                child: DrugLogButton(drugLog: tempLog)),
                          );
                        },
                      );
              }),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(50)),
              onPressed: () {
                showDialog(
                    context: context,
                    // barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AddDrugLogDialog(parentCallback: () {
                        getDrugLogs();
                        setState(() {});
                      });
                    });
              },
              child: const Text("Add Log"),
            ),
          ),
        ],
      ),
    );
  }
}
