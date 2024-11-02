// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskSummary _$TaskSummaryFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id'],
  );
  return TaskSummary(
    id: json['id'] as String,
    title: json['title'] as String?,
    priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']) ??
        TaskPriority.none,
    isCompleted: json['is_completed'] as bool? ?? false,
  );
}

Map<String, dynamic> _$TaskSummaryToJson(TaskSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'priority': _$TaskPriorityEnumMap[instance.priority]!,
      'is_completed': instance.isCompleted,
    };

const _$TaskPriorityEnumMap = {
  TaskPriority.high: 'high',
  TaskPriority.medium: 'medium',
  TaskPriority.low: 'low',
  TaskPriority.none: 'none',
};
