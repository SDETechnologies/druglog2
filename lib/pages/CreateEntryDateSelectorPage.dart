import 'package:druglog2/global/CreateEntryState.dart';
import 'package:druglog2/models/Entry.dart';
import 'package:flutter/material.dart';

class CreateEntryDateSelectorPage extends StatefulWidget {
  const CreateEntryDateSelectorPage({super.key});

  @override
  State<CreateEntryDateSelectorPage> createState() =>
      _CreateEntryDateSelectorPageState();
}

class _CreateEntryDateSelectorPageState
    extends State<CreateEntryDateSelectorPage> {
  DateTime time = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select timestamp"),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FilledButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  minimumSize: const Size.fromHeight(50)),
              onPressed: () async {
                DateTime now = DateTime.now();
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(now.year - 10, now.month, now.day),
                  lastDate: DateTime(now.year + 10, now.month, now.day),
                );
                if (selectedDate != null) {
                  time = DateTime(selectedDate.year, selectedDate.month,
                      selectedDate.day, time.hour, time.minute, time.second);
                }
                setState(() {});
              },
              child: Text("Select Date")),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FilledButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  minimumSize: const Size.fromHeight(50)),
              onPressed: () async {
                TimeOfDay? selecteTime = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                if (selecteTime != null) {
                  time = DateTime(time.year, time.month, time.day,
                      selecteTime.hour, selecteTime.minute);
                }
                setState(() {});
              },
              child: Text("Select Time")),
        ),
        Text("${time}"),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FilledButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                minimumSize: const Size.fromHeight(50)),
            child: Text("Submit"),
            onPressed: () {
              Entry.insertEntry(
                  CreateEntry.drug!,
                  CreateEntry.unit!,
                  CreateEntry.dose!,
                  CreateEntry.roa!,
                  time,
                  CreateEntry.druglog!);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        )
      ]),
    );
  }
}
