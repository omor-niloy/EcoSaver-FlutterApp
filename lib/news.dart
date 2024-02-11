import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({super.key});

  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  List<dynamic> articles = [];
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadNews();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // Reached the bottom of the list, load more data.
      currentPage++;
      _loadNews();
    }
  }

  Future<void> _loadNews() async {
    const apiKey =
        '1e0a82c1-0ac2-4e7c-9b1d-cc412ac1ee4a'; // Replace with your Guardian API key
    final apiUrl =
        'https://content.guardianapis.com/environment?page=$currentPage&api-key=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          articles.addAll(jsonData['response']['results']);
        });
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network error
      print('Network error: $error');
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Feed'),
        backgroundColor: Color.fromARGB(255, 236, 240, 234),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/c.jpg', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // ListView.builder above the background image
          Container(
            color: Colors.transparent, // Make the container transparent
            child: ListView.builder(
              controller: _scrollController,
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return GestureDetector(
                  onTap: () {
                    // Open the URL when the ListTile is tapped
                    _launchURL(article['webUrl']);
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    elevation: 4.0,
                    color: Color.fromRGBO(255, 255, 255, 0.8),
                    child: ListTile(
                      title: Text(
                        article['webTitle'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(article['webPublicationDate']),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}