import 'package:flutter/material.dart';

class FAQsScreen extends StatelessWidget {
  const FAQsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Questions'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FAQItem(
              question: 'How does carbon footprint calculator work?',
              answer: 'A carbon footprint calculator estimates an individual\'s or organization\'s greenhouse gas emissions by inputting data on activities and using emission factors to calculate the total emissions, helping users understand their environmental impact.',
            ),
            FAQItem(
              question: 'What are the emission factors?',
              answer: 'We recognize that carbon emissions result from various human activities, and these four categories are associated with the everyday actions of common people:\n1. Transportation (car): Approximately 0.0227 kgCO2e per kilometer.\n2. Electricity: Around 0.3712 kgCO2e per kilowatt-hour.\n3. Food (meat): About 0.0122 kgCO2e per gram.\n4. Water usage: Roughly 0.02 kgCO2e per liter.',
            ),
            // Add more FAQItems here
          ],
        ),
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({super.key, required this.question, required this.answer});

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          title: Text(
            widget.question,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(
            icon: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(widget.answer),
          ),
        const Divider(),
      ],
    );
  }
}
