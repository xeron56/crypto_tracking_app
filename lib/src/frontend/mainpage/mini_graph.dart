import 'package:crypto_tracking_app/src/models/coin.dart';
import 'package:flutter/material.dart';

class MiniGraph extends CustomPainter {
  final Coin _coin;

  MiniGraph({required Coin coin}) : _coin = coin;

  @override
  void paint(Canvas canvas, Size size) {
    final num _maxPrice = _coin.coinStats.highDay;
    final num _minPrice = _coin.coinStats.lowDay;
    final num _range = (_maxPrice - _minPrice);
    final num _normalizedFinalPrice =
        _maxPrice - (_coin.coinStats.price + _coin.coinStats.changeDay);
    final num _normalizedOpenPrice = _maxPrice - _coin.coinStats.openDay;
    final bool _isPositive = _coin.coinStats.changeDay >= 0;

    Paint _line = Paint()
      ..color = _isPositive ? Color(0xFF0000FF) : Color(0xFFFF0000)
      ..strokeCap = StrokeCap.square // Use StrokeCap.square for vertical lines
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    Path _path = Path();

    final double lineHeight = size.height / 2;

    print(">>>lineHeight: $lineHeight");

    _path.moveTo(0, (_normalizedOpenPrice / _range) * size.height);

    if (_isPositive) {
      _path.lineTo(size.width / 4, lineHeight);
      _path.lineTo(size.width / 2, lineHeight);
      _path.lineTo((3 * size.width) / 4,
          (_maxPrice - _coin.coinStats.lowDay) / _range * size.height);
      _path.lineTo(size.width, _normalizedFinalPrice / _range * size.height);
    } else {
      _path.lineTo(size.width / 4,
          (_maxPrice - _coin.coinStats.lowDay) / _range * size.height);
      _path.lineTo(size.width / 2, lineHeight);
      _path.lineTo((3 * size.width) / 4, lineHeight);
      _path.lineTo(size.width, (_normalizedFinalPrice / _range) * size.height);
    }

    canvas.drawPath(_path, _line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
