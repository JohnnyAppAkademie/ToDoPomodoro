import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/data/models/tag.dart';
import 'package:todopomodoro/src/core/extensions/context_extension.dart';
import 'package:todopomodoro/src/core/widgets/custom_widgets.dart';

class TagListing extends StatelessWidget {
  const TagListing({
    super.key,
    required this.allTags,
    required this.chosenTags,
    required this.onTagPressed,
  });

  final List<Tag> allTags;
  final List<String> chosenTags;
  final ValueChanged<String> onTagPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: context.wgap5, bottom: context.hgap2),
          child: Text(
            "Associated Tags",
            style: context.textStyles.dark.labelSmall,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.wgap5),
          child: CustomContainer(
            hightLimit: 0.10,
            childWidget: LayoutBuilder(
              builder: (context, constraints) {
                const double minButtonWidth = 120;

                final int crossAxisCount =
                    (context.screenWidth / minButtonWidth).floor().clamp(2, 6);

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 2.8,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: allTags.length - 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final Tag tag = allTags[index + 1];
                    final bool taskInTag = chosenTags.contains(tag.uID);

                    return ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          taskInTag
                              ? context.appStyle.buttonBackgroundLight
                              : context.appStyle.buttonBackgroundLight
                                    .withValues(alpha: 0.25),
                        ),
                      ),
                      onPressed: () => onTagPressed(tag.uID),
                      child: Text(
                        tag.title,
                        style: TextStyle(
                          color: context.appStyle.writingHighlight,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
