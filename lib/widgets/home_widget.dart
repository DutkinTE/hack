import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FloatingActionButton(
              onPressed: () {
                final navigator = Navigator.of(context);
                navigator.pushNamedAndRemoveUntil('/create', (Route<dynamic> route) => true);
              },
              child: const Icon(Icons.add),
            ),
          ),
        )
      ],
    );
  }
}
