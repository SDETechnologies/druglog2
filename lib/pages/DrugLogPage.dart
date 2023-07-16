import 'package:druglog2/models/Entry.dart';
import 'package:druglog2/models/drug.dart';
import 'package:druglog2/components/AddEntryDialog.dart';
import 'package:flutter/material.dart';

class DrugLogPage extends StatefulWidget {
  const DrugLogPage({super.key});

  @override
  State<DrugLogPage> createState() => _DrugLogPageState();
}

class _DrugLogPageState extends State<DrugLogPage> {
  List<Entry> logs = [];
  List<Drug> drugs = [];

  TextEditingController notesEditingController = TextEditingController();
  TextEditingController doseEditingController = TextEditingController();

  var selectedDrug;

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

  @override
  Widget build(BuildContext context) {
    getLogs();
    getDrugs();

    return Scaffold();
  }
}
