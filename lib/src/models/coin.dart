import 'package:crypto_tracking_app/src/models/crypto_data.dart';
import 'package:crypto_tracking_app/src/models/coin_stats.dart';

class Coin {
  CoinInfo _coinInfo;
  CoinStats _coinStats;

  CoinInfo get coinInfo => _coinInfo;
  CoinStats get coinStats => _coinStats;

  Coin._({required CoinInfo coinInfo, required CoinStats coinStats})
      : _coinInfo = coinInfo,
        _coinStats = coinStats;

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin._(
      coinInfo: CoinInfo.fromJson(json["CoinInfo"]),
      coinStats: CoinStats.fromJson(json["RAW"]["USD"]),
    );
  }
}
