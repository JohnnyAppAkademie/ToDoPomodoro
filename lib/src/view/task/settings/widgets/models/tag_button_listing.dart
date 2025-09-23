/* General Import */
import 'package:flutter/material.dart';
import 'package:todopomodoro/generated/l10n.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/* View Model - Import */
import 'package:todopomodoro/src/view/task/settings/logic/task_setting_view_model.dart';

/* Data - Import */
import 'package:todopomodoro/src/core/data/data.dart' show Tag;

/* Custom Widgets - Import */
import 'package:todopomodoro/src/widgets/custom_widgets.dart';

/// `TagButtonListing` - Class <br>
/// <br>  __Info:__
/// <br>  Creates a Grid of usable Buttons.
/// <br>  Each Button-Use will add the Task to the corrosponding Tag. <br>
/// <br>  __Required:__ <br>

/// * [ __TaskSettingViewModel : viewModel__ ] - A ViewModel for Logic-Functions
class TagButtonListing extends StatelessWidget {
  const TagButtonListing({super.key, required this.viewModel});

  final TaskSettingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final List<Tag> allTags = viewModel.allTags;
    final List<String> selectedTags = viewModel.selectedTagIds;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: context.wgap5, bottom: context.hgap2),
          child: Text(
            S.of(context).task_setting_tag,
            style: context.textStyles.dark.labelSmall,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.wgap5),
          child: CustomContainer(
            heightLimit: 0.10,
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
                    final bool taskInTag = selectedTags.contains(tag.uID);

                    return ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          taskInTag
                              ? context.appStyle.buttonBackgroundLight
                              : context.appStyle.buttonBackgroundLight
                                    .withValues(alpha: 0.25),
                        ),
                      ),
                      onPressed: () => viewModel.toggleTagSelection(tag.uID),
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
