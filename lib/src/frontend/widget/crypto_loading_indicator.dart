import 'package:flutter/material.dart';

class CryptoLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 200,
        maxWidth: 200,
      ),
      child: CircularProgressIndicator(),
    );
  }
}
