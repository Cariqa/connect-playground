import 'package:connect_reference_client/_playground/api_call_log.dart';
import 'package:connect_reference_client/_playground/api_client.dart';
import 'package:connect_reference_client/_playground/cubits.dart';
import 'package:connect_reference_client/_playground/global_app.dart';
import 'package:connect_reference_client/_playground/json_editor.dart';
import 'package:connect_reference_client/_playground/json_editor_plain.dart';
import 'package:connect_reference_client/_playground/json_viewer.dart';
import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_switcher.dart';
import 'package:connect_reference_client/_playground/playground.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ModuleWidget extends StatefulWidget {
  final String urlName;
  final ApiType apiType;
  final ReqType reqType;
  final Map<String, dynamic> Function()? pathParams;
  final Map<String, dynamic> Function() requestParams;
  final void Function(ApiClient, Map<String, dynamic>) getApiClient;
  final void Function(Map<String, dynamic>)? onPathChange;
  final void Function(Map<String, dynamic>)? onQueryChange;
  final ValueNotifier<Map<String, dynamic>>? updateQueryParams;
  final ValueNotifier<ModuleState>? moduleController;
  final Widget? responseWidget;

  const ModuleWidget({
    super.key,
    required this.urlName,
    required this.apiType,
    this.pathParams,
    this.reqType = ReqType.query,
    required this.requestParams,
    required this.getApiClient,
    this.onPathChange,
    this.onQueryChange,
    this.updateQueryParams,
    this.moduleController,
    this.responseWidget,
  });

  @override
  State<ModuleWidget> createState() => _ModuleWidgetState();
}

class _ModuleWidgetState extends State<ModuleWidget> {
  final ValueNotifier<List<ApiCallLog>> logsController = ValueNotifier([]);
  late final apiClient = ApiClient(logsController, globalHttpClient);
  Map<String, dynamic> queryParams = {};
  Map<String, dynamic>? pathParams;

  @override
  void initState() {
    queryParams = widget.requestParams();
    pathParams = widget.pathParams?.call();

    logsController.addListener(_updateListener);
    loadingController.addListener(_updateListener);
    widget.updateQueryParams?.addListener(updateQueryListener);
    widget.moduleController?.addListener(moduleControllerListener);

    super.initState();
  }

  void _updateListener() {
    if (mounted) setState(() {});
  }

  void updateQueryListener() {
    for (final map in (widget.updateQueryParams?.value ?? {}).entries) {
      queryParams.update(map.key, (_) => map.value);
    }
    setState(() {});
  }

  void moduleControllerListener() {
    if (widget.moduleController?.value.triggerCall == true) {
      if (loadingController.value == false) {
        widget.getApiClient(apiClient, queryParams);
      }
    }
  }

  @override
  void deactivate() {
    context.read<PlaygroundCubit>().setTab(AppTab.none);
    super.deactivate();
  }

