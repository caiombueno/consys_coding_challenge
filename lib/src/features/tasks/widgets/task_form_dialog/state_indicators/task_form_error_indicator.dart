import 'package:flutter/material.dart';

class TaskFormErrorIndicator extends StatelessWidget {
  final String errorMessage;

  const TaskFormErrorIndicator({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error, color: Colors.red, size: 64),
        const SizedBox(height: 16),
        Text(
          'Error',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.red),
        ),
        const SizedBox(height: 8),
        Text(
          errorMessage,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
