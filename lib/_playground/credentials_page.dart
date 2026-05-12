import 'package:connect_reference_client/_playground/cubits.dart';
import 'package:connect_reference_client/_playground/google_maps_util.dart';
import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/playground.dart';
import 'package:connect_reference_client/main.dart';
import 'package:connect_reference_client/payments_initialization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CredentialsPage extends StatefulWidget {
  const CredentialsPage({super.key});

  @override
  State<CredentialsPage> createState() => _CredentialsPageState();
}

class _CredentialsPageState extends State<CredentialsPage> {
  final connectApiDomainController = TextEditingController();
  final connectApiKeyController = TextEditingController();
  final stripePublishableKeyController = TextEditingController();
  final googleMapsKeyController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      connectApiDomainController.text = RunMode.test.url;

      getCredentials();

      connectApiKey = connectApiKeyController.text;
      connectApiDomain = connectApiDomainController.text;
      googleMapApiKey = googleMapsKeyController.text;
      setState(() {});
    });
    super.initState();
  }

  void getCredentials() {
    if (runMode == RunMode.test) {
      connectApiKeyController.text =
          localDb.getString('connect-api-key') ?? const String.fromEnvironment('CONNECT_API_KEY');
      connectApiDomainController.text = RunMode.test.url;

      stripePublishableKeyController.text =
          localDb.getString('stripe-publishable-key') ?? const String.fromEnvironment('STRIPE_PUBLISHABLE_KEY');
      googleMapsKeyController.text =
          localDb.getString('google-maps-key') ?? const String.fromEnvironment('GOOGLE_MAPS_API_KEY');
    }
  }

  @override
  void dispose() {
    connectApiDomainController.dispose();
    connectApiKeyController.dispose();
    stripePublishableKeyController.dispose();
    googleMapsKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: isMobile ? 400 : 500,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(height: 20),
          Text(
            'Welcome to Playground',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
          ),
          SizedBox(height: 8),
          Text(
            'Enter your API credentials to access the playground',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: 20),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              buildLabel('Connect API domain'),
              Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                enableTapToDismiss: false,
                decoration: BoxDecoration(color: Colors.transparent),
                showDuration: const Duration(seconds: 30),
                richMessage: WidgetSpan(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 400),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black26),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          spacing: 4,
                          children: [
                            ...RunMode.values.map((mode) {
                              return Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 60,
                                          decoration: BoxDecoration(
                                            color: mode.colorSecondary,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                          child: Text(
                                            mode.name.toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: mode.colorPrimary, fontSize: 12, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(mode.url, style: TextStyle(fontSize: 14, color: Colors.black))
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    connectApiDomainController.text = mode.url;
                                    connectApiDomain = connectApiDomainController.text;
                                    runMode = mode;
                                    getCredentials();
                                    setState(() {});
                                    Tooltip.dismissAllToolTips();
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      )),
                ),
                child: Stack(
                  children: [
                    TextFormField(
                      mouseCursor: SystemMouseCursors.click,
                      controller: connectApiDomainController,
                      autocorrect: false,
                      onChanged: (_) => connectApiDomain = connectApiDomainController.text,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(right: 30),
                        prefix: Container(
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: runMode.colorSecondary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: Text(
                            runMode.name.toUpperCase(),
                            style: TextStyle(color: runMode.colorPrimary, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 10,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Icon(Icons.keyboard_arrow_down_rounded, size: 26),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 22),
          buildLabel('Connect API key'),
          TextFormField(
            controller: connectApiKeyController,
            onChanged: (text) => connectApiKey = text,
            decoration: InputDecoration(labelStyle: TextStyle(fontSize: 14)),
          ),
          SizedBox(height: 22),
          buildLabel('Stripe publishable key'),
          TextFormField(
            controller: stripePublishableKeyController,
          ),
          SizedBox(height: 22),
          if (kIsWeb) ...[
            buildLabel('Google Maps key (optional)'),
            TextFormField(
              controller: googleMapsKeyController,
              onChanged: (text) => googleMapApiKey = text,
            ),
            SizedBox(height: 22),
          ],
          if (runMode == RunMode.test)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('* ', style: TextStyle(fontSize: 13)),
                    Flexible(
                      child: Text(
                        'Test mode keeps your credentials saved, so you don\'t have to re-enter them after a restart.',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: FilledButton(
              onPressed: () {
                if (stripePublishableKeyController.text.isNotEmpty) {
                  applyStripeSettings(stripePublishableKey: stripePublishableKeyController.text);
                }
                if (kIsWeb) appendGoogleMapScriptHtml();
                if (runMode == RunMode.test) {
                  localDb.setString('connect-api-key', connectApiKeyController.text);
                  localDb.setString('stripe-publishable-key', stripePublishableKeyController.text);
                  localDb.setString('google-maps-key', googleMapsKeyController.text);
                }
                context.read<PlaygroundCubit>().setIsCredentialsSet();
              },
              child: Text('Access Playground'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLabel(String text) => Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(text, style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor)),
        ),
      );
}
