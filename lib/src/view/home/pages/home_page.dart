import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/extensions/context_extension.dart';
import 'package:todopomodoro/src/core/widgets/custom_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeaderWidget(title: "Welcome", subtitle: "user"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: context.hgap2),

            Text(
              "Selfcare is important!",
              textAlign: TextAlign.center,
              style: context.textStyles.highlight.labelLarge,
            ),

            SizedBox(height: context.hgap1),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.hgap1),
              child: Image.asset(
                "assets/pictures/page/Sleepy_and_Raven.png",
                height: context.screenHeight * 0.3,
                width: context.screenWidth * 1,
                fit: BoxFit.contain,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                child: Text(
                  "So take care during your day, take your breaks and breathe.\n\nFind your own rhythm throughout the day using this app.\n\nFinish your tasks in your own pace, without stress or forgetting them.",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: context.textStyles.highlight.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