  @override
  void dispose() {
    logsController.dispose();
    logsController.removeListener(_updateListener);
    loadingController.removeListener(_updateListener);
    widget.updateQueryParams?.removeListener(updateQueryListener);
    widget.moduleController?.removeListener(moduleControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plainEditor = context.select((PlaygroundCubit bloc) => bloc.state.plainEditor);
    final sendButton = Align(
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: loadingController.value == true ? null : () => widget.getApiClient(apiClient, queryParams),
        child: loadingController.value == true
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(color: context.ext.sendCall, strokeWidth: 4),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Send',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: context.ext.sendCall),
                  ),
                  SizedBox(width: 3),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Icon(Icons.arrow_forward_ios_rounded, color: context.ext.sendCall, size: 14),
                  )
                ],
              ),
      ),
    );
    final bodyWidgets = [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: context.ext.moduleHeader,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(14, 0, 20, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Make request',
                          style:
                              TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.ext.moduleHeaderText),
                        ),
                        if (isMobile == false) sendButton,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: widget.apiType.color, borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        widget.apiType.name.toUpperCase(),
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(child: Text(widget.urlName, style: TextStyle(color: context.ext.modulePath))),
                ],
              ),
            ),
            Divider(height: 1),
            Flexible(
              child: SingleChildScrollView(
                physics: isMobile ? NeverScrollableScrollPhysics() : null,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 0,
                  children: [
                    SizedBox(width: double.infinity),
                    if (pathParams != null) ...[
                      SizedBox(height: 20),
                      ModuleSwitcher(title: 'Path params'.toUpperCase(), showSwitcher: true),
                      plainEditor
                          ? JsonEditorPlain(
                              initialData: pathParams ?? {},
                              showFormatButton: plainEditor,
                              onChanged: (a) {
                                pathParams = a;
                                widget.onPathChange?.call(a);
                                setState(() {});
                              },
                            )
                          : JsonEditor(
                              initialData: pathParams ?? {},
                              onChanged: (a) {
                                pathParams = a;
                                widget.onPathChange?.call(a);
                                setState(() {});
                              },
                            ),
                    ],
                    SizedBox(height: 20),
                    ModuleSwitcher(
                      title: (widget.reqType == ReqType.query ? 'Query params' : 'Body').toUpperCase(),
                      showSwitcher: pathParams == null,
                    ),
                    plainEditor
                        ? JsonEditorPlain(
                            showFormatButton: pathParams == null,
                            initialData: queryParams,
                            onChanged: (a) {
                              queryParams = a;
                              widget.onQueryChange?.call(a);
                              setState(() {});
                            },
                          )
                        : JsonEditor(
                            initialData: queryParams,
                            onChanged: (a) {
                              queryParams = a;
                              widget.onQueryChange?.call(a);
                              setState(() {});
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.responseWidget != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: widget.responseWidget!,
            ),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: context.ext.moduleHeader,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13)),
                    ),
                    child: Row(
                      spacing: 20,
                      children: [
                        SizedBox(width: 1),
                        Expanded(
                          child: Text(
                            'Logs',
                            style: TextStyle(fontWeight: FontWeight.w600, color: context.ext.moduleHeaderText),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (logsController.value.isEmpty) SizedBox(height: 200),
                          ...logsController.value.map(
                            (logValue) => Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(height: 1),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                  child: Row(
                                    children: [
                                      Text('Status:', style: TextStyle(color: context.ext.httpStatusText)),
                                      SizedBox(width: 5),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: logValue.status == 200 ||
                                                    logValue.status == 201 ||
                                                    logValue.status == 204
                                                ? Colors.green
                                                : logValue.status == 0
                                                    ? Colors.grey
                                                    : Colors.red),
                                        child: Text(
                                          logValue.status.toString(),
                                          style:
                                              TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(height: 1),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('REQUEST:',
                                          style: GoogleFonts.robotoMono(fontSize: 12, fontWeight: FontWeight.w600)),
                                      SizedBox(height: 10),
                                      Text(logValue.request, style: GoogleFonts.robotoMono(color: context.ext.httpUrl)),
                                      Text(
                                        'Query params:',
                                        style: GoogleFonts.robotoMono(),
                                      ),
                                      JsonViewer(json: logValue.reqParams ?? {}),
                                      if (logValue.response.isNotEmpty) ...[
                                        SizedBox(height: 30),
                                        Text(
                                          'RESPONSE:',
                                          style: GoogleFonts.robotoMono(fontSize: 12, fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(height: 10),
                                        if (logValue.responseError != null)
                                          Text(
                                            logValue.responseError ?? '--',
                                            style: GoogleFonts.robotoMono(color: context.ext.responseBody),
                                          )
                                        else
                                          JsonViewer(json: logValue.responseBody ?? {}),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ];
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.robotoMonoTextTheme(ThemeData(brightness: Brightness.light).textTheme),
      ),
      child: isMobile
          ? Scaffold(
              appBar: AppBar(scrolledUnderElevation: 0.0, title: sendButton),
              body: ListView(
                padding: EdgeInsets.all(16),
                children: bodyWidgets.expand((widget) => [widget, SizedBox(height: 10)]).toList(),
              ),
            )
          : SelectionArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  ...bodyWidgets.map((widget) => Expanded(child: widget)),
                  SizedBox(width: 1),
                ],
              ),
            ),
    );
  }
}
