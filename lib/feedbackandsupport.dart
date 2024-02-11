import 'package:flutter/material.dart';

class FeedbackAndSupportScreen extends StatelessWidget {
  const FeedbackAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback and Support'),
        backgroundColor: const Color.fromARGB(255,245, 248, 246),
      ),
      backgroundColor: const Color.fromARGB(255, 245, 248, 246),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'We value your feedback and are here to assist you. Please provide your feedback or contact our support team:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            FeedbackForm(),
            SizedBox(height: 16.0),
            ContactSupport(),
          ],
        ),
      ),
    );
  }
}

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Submit Feedback:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: feedbackController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Type your feedback here...',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle feedback submission, e.g., sending it to your server
            String feedback = feedbackController.text;
            // TODO: Send the feedback to your server or handle it as needed
            print(feedback);
            // TODO: Send the feedback to your server or handle it as needed
          },
          child: const Text('Submit Feedback'),
        ),
      ],
    );
  }
}

class ContactSupport extends StatelessWidget {
  const ContactSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Contact Support:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ListTile(
          title: const Text('Email: omor.niloy.0@gmail.com'),
          subtitle: const Text('Send us an email for assistance.'),
          onTap: () {
            // Open the user's email app with a pre-filled support email address
            // You can use a package like 'url_launcher' for this functionality.
          },
        ),
        ListTile(
          title: const Text('Phone: +880 19 6648 0555'),
          subtitle: const Text('Call our support team for immediate assistance.'),
          onTap: () {
            // Open the phone app with the support phone number pre-filled
            // You can use a package like 'url_launcher' for this functionality.
          },
        ),
      ],
    );
  }
}
