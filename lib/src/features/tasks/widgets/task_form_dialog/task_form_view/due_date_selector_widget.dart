import 'package:consys_coding_challenge/src/utils/readable_date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class DueDateSelectorWidget extends HookWidget {
  const DueDateSelectorWidget({
    super.key,
    required this.dueDateRef,
  });

  final ObjectRef<DateTime?> dueDateRef;

  @override
  Widget build(BuildContext context) {
    // Local UI state for managing selected due date within the widget
    final dueDateState = useState<DateTime?>(dueDateRef.value);

    useEffect(() {
      dueDateRef.value = dueDateState.value;
      dueDateState.addListener(() {
        dueDateRef.value = dueDateState.value;
      });
      return null;
    }, [dueDateState.value]);

    final dueDate = dueDateRef.value;

    return ListTile(
      title: const Text('Due Date'),
      subtitle: Text(
        dueDate != null ? dueDate.toReadableString(context) : 'No due date',
      ),
      trailing: IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: () async {
          final selected = await showOmniDateTimePicker(
            context: context,
            initialDate: dueDateState.value ?? DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
            is24HourMode: true,
          );
          if (selected != null) dueDateState.value = selected;
        },
      ),
    );
  }
}
