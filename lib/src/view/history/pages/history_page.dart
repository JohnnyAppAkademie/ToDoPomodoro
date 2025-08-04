import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/widgets/app_header.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppHeaderWidget(title: "History"),
          SizedBox(height: 10),
          Container(),
        ],
      ),
    );
  }
}
