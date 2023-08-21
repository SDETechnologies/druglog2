import 'package:druglog2/global/CreateEntryState.dart';
import 'package:druglog2/pages/CreateEntryDrugSelectorPage.dart';
import 'package:flutter/material.dart';
import 'package:druglog2/models/DrugLog.dart';
import 'package:druglog2/models/Entry.dart';
import 'package:druglog2/models/drug.dart';

class DrugLogPage extends StatefulWidget {
  final DrugLog drugLog;
  const DrugLogPage({Key? key, required this.drugLog}) : super(key: key);
  @override
  State<DrugLogPage> createState() => _DrugLogPageState();
}

class _DrugLogPageState extends State<DrugLogPage> {
  List<Entry> entries = [];
  List<Drug> drugs = [];

  TextEditingController notesEditingController = TextEditingController();
  TextEditingController doseEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => widget.drugLog.getEntries());

    return Scaffold(
      appBar: AppBar(title: Text("Drug log")),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          FutureBuilder<List<Entry>>(
              future: widget.drugLog.getEntries(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Entry>> snapshot) {
                if (!snapshot.hasData) {
                  return Text('Loading...');
                }
                if (!snapshot.hasData) {
                  return Text('No entries');
                }
                return Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (var entry in snapshot.data!)
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
                                    Row(
                                      children: [
                                        Spacer(),
                                        Text("Time: ${entry.time}"),
                                        Spacer()
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            "${entry.dose!}${entry.unit!.value!} - ${entry.drug!.name}"),
                                      ],
                                    ),
                                    Text(entry.roa!.value!),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  minimumSize: const Size.fromHeight(50)),
              onPressed: () {
                CreateEntry.dose = "";
                CreateEntry.drug = null;
                CreateEntry.druglog = widget.drugLog;
                CreateEntry.roa = null;
                CreateEntry.unit = null;

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateEntryDrugSelectorPage()));
              },
              child: const Text("Add Entry"),
            ),
          ),
        ],
      ),
    );
  }
}
