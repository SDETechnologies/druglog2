import 'package:druglog2/models/drug_model.dart';
import 'package:druglog2/models/log_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  List<Log> logs = [];
  List<Drug> drugs = [];
  Drug? selectedDrug;

  bool includeDrug = true;

  TextEditingController notesEditingController = TextEditingController();
  TextEditingController doseEditingController = TextEditingController();

  getLogs() async {
    logs = await Log.getLogs();

    setState(() {});
  }

  addLog() async {
    var selectedDrugId = selectedDrug?.id;
    if (selectedDrugId != null) {
      Log.insertLogWithDrug(notesEditingController.text, selectedDrugId,
          doseEditingController.text);
    } else {
      Log.insertLog(notesEditingController.text);
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

    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: notesEditingController,
          maxLines: 4, //or null
          decoration: InputDecoration.collapsed(hintText: "Text"),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text("Include drug?"),
            Spacer(),
            Checkbox(
                value: includeDrug,
                checkColor: Colors.blue,
                onChanged: (bool? value) {
                  setState(() {
                    includeDrug = value!;
                  });
                }),
          ],
        ),
      ),
      Visibility(
        visible: includeDrug,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(children: [
                FilledButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Container(
                          width: double.maxFinite,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: drugs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return OutlinedButton(
                                      child: Text(drugs[index].name),
                                      onPressed: () {
                                        selectedDrug = drugs[index];
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  child: Text("Select drug"),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text("Selected drug: ${selectedDrug?.name ?? ""}"),
                ),
              ]),
              Padding(
                padding: EdgeInsets.all(2),
                child: TextField(
                  controller: doseEditingController,
                  decoration: InputDecoration.collapsed(hintText: "Dose"),
                ),
              ),
            ],
          ),
        ),
      ),
      FilledButton(child: Text("Add a log"), onPressed: () => addLog()),
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
    ]);
  }
}
