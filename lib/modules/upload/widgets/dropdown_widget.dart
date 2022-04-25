import 'package:flutter/material.dart';

class DropdownWidget extends StatelessWidget {
  final Function(String?)? onChanged;
  final Function()? onTap;
  final String hint;
  final String value;
  final List<DropdownMenuItem<String>>? items;
  final Color? dropdownColor;

  const DropdownWidget(
      {Key? key,
      required this.onChanged,
      this.hint = '',
      required this.value,
      required this.items,
      this.dropdownColor,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.0,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton(
        dropdownColor: dropdownColor,
        underline: Container(height: 0),
        hint: Text(
          hint,
          style: const TextStyle(color: Colors.black),
        ),
        style: const TextStyle(fontSize: 15),
        isExpanded: true,
        itemHeight: 60.0,
        onChanged: onChanged,
        onTap: onTap,
        value: value,
        items: items,
      ),
    );
  }
}
