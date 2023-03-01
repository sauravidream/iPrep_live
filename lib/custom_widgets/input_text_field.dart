import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idream/common/constants.dart';

import '../../ui/onboarding/sign_up/sign_up_page.dart';

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget({
    Key? key,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.initialValue,
    this.hintText,
    this.errorText,
    this.iconData,
    this.padding,
    this.labelText,
    this.obscureText,
    this.suffixIcon,
    this.isFirst,
    this.isLast,
    this.style,
    this.textAlign,
    this.suffix,
    this.prefixText,
    this.textEditingController,
    this.info,
    this.onTap,
    this.enabled,
    this.inputSuffixIcon,
    this.inputFormatters,
  }) : super(key: key);

  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  bool? enabled = false;
  final String? initialValue;
  final String? hintText;
  final String? errorText;
  final Widget? inputSuffixIcon;
  final TextAlign? textAlign;
  final String? labelText;
  final TextStyle? style;
  final IconData? iconData;
  final Widget? padding;
  final bool? obscureText;
  final bool? isFirst;
  final bool? isLast;
  final Widget? suffixIcon;
  final Widget? suffix;
  final String? prefixText;
  final TextEditingController? textEditingController;
  bool? info = false;
  int? inputFormatters = 20;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              labelText ?? '',
              style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400),
              textAlign: textAlign ?? TextAlign.start,
            ),
            const SizedBox(
              width: 2,
            ),
            info == true
                ? GestureDetector(
                    onTap: onTap,
                    child: const Icon(
                      Icons.info_outline,
                      size: 14,
                    ))
                : const SizedBox(),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          inputFormatters: [
            LengthLimitingTextInputFormatter(inputFormatters),
          ],
          enabled: enabled,
          keyboardType: keyboardType ?? TextInputType.text,
          onSaved: onSaved,
          onChanged: onChanged,
          validator: validator,
          controller: textEditingController,
          style: style ?? const TextStyle(color: Colors.black),
          obscureText: obscureText ?? false,
          textAlign: textAlign ?? TextAlign.start,
          cursorColor: Colors.black87,
          decoration: InputDecoration(
            suffixIcon: inputSuffixIcon,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xFFCDCDCD),
            ),
            prefixText: prefixText,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF0077FF),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: Constants.inputTextOutline,
            border: Constants.inputTextOutline,
          ),
        ),
      ],
    );
  }
}
