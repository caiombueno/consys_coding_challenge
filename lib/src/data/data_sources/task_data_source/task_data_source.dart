import 'package:consys_coding_challenge/src/models/models.dart';
export 'local_task_data_source.dart';

abstract class TaskDataSource {
  const TaskDataSource();

  Object get taskSummaries;
  dynamic deleteTask(TaskId id);
}
