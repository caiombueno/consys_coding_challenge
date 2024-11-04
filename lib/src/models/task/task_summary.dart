// lib/features/tasks/data/models/task_summary.dart

import 'package:consys_coding_challenge/src/models/task/task_id.dart';
import 'package:consys_coding_challenge/src/models/task/task_priority.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_summary.g.dart';

@JsonSerializable()
class TaskSummary extends Equatable {
  @JsonKey(required: true)
  final TaskId id;
  final String? title;
  @JsonKey(defaultValue: TaskPriority.none)
  final TaskPriority priority;
  @JsonKey(defaultValue: false, name: 'is_completed')
  final bool isCompleted;

  const TaskSummary({
    required this.id,
    this.title,
    this.priority = TaskPriority.none,
    this.isCompleted = false,
  });

  factory TaskSummary.fromJson(Map<String, dynamic> json) =>
      _$TaskSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$TaskSummaryToJson(this);

  @override
  List<Object?> get props => [id, title, priority, isCompleted];
}
