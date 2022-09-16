class OhlcModel {
  final DateTime closeTime;
  final double openPrice;
  final double highPrice;
  final double lowPrice;
  final double closePrice;
  final double volume;
  final double quoteVolume;

  const OhlcModel({
    required this.closeTime,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.closePrice,
    required this.volume,
    required this.quoteVolume,
  });

  factory OhlcModel.fromJson(List<dynamic> data) => OhlcModel(
        closeTime: DateTime.fromMillisecondsSinceEpoch(data[0] * 1000),
        openPrice: data[1].toDouble(),
        highPrice: data[2].toDouble(),
        lowPrice: data[3].toDouble(),
        closePrice: data[4].toDouble(),
        volume: data[5].toDouble(),
        quoteVolume: data[6].toDouble(),
      );

  @override
  String toString() => <String, dynamic>{
        'closeTime': closeTime.toIso8601String(),
        'openPrice': openPrice,
        'highPrice': highPrice,
        'lowPrice': lowPrice,
        'closePrice': closePrice,
        'volume': volume,
        'quoteVolume': quoteVolume,
      }.toString();
}
