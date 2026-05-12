import 'package:connect_reference_client/_playground/all_menu_widget.dart';
import 'package:connect_reference_client/_playground/credentials_page.dart';
import 'package:connect_reference_client/_playground/cubits.dart';
import 'package:connect_reference_client/_playground/cubits_wrapper.dart';
import 'package:connect_reference_client/_playground/docs_button.dart';
import 'package:connect_reference_client/_playground/global_app.dart';
import 'package:connect_reference_client/_playground/playground.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  await Playground.initialize();
  runApp(CubitsWrapper(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isCredentialSet = context.select((PlaygroundCubit bloc) => bloc.state.isCredentialsSet);
    return GlobalApp(
      child: isCredentialSet == false
          ? Stack(
              children: [
                Center(child: CredentialsPage()),
                if (kIsWeb) DocsButton(),
              ],
            )
          : AllMenuWidget(),
    );
  }
}

String connectApiDomain = '';
String connectApiKey = '';
String googleMapApiKey = '';

String? userId = 'USER_ID';
String? sessionId = 'SESSION_ID';
String? stationId;
String? evseId;
String? paymentMethodId;

Map<String, String> get authorizationBearerConnectTokenHeader => {'Authorization': 'Bearer $connectApiKey'};

const testUrl = 'dev.connect.cariqa.com/api/v1';
const prodUrl = 'connect.cariqa.com/api/v1';

const docsUrl = 'https://docs.cariqa.com';
