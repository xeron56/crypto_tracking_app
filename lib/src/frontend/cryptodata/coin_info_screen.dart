import 'package:crypto_tracking_app/src/models/coin.dart';
import 'package:crypto_tracking_app/src/models/selected_time_mode.dart';
import 'package:crypto_tracking_app/src/frontend/cryptodata/cryptodata.dart';
import 'package:crypto_tracking_app/src/frontend/cryptodata/custom_widgets.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoinInfoScreen extends StatelessWidget {
  final Coin _coin;
  final double _appBarHeight = 150;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CoinInfoScreen({required Coin coin}) : _coin = coin;

  @override
  Widget build(BuildContext context) {
    final _coinInfoBloc = CoinInfoBloc(_coin.coinInfo.symbol);
    _spamSnackBar(_coinInfoBloc, context);

    return Provider(
      create: (BuildContext context) => _coinInfoBloc,
      child: Scaffold(
        key: _scaffoldKey,
        //add appbar with backbutton
        appBar: AppBar(
          title: Text(_coin.coinInfo.fullName),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),

        body: ListView(
          physics: AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  //color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Current Price \nof ${_coin.coinInfo.symbol}",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "\$ ${_coin.coinStats.price.toStringAsFixed(3)}",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TimeModeButton(
                        mode: SelectedTimeMode.Daily,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TimeModeButton(
                        mode: SelectedTimeMode.Hourly,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2.2,
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: StreamBuilder<SelectedTimeMode>(
                stream: _coinInfoBloc.timeMode$,
                builder: (BuildContext context,
                    AsyncSnapshot<SelectedTimeMode> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  final SelectedTimeMode _mode = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 22.0),
                    child: CoinInfoGraph(
                      key: UniqueKey(),
                      mode: _mode,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _spamSnackBar(CoinInfoBloc _coinInfoBloc, BuildContext context) {
    _coinInfoBloc.isLoading$.listen(
      (bool isLoading) {
        if (isLoading) {
          _showSnackBar("Loading ......", context);
        }
      },
    );
  }

  void _showSnackBar(String title, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        duration: Duration(milliseconds: 1500),
        content: Text(title),
      ),
    );
  }
}
