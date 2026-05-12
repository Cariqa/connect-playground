import 'dart:math';

import 'package:connect_reference_client/_playground/cubits.dart';
import 'package:connect_reference_client/_playground/global_app.dart';
import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetStationsTiles extends StatefulWidget {
  const GetStationsTiles({super.key});

  @override
  State<GetStationsTiles> createState() => _GetStationsTilesState();
}

class _GetStationsTilesState extends State<GetStationsTiles> {
  bool initializedMap = false;
  List<dynamic> tiles = [];
  final ValueNotifier<Map<String, dynamic>> queryParamsController = ValueNotifier({});
  final ValueNotifier<ModuleState> moduleController = ValueNotifier(ModuleState());

  @override
  Widget build(BuildContext context) {
    final url = '/stations/tile/';
    return ModuleWidget(
      urlName: url,
      apiType: ApiType.get,
      requestParams: () => {
        'x': ['8803'],
        'y': ['5374'],
        'z': ['14'],
        'max_price': '',
        'only_available': 'false',
        'only_partners': 'false',
        'connector_types': [],
        'operators': [],
        'power_groups': [],
      },
      updateQueryParams: queryParamsController,
      moduleController: moduleController,
      getApiClient: (apiClient, params) async {
        final response = await apiClient.get(
          url: url,
          params: params,
          addHeaders: authorizationBearerConnectTokenHeader,
        );

        tiles = List<Map<String, dynamic>>.from(response['features']);
        stationId = (response['features'] as List<dynamic>).firstWhere((e) => e?['station_id'] != null)?['station_id'];
        setState(() {});
      },
      // Playground Google Maps
      responseWidget: FutureBuilder(
        future: initializedMap ? null : Future.delayed(Duration(seconds: 1)),
        builder: (context, data) {
          if (data.connectionState == ConnectionState.waiting) return SizedBox();
          initializedMap = true;
          return _GoogleMapWidget(
            pins: tiles.map((e) => e as Map<String, dynamic>).toList(),
            initialCameraPosition: LatLng(52.51760102306344, 13.416584931274418),
            onCameraMove: (tile) {
              queryParamsController.value = {
                'x': [tile.x.toString()],
                'y': [tile.y.toString()],
                'z': [tile.z.toString()],
              };
              moduleController.value = ModuleState(triggerCall: true);
            },
          );
        },
      ),
    );
  }
}

class _GoogleMapWidget extends StatefulWidget {
  final LatLng initialCameraPosition;
  final List<Map<String, dynamic>> pins;
  final void Function(TileModel) onCameraMove;

  const _GoogleMapWidget({
    required this.initialCameraPosition,
    this.pins = const [],
    required this.onCameraMove,
  });

  @override
  State<_GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<_GoogleMapWidget> {
  GoogleMapController? mapController;
  TileModel? lastTileModel;

  Set<Marker> markers = <Marker>{};

  @override
  void didUpdateWidget(covariant _GoogleMapWidget oldWidget) {
    if (oldWidget.pins.toList().toString() == widget.pins.toList().toString()) {
      return;
    }
    updatePins();
    super.didUpdateWidget(oldWidget);
  }

  void updatePins() async {
    markers.clear();
    for (final pin in widget.pins) {
      final id = '${pin['station_id'] ?? pin['cluster_id']}';
      final count = pin['properties']['count'];
      final isCluster = count != 1 && count != null;
      markers.add(
        Marker(
          onTap: () {
            Clipboard.setData(ClipboardData(text: id));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied: $id')));
            stationId = id;
          },
          position: LatLng(
            double.parse(pin['geometry']['coordinates'][0] as String),
            double.parse(pin['geometry']['coordinates'][1] as String),
          ),
          markerId: MarkerId(id),
          icon: isCluster
              ? AssetMapBitmap('assets/cluster.png', height: 18)
              : AssetMapBitmap('assets/map_icon.png', height: 35),
          infoWindow: InfoWindow(
            title: 'id: $id',
            snippet: isCluster ? 'Cluster with $count stations' : '${pin['properties']['operator_id']}',
          ),
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: dividerColor, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: GoogleMap(
          onCameraMove: _onCameraMove,
          padding: EdgeInsets.all(20),
          mapType: MapType.terrain,
          initialCameraPosition: CameraPosition(
            zoom: 14,
            target: widget.initialCameraPosition,
          ),
          onMapCreated: (GoogleMapController controller) async {
            mapController = controller;
          },
          markers: markers,
        ),
      ),
    );
  }

  void _onCameraMove(CameraPosition position) {
    EasyDebounce.debounce('map-tiles', Duration(milliseconds: 400), () {
      double lat = position.target.latitude;
      double lon = position.target.longitude;
      int z = position.zoom.toInt();

      int x = ((lon + 180) / 360 * pow(2, z)).floor();
      int y = ((1 - log(tan(lat * pi / 180) + 1 / cos(lat * pi / 180)) / pi) / 2 * pow(2, z)).floor();

      if (lastTileModel?.x == x && lastTileModel?.y == y && lastTileModel?.z == z) {
        return;
      }

      final tile = TileModel(x: x, y: y, z: z);
      lastTileModel = tile;
      widget.onCameraMove(tile);
    });
  }
}
