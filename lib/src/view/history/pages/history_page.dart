import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/widgets/custom_app_bar.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeaderWidget(title: "History"),
      body: Column(children: [SizedBox(height: 10), Placeholder()]),
    );
  }
}
