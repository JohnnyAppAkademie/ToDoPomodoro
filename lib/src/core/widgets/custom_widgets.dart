import 'dart:ui';
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

/* Custom Container */
class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.childWidget,
    this.hightLimit,
  });
  final Widget childWidget;
  final double? hightLimit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: hightLimit != null ? context.screenHeight * hightLimit! : null,
      decoration: BoxDecoration(
        color: context.appStyle.labelBackground.withAlpha(30),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: context.appStyle.labelBackground.withAlpha(50),
          width: 0.75,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: childWidget,
    );
  }
}

/* Custom Appbar */
class AppHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppHeaderWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.returnButton = false,
    this.callBack,
  });

  final String title;
  final String? subtitle;
  final bool returnButton;
  final VoidCallback? callBack;

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 4,
      backgroundColor: context.appBarTheme.backgroundColor,
      centerTitle: true,
      title: Text(title, style: context.textStyles.light.labelLarge),

      leading: returnButton
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: callBack,
            )
          : null,

      actions: [
        IconButton(
          icon: Icon(Icons.person, color: Colors.white),
          onPressed: () => {},
        ),
      ],

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(35),
        child: Container(
          width: double.infinity,
          height: 35,
          decoration: BoxDecoration(
            color: appBarTheme.backgroundColor,
            border: Border(
              top: BorderSide(color: Colors.black, width: 1.0),
              bottom: BorderSide(color: Colors.black, width: 1.0),
            ),
          ),
          alignment: Alignment.center,
          child: subtitle != null
              ? Text(
                  subtitle!,
                  style: context.textStyles.light.labelSmall,
                  textAlign: TextAlign.center,
                )
              : SizedBox.shrink(),
        ),
      ),
    );
  }
}

/* Custom Dialog */
class CustomDialoge extends StatelessWidget {
  const CustomDialoge({
    super.key,
    required this.dialogeText,
    required this.leftButtonText,
    required this.leftButtonFunc,
    required this.rightButtonText,
    required this.rightButtonFunc,
  });

  final String dialogeText;
  final String leftButtonText;
  final VoidCallback leftButtonFunc;
  final String rightButtonText;
  final VoidCallback rightButtonFunc;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDialog(context, leftButtonFunc, rightButtonFunc);
    });

    return const SizedBox.shrink();
  }

  Future<dynamic> _showDialog(
    BuildContext context,
    VoidCallback leftButtonFunc,
    VoidCallback rightButtonFunc,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),

            Center(
              child: Container(
                width: context.screenWidth * 0.75,
                height: context.screenHeight * 0.25,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.appStyle.gradient1,
                      context.appStyle.gradient2,
                      context.appStyle.gradient3,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: context.appStyle.buttonBackgroundprimary,
                    width: 0.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Dialogtext
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        dialogeText,
                        style: context.textStyles.light.labelSmall,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // Button-Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDialogButton(
                          context,
                          label: leftButtonText,
                          onPressed: leftButtonFunc,
                        ),
                        _buildDialogButton(
                          context,
                          label: rightButtonText,
                          onPressed: rightButtonFunc,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Exit-Button oben rechts
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.cancel_outlined, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogButton(
    BuildContext context, {
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 50,
      width: 100,
      decoration: BoxDecoration(
        color: context.appStyle.buttonBackgroundLight,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: context.appStyle.buttonBackgroundLight,
          width: 0.5,
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(label, style: context.textStyles.highlight.bodySmall),
      ),
    );
  }
}
