import 'package:druglog2/models/DrugLog.dart';
import 'package:druglog2/models/Drug.dart';
import 'package:druglog2/models/Entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddLogPopup {
  AddLogPopup();

  Drug? selectedDrug;

  TextEditingController notesEditingController = TextEditingController();
  TextEditingController doseEditingController = TextEditingController();

  bool includeDrug = true;

  addLog() async {
    var selectedDrugId = selectedDrug?.id;
    if (selectedDrugId != null) {
      Entry.insertLogWithDrug(notesEditingController.text, selectedDrugId,
          doseEditingController.text, 1);
    } else {
      Entry.insertLog(notesEditingController.text, 1);
    }

    notesEditingController.clear();
    doseEditingController.clear();
    selectedDrug = null;
  }

  Future show(
      BuildContext context, List<Drug> drugs, void refreshPage()) async {
    // ignore: use_build_context_synchronously
    return showDialog(
      context: context,
      builder: (context) => Theme(
        data: ThemeData(dialogBackgroundColor: Colors.white),
        child: AlertDialog(
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
                            // setState(() {
                            includeDrug = value!;
                            // });
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
                            decoration:
                                InputDecoration.collapsed(hintText: "Dose"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FilledButton(
                    child: Text("Add a log"), onPressed: () => addLog()),
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
          ),
        ),
      ),
    );
  }
}
