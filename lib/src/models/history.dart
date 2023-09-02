import 'package:crypto_tracking_app/src/models/graph_data.dart';

class History {
  List<GraphData> _graphData;
  num _timeTo;
  num _timeFrom;

  List<GraphData> get graphData => _graphData;
  num get timeTo => _timeTo;
  num get timeFrom => _timeFrom;

  History._(
      {required List<GraphData> graphData,
      required num timeTo,
      required num timeFrom})
      : _graphData = graphData,
        _timeTo = timeTo,
        _timeFrom = timeFrom;

  factory History.fromJson(Map<String, dynamic> json) {
    List<GraphData> _graphDataList = [];
    for (var item in json["Data"]) {
      _graphDataList.add(GraphData.fromJson(item));
    }
    return History._(
      graphData: _graphDataList,
      timeFrom: json["TimeFrom"],
      timeTo: json["TimeTo"],
    );
  }
}
