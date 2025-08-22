/*  Basic Import  */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*  Provider - Import */
import 'package:todopomodoro/src/core/provider/app_provider.dart';

/* Custom Widgets - Import */
import 'package:todopomodoro/src/core/widgets/custom_widgets.dart';
import 'package:todopomodoro/src/view/tag/main/widgets/tag_card.dart';

class TagPage extends StatelessWidget {
  const TagPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tagController = Provider.of<AppProvider>(context);

    if (tagController.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppHeaderWidget(title: "Tags", returnButton: false),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tagController.tags.length,
              itemBuilder: (BuildContext context, int index) {
                final tag = tagController.tags[index];
                return TagCard(
                  tag: tag,
                  settingEnabled: tag.uID != tagController.getDefaultTagUID,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
