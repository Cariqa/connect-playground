import 'package:connect_reference_client/_playground/global_app.dart';
import 'package:flutter/material.dart';

class StartPageDisclaimer extends StatefulWidget {
  const StartPageDisclaimer({super.key});

  @override
  State<StartPageDisclaimer> createState() => _StartPageDisclaimerState();
}

class _StartPageDisclaimerState extends State<StartPageDisclaimer> {
  bool open = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 18),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        splashFactory: NoSplash.splashFactory,
        onTap: () {
          setState(() {
            open = !open;
          });
        },
        child: Container(
          width: 300,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
            color: Colors.green.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  'This Playground is a demo tool for trying out Connect API flows end-to-end without building anything on your side, combining backend and frontend duties into one environment for simplicity. In a real implementation, only your backend should interact with the Connect API, while your frontend integrates the Stripe SDK and communicates with your backend.',
                  style: TextStyle(fontSize: 14),
                  maxLines: open ? 40 : 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                open ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                color: context.ext.menuUnselectedText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
