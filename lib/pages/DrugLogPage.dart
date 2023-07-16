import 'package:druglog2/models/Entry.dart';
import 'package:druglog2/models/drug.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrugLogPage extends StatefulWidget {
  const DrugLogPage({super.key});

  @override
  State<DrugLogPage> createState() => _DrugLogPageState();
}

class _DrugLogPageState extends State<DrugLogPage> {
  List<Entry> logs = [];
  List<Drug> drugs = [];
  Drug? selectedDrug;

  TextEditingController notesEditingController = TextEditingController();
  TextEditingController doseEditingController = TextEditingController();

  getLogs() async {
    logs = await Entry.getLogs();

    print("sde logs ${logs}");
    setState(() {});
  }

  void setDrug(dynamic drug) {
    this.selectedDrug = drug;
    setState(() {});
  }

  addLog() async {
    print("sde inserting");

    var selectedDrugId = selectedDrug?.id;
    if (selectedDrugId != null) {
      Entry.insertLogWithDrug(notesEditingController.text, selectedDrugId,
          doseEditingController.text, 1);
    } else {
      Entry.insertLog(notesEditingController.text, 1);
    }

    getLogs();
    setState(() {});
    notesEditingController.clear();
    doseEditingController.clear();
    selectedDrug = null;
  }

  getDrugs() async {
    drugs = await Drug.getDrugs();
  }

  @override
  Widget build(BuildContext context) {
    getLogs();
    getDrugs();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          print("sde pressed");
          showDialog(
            context: context,
            builder: (BuildContext context) {
              bool includeDrug = false;
              return AlertDialog(
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      width: double.maxFinite,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: notesEditingController,
                              maxLines: 4, //or null
                              decoration:
                                  InputDecoration.collapsed(hintText: "Text"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text("Include drug?"),
                                Checkbox(
                                    value: includeDrug,
                                    checkColor: Colors.blue,
                                    onChanged: (bool? value) {
                                      print("sde include drug ${includeDrug}");
                                      setState(() {
                                        includeDrug = value!;
                                      });
                                    }),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(children: [
                                  FilledButton(
                                    onPressed: () {},
                                    child: Text("Select drug"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                        "Selected drug: ${selectedDrug?.name ?? ""}"),
                                  ),
                                ]),
                                Padding(
                                  padding: EdgeInsets.all(2),
                                  child: TextField(
                                    controller: doseEditingController,
                                    decoration: InputDecoration.collapsed(
                                        hintText: "Dose"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FilledButton(
                              child: Text("Add a log"),
                              onPressed: () => addLog()),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: drugs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return OutlinedButton(
                                  child: Text(drugs[index].name),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
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
