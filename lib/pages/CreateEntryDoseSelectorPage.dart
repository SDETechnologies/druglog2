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
  int? selectedIndex;
  TextEditingController amountEditingController = TextEditingController();

  List<Unit> units = [];

  Future<List<Unit>> getAllUnits() async {
    List<Unit> u = await Unit.getUnits();
    units = u;
    return u;
  }

  @override
  Widget build(BuildContext context) {
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
        FutureBuilder<List<Unit>>(
            future: getAllUnits(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Unit>> snapshot) {
              if (!snapshot.hasData) {
                return Text("Loading");
              }
              return Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(snapshot.data![index].value!),
                          tileColor:
                              selectedIndex == index ? Colors.black12 : null,
                          onTap: (() {
                            setState(() {
                              selectedIndex = index;
                            });
                          }),
                        ),
                      );
                    }),
              );
            }),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FilledButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                minimumSize: const Size.fromHeight(50)),
            child: Text("Select date"),
            onPressed: () {
              if (selectedIndex != null &&
                  units != [] &&
                  amountEditingController.text != "") {
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
