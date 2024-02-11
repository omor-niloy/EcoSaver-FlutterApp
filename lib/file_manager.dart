import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileManager {
  static FileManager? _instance;

  FileManager._internal() {
    _instance = this;
  }

  factory FileManager() => _instance ?? FileManager._internal();

  Future<String> get _directoryPath async {
    // write for android and linux
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      return directory!.path;
    } else if (Platform.isLinux) {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } else {
      throw Exception('Unsupported platform');
    }
  }

  Future<File> get _jsonFile async {
    final path = await _directoryPath;
    return File('$path/history.json');
  }

  Future<String> readJsonFile() async {
    String fileContent = '{}';

    File file = await _jsonFile;

    if (await file.exists()) {
      try {
        fileContent = await file.readAsString();
        return fileContent;
      } catch (e) {
        print(e);
      }
    }
    return fileContent;
    // return json.decode(fileContent);
  }

  Future<void> writeJsonFile(Map<String, dynamic> existingEntries) async {
    File file = await _jsonFile;
    await file.writeAsString(json.encode(existingEntries));
  }
}

class HistoryEntry {
  final double totalFootprint;
  final String timestamp;

  HistoryEntry({
    required this.totalFootprint,
    required this.timestamp,
  });
  Map<String, dynamic> toJason() {
    return {
    'totalFootprint': totalFootprint,
    'timestamp': timestamp,
    };
  }
  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      totalFootprint: json['totalFootprint'],
      timestamp: json['timestamp'],
    );
  }
}