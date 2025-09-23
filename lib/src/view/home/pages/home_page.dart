/* General Import */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/generated/l10n.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* Provider - Import */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show UserProvider;

/* Custom Widget's - Import */
import 'package:todopomodoro/src/widgets/custom_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider controller = context.watch<UserProvider>();

    if (controller.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).welcome,
        subtitle: controller.currentUser!.username,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: context.hgap2),

            Text(
              S.of(context).home_selfcare_header,
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
                  "${S.of(context).home_selfcare_1}\n\n${S.of(context).home_selfcare_2}\n\n${S.of(context).home_selfcare_3}",
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
