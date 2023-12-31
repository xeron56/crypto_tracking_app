import 'package:crypto_tracking_app/src/provider/universal_provider.dart';
import 'package:crypto_tracking_app/src/models/coin.dart';
import 'package:crypto_tracking_app/src/frontend/cryptodata/coin_info_screen.dart';
import 'package:crypto_tracking_app/src/frontend/widget/crypto_loading_indicator.dart';
import 'package:crypto_tracking_app/src/frontend/mainpage/coin_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:delayed_display/delayed_display.dart';

class MarketScreen extends StatefulWidget {
  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  late ScrollController _scrollController;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _textEditingController.text =
        Provider.of<GlobalBloc>(context).searchBloc.currentText$.value;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Tracking App'),
      ),
      body: StreamBuilder<List<Coin>>(
        stream: _globalBloc.coinsBloc.coins$,
        builder: (BuildContext context, AsyncSnapshot<List<Coin>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CryptoLoadingIndicator(),
            );
          }
          final List<Coin>? _coins = snapshot.data;
          return Stack(
            children: <Widget>[
              RefreshIndicator(
                color: Color(0xFF4CDA63),
                onRefresh: () async {
                  await _globalBloc.coinsBloc.getCoins();
                  _textEditingController.text = "";
                  _globalBloc.searchBloc.changeTypingState(false);
                  _globalBloc.searchBloc.updateText("");
                },
                child: ListView.separated(
                  key: PageStorageKey("Market"),
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  itemCount: _coins!.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return DelayedDisplay(
                        delay: Duration(milliseconds: 15 * index),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFF4F3F7),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: _textEditingController,
                            maxLines: 1,
                            cursorColor: Color(0xFF4CDA63),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 16.0),
                              hintText: "Search for currency",
                              hintMaxLines: 1,
                              hintStyle: TextStyle(
                                color: Color(0xFF8F8F91),
                              ),
                              border: InputBorder.none,
                              suffixIcon: StreamBuilder<bool>(
                                  stream: _globalBloc.searchBloc.isTyping$,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<bool> snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container();
                                    }
                                    final bool? _isTyping = snapshot.data;
                                    return IconButton(
                                      onPressed: () => _globalBloc.coinsBloc
                                          .filterCoins(
                                              _textEditingController.text),
                                      icon: Icon(
                                        Icons.search,
                                        color: _isTyping!
                                            ? Color(0xFF4CDA63)
                                            : Color(0xFF8F8F91),
                                      ),
                                    );
                                  }),
                            ),
                            onSubmitted: (String value) =>
                                _globalBloc.coinsBloc.filterCoins(value),
                            onChanged: (String value) {
                              if (value.trim().length == 0) {
                                _globalBloc.searchBloc.changeTypingState(false);
                              } else {
                                _globalBloc.searchBloc.changeTypingState(true);
                              }
                              _globalBloc.searchBloc.updateText(value);
                            },
                          ),
                        ),
                      );
                    }
                    final Coin _coin = _coins[index - 1];
                    return DelayedDisplay(
                      delay: Duration(milliseconds: 15 * index),
                      child: CoinCard(
                        key: UniqueKey(),
                        coin: _coin,
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (BuildContext context) => CoinInfoScreen(
                                coin: _coin,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      width: double.infinity,
                      height: 15,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
