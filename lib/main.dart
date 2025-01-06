import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



void main() {
  runApp(const QuotesApp());
}

class QuotesApp extends StatelessWidget {
  const QuotesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const QuotesPage(),
    );
  }
}

class QuotesPage extends StatefulWidget {
  const QuotesPage({Key? key}) : super(key: key);

  @override
  _QuotesPageState createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  String _quote = "Loading...";
  String _author = "";

  Future<void> fetchQuote() async {
    const url = "https://quotes15.p.rapidapi.com/quotes/random/";
    const headers = {
      "X-RapidAPI-Key": "4a3314736bmsh9de118d6b46fd5fp1dfdf8jsn388eb6bf295e", // Ganti dengan API Key Anda
      "X-RapidAPI-Host": "quotes15.p.rapidapi.com"
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _quote = data['content'] ?? "No quote found";
          _author = data['originator']['name'] ?? "Unknown";
        });
      } else {
        setState(() {
          _quote = "Failed to load quote";
          _author = "";
        });
      }
    } catch (e) {
      setState(() {
        _quote = "Error: $e";
        _author = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quotes App"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '"$_quote"',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 10),
              Text(
                "- $_author",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: fetchQuote,
                child: const Text("Get New Quote"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
