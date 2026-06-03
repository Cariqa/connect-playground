import 'dart:ui';

import 'package:connect_reference_client/main.dart';

enum AppTab {
  none,
  createUser,
  addPaymentMethod,
  addBillingDetails,
  getPaymentMethods,
  deletePaymentMethod,
  getStationsTiles,
  getStationsList,
  getStationDetails,
  startCharging,
  getChargingSession,
  stopCharging,
  getAllChargingSessions,
  getUnpaidSessions,
  getInvoices,
  getAllUsers,
  rateChargingSession;
}

enum RunMode {
  dev(Color(0xFFF59E0B), Color(0xFFFAF0BE), devUrl),
  prod(Color(0xFF27BC24), Color(0xFFC5F0DA), prodUrl);

  final Color colorPrimary;
  final Color colorSecondary;
  final String url;

  const RunMode(this.colorPrimary, this.colorSecondary, this.url);
}

class TileModel {
  final int x;
  final int y;
  final int z;

  TileModel({
    required this.x,
    required this.y,
    required this.z,
  });
}

enum ApiType {
  get(Color(0xFF27BC24)),
  post(Color(0xFF6B4EFF)),
  put(Color(0xFFFF8A04)),
  patch(Color(0xFFFF8A04)),
  delete(Color(0xFFDD3842));

  final Color color;

  const ApiType(this.color);
}

enum ReqType {
  query,
  body;
}
