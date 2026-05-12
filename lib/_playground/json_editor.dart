import 'package:connect_reference_client/_playground/global_app.dart';
import 'package:connect_reference_client/_playground/playground.dart';
import 'package:connect_reference_client/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JsonEditor extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onChanged;

  const JsonEditor({
    super.key,
    required this.initialData,
    required this.onChanged,
  });

  @override
  State<JsonEditor> createState() => _JsonEditorState();
}

class _JsonEditorState extends State<JsonEditor> {
  late Map<String, dynamic> _data;

  @override
  void initState() {
    super.initState();
    _data = Map<String, dynamic>.from(widget.initialData);
  }

  @override
  void didUpdateWidget(covariant JsonEditor oldWidget) {
    _data = Map<String, dynamic>.from(widget.initialData);
    setState(() {});

    super.didUpdateWidget(oldWidget);
  }

  void _notify() => widget.onChanged(_data);

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          _SyntaxText("{", color: context.ext.jsonValue),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: _buildMap(_data),
          ),
          _SyntaxText("}", color: context.ext.jsonValue),
        ],
      ),
    );
  }

  Widget _buildMap(Map<String, dynamic> map) {
    List<Widget> children = [];
    final keys = map.keys.toList();

    for (int i = 0; i < keys.length; i++) {
      final key = keys[i];
      final value = map[key];

      final valueWidget = _buildValue(
        value,
        key,
        (newVal) {
          setState(() => map[key] = newVal);
          _notify();
        },
      );

      final innerChildren = [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            children: [
              _SyntaxText('"$key": ', color: context.ext.jsonKey),
              if (value is Map) _SyntaxText('{'),
            ],
          ),
        ),
        if (isMobile) Flexible(child: valueWidget) else IntrinsicWidth(child: valueWidget),
      ];

      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: value is Map
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: innerChildren,
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: innerChildren,
                ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildList(List<dynamic> list, Function(List<dynamic>) onUpdate) {
    final addButton = TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        minimumSize: Size(16, 16),
      ),
      onPressed: () {
        setState(() => list.add(""));
        onUpdate(list);
      },
      child: Icon(Icons.add_circle_outline, color: context.ext.jsonValue, size: 16),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 6),
        const _SyntaxText("["),
        ...list.asMap().entries.map((entry) {
          final idx = entry.key;
          final val = entry.value;
          final isLast = idx == list.length - 1;

          return Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IntrinsicWidth(
                    child: _buildValue(val, list.elementAt(idx), (newVal) {
                  list[idx] = newVal;
                  onUpdate(list);
                })),
                _SyntaxText(" ,", color: !isLast ? null : Colors.transparent),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    minimumSize: Size(16, 16),
                  ),
                  child: const Icon(Icons.remove_circle_outline, color: Colors.deepOrangeAccent, size: 16),
                  onPressed: () {
                    setState(() => list.removeAt(idx));
                    onUpdate(list);
                  },
                ),
                if (isLast) addButton,
              ],
            ),
          );
        }),
        if (list.isEmpty) addButton,
        const _SyntaxText("]"),
      ],
    );
  }

  Widget _buildValue(dynamic value, String keyString, Function(dynamic) onUpdate) {
    if (value is Map<String, dynamic>) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.only(left: 20), child: _buildMap(value)),
          const _SyntaxText("}"),
        ],
      );
    } else if (value is List) {
      return _buildList(value, onUpdate);
    } else {
      return _InlineEditor(
        initialValue: value.toString(),
        keyString: keyString,
        onChanged: (v) => onUpdate(v),
      );
    }
  }
}

class _SyntaxText extends StatelessWidget {
  final String text;
  final Color? color;
  const _SyntaxText(this.text, {this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.robotoMono(
        color: color ?? context.ext.jsonValue,
        fontSize: 14,
      ),
    );
  }
}

class _InlineEditor extends StatefulWidget {
  final String initialValue;
  final String keyString;
  final Function(dynamic) onChanged;

  const _InlineEditor({required this.initialValue, required this.onChanged, required this.keyString});

  @override
  State<_InlineEditor> createState() => _InlineEditorState();
}

class _InlineEditorState extends State<_InlineEditor> {
  final controller = TextEditingController();

  @override
  void initState() {
    controller.text = handleText(widget.initialValue);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _InlineEditor oldWidget) {
    controller.value = controller.value.copyWith(text: handleText(widget.initialValue));

    super.didUpdateWidget(oldWidget);
  }

  String handleText(String text) {
    return text == 'null' ? '' : text;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prefillValue = _getPrefillValue(widget.keyString);
    return Container(
      padding: const EdgeInsets.all(0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: TextFormField(
              controller: controller,
              onChanged: (t) {
                setState(() {});
                widget.onChanged(t);
              },
              style: TextStyle(
                color: context.ext.jsonValue,
                fontSize: 14,
              ),
              cursorColor: Theme.of(context).primaryColor,
              maxLines: null,
              decoration: InputDecoration(
                hintText: '         ',
                hintStyle: TextStyle(color: Colors.transparent),
                isCollapsed: true,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9), borderSide: BorderSide(color: Color(0xFFD1C4F7))),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9), borderSide: BorderSide(color: Color(0xFFD1C4F7))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9), borderSide: BorderSide(color: Color(0xFF8267F5))),
              ),
            ),
          ),
          if (prefillValue != null && prefillValue != controller.text)
            Tooltip(
              textStyle: GoogleFonts.robotoMono(
                  fontSize: 14, fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.1)),
                borderRadius: BorderRadius.circular(10),
                color: context.ext.moduleHeader,
              ),
              positionDelegate: (context) {
                final Offset targetPos = context.target;
                return Offset(
                  targetPos.dx + context.targetSize.width,
                  targetPos.dy + (context.targetSize.height - context.tooltipSize.height) - 15,
                );
              },
              message: 'Prefill ${widget.keyString}: "$prefillValue"',
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: IconButton(
                  padding: EdgeInsets.all(3),
                  constraints: const BoxConstraints(),
                  icon: Image.asset('assets/magic_wand.png', width: 28, color: context.ext.magicWand),
                  onPressed: () {
                    controller.text = prefillValue;
                    widget.onChanged(prefillValue);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  String? _getPrefillValue(String key) {
    if (key == 'userId' && userId != 'USER_ID') {
      return userId;
    }
    if (key == 'evse_id') {
      return evseId;
    }
    if (key == 'payment_method_id' || key == 'paymentMethodId') {
      return paymentMethodId;
    }
    if (key == 'id') {
      return stationId;
    }
    if (key == 'sessionId' && sessionId != 'SESSION_ID') {
      return sessionId;
    }

    return null;
  }
}
