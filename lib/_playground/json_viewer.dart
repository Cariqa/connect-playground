import 'dart:convert';

import 'package:connect_reference_client/_playground/global_app.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JsonViewer extends StatelessWidget {
  final Map<String, dynamic> json;

  JsonViewer({super.key, required this.json});
  final TextStyle numberStyle = GoogleFonts.robotoMono(color: Colors.blue);
  final TextStyle boolStyle = GoogleFonts.robotoMono(color: Color(0xFFAD6B03));
  final TextStyle syntaxStyle = GoogleFonts.robotoMono(color: Colors.grey);
  @override
  Widget build(BuildContext context) {
    final String prettyString = const JsonEncoder.withIndent('  ').convert(json);

    return SelectableText.rich(
      TextSpan(
        style: GoogleFonts.robotoMono(fontSize: 14),
        children: _getJsonSpans(context, prettyString),
      ),
    );
  }

  List<TextSpan> _getJsonSpans(BuildContext context, String input) {
    final List<TextSpan> spans = [];
    // Regex identifies: Keys, Strings, Numbers, Booleans, and Syntax ({ } [ ] : ,)
    final regExp = RegExp(
      r'(".*?")(?=\s*:)|(".*?")|(\b\d+\b)|(\btrue\b|\bfalse\b|\bnull\b)|([\{\}\[\]:,])',
      multiLine: true,
    );

    int lastMatchEnd = 0;
    for (final match in regExp.allMatches(input)) {
      // Add text before the match (usually whitespace/newlines)
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: input.substring(lastMatchEnd, match.start), style: syntaxStyle));
      }

      if (match.group(1) != null) {
        // Key
        spans.add(TextSpan(text: match.group(1), style: GoogleFonts.robotoMono(color: context.ext.jsonKey)));
      } else if (match.group(2) != null) {
        // String value
        spans.add(TextSpan(text: match.group(2), style: GoogleFonts.robotoMono(color: context.ext.jsonValue)));
      } else if (match.group(3) != null) {
        // Number
        spans.add(TextSpan(text: match.group(3), style: numberStyle));
      } else if (match.group(4) != null) {
        // Boolean/Null
        spans.add(TextSpan(text: match.group(4), style: boolStyle));
      } else if (match.group(5) != null) {
        // Syntax characters
        spans.add(TextSpan(text: match.group(5), style: syntaxStyle));
      }

      lastMatchEnd = match.end;
    }
    return spans;
  }
}
