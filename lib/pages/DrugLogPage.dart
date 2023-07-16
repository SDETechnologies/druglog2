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
                bool includeDrug = false;
                return StatefulBuilder(builder: (context, setState) {
                  addEntry() async {
                    var selectedDrugId = selectedDrug?.id;

                    if (selectedDrugId != null) {
                      print("inserting with drug");
                      Entry.insertLogWithDrug(notesEditingController.text,
                          selectedDrugId, doseEditingController.text, 1);
                    } else {
                      print("inserting without drug");
                      Entry.insertLog(notesEditingController.text, 1);
                    }

                    getLogs();
                    setState(() {});
                    notesEditingController.clear();
                    doseEditingController.clear();
                    Navigator.pop(context);
                  }

                  return AlertDialog(
                      content: Container(
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
                        FilledButton(
                            child: Text("Add entry"),
                            onPressed: () => addEntry()),
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
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                      "Selected drug: ${selectedDrug?.name ?? "no drug"}"),
                                ),
                              ]),
                              Padding(
                                padding: EdgeInsets.all(4),
                                child: TextField(
                                  controller: doseEditingController,
                                  decoration: InputDecoration.collapsed(
                                      hintText: "Dose"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: drugs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return OutlinedButton(
                                child: Text(drugs[index].id == selectedDrug?.id
                                    ? "${drugs[index].name} selected"
                                    : drugs[index].name),
                                onPressed: () async {
                                  print('drug pressed');
                                  await setSelectedDrug(drugs[index]);
                                  setState(() {});
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ));
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
