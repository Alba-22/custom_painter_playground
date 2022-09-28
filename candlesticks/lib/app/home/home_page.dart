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

  Offset currentOffset = Offset.zero;
  Offset startOffset = Offset.zero;
  Offset updateOffset = Offset.zero;

  double scaleDelta = 1;
  double scaleStart = 1;

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
      body: _data != null
          ? GestureDetector(
              onScaleStart: (details) {
                startOffset = details.localFocalPoint;

                setState(() => {});
              },
              onScaleUpdate: (details) {
                updateOffset = details.localFocalPoint - startOffset;
                scaleDelta = details.scale * scaleStart;
                setState(() => {});
              },
              onScaleEnd: (details) {
                scaleStart = scaleDelta;
                currentOffset += updateOffset;
                updateOffset = Offset.zero;

                setState(() => {});
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black87,
                child: CustomPaint(
                  size: const Size(500, 500),
                  painter: CandlestickPainter(
                    data: _data!,
                    offset: updateOffset + currentOffset,
                    scale: scaleDelta,
                  ),
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scaleStart = 1;
          scaleDelta = 1;
          currentOffset = Offset.zero;
          startOffset = Offset.zero;
          updateOffset = Offset.zero;
          setState(() => {});
        },
      ),
    );
  }
}


// TODO LIST
// - Exibir texto com os valores de zoom e deslocamento
// - Exibir legenda pros eixos(fazer do eixo x na diagonal)
// - Adicionar o zoom no eixo Y(o ajuste do eixo Y também deve ser feito no deslocamento)
// - Melhorar o zoom no ponto onde foi dado zoom
// - Limitar o deslocamento no início e fim do gráfico
// - Limitar o zoom out pra ficar pelo menos todos os pontos na tela