import 'package:druglog2/global/CreateEntryState.dart';
import 'package:druglog2/models/Unit.dart';
import 'package:druglog2/pages/CreateEntryDateSelectorPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateEntryDosePage extends StatefulWidget {
  const CreateEntryDosePage({super.key});

  @override
  State<CreateEntryDosePage> createState() => _CreateEntryDosePageState();
}

class _CreateEntryDosePageState extends State<CreateEntryDosePage> {
  List<Unit> units = [];
  int? selectedIndex;
  TextEditingController amountEditingController = TextEditingController();

  void getAllUnits() async {
    units = await Unit.getUnits();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getAllUnits();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter amount"),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: amountEditingController,
            decoration: InputDecoration(
                hintText: "Enter amount", border: OutlineInputBorder()),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: units.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(units[index].value!),
                    tileColor: selectedIndex == index ? Colors.black12 : null,
                    onTap: (() {
                      setState(() {
                        selectedIndex = index;
                      });
                    }),
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FilledButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                minimumSize: const Size.fromHeight(50)),
            child: Text("Select date"),
            onPressed: () {
              if (selectedIndex != null && amountEditingController.text != "") {
                CreateEntry.unit = units[selectedIndex!];
                CreateEntry.dose = amountEditingController.text;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateEntryDateSelectorPage()));
              }
            },
          ),
        ),
      ]),
    );
  }
}
