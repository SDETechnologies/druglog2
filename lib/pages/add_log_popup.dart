import 'package:druglog2/models/drug_log_model.dart';
import 'package:druglog2/models/drug_model.dart';
import 'package:druglog2/models/entry_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddLogPopup {
  AddLogPopup();

  Future show(
      BuildContext context, List<Drug> drugs, void setDrug(Drug)) async {
    DrugLog drugLog = await DrugLog.insertDrugLog("test");
    Drug drug = await Drug.insertDrug("acid");

    Entry entry = await Entry.insertLog("test", drugLog.id!);
    Entry entry2 =
        await Entry.insertLogWithDrug("test", drug.id!, "1 tab", drugLog.id!);

    List<Entry> entries = await drugLog.getEntriesForDrugLog();

    print(entries);

    return showDialog(
      context: context,
      builder: (context) => Theme(
        data: ThemeData(dialogBackgroundColor: Colors.white),
        child: AlertDialog(
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: drugs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return OutlinedButton(
                        child: Text(drugs[index].name),
                        onPressed: () {
                          setDrug(drugs[index]);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
