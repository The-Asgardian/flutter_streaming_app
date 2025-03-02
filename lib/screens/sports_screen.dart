import 'package:flutter/material.dart';

class SportsScreen extends StatefulWidget {
  const SportsScreen({super.key});

  @override
  SportsScreenState createState() => SportsScreenState();
}

class SportsScreenState extends State<SportsScreen> {
  List<Map<String, String>> sportsEvents = [
    {"title": "Champions League Final", "time": "Today 8:00 PM"},
    {"title": "NBA Finals Game 2", "time": "Tomorrow 7:30 PM"},
    {"title": "Formula 1 Grand Prix", "time": "Sunday 3:00 PM"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live & Upcoming Sports")),
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: sportsEvents.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.grey[900],
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: ListTile(
              title: Text(
                sportsEvents[index]["title"]!,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              subtitle: Text(
                sportsEvents[index]["time"]!,
                style: TextStyle(color: Colors.white70),
              ),
              trailing: Icon(Icons.sports, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
