import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './drink_tracker_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DrinkTrackerModel(),
      child: const DrinkTrackerApp(),
    ),
  );
}

class DrinkTrackerApp extends StatelessWidget {
  const DrinkTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drink Tracker',
      theme: ThemeData.dark(),
      home: const DrinkHomePage(),
    );
  }
}

class DrinkHomePage extends StatelessWidget {
  const DrinkHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<DrinkTrackerModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drink Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => model.resetCount(),
            tooltip: 'Reset Count',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Drinks consumed:', style: TextStyle(fontSize: 24)),
            Text(
              '${model.drinkCount}',
              style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => model.addDrink(),
              icon: const Icon(Icons.local_bar),
              label: const Text('Add Drink'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20), // Add spacing between buttons
            ElevatedButton.icon(
              onPressed: () => model.subtractDrink(),
              icon: const Icon(Icons.remove),
              label: const Text('Subtract Drink'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
