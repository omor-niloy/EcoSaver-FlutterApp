import 'package:flutter/material.dart';
import 'dart:convert';
// import 'dart:io';
import 'file_manager.dart';



class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HistoryEntry> historyEntries = [];

  @override
  void initState() {
    super.initState();
    loadHistoryData();
  }

  Future<void> loadHistoryData() async {
      final Future<String> tmp = FileManager().readJsonFile();
      String jsonData = await tmp;
      final jsonMap = json.decode(jsonData) as Map<String, dynamic>;
      historyEntries = jsonMap.entries
          .map((entry) => HistoryEntry.fromJson(entry.value as Map<String, dynamic>))
          .toList();

      setState(() {});
  }

  Future<void> deleteEntry(int index) async {
    // Remove the entry from the list
    if (index >= 0 && index < historyEntries.length) {
      historyEntries.removeAt(index);

      // Save the updated list to the JSON file
      await saveHistoryData();

      // Trigger a rebuild to reflect the changes
      setState(() {});
    }
  }

  Future<void> saveHistoryData() async {
    final jsonMap = {
      for (var i = 0; i < historyEntries.length; i++)
        '$i': historyEntries[i].toJson(),
    };
    FileManager().writeJsonFile(jsonMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: const Color.fromARGB(255, 223, 238, 235),
      ),
      backgroundColor: const Color.fromARGB(255, 230, 242, 231),
      body: ListView.builder(
        itemCount: historyEntries.length,
        itemBuilder: (context, index) {
          final entry = historyEntries[historyEntries.length - 1 - index];
          return Card(
            // set color for each card to ash
            color: Colors.grey[200],
            elevation: 3,
            margin: const EdgeInsets.all(8),
            child: ListTile(

              // title: Text('Total Footprint: ${entry.totalFootprint.toString()}'),
              // make title size 20 and bold
              title: Text(
                'Total Footprint (kgCO2e): ${entry.totalFootprint.toStringAsFixed(2)} ',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text('Timestamp: ${entry.timestamp}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                onPressed: () => deleteEntry(index),
              ),
            ),
          );
        },
      ),
    );
  }
}

class HistoryEntry {
  final double totalFootprint;
  final String timestamp;

  HistoryEntry({
    required this.totalFootprint,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
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
