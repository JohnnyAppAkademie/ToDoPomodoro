/*  Basic Import  */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*  General - Design  */
import 'package:todopomodoro/style.dart';
/* Generic Widgets - Import */
import 'package:todopomodoro/src/core/widgets/app_header.dart';
/*  TagCard - Design */
import 'package:todopomodoro/src/view/tag/widgets/tag_card.dart';
/*  Provider - Import */
import 'package:todopomodoro/src/core/utils/task/task_provider.dart';

class TagPage extends StatelessWidget {
  const TagPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TaskProvider>();

    if (controller.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColours.background,
      body: Column(
        children: [
          AppHeaderWidget(title: "Tags"),
          Expanded(
            child: ListView.builder(
              itemCount: controller.tags.length,
              itemBuilder: (BuildContext context, int index) {
                final tag = controller.tags[index];
                return TagCard(tag: tag, settingEnabled: tag.name != "Tasks");
              },
            ),
          ),
        ],
      ),
    );
  }
}
