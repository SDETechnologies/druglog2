import 'package:flutter/material.dart';

List<String> roaList = [
  "Oral",
  "Intravaenous",
  "Sublingual",
  "Intramuscular",
  "Intranasal",
  "Vaporized",
  "Rectal",
  "Vaginal",
  "Subcataenous",
];

class RoaDropdown extends StatefulWidget {
  // final String selectedRoa = roaList[0];
  final Function(String) parentCallback;
  const RoaDropdown({Key? key, required this.parentCallback}) : super(key: key);
  @override
  State<RoaDropdown> createState() => RoaDropdownState();
}

class RoaDropdownState extends State<RoaDropdown> {
  String selectedRoa = roaList[0];
  String dropdownValue = roaList.first;

  setDropdown(index) {
    dropdownValue = roaList[index];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_drop_down_circle),
        items: roaList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? value) {
          print('Roa dropdown changed to $value');
          setState(() {
            dropdownValue = value!;
            widget.parentCallback(value);
          });
        });
  }
}
