/*  General Import  */
import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';

/*  View Model - Import  */
import 'package:todopomodoro/src/view/task/settings/logic/task_setting_view_model.dart';

/*  Custom Widgets - Import */
import 'package:todopomodoro/src/widgets/custom_widgets.dart';

/// `TaskDurationPicker` - Class <br>
/// <br>  __Info:__
/// <br>  Creates a Widget to choose the duration of a task. <br>
/// <br>  __Required:__ <br>
/// * [ __TaskSettingViewModel : viewModel__ ] - A ViewModel for Logic-Functions
class TaskDurationPicker extends StatefulWidget {
  final TaskSettingViewModel viewModel;

  const TaskDurationPicker({super.key, required this.viewModel});

  @override
  State<TaskDurationPicker> createState() => _TaskDurationPickerState();
}

class _TaskDurationPickerState extends State<TaskDurationPicker> {
  late FixedExtentScrollController _controller;
  late TextEditingController _textController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(
      initialItem: widget.viewModel.task.duration.inMinutes - 1,
    );
    _textController = TextEditingController(
      text: widget.viewModel.task.duration.inMinutes.toString(),
    );
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /* Get-Function */

  /// `TaskDurationPicker - getcurrentMinutes()` <br>
  /// <br>  __Info:__
  /// <br>  Get-Function to return the currently chosen Duration of the Task. <br>
  int get getcurrentMinutes =>
      int.tryParse(_textController.text) ??
      widget.viewModel.task.duration.inMinutes;

  /// `TaskDurationPicker - formattedDuration()` <br>
  /// <br>  __Info:__
  /// <br>  Get-Function to return the currently chosen Duration as a String. <br>
  String get formattedDuration {
    final hours = widget.viewModel.task.duration.inHours;
    final minutes = widget.viewModel.task.duration.inMinutes % 60;
    if (hours > 0) {
      return "${hours}h ${minutes.toString().padLeft(2, '0')}min";
    }
    return "${widget.viewModel.task.duration.inMinutes} min";
  }

  /*  Functions */

  /// `TaskDurationPicker - _updateMinutes()` <br>
  /// <br>  __Info:__
  /// <br>  Updates the task with the new duration <br>
  /// <br>  __Required:__ <br>
  /// [ __int : newMinutes__] - The Duration ( in minutes ) for the update
  void _updateMinutes(int newMinutes) {
    if (newMinutes < 1) newMinutes = 1;
    if (newMinutes > 120) newMinutes = 120;

    widget.viewModel.updateDuration(Duration(minutes: newMinutes));
    _textController.text = newMinutes.toString();

    if (_controller.selectedItem != newMinutes - 1) {
      _controller.animateToItem(
        newMinutes - 1,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }

    _textController.selection = TextSelection.fromPosition(
      TextPosition(offset: _textController.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /* Label */
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.wgap5,
              vertical: context.hgap2,
            ),
            child: Row(
              children: [
                Text(
                  "Duration of the Task -",
                  style: context.textStyles.dark.labelSmall,
                ),
                SizedBox(width: context.wgap5),
                Text(
                  formattedDuration,
                  style: context.textStyles.highlight.labelSmall,
                ),
              ],
            ),
          ),

          /* Duration Picker */
          SizedBox(
            height: context.screenHeight * 0.20,
            width: context.screenWidth * 0.90,
            child: CustomContainer(
              heightLimit: 0.15,
              childWidget: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Minus-Button
                      IconButton(
                        icon: const Icon(Icons.remove),
                        color: context.appStyle.writingHighlight,
                        style: context.buttonStyles.secondary,
                        onPressed: () => _updateMinutes(getcurrentMinutes - 1),
                      ),
                      // Scrollrad
                      SizedBox(
                        height: context.screenHeight * 0.15,
                        width: context.screenWidth * 0.25,
                        child: ListWheelScrollView.useDelegate(
                          controller: _controller,
                          itemExtent: 60,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            _updateMinutes(index + 1);
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              Widget item = Center(
                                child: Text(
                                  (index + 1).toString().padLeft(2, '0'),
                                  style: context.textStyles.dark.labelMedium,
                                ),
                              );

                              if (context.isDesktop) {
                                item = MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () => _updateMinutes(index + 1),
                                    child: item,
                                  ),
                                );
                              }
                              return item;
                            },
                            childCount: 120,
                          ),
                        ),
                      ),

                      IconButton(
                        icon: Icon(Icons.add),
                        style: context.buttonStyles.secondary,
                        color: context.appStyle.writingHighlight,
                        onPressed: () => _updateMinutes(
                          widget.viewModel.task.duration.inMinutes + 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
