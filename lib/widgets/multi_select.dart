import 'package:flutter/material.dart';
import 'package:spending_app/constants.dart';
import 'package:spending_app/models/member.dart';
import 'package:spending_app/widgets/custom_button.dart';

class MultiSelect extends StatefulWidget {
  final String title;
  final List<Member> items;
  const MultiSelect({Key? key, required this.title, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  List<Member> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(Member itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(onPressed: () {
              setState(() {
                _selectedItems = [];
                for (var item in widget.items) {
                  _selectedItems.add(item);
                }
              });
            }, child: const Text('Chọn tất cả'),),
            ListBody(
              children: widget.items
                  .map((item) => CheckboxListTile(
                value: _selectedItems.contains(item),
                title: Text(item.firstName),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (isChecked) => _itemChange(item, isChecked!),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
      actions: [
        CustomButton(isConfirm: false, width: 100, height: 32, title: ConstantStrings.appString.cancel, onTap: _cancel,),
        CustomButton(width: 100, height: 32, title: ConstantStrings.appString.confirm, onTap: _submit,),
      ],
    );
  }
}