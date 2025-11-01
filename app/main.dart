import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const UsmanPSXScanner());
}

class UsmanPSXScanner extends StatelessWidget {
  const UsmanPSXScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Usman PSX Scanner',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
      ),
      home: const PSXScannerHome(),
    );
  }
}

class PSXScannerHome extends StatefulWidget {
  const PSXScannerHome({super.key});

  @override
  State<PSXScannerHome> createState() => _PSXScannerHomeState();
}

class _PSXScannerHomeState extends State<PSXScannerHome> {
  final List<Map<String, dynamic>> _signals = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _loadSignals();
  }

  Future<void> _loadSignals() async {
    // Demo — Random PSX signals
    List<String> stocks = [
      "OGDC", "HBL", "ENGRO", "PSO", "LUCK", "SYS", "MEBL", "FFC",
      "BAHL", "UBL", "TRG", "PPL", "MCB", "EFERT", "HUBC", "SEARL"
    ];

    List<Map<String, dynamic>> list = [];
    for (var s in stocks) {
      double price = 100 + _random.nextDouble() * 200;
      bool buy = _random.nextBool();
      double tp = price * (buy ? 1.03 : 0.97);
      double sl = price * (buy ? 0.97 : 1.03);

      list.add({
        "symbol": s,
        "signal": buy ? "BUY" : "SELL",
        "price": price.toStringAsFixed(2),
        "tp": tp.toStringAsFixed(2),
        "sl": sl.toStringAsFixed(2),
      });
    }

    setState(() => _signals.clear());
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _signals.addAll(list));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usman PSX Scanner"),
        centerTitle: true,
      ),
      body: _signals.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadSignals,
              child: ListView.builder(
                itemCount: _signals.length,
                itemBuilder: (context, index) {
                  final s = _signals[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    color: s["signal"] == "BUY"
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                    child: ListTile(
                      title: Text(
                        "${s["symbol"]} — ${s["signal"]}",
                        style: TextStyle(
                          color: s["signal"] == "BUY"
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Price: ${s["price"]} | TP: ${s["tp"]} | SL: ${s["sl"]}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: const Icon(Icons.trending_up, color: Colors.white),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
