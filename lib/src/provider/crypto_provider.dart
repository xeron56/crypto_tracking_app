import 'dart:async';

import 'package:crypto_tracking_app/src/models/coin.dart';
import 'package:crypto_tracking_app/src/models/private_data.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CoinsBloc {
  late BehaviorSubject<List<Coin>> _coins$;
  late BehaviorSubject<int> _maxListSize$;
  late List<Coin> _defaultCoinList;
  late Timer _pollingTimer;

  BehaviorSubject<List<Coin>> get coins$ => _coins$;
  BehaviorSubject<int> get maxListSize$ => _maxListSize$;

  CoinsBloc() {
    _coins$ = BehaviorSubject<List<Coin>>();
    _maxListSize$ = BehaviorSubject<int>();
    _defaultCoinList = [];
    _initPolling();
    getCoins();
  }

  void _initPolling() {
    _pollingTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      print(">>>polling data");
      await getCoins();
    });
  }

  Future<void> getCoins() async {
    await _pushMaxListSize();
    final String _maxList = _maxListSize$.value.toString();
    final PrivateData _privateData =
        await PrivateData.fromAssets("assets/data/privateData.json");
    final String _url =
        "https://min-api.cryptocompare.com/data/top/totalvolfull?limit=$_maxList&tsym=USD&api_key=${_privateData.apiKey}";
    final _response = await http.get(Uri.parse(_url));
    final Map<String, dynamic> _json = jsonDecode(_response.body);
    _defaultCoinList = [];
    for (var object in _json["Data"]) {
      _defaultCoinList.add(Coin.fromJson(object));
    }
    //remove 6th element from _defaultCoinList
    _defaultCoinList.removeAt(6);
    _coins$.add(_defaultCoinList);
  }

  void filterCoins(String text) {
    List<Coin> _result = [];
    text = text.toLowerCase().replaceAll(' ', '');
    for (var coin in _defaultCoinList) {
      final String _compareString =
          (coin.coinInfo.fullName + coin.coinInfo.symbol)
              .toLowerCase()
              .replaceAll(' ', '');
      if (_compareString.contains(text)) {
        _result.add(coin);
      }
    }
    _coins$.add(_result);
  }

  Future<void> _pushMaxListSize() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final int? _maxSize = _prefs.getInt("max size");
    _maxListSize$.add(_maxSize ?? 100);
  }

  Future<void> setMaxListSize(int value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setInt("max size", value);
    _maxListSize$.add(value);
  }

  void dispose() {
    _coins$.close();
    _maxListSize$.close();
    _pollingTimer.cancel();
  }
}
