import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/util/context_extension.dart';
import 'package:todopomodoro/src/widgets/custom_widgets.dart';

class TaskDurationPicker extends StatefulWidget {
  final Duration duration;
  final ValueChanged<Duration> onChanged;

  const TaskDurationPicker({
    super.key,
    required this.duration,
    required this.onChanged,
  });

  @override
  State<TaskDurationPicker> createState() => _TaskDurationPickerState();
}

class _TaskDurationPickerState extends State<TaskDurationPicker> {
  late FixedExtentScrollController _controller;
  late TextEditingController _textController;
  late FocusNode _focusNode;

  int get currentMinutes =>
      int.tryParse(_textController.text) ?? widget.duration.inMinutes;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(
      initialItem: widget.duration.inMinutes - 1,
    );
    _textController = TextEditingController(
      text: widget.duration.inMinutes.toString(),
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

  void _updateMinutes(int newMinutes) {
    if (newMinutes < 1) newMinutes = 1;
    if (newMinutes > 120) newMinutes = 120;

    widget.onChanged(Duration(minutes: newMinutes));
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

  String get formattedDuration {
    final hours = widget.duration.inHours;
    final minutes = widget.duration.inMinutes % 60;
    if (hours > 0) {
      return "${hours}h ${minutes.toString().padLeft(2, '0')}min";
    }
    return "${widget.duration.inMinutes} min";
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Label
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
                const SizedBox(width: 8),
                Text(
                  formattedDuration,
                  style: context.textStyles.highlight.labelSmall,
                ),
              ],
            ),
          ),
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
                        onPressed: () => _updateMinutes(currentMinutes - 1),
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
                        icon: const Icon(Icons.add),
                        style: context.buttonStyles.secondary,
                        color: context.appStyle.writingHighlight,
                        onPressed: () => _updateMinutes(currentMinutes + 1),
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
