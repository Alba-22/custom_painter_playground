import 'package:candlesticks/app/home/components/candlestick_painter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'models/ohcl_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<OhlcModel>? _data;
  double maxHighValue = -double.infinity;
  double minLowValue = double.infinity;

  Future<void> init() async {
    await Dio().get('https://api.cryptowat.ch/markets/kraken/btceur/ohlc').then(
      (value) {
        setState(
          () => _data = (value.data['result']['60'] as List).map<OhlcModel>((e) {
            final model = OhlcModel.fromJson(e);
            if (model.lowPrice < minLowValue) {
              minLowValue = model.lowPrice;
            }
            if (model.highPrice > maxHighValue) {
              maxHighValue = model.highPrice;
            }
            return model;
          }).toList(),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Candle Sticks",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[300],
        child: _data != null
            ? CustomPaint(
                size: const Size(500, 500),
                painter: CandlestickPainter(
                  data: _data!,
                  minValue: minLowValue,
                  maxValue: maxHighValue,
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
