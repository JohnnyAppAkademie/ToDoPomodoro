/*  Basic Import  */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todopomodoro/generated/l10n.dart';

/*  Provider - Import */
import 'package:todopomodoro/src/core/provider/providers.dart'
    show TaskProvider;
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* Custom Widgets - Import */
import 'package:todopomodoro/src/widgets/custom_widgets.dart';
import 'package:todopomodoro/src/view/tag/main/widgets/tag_card.dart';

class TagPage extends StatelessWidget {
  const TagPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tagController = Provider.of<TaskProvider>(context);

    if (tagController.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final filteredTags = tagController.tags
        .where((tag) => tag != tagController.getDefaultTag)
        .toList();

    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).tag),
      body: Column(
        children: [
          Expanded(
            child: filteredTags.isEmpty
                ? Center(
                    child: Text(
                      S.of(context).no_tags,
                      style: context.textStyles.dark.titleSmall,
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredTags.length,
                    itemBuilder: (BuildContext context, int index) {
                      final tag = filteredTags[index];
                      return TagCard(tag: tag);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
