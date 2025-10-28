import 'package:flutter/material.dart';

class ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorRetry({required this.message, required this.onRetry, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text(message, textAlign: TextAlign.center),
      const SizedBox(height: 8),
      ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
    ]);
  }
}
