import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/extensions/context_extension.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: Center(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.red),
            foregroundColor: WidgetStateProperty.all(Colors.white),
          ),
          child: Text(
            'App-Daten zurücksetzen',
            style: context.textStyles.light.labelLarge,
          ),
          onPressed: () async {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Daten wurden zurückgesetzt')),
            );
          },
        ),
      ),
    );
  }
}
