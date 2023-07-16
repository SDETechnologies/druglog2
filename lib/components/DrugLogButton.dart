import 'package:flutter/material.dart';
import 'package:druglog2/models/DrugLog.dart';
import 'package:druglog2/pages/DrugLogPage.dart';
import 'package:druglog2/models/Entry.dart';

class DrugLogButton extends StatefulWidget {
  final DrugLog drugLog;
  const DrugLogButton({Key? key, required this.drugLog}) : super(key: key);
  @override
  State<DrugLogButton> createState() => _DrugLogButtonState();
}

class _DrugLogButtonState extends State<DrugLogButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text('${widget.drugLog.title} - ${widget.drugLog.creationTime}'),
      onPressed: () {
        print('button pressed for druglog: ${widget.drugLog}');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DrugLogPage(drugLog: widget.drugLog)));
      },
    );
  }
}
