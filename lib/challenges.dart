import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({Key? key}) : super(key: key);

  @override
  _ChallengesScreenState createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  List<ChallengeCategory> categories = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final dailyChallenges = await fetchChallenges(
          'https://raw.githubusercontent.com/omor-niloy/EcoSaver-Challenges/main/daily-challenges.json');
      final weeklyChallenges = await fetchChallenges(
          'https://raw.githubusercontent.com/omor-niloy/EcoSaver-Challenges/main/weekly-challenges.json');
      final monthlyChallenges = await fetchChallenges(
          'https://raw.githubusercontent.com/omor-niloy/EcoSaver-Challenges/main/monthly-challenges.json');

      setState(() {
        categories = [
          ChallengeCategory(title: 'Daily Challenges', challenges: dailyChallenges),
          ChallengeCategory(title: 'Weekly Challenges', challenges: weeklyChallenges),
          ChallengeCategory(title: 'Monthly Challenges', challenges: monthlyChallenges),
        ];
      });

      // print('Categories: $categories');
    } catch (e) {
      print('Error fetching challenges: $e');
    }
  }

  Future<List<ChallengeCard>> fetchChallenges(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic>? data = json.decode(response.body);

      if (data != null) {
        // print('Fetched data: $data');
        return data.map((challenge) => ChallengeCard.fromJson(challenge)).toList();
      } else {
        throw Exception("Data is null");
      }
    } else {
      throw Exception("Failed to load challenges. Status code: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 244, 249, 254),
        title: const Text('Eco-Friendly Challenges'),
      ),
      backgroundColor: Colors.grey[200],
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/c.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      
        child: SingleChildScrollView(
          child: Center(
            // color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: categories,
            ),
          ),
        ),
      ),
    );
  }
}

class ChallengeCategory extends StatelessWidget {
  final String title;
  final List<ChallengeCard> challenges;

  const ChallengeCategory({
    required this.title,
    required this.challenges,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: challenges,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class ChallengeCard extends StatefulWidget {
  final String title;
  final String description;
  final String challengeKey;

  const ChallengeCard({
    required this.title,
    required this.description,
    required this.challengeKey,
    Key? key,
  }) : super(key: key);
  factory ChallengeCard.fromJson(Map<String, dynamic> json) {
    return ChallengeCard(
      title: json['title'],
      description: json['description'],
      challengeKey: json['challengeKey'],
    );
  }

  @override
  _ChallengeCardState createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard> {
  late bool isTaken = false;
  late bool isDone;

  @override
  void initState() {
    super.initState();
    isDone = false;
    loadChallengeState();
  }

  void loadChallengeState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isTaken = prefs.getBool('${widget.challengeKey}_taken') ?? false;
      isDone = prefs.getBool('${widget.challengeKey}_done') ?? false;
    });
  }

  void takeChallenge() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('${widget.challengeKey}_taken', true);
    setState(() {
      isTaken = true;
    });
  }

  void abandonChallenge() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('${widget.challengeKey}_taken');
    prefs.remove('${widget.challengeKey}_done');
    setState(() {
      isTaken = false;
      isDone = false;
    });
  }

  void resetChallenge() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('${widget.challengeKey}_done');
    prefs.remove('${widget.challengeKey}_taken');  // Add this line
    setState(() {
      isTaken = false;
      isDone = false;
    });
  }

  void markChallengeDone() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('${widget.challengeKey}_done', true);
    setState(() {
      isDone = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(8),
      child: Container(
        width: 300, // Set a fixed width for all cards
        height: 190,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(widget.description),
            const SizedBox(height: 16),
            if (!isTaken)
              ElevatedButton(
                onPressed: takeChallenge,
                child: const Text('Take'),
              ),
            if (isTaken && !isDone)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: abandonChallenge,
                    child: const Text('Abandon'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      markChallengeDone();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Challenge Completed!'),
                        ),
                      );
                    },
                    child: const Text('Done'),
                  ),
                ],
              ),
            if (isDone)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      resetChallenge();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Challenge Reset!'),
                        ),
                      );
                    },
                    child: const Text('Reset'),
                  ),
                  const Text(
                    'Challenge Completed!',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
