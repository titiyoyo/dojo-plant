import 'package:flutter/material.dart';
import 'package:flutter_app/lib/ContractData.dart';
import 'package:flutter_app/lib/TreeTypeData.dart';
import 'package:flutter_app/main.dart';

import '../globals.dart' as globals;

class TreesDropDown extends StatefulWidget {
  const TreesDropDown({
    super.key,
    required this.contract
  });

  final String defaultLanguage = 'english';
  final ContractData contract;

  @override
  State<TreesDropDown> createState() => _TreesDropDownState();
}

class _TreesDropDownState extends State<TreesDropDown> {
  String? dropdownValue = null;
  late List<int> treesList;

  @override
  void initState() {
    super.initState();
    treesList = widget.contract.treeList;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: widget.contract.treeList.map((int treeId) {
        Iterable<TreeTypeData> treeTypes = globals.treeTypesData.where(
            (TreeTypeData treeType) => treeType.id == treeId
        );

        late String translation = treeTypes.first.translations['latin'];
        if (treeTypes.first.translations.containsKey(widget.contract.preferences.language)) {
          translation = treeTypes.first.translations[widget.contract.preferences.language];
        }

        return DropdownMenuItem<String>(
            value: treeId.toString(),
            child: Text(translation.toTitleCase)
        );
      }).toList()
    );
  }

  List<DropdownMenuEntry> getMenuEntries() {
    List<DropdownMenuEntry> entries = [];

    widget.contract.treeList.forEach((int treeId) {
      Iterable<TreeTypeData> treeTypes = globals.treeTypesData.where(
        (TreeTypeData treeType) => treeType.id == treeId
      );

      late String translation = treeTypes.first.translations['latin'];
      if (treeTypes.first.translations.containsKey(widget.contract.preferences.language)) {
        translation = treeTypes.first.translations[widget.contract.preferences.language];
      }

      entries.add(DropdownMenuEntry<String>(
          value: treeId.toString(),
          label: translation
      ));
    });

    return entries;
  }
}
