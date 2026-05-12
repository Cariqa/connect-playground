import 'dart:convert';

import 'package:connect_reference_client/_playground/global_app.dart';
import 'package:flutter/material.dart';

typedef Json = dynamic;

class JsonEditorPlain extends StatefulWidget {
  final Json initialData;
  final bool showFormatButton;
  final ValueChanged<Json>? onChanged;

  const JsonEditorPlain({
    super.key,
    required this.initialData,
    required this.onChanged,
    required this.showFormatButton,
  });

  @override
  State<JsonEditorPlain> createState() => _JsonEditorPlainState();
}

class _JsonEditorPlainState extends State<JsonEditorPlain> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _pretty(widget.initialData));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    try {
      final parsed = jsonDecode(text);
      setState(() => _error = null);
      widget.onChanged?.call(parsed);
    } on FormatException catch (e) {
      setState(() => _error = e.message);
    }
  }

  void _format() {
    if (_error != null) return;
    final parsed = jsonDecode(_controller.text);
    _controller.text = _pretty(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final c = _Colors.of(Theme.of(context).brightness == Brightness.dark);
    final statusColor = _error == null ? c.success : c.danger;

    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(4),
              child: TextField(
                controller: _controller,
                maxLines: 14,
                minLines: 6,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.55,
                  color: context.ext.jsonValue,
                ),
                decoration: const InputDecoration(
                  errorMaxLines: 5,
                  contentPadding: EdgeInsets.all(10),
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: '{\n  "key": "value"\n}',
                ),
                onChanged: _onTextChanged,
              ),
            ),
            if (_error != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(_error == null ? Icons.check_circle_outline : Icons.error_outline,
                        size: 14, color: statusColor),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _error ?? '',
                        style: TextStyle(fontSize: 12, color: statusColor),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        if (widget.showFormatButton)
          Positioned(
            top: 18,
            right: 8,
            child: InkWell(
              onTap: _format,
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 8),
                    Text('Format', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    SizedBox(width: 2),
                    Image.asset('assets/magic_wand.png', width: 24, color: Theme.of(context).primaryColor),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Colors {
  final Color success, danger;
  const _Colors({required this.success, required this.danger});

  static _Colors of(bool dark) {
    if (dark) {
      return const _Colors(
        success: Color(0xFF7DD893),
        danger: Color(0xFFFF7A7A),
      );
    }
    return const _Colors(
      success: Color(0xFF1A7F37),
      danger: Color(0xFFCF222E),
    );
  }
}

String _pretty(Json v) => const JsonEncoder.withIndent('  ').convert(v);
