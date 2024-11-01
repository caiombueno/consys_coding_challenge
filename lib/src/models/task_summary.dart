// lib/features/tasks/data/models/task_summary.dart

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_summary.g.dart';

enum TaskPriority {
  high(
    name: 'High',
    color: 0xFFE53935, // Red color
  ),
  medium(
    name: 'Medium',
    color: 0xFFFFB300, // Amber color
  ),
  low(
    name: 'Low',
    color: 0xFF43A047, // Green color
  ),
  none(
    name: 'None',
    color: 0xFF9E9E9E, // Grey color
  );

  const TaskPriority({
    required this.name,
    required this.color,
  });

  final String name;
  final int color;
}

typedef TaskId = String;

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
