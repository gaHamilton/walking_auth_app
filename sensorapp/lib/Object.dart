import 'package:flutter/material.dart';

class Coordinates with ChangeNotifier {
  final double x;
  final double y;
  final double z;

  Coordinates(
    @required this.x,
    @required this.y,
    @required this.z,
  );

  Map<String, dynamic> toMap() {
    return {
      'X': x,
      'Y': y,
      'Z': z,
    };
  }
}
