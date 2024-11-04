import 'dart:async';

import 'package:consys_coding_challenge/src/features/tasks/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskSummaryTitleSearchBar extends HookConsumerWidget {
  const TaskSummaryTitleSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = useState<String>('');

    final textController = useTextEditingController();

    final taskSummaryListController =
        ref.read(taskSummaryListControllerProvider.notifier);

    final debounceTimer = useRef<Timer?>(null);

    void updateTitleSearch() {
      taskSummaryListController.updateTitleSearch(title.value);
    }

    void updateTitle(String newTitle) {
      title.value = newTitle;

      // Cancel any existing timer when typing
      debounceTimer.value?.cancel();

      // Start a new timer that updates the search after 500ms of inactivity
      debounceTimer.value = Timer(
        const Duration(milliseconds: 500),
        updateTitleSearch,
      );
    }

    void clearTitle() {
      title.value = '';
      textController.clear();
      updateTitleSearch();
    }

    return _ClearableTextField(
      controller: textController,
      onChanged: updateTitle,
      onClear: clearTitle,
    );
  }
}

class _ClearableTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _ClearableTextField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Search tasks...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: onClear,
              )
            : null,
      ),
      onChanged: onChanged,
    );
  }
}
