import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* Custom Dialog */
class CustomDialoge extends StatelessWidget {
  const CustomDialoge({
    super.key,
    required this.dialogeLabel,
    required this.dialogeText,
    required this.leftButtonText,
    required this.leftButtonFunc,
    required this.rightButtonText,
    required this.rightButtonFunc,
  });

  final String dialogeLabel;
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
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: context.hgap2,
                    horizontal: context.wgap2,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          dialogeLabel,
                          style: context.textStyles.light.labelMedium,
                        ),
                      ),
                      SizedBox(height: context.hgap2),

                      Text(
                        dialogeText,
                        style: context.textStyles.light.labelSmall,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: context.hgap5),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.wgap5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              right: context.screenWidth * 0.12,
              top: context.screenHeight * 0.35,
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
