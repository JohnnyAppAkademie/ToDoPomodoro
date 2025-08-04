/* General Import */
import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/utils/extensions/context_extension.dart';
/*  Custom Widgets - Import */
import 'package:todopomodoro/src/core/widgets/app_header.dart';
import 'package:todopomodoro/src/core/widgets/custom_editable_text.dart';

/* Tag-Logik - Import */
import 'package:todopomodoro/src/data/tag.dart';

class TagSettingPage extends StatefulWidget {
  const TagSettingPage({super.key, this.tag});

  final Tag? tag;

  @override
  State<TagSettingPage> createState() => _TagSettingPageState();
}

class _TagSettingPageState extends State<TagSettingPage> {
  late Tag? tag;

  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController(
    text: "Initialer Text",
  );

  @override
  void initState() {
    super.initState();
    if (widget.tag != null) {
      tag = widget.tag;
      _controller.text = widget.tag!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppHeaderWidget(
            title: widget.tag != null ? "Tag - Adjustment" : "Tag - Creation",
            subtitle: widget.tag?.name,
            returnButton: true,
            callBack: () => Navigator.pop(context),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TagLabel(controller: _controller, focusNode: _focusNode),
            ],
          ),
        ],
      ),
    );
  }
}

class _TagLabel extends StatelessWidget {
  const _TagLabel({
    required TextEditingController controller,
    required FocusNode focusNode,
  }) : _controller = controller,
       _focusNode = focusNode;

  final TextEditingController _controller;
  final FocusNode _focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: context.hgap5,
            left: context.wgap5,
            bottom: context.hgap2,
          ),
          child: Text("Tag:"),
        ),
        CustomEditableText(controller: _controller, focusNode: _focusNode),
      ],
    );
  }
}
