// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:candlesticks/app/home/models/ohcl_model.dart';

class CandlestickPainter extends CustomPainter {
  final Offset offset;
  final List<OhlcModel> data;
  final double scale;

  CandlestickPainter({
    required this.offset,
    required this.data,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxX = data.length;
    final candleWidth = (size.width / maxX) * scale;

    double minY = double.infinity;
    double maxY = -double.infinity;

    for (int i = 0; i < maxX; i++) {
      final xPositionOfCandleInPixels = (candleWidth * (i + 0.5) + (offset.dx)).toDouble();
      if (xPositionOfCandleInPixels < 0 || xPositionOfCandleInPixels > size.width) {
        continue;
      }
      minY = min(minY, data[i].lowPrice);
      maxY = max(maxY, data[i].highPrice);
    }

    final deltaY = (maxY - minY) * 1.1;

    final yAverage = (maxY + minY) / 2;

    minY = yAverage - (deltaY / 2);

    for (int i = 0; i < maxX; i++) {
      final info = data[i];

      final xPositionOfCandleInPixels = (candleWidth * (i + 0.5) + (offset.dx)).toDouble();

      final candleAverage = (info.closePrice + info.openPrice) / 2 - minY;
      final candleHeightInPixels = (1 - (candleAverage / deltaY)) * size.height;
      final centerOfCandle = Offset(xPositionOfCandleInPixels, candleHeightInPixels);

      final stickAverage = (info.highPrice + info.lowPrice) / 2 - minY;
      final stickHeightInPixels = (1 - (stickAverage / deltaY)) * size.height;
      final centerOfStick = Offset(xPositionOfCandleInPixels, stickHeightInPixels);

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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
