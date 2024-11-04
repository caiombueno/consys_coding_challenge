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
