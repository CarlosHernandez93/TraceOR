import 'package:flutter/material.dart';

class CustomListField extends StatefulWidget {
  final List<dynamic> items;
  final String hintText;
  final ValueChanged<dynamic> onChanged;
  final dynamic initialValue;

  const CustomListField({
    super.key,
    required this.items,
    required this.onChanged,
    this.hintText = 'Seleccione una opción',
    this.initialValue,
  });

  @override
  State<CustomListField> createState() => _CustomListFieldState();
}

class _CustomListFieldState extends State<CustomListField> {

  dynamic selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
   Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 238, 238, 238),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey, width: 2.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<dynamic>(
            value: selectedValue,
            hint: Text(
              widget.hintText,
              style: const TextStyle(
                fontFamily: "OpenSans",
                color: Color.fromARGB(255, 108, 108, 108),
                fontWeight: FontWeight.w500
              )
            ),
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 24,
            style: const TextStyle(
              color: Colors.black, 
              fontSize: 16,
            ),
            items: widget.items.map((dynamic item) {
              if(item is String) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }
              else {
                return DropdownMenuItem<dynamic>(
                  value: item['id'],
                  child: Text(item['name']),
                );
              }
            }).toList(),
            onChanged: (dynamic newValue) {
              setState(() {
                selectedValue = newValue;
              });
              widget.onChanged(newValue);
            },
          ),
        )
      ),
    ); 
  }
}