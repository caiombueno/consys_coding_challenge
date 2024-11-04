import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TaskFormSuccessIndicator extends HookWidget {
  const TaskFormSuccessIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    // Automatically close the dialog after 1 second
    useEffect(() {
      final timer = Timer(const Duration(seconds: 1), () {
        if (context.mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      });
      return timer.cancel;
    }, []);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 64),
        const SizedBox(height: 16),
        Text(
          'Success!',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.green),
        ),
        const SizedBox(height: 8),
        Text(
          'Task saved successfully.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
