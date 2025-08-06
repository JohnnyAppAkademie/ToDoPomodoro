import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/widgets/custom_app_bar.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeaderWidget(title: "Settings"),
      body: Placeholder(),
    );
  }
}
