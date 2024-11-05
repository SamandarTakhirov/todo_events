import 'package:calendar/core/utils/context_utils.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

class TextInput extends StatefulWidget {
  final String inputName;
  final double size;
  final TextEditingController textEditingController;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final int? maxLines;

  const TextInput({
    required this.inputName,
    required this.textEditingController,
    required this.size,
    this.maxLines = 1,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    super.key,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.inputName,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: widget.size,
            child: TextFormField(
              controller: widget.textEditingController,
              onChanged: (value) {},
              keyboardType: widget.textInputType,
              expands: false,
              textAlign: TextAlign.start,
              textInputAction: TextInputAction.done,
              maxLines: widget.maxLines,
              cursorColor: AppColors.black,
              decoration: const InputDecoration(
                filled: true,
                fillColor: AppColors.inputColor,
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                focusColor: Colors.transparent,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(
                    color: AppColors.thisDay,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
