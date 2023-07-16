import 'package:flutter/material.dart';
import 'package:druglog2/models/Drug.dart';

class DrugButton extends StatefulWidget {
  final Drug drug;
  const DrugButton({Key? key, required this.drug}) : super(key: key);
  @override
  State<DrugButton> createState() => _DrugButtonState();
}

class _DrugButtonState extends State<DrugButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text(widget.drug.name),
      onPressed: () async {
        // print('drug pressed');
        // await setSelectedDrug(drugs[index]);
        // setState(() {});
      },
    );
  }
}
