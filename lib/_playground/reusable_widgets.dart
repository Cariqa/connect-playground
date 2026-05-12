import 'package:flutter/material.dart';

class UiPanel extends StatelessWidget {
  final List<Widget> children;
  const UiPanel({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        constraints: const BoxConstraints(minHeight: 300, maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: children,
        ),
      ),
    );
  }
}
