import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/dimens.dart';

/// * Area for stateProvider

class DynamicDropDownWidget<T> extends ConsumerStatefulWidget {
  const DynamicDropDownWidget(
      {super.key,
      required this.items,
      required this.onSelect,
      this.defaultBgColor = true,
        this.hintText,
      this.initValue});
  final List<dynamic> items;
  final void Function(dynamic) onSelect;
  final bool defaultBgColor;
  final dynamic initValue;
  final String? hintText;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends ConsumerState<DynamicDropDownWidget> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.white,
      ),
      child: DropdownButtonFormField2<dynamic>(
        value: widget.initValue,
        hint: Text(widget.hintText ?? '',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.normal),),
        isExpanded: true,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey, width: 1)),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(vertical: 16, horizontal: 2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        selectedItemBuilder: (BuildContext context) {
          return widget.items.map<Widget>((dynamic item) {
            return Text(
              item['name'],
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal
              ),
            );
          }).toList();
        },
        items: widget.items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item['name'],
                    style: const TextStyle(
                      color: Colors.black,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                ))
            .toList(),
        onChanged: (value) => widget.onSelect(value),
        validator: (value) {
          if (value == null) {
            return 'Please select';
          }
          return null;
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 2),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.black45,
          ),
          iconSize: 24,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
    );
  }
}
