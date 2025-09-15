import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/*  Custom TextField */
class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.textController,
    required this.onChanged,
    required this.topic,
    this.isPassword = false,
  });

  final TextEditingController textController;
  final ValueChanged<String> onChanged;
  final bool isPassword;
  final String topic;

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  final FocusNode focus = FocusNode();
  late TextEditingController _textController;
  late ValueChanged<String> _onChanged;
  late String _topic = "";
  late bool _isPassword;

  @override
  void initState() {
    super.initState();
    _textController = widget.textController;
    _onChanged = widget.onChanged;
    _isPassword = widget.isPassword;
    _topic = widget.topic;
  }

  @override
  void dispose() {
    super.dispose();
    focus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isPassword == false) _obscureText = false;

    return TextField(
      controller: _textController,
      focusNode: focus,
      style: context.textStyles.dark.bodySmall!.copyWith(
        color: context.appStyle.writingDark.withValues(alpha: 0.75),
      ),
      cursorColor: context.appStyle.writingDark,
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
}
