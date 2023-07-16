import 'package:flutter/material.dart';
import 'package:druglog2/models/DrugLog.dart';

class DrugLogPreview extends StatefulWidget {
  final DrugLog drugLog;
  const DrugLogPreview({Key? key, required this.drugLog}) : super(key: key);

  @override
  State<DrugLogPreview> createState() => _DrugLogPreviewState();
}

class _DrugLogPreviewState extends State<DrugLogPreview> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[
            SizedBox(
              width: 200,
              height: 20,
              child: Text('DrugLog name:  ${widget.drugLog.title}'),
            ),
          ]),
          Row(children: <Widget>[
            SizedBox(
              width: 200,
              height: 20,
              child: Text('Creation date:  ${widget.drugLog.creationTime}'),
            ),
          ]),
        ]);
  }
}
