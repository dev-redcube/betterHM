import 'package:better_hm/home/calendar/view/component/input_container.dart';
import 'package:flutter/material.dart';

class CalendarTextField extends StatelessWidget {
  const CalendarTextField({
    required this.label,
    required this.controller,
    required this.inputValid,
    this.onChanged,
    required this.placeholder,
    super.key,
  });

  final String label;
  final String? placeholder;
  final TextEditingController controller;
  final Stream<String?> inputValid;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: inputValid,
      builder: (context, snapshot) {
        return InputContainer(
          child: TextFormField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              labelText: label,
              hintText: placeholder,
              border: InputBorder.none,
              errorText: snapshot.data,
            ),
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          ),
        );
      },
    );
  }
}
