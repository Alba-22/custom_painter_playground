// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:candlesticks/app/home/models/ohcl_model.dart';

class CandlestickPainter extends CustomPainter {
  final List<OhlcModel> data;
  final double minValue;
  final double maxValue;

  CandlestickPainter({
    required this.data,
    required this.minValue,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final max = data.length;
    final candleWidth = (size.width / max);

    for (int i = 0; i < max; i++) {
      final info = data[i];
      final deltaY = maxValue - minValue;

      final candleAverage = (info.closePrice + info.openPrice) / 2 - minValue;
      final candleHeightInPixels = (1 - (candleAverage / deltaY)) * size.height;
      final centerOfCandle = Offset((candleWidth * (i + 0.5)).toDouble(), candleHeightInPixels);

      final stickAverage = (info.highPrice + info.lowPrice) / 2 - minValue;
      final stickHeightInPixels = (1 - (stickAverage / deltaY)) * size.height;
      final centerOfStick = Offset((candleWidth * (i + 0.5)).toDouble(), stickHeightInPixels);

      final color = info.closePrice - info.openPrice > 0 ? Colors.green : Colors.red;

      final paint = Paint()..color = color;
      final candleRect = Rect.fromCenter(
        center: centerOfCandle,
        width: candleWidth,
        height: ((info.closePrice - info.openPrice).abs() / deltaY) * size.height,
      );
      final stickRect = Rect.fromCenter(
        center: centerOfStick,
        width: 2,
        height: ((info.highPrice - info.lowPrice) / deltaY) * size.height,
      );
      canvas.drawRect(candleRect, paint);
      canvas.drawRect(stickRect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
