import 'package:consys_coding_challenge/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

export 'task_id.dart';
export 'task_priority.dart';
export 'task_summary.dart';

part 'task.g.dart';

@JsonSerializable()
class Task extends Equatable {
  @JsonKey(required: true)
  final TaskId id;
  final String? title;
  final String? description;
  @JsonKey(defaultValue: TaskPriority.none)
  final TaskPriority priority;
  @JsonKey(defaultValue: false, name: 'is_completed')
  final bool isCompleted;
  final DateTime? dueDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Task({
    required this.id,
    this.title,
    this.description,
    this.priority = TaskPriority.none,
    this.isCompleted = false,
    this.dueDate,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory constructor to create a Task with the current date
  factory Task.create({
    required TaskId id,
    String? title,
    String? description,
    TaskPriority priority = TaskPriority.none,
    bool isCompleted = false,
    DateTime? dueDate,
  }) {
    final currentDate = DateTime.now();
    return Task(
      id: id,
      title: title,
      description: description,
      priority: priority,
      isCompleted: isCompleted,
      dueDate: dueDate,
      createdAt: currentDate,
      updatedAt: currentDate,
    );
  }

  Task copyWith({
    String? title,
    String? description,
    TaskPriority? priority,
    bool? isCompleted,
    DateTime? dueDate,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Task edit({
    String? title,
    String? description,
    TaskPriority? priority,
    bool? isCompleted,
    DateTime? dueDate,
  }) {
    return copyWith(
      title: title,
      description: description,
      priority: priority,
      isCompleted: isCompleted,
      dueDate: dueDate,
      updatedAt: DateTime.now(),
    );
  }

  /// Simplified complete method using copyWith
  Task toggleComplete() {
    return copyWith(
      isCompleted: !isCompleted,
      updatedAt: DateTime.now(),
    );
  }

  TaskSummary toSummary() {
    return TaskSummary(
      id: id,
      title: title,
      priority: priority,
      isCompleted: isCompleted,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        priority,
        isCompleted,
        dueDate,
        createdAt,
        updatedAt,
      ];
}
