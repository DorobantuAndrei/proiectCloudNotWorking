import 'package:flutter/material.dart';

import '../constants.dart';

class InputField extends StatelessWidget {
  final TextEditingController inputController;
  final TextInputType textInputType;
  final String hint;
  final Icon icon;
  final String label;
  final bool isRequired;
  final bool isEnabled;

  final Function onChangeFunction;
  final Function validatorFunction;

  const InputField({
    Key key,
    @required this.inputController,
    @required this.textInputType,
    this.label,
    this.icon,
    this.hint,
    this.isRequired = false,
    this.isEnabled = true,
    @required this.onChangeFunction,
    @required this.validatorFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = kPrimaryColor;
    const accentColor = kPrimaryColor;
    const backgroundColor = Colors.white;
    const errorColor = Color(0xffEF4444);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: const Offset(12, 26),
                blurRadius: 50,
                spreadRadius: 0,
                color: Colors.grey.withOpacity(.1),
              ),
            ],
          ),
          child: TextFormField(
            enabled: isEnabled,
            controller: inputController,
            onChanged: (value) {
              onChangeFunction(value);
            },
            keyboardType: textInputType,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            maxLines: null,
            cursorColor: primaryColor,
            validator: (value) {
              return validatorFunction(value);
            },
            decoration: InputDecoration(
              prefixIcon: icon,
              hoverColor: kPrimaryColor,
              filled: true,
              fillColor: backgroundColor,
              hintText: hint ?? '',
              hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
              errorStyle: const TextStyle(color: errorColor),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: accentColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: errorColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
