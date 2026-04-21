import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum QrType { scanned, created }

class QrHistoryItem {
  final String id;
  final String data;
  final DateTime timestamp;
  final QrType type;

  QrHistoryItem({
    required this.id,
    required this.data,
    required this.timestamp,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'data': data,
        'timestamp': timestamp.toIso8601String(),
        'type': type.index,
      };

  factory QrHistoryItem.fromJson(Map<String, dynamic> json) => QrHistoryItem(
        id: json['id'],
        data: json['data'],
        timestamp: DateTime.parse(json['timestamp']),
        type: QrType.values[json['type']],
      );
}

class HistoryController extends GetxController {
  final _storage = GetStorage();
  final history = <QrHistoryItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadHistory();
  }

  void _loadHistory() {
    final List<dynamic>? storedData = _storage.read<List<dynamic>>('qr_history');
    if (storedData != null) {
      history.value = storedData
          .map((item) => QrHistoryItem.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
  }

  void addItem(String data, QrType type) {
    final newItem = QrHistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      data: data,
      timestamp: DateTime.now(),
      type: type,
    );
    history.insert(0, newItem); // Most recent first
    _saveHistory();
  }

  void deleteItem(String id) {
    history.removeWhere((item) => item.id == id);
    _saveHistory();
  }

  void clearHistory() {
    history.clear();
    _saveHistory();
  }

  void _saveHistory() {
    _storage.write('qr_history', history.map((item) => item.toJson()).toList());
  }
}
