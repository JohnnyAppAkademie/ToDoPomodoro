/*  General Import */
import 'package:flutter/material.dart';

/*  Extension Import */
import 'package:todopomodoro/src/core/utils/extensions/context_extension.dart';

import 'package:todopomodoro/src/core/widgets/app_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppHeaderWidget(title: "Welcome", subtitle: "user"),
            SizedBox(height: context.screenHeight * 0.02),
            Text(
              "Selfcare is important!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: context.screenWidth * 0.05),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.screenHeight * 0.02,
              ),
              child: Image(
                image: AssetImage("assets/pictures/page/Sleepy_and_Raven.png"),
                height: context.screenHeight * 0.4,
                width: context.screenWidth * 0.8,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: context.screenHeight * 0.3,
                child: Text(
                  "So take care during your day, take your breaks and breathe. Find your Rythm throughout the day using this app. Finish your tasks in your own pace, without stress or forgetting them.",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: TextStyle(fontSize: context.screenWidth * 0.045),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
