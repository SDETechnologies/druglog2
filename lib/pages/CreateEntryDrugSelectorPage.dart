import 'package:druglog2/global/CreateEntryState.dart';
import 'package:druglog2/models/Drug.dart';
import 'package:druglog2/pages/CreateEntryROASelectorPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateEntryDrugSelectorPage extends StatefulWidget {
  const CreateEntryDrugSelectorPage({super.key});

  @override
  State<CreateEntryDrugSelectorPage> createState() =>
      _CreateEntryDrugSelectorPageState();
}

class _CreateEntryDrugSelectorPageState
    extends State<CreateEntryDrugSelectorPage> {
  List<Drug> drugs = [];
  int? selectedIndex;

  Future<List<Drug>> getDrugs() async {
    List<Drug> d = await Drug.getDrugs();
    drugs = d;
    return d;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select a drug"),
      ),
      body: Column(
        children: [
          FutureBuilder<List<Drug>>(
              future: getDrugs(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Drug>> snapshot) {
                if (!snapshot.hasData) {
                  return Text("Loading");
                }
                return Expanded(
                  child: ListView.builder(
                      itemCount: drugs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ListTile(
                            title: Text(drugs[index].name),
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
              child: Text("Select ROA"),
              onPressed: () {
                if (selectedIndex != null) {
                  CreateEntry.drug = drugs[selectedIndex!];
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CreateEntryROASelectorPagState()));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
