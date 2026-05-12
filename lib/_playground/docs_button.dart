import 'package:connect_reference_client/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DocsButton extends StatelessWidget {
  const DocsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 30),
        child: TextButton(
          onPressed: () => launchUrlString(docsUrl),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Documentation',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Theme.of(context).primaryColor),
              ),
              SizedBox(width: 8),
              Image.asset('assets/arrow-top-right.png', color: Theme.of(context).primaryColor, width: 20)
            ],
          ),
        ),
      ),
    );
  }
}
