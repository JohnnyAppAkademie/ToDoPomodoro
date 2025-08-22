import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/widgets/custom_widgets.dart';

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
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TaskDurationPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.animateToItem(
        widget.duration.inMinutes - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      _textController.text = widget.duration.inMinutes.toString();
    }
  }

  void _onTextChanged(String value) {
    final minutes = int.tryParse(value);
    if (minutes != null && minutes >= 1 && minutes <= 120) {
      widget.onChanged(Duration(minutes: minutes));
      _controller.animateToItem(
        minutes - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label
            Text(
              "Duration of the Task",
              style: TextStyle(
                fontSize: isDesktop ? 20 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Duration display
            Text(
              formattedDuration,
              style: TextStyle(
                fontSize: isDesktop ? 26 : 20,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            // Scrollrad
            SizedBox(
              height: 120,
              child: NotificationListener<ScrollEndNotification>(
                onNotification: (notification) {
                  final index = _controller.selectedItem;
                  widget.onChanged(Duration(minutes: index + 1));
                  _textController.text = (index + 1).toString();
                  return true;
                },
                child: ListWheelScrollView.useDelegate(
                  controller: _controller,
                  itemExtent: 45,
                  physics: const FixedExtentScrollPhysics(),
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      Widget item = Center(
                        child: Text(
                          (index + 1).toString().padLeft(2, '0'),
                          style: TextStyle(
                            fontSize: isDesktop ? 24 : 18,
                            color: Colors.black87,
                          ),
                        ),
                      );

                      // Klickbar auf Desktop
                      if (isDesktop) {
                        item = MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              _controller.animateToItem(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                              widget.onChanged(Duration(minutes: index + 1));
                              _textController.text = (index + 1).toString();
                            },
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
            ),
            const SizedBox(height: 16),
            // Manuelle Eingabe
            SizedBox(
              width: 200,
              child: CustomTextField(
                textController: _textController,
                focusNode: _focusNode,
                topic: 'Minuten',
                isPassword: false,
                onChanged: _onTextChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
