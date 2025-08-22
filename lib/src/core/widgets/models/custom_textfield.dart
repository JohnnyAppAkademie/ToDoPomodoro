import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/extensions/context_extension.dart';

/*  Custom TextField */
class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.textController,
    required this.focusNode,
    required this.onChanged,
    required this.topic,
    required this.isPassword,
  });

  final TextEditingController textController;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool isPassword;
  final String topic;

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  late TextEditingController _textController;
  late FocusNode _focusNode;
  late ValueChanged<String> _onChanged;
  late String _topic = "";
  late bool _isPassword;

  @override
  void initState() {
    _textController = widget.textController;
    _focusNode = widget.focusNode;
    _onChanged = widget.onChanged;
    _isPassword = widget.isPassword;
    _topic = widget.topic;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isPassword == false) _obscureText = false;

    return TextField(
      controller: _textController,
      style: context.textStyles.dark.bodySmall!.copyWith(
        color: context.appStyle.writingDark.withValues(alpha: 0.75),
      ),
      cursorColor: context.appStyle.writingDark,
      focusNode: _focusNode,
      onChanged: _onChanged,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: _topic,
        labelStyle: context.textStyles.dark.bodySmall!.copyWith(
          color: context.appStyle.writingDark.withValues(alpha: 0.75),
        ),
        border: OutlineInputBorder(),
        suffixIcon: _isPassword
            ? IconButton(
                icon: Icon(
                  color: context.appStyle.writingDark,
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }

  bool isValidEmail(String email) {
    RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
      caseSensitive: false,
    );

    return emailRegex.hasMatch(email);
  }
}
