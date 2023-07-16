import 'package:flutter/material.dart';
import 'package:druglog2/models/DrugLog.dart';

class AddDrugLogDialog extends StatefulWidget {
  final Function() parentCallback;
  const AddDrugLogDialog({Key? key, required this.parentCallback})
      : super(key: key);
  @override
  State<AddDrugLogDialog> createState() => _AddDrugLogDialogState();
}

class _AddDrugLogDialogState extends State<AddDrugLogDialog> {
  TextEditingController titleController = TextEditingController();

  addDrugLog() async {
    if (titleController.text == '') {
      print('Empty title');
      return;
    }
    await DrugLog.insertDrugLog(titleController.text);
    Navigator.pop(context);
    widget.parentCallback();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 500,
        height: 200,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4),
              child: TextField(
                controller: titleController,
                maxLines: 4, //or null
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  hintText: "Log Title",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: FilledButton(
                  child: Text("Add Log"), onPressed: () => addDrugLog()),
            ),
          ],
        ),
      ),
    );
  }
}
