import 'package:consys_coding_challenge/src/utils/readable_date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class DateSelectorWidget extends HookWidget {
  const DateSelectorWidget({
    super.key,
    this.title = 'Select date',
    this.emptyDateSubtitle = 'No date',
    required this.dateRef,
  });

  final String title;
  final String emptyDateSubtitle;
  final ObjectRef<DateTime?> dateRef;

  @override
  Widget build(BuildContext context) {
    // Local UI state for managing selected due date within the widget
    final dateState = useState<DateTime?>(dateRef.value);

    useEffect(() {
      dateRef.value = dateState.value;
      dateState.addListener(() {
        dateRef.value = dateState.value;
      });
      return null;
    }, [dateState.value]);

    final dueDate = dateRef.value;

    return ListTile(
      title: Text(title),
      subtitle: Text(
        dueDate != null ? dueDate.toReadableString(context) : emptyDateSubtitle,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: () async {
          final selected = await showOmniDateTimePicker(
            context: context,
            initialDate: dateState.value ?? DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
            is24HourMode: true,
          );
          if (selected != null) dateState.value = selected;
        },
      ),
    );
  }
}
