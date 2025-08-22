/* General Import */
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:todopomodoro/src/core/extensions/context_extension.dart';

/* Data - Import  */
import 'package:todopomodoro/src/core/data/models/task.dart';

class TaskSelectionDialog extends StatefulWidget {
  final List<Task> allTasks;
  final Set<String> initiallySelected;
  final void Function(Set<String>) onSave;

  const TaskSelectionDialog({
    super.key,
    required this.allTasks,
    required this.initiallySelected,
    required this.onSave,
  });

  @override
  State<TaskSelectionDialog> createState() => _TaskSelectionDialogState();
}

class _TaskSelectionDialogState extends State<TaskSelectionDialog> {
  late Set<String> selectedIds;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    selectedIds = Set<String>.from(widget.initiallySelected);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: const SizedBox.expand(),
            ),
          ),
          Center(
            child: Container(
              width: context.screenWidth * 0.9,
              height: context.screenHeight * 0.6,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF4EFFA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    "Select Tasks",
                    style: context.textStyles.dark.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: Scrollbar(
                      controller: _scrollController,

                      child: ListView.builder(
                        itemCount: widget.allTasks.length,
                        itemBuilder: (_, index) {
                          final task = widget.allTasks[index];
                          final isChecked = selectedIds.contains(task.uID);
                          return CheckboxListTile(
                            checkColor: context.appStyle.writingLight,
                            activeColor:
                                context.appStyle.buttonBackgroundprimary,
                            title: Text(
                              "${task.title} - ${task.duration.inMinutes.toString()} min",
                              style: context.textStyles.dark.labelSmall,
                            ),
                            value: isChecked,
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  selectedIds.add(task.uID);
                                } else {
                                  selectedIds.remove(task.uID);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: context.buttonStyles.primary,
                      onPressed: () {
                        widget.onSave(selectedIds);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Fertig",
                        style: context.textStyles.light.bodyMedium,
                      ),
                    ),
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
