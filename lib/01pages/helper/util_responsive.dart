import 'package:flutter/material.dart';
import 'dart:math' as math;

class UtilResponsive {
  double _vAncho = 0, _vAlto = 0, _vDiagonal = 0;
  bool _isTablet = false;
  bool get isTablet => _isTablet;
  double get vAncho => _vAncho;
  double get vAlto => _vAlto;
  double get vDiagonal => _vDiagonal;

  UtilResponsive(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    _vAncho = size.width;
    _vAlto = size.height;
    _vDiagonal = math.sqrt(math.pow(_vAncho, 2) + math.pow(_vAlto, 2));
    _isTablet = size.shortestSide >= 600;
  }
  double anchoPorcentaje(double pPorcentaje) => _vAncho * pPorcentaje / 100;
  double altoPorcentaje(double pPorcentaje) => _vAlto * pPorcentaje / 100;
  double diagonalPorcentaje(double pPorcentaje) =>
      _vDiagonal * pPorcentaje / 100;

  static UtilResponsive of(BuildContext context) => UtilResponsive(context);
}
