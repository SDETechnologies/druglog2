import 'package:flutter/material.dart';

import '../models/drug_model.dart';

class DrugPage extends StatefulWidget {
  const DrugPage({super.key});

  @override
  State<DrugPage> createState() => _DrugPageState();
}

class _DrugPageState extends State<DrugPage> {
  final drugNameController = TextEditingController();

  List<Drug> drugs = [];

  void insertDrug() async {
    if (drugNameController.text == "") {
      return;
    }
    Drug drug = await Drug.insertDrug(drugNameController.text);
    drugs.add(drug);
    drugNameController.clear();
    setState(() {});
  }

  void deleteDrug(Drug drug) async {
    drug.Delete();
    drugs = await Drug.getDrugs();
    setState(() {});
  }

  void load() async {
    drugs = await Drug.getDrugs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    load();
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: drugNameController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: "Enter a drug"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          child: Row(
            children: [
              FilledButton(
                child: const Text("Add Drug"),
                onPressed: insertDrug,
              ),
              const Spacer()
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          child: Column(
            children: [
              for (var drug in drugs)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  child: Row(
                    children: [
                      Text(drug.name),
                      Spacer(),
                      IconButton(
                          onPressed: () => deleteDrug(drug),
                          icon: Icon(Icons.delete))
                    ],
                  ),
                )
            ],
          ),
        )
      ],
    );
  }
}
