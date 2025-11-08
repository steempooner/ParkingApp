import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ParkingScreen(),
    );
  }
}

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});
  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  List<dynamic> parkings = [];
  bool loading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      loading = true;
      error = '';
      parkings = [];
    });

    final proxyUrl = 'https://api.allorigins.win/get?url=';
    final targetUrl = Uri.encodeComponent(
        'https://open-data.dortmund.de/api/explore/v2.1/catalog/datasets/parkhauser/records?limit=100');

    try {
      final response = await http.get(Uri.parse(proxyUrl + targetUrl));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final realData = jsonDecode(jsonData['contents']);
        setState(() {
          parkings = realData['results'];
          loading = false;
        });
      } else {
        setState(() {
          error = 'Fehler beim Laden: ${response.statusCode}';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Verbindungsproblem: $e';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parkhäuser Dortmund'),
        backgroundColor: Colors.blue,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(child: Text(error, style: const TextStyle(color: Colors.red)))
              : ListView.builder(
                  itemCount: parkings.length,
                  itemBuilder: (context, index) {
                    final p = parkings[index];
                    final name = p['name'] ?? 'Unbekannt';
                    final freeRaw = p['frei'] ?? 0;
                    final free = freeRaw < 0 ? 0 : freeRaw;  // Fix für negative Werte
                    final capacity = p['capacity'] ?? 0;
                    final percent = capacity > 0 ? (free / capacity * 100).toInt() : 0;
                    final color = percent > 50 ? Colors.green : percent > 20 ? Colors.orange : Colors.red;
                    final subtitleText = freeRaw < 0 ? 'Frei: $free / $capacity ($percent%) (Datenfehler korrigiert)' : 'Frei: $free / $capacity ($percent%)';

                    return Card(
                      child: ListTile(
                        title: Text(name),
                        subtitle: Text(subtitleText),
                        trailing: CircleAvatar(backgroundColor: color, child: const Icon(Icons.local_parking, color: Colors.white)),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadData,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}