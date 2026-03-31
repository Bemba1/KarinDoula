import 'package:flutter/material.dart';

class OneShotPage extends StatelessWidget {
  const OneShotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("One Shot")),
      body: const Center(
        child: Text("Page One Shot"),
      ),
    );
  }
}