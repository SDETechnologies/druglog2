import 'package:druglog2/models/Entry.dart';
import 'package:druglog2/models/drug.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddEntryNotification extends Notification {}

class AddEntryDialog extends StatefulWidget {
  final Function() parentCallback;
  const AddEntryDialog({Key? key, required this.parentCallback})
      : super(key: key);

  @override
  State<AddEntryDialog> createState() => _AddEntryDialogState();
}

class _AddEntryDialogState extends State<AddEntryDialog> {
  List<Entry> logs = [];
  List<Drug> drugs = [];

  TextEditingController notesEditingController = TextEditingController();
  TextEditingController doseEditingController = TextEditingController();

  var selectedDrug;
  bool addNote = false;
  bool addDrug = false;

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

  addEntry() async {
    var selectedDrugId = selectedDrug?.id;

    if (selectedDrugId != null) {
      print("inserting with drug");
      Entry.insertLogWithDrug(notesEditingController.text, selectedDrugId,
          doseEditingController.text, 1);
    } else {
      print("inserting without drug");
      Entry.insertLog(notesEditingController.text, 1);
    }

    getLogs();
    setState(() {});
    notesEditingController.clear();
    doseEditingController.clear();

    Navigator.pop(context);
    widget.parentCallback();
  }

  @override
  Widget build(BuildContext context) {
    // getLogs();
    getDrugs();

    return AlertDialog(
        content: Container(
      // width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text("Add Note?"),
                Checkbox(
                    value: addNote,
                    checkColor: Colors.blue,
                    onChanged: (bool? value) {
                      print("sde include drug ${addNote}");
                      setState(() {
                        addNote = value!;
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
                    decoration: InputDecoration.collapsed(hintText: "Dose"),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            // Flexible(
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
          if (addNote)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: notesEditingController,
                maxLines: 4, //or null
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 200),
                  hintText: "Note Text",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          FilledButton(child: Text("Add entry"), onPressed: () => addEntry()),
        ],
      ),
    ));
  }
}
