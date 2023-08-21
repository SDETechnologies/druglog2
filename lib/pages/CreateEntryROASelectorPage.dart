import 'package:druglog2/global/CreateEntryState.dart';
import 'package:druglog2/models/ROA.dart';
import 'package:druglog2/pages/CreateEntryDoseSelectorPage.dart';
import 'package:flutter/material.dart';

class CreateEntryROASelectorPagState extends StatefulWidget {
  const CreateEntryROASelectorPagState({super.key});

  @override
  State<CreateEntryROASelectorPagState> createState() =>
      _CreateEntryROASelectorPagStateState();
}

class _CreateEntryROASelectorPagStateState
    extends State<CreateEntryROASelectorPagState> {
  List<ROA> roas = [];
  int? selectedIndex;

  Future<List<ROA>> getAllRoas() async {
    List<ROA> r = await ROA.getROAs();
    roas = r;
    return r;
  }

  @override
  Widget build(BuildContext context) {
    getAllRoas();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select ROA"),
      ),
      body: Column(
        children: [
          FutureBuilder<List<ROA>>(
              future: getAllRoas(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<ROA>> snapshot) {
                if (!snapshot.hasData) {
                  return Text("Loading");
                }
                return Expanded(
                  child: ListView.builder(
                      itemCount: roas.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ListTile(
                            title: Text(roas[index].value!),
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
              child: Text("Select Dose"),
              onPressed: () {
                if (selectedIndex != null) {
                  CreateEntry.roa = roas[selectedIndex!];
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateEntryDosePage()));
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
