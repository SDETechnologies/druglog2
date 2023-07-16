import 'package:flutter/material.dart';
import 'package:druglog2/models/DrugLog.dart';
import 'package:druglog2/models/Entry.dart';
import 'package:druglog2/models/drug.dart';
import 'package:druglog2/components/AddEntryDialog.dart';

class DrugLogPage extends StatefulWidget {
  final DrugLog drugLog;
  const DrugLogPage({Key? key, required this.drugLog}) : super(key: key);
  @override
  State<DrugLogPage> createState() => _DrugLogPageState();
}

class _DrugLogPageState extends State<DrugLogPage> {
  List<Entry> logs = [];
  List<Drug> drugs = [];

  TextEditingController notesEditingController = TextEditingController();
  TextEditingController doseEditingController = TextEditingController();

  var selectedDrug;

  getLogs() async {
    logs = await Entry.getLogs();
    setState(() {
      print("sde logs ${logs}");
    });
  }

  // void setSelectedDrug(dynamic drug) {
  //   this.selectedDrug = drug;
  //   setState(() {});
  // }

  getDrugs() async {
    drugs = await Drug.getDrugs();
  }

  setSelectedDrug(Drug drug) async {
    selectedDrug = drug;
  }

  @override
  Widget build(BuildContext context) {
    getLogs();
    getDrugs();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              // barrierDismissible: true,
              builder: (BuildContext context) {
                return AddEntryDialog(parentCallback: () {
                  setState(() {});
                });
              });
        },
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (var log in logs)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(.5),
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: const Offset(5.0, 5.0)),
                        ],
                      ),
                      child: Container(
                        color: Colors.grey.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Time: ${log.time}"),
                              Text("Note: ${log.notes ?? ""}"),
                              if (log.drugId != null)
                                Column(
                                  children: [
                                    Text("Drug: ${log.drugName}"),
                                    Text("Dose: ${log.dose}"),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
