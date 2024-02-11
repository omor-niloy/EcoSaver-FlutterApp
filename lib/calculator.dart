import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'History.dart';
import 'file_manager.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CarbonFootprintTracker(),
    );
  }
}

class CarbonFootprintTracker extends StatefulWidget {
  const CarbonFootprintTracker({super.key});

  @override
  _CarbonFootprintTrackerState createState() =>
      _CarbonFootprintTrackerState();
}

class _CarbonFootprintTrackerState extends State<CarbonFootprintTracker> {
  double transport = 0.0, electricity = 0.0, food = 0.0, water = 0.0;
  double ptransport = 0.0, pelectricity = 0.0, pfood = 0.0, pwater = 0.0;
  double totalCarbonFootprint = 0.0;
  final List<HistoryEntry> historyLog = [];

  @override
  Widget build(BuildContext context) {
    ptransport = (transport * 0.0227); pelectricity = (electricity * 0.3712);
    pfood = (food * 0.0122); pwater = (water * 0.02);
    totalCarbonFootprint = ptransport + pelectricity + pfood + pwater;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carbon Footprint Tracker'),
        backgroundColor: Colors.blue[50],
        actions: <Widget>[
          // History log button
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Navigate to the history screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Enter your carbon footprint data :',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              InputCard(
                title: 'Transportation',
                description:
                    'Enter how much distance(km) you have traveled by car:',
                value: transport,
                onChanged: (value) {
                  setState(() {
                    transport = value;
                  });
                },
              ),
              InputCard(
                title: 'Electricity',
                description: 'Enter how much electricity(kWh) you have used:',
                value: electricity,
                onChanged: (value) {
                  setState(() {
                    electricity = value;
                  });
                },
              ),
              InputCard(
                title: 'Food',
                description: 'Enter how much meat(gm) you have eaten:',
                value: food,
                onChanged: (value) {
                  setState(() {
                    food = value;
                  });
                },
              ),
              InputCard(
                title: 'Water',
                description: 'Enter how much water(L) you have used:',
                value: water,
                onChanged: (value) {
                  setState(() {
                    water = value;
                  });
                },
              ),
              // const SizedBox(height: 20),
              Visibility(
                visible: true, // Control the visibility of ResultCard
                child: ResultCard(
                  transport: ptransport,
                  electricity: pelectricity,
                  food: pfood,
                  water: pwater,
                  totalFootprint: totalCarbonFootprint,
                  onSave: () {
                    // Save the data to history log
                    saveToHistory();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveToHistory() async {
    String dateAndTime = DateFormat.yMd().add_jm().format(DateTime.now());
    final entry = HistoryEntry(
      totalFootprint: totalCarbonFootprint,
      timestamp: dateAndTime,
    );
    Map<String, dynamic> existingEntries = {};
    final Future<String> tmp = FileManager().readJsonFile();
    String jsonData = await tmp;
    existingEntries = json.decode(jsonData);

    // // indexDateandTime with seconds
    String indexDateandTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    // // add new entry to ecisting entries
    existingEntries[indexDateandTime] = entry.toJason();
    FileManager().writeJsonFile(existingEntries);
  }
}

class InputCard extends StatelessWidget {
  final String title;
  final String description;
  final double value;
  final Function(double) onChanged;

  const InputCard({
    super.key,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: SizedBox(
          width: 100,
          child: TextField(
            keyboardType: TextInputType.number,
            onChanged: (text) {
              onChanged(double.tryParse(text) ?? 0.0);
            },
            decoration: InputDecoration(
              hintText: value.toString(),
              isDense: true,
            ),
          ),
        ),
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  final double transport;
  final double electricity;
  final double food;
  final double water;
  final double totalFootprint;
  final VoidCallback onSave;

  const ResultCard({
    super.key,
    required this.transport,
    required this.electricity,
    required this.food,
    required this.water,
    required this.totalFootprint,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text(
              'Transportation Footprint (kgCO2e) :',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              (transport).toStringAsFixed(2),
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'Electricity Footprint (kgCO2e) :',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              (electricity).toStringAsFixed(2),
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'Food Footprint (kgCO2e) :',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              (food).toStringAsFixed(2),
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'Water Footprint (kgCO2e) :',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              (water).toStringAsFixed(2),
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'Total Carbon Footprint (kgCO2e) :',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              totalFootprint.toStringAsFixed(2),
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text('Save', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class HistoryEntry {
  // final double transport;
  // final double electricity;
  // final double food;
  // final double water;
  final double totalFootprint;
  final String timestamp;

  HistoryEntry({
    // required this.transport,
    // required this.electricity,
    // required this.food,
    // required this.water,
    required this.totalFootprint,
    required this.timestamp,
  });
  Map<String, dynamic> toJason() {
    return {
    // 'transport': transport,
    // 'electricity': electricity,
    // 'food': food,
    // 'water': water,
    'totalFootprint': totalFootprint,
    'timestamp': timestamp,
    };
  }
  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      // transport: json['transport'],
      // electricity: json['electricity'],
      // food: json['food'],
      // water: json['water'],
      totalFootprint: json['totalFootprint'],
      timestamp: json['timestamp'],
    );
  }
}