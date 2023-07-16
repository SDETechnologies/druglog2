import 'package:druglog2/models/Entry.dart';
import 'package:druglog2/models/drug.dart';
import 'package:druglog2/components/AddEntryDialog.dart';
import 'package:flutter/material.dart';

class DrugLogPage extends StatefulWidget {
  const DrugLogPage({super.key});

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

    print("sde logs ${logs}");
    setState(() {});
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddEntryDialog();
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
