import 'package:flutter/material.dart';
import 'package:druglog2/models/DrugLog.dart';
import 'package:druglog2/components/DrugLogButton.dart';

class DrugLogListView extends StatefulWidget {
  final List<DrugLog> drugLogList;
  const DrugLogListView({Key? key, required this.drugLogList})
      : super(key: key);
  @override
  State<DrugLogListView> createState() => _DrugLogListViewState();
}

class _DrugLogListViewState extends State<DrugLogListView> {
  // getDrugLogs() async {
  //   drugLogList = await DrugLog
  // }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        for (var drugLog in widget.drugLogList)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(5.0, 5.0)),
                ],
              ),
              child: Container(
                color: Colors.grey.shade100,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DrugLogButton(drugLog: drugLog)),
              ),
            ),
          )
      ],
    );
  }
}
