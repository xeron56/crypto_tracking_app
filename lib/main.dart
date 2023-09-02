import 'package:flutter/material.dart';
import 'package:crypto_tracking_app/src/provider/universal_provider.dart';

import 'package:crypto_tracking_app/src/frontend/mainpage/market_screen.dart';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(CryptoApp());

class CryptoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Provider(
      create: (BuildContext context) => GlobalBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          hintColor: Colors.blue,
          backgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: Colors.blue.withOpacity(0.7),
            selectionHandleColor: Colors.blue,
          ),
        ),
        home: MarketScreen(),
      ),
    );
  }
}
