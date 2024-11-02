// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id'],
  );
  return Task(
    id: json['id'],
    title: json['title'] as String?,
    description: json['description'] as String?,
    priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']) ??
        TaskPriority.none,
    isCompleted: json['is_completed'] as bool? ?? false,
    dueDate: json['dueDate'] == null
        ? null
        : DateTime.parse(json['dueDate'] as String),
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String),
  );
}

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'priority': _$TaskPriorityEnumMap[instance.priority]!,
      'is_completed': instance.isCompleted,
      'dueDate': instance.dueDate?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$TaskPriorityEnumMap = {
  TaskPriority.high: 'high',
  TaskPriority.medium: 'medium',
  TaskPriority.low: 'low',
  TaskPriority.none: 'none',
};
