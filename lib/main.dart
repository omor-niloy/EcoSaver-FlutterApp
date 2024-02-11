import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'challenges.dart';
import 'calculator.dart';
import 'FAQs.dart';
import 'feedbackandsupport.dart';
import 'History.dart';
import 'news.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoSaver',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 38, 123, 4)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'EcoSaver'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late List<String> ecoTips;
  late String currentTip = "null";
  late int randomIndex = 0;
  
  late List<Map<String, dynamic>> articles = [];
  late int currentPage = 1;
  final apiKey = '1e0a82c1-0ac2-4e7c-9b1d-cc412ac1ee4a';
  int _selectedIndex = 0; // Index for the selected tab

  @override
  void initState() {
    super.initState();
    loadEcoTips();
  }

  Future<void> loadEcoTips() async {
    final String tipsJsonString =
        await rootBundle.loadString('assets/eco_tips.json');
    final List<dynamic> tipsList = json.decode(tipsJsonString);
    ecoTips = tipsList.cast<String>();
    showRandomTip();
  }

  void showRandomTip() {
    final Random random = Random();
    randomIndex = random.nextInt(ecoTips.length);
    // randomIndex = (randomIndex + 1) % 47;
    // print randomIndex on Debug Console
    // print(randomIndex);
    setState(() {
      currentTip = ecoTips[randomIndex];
    });
  }


  void _navigateToScreen(String screenName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        if (screenName == 'Challenges') {
          return const ChallengesScreen();
        } else if (screenName == 'Calculator') {
          return const CarbonFootprintTracker();
        } else if (screenName == 'History') {
          return const HistoryScreen();
        } else if (screenName == 'FAQs') {
          return const FAQsScreen();
        } else if (screenName == 'Feedback or Support') {
          return const FeedbackAndSupportScreen();
        }  else if (screenName == 'News') {
          return const NewsFeedPage();
        } else {
          // Default to the "Home" screen
          return const MyHomePage(title: 'EcoSaver');
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // backgroundColor: Colors.green[50],
        title: Text(widget.title),
      ),
      backgroundColor: const Color.fromARGB(255, 233, 249, 235),
      endDrawer: Drawer( // This is the sliding right drawer
        backgroundColor: const Color.fromARGB(255, 251, 252, 253),
        child: ListView(
          children: [
            ListTile(
              title: const Text('Challenges'),
              onTap: () {
                _navigateToScreen('Challenges');
                // Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Calculator'),
              onTap: () {
                _navigateToScreen('Calculator');
                // Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('History'),
              onTap: () {
                _navigateToScreen('History');
                // Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Environmental News'),
              onTap: () {
                _navigateToScreen('News');
                // Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('FAQs'),
              onTap: () {
                _navigateToScreen('FAQs');
                // Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Feedback or Support'),
              onTap: () {
                _navigateToScreen('Feedback or Support');
                // Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img6.jpg"),
            fit: BoxFit.cover,
          ),
        ),
         child : SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    elevation: 0.0,
                    // elevation: 5,
                    color: Color.fromRGBO(239, 240, 237, 0.363), // 0.8 for 80% transparency
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Eco-Friendly Tip:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            currentTip,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              showRandomTip();
                            },
                            child: const Text('Refresh'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 200),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(201, 230, 173, 0.498), // Adjust color and transparency as needed
                      borderRadius: BorderRadius.circular(15), // Set border radius for circular corners
                    ),
                    // Adjust color and transparency as needed
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Check your Carbon Footprint',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            _navigateToScreen('Calculator');
                          },
                          child: Text('Calculate'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(201, 230, 173, 0.498), // Adjust color and transparency as needed
                      borderRadius: BorderRadius.circular(15), // Set border radius for circular corners
                    ),
                    // Adjust color and transparency as needed
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Take an eco-friendly challenge',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            _navigateToScreen('Challenges');
                          },
                          child: Text('Take a Challenge'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 1) {
              _navigateToScreen('News');
            }
          });
        },
      ),
    );
  }
}
