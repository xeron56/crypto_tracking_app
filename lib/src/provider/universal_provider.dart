import 'package:crypto_tracking_app/src/provider/crypto_provider.dart';
import 'package:crypto_tracking_app/src/provider/find_provider.dart';

class GlobalBloc {
  late CoinsBloc _coinsBloc;
  late SearchBloc _searchBloc;

  CoinsBloc get coinsBloc => _coinsBloc;
  SearchBloc get searchBloc => _searchBloc;

  GlobalBloc() {
    _coinsBloc = CoinsBloc();
    _searchBloc = SearchBloc();
  }

  void dispose() {
    _coinsBloc.dispose();
    _searchBloc.dispose();
  }
}
