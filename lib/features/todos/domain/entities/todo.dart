import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final int id;
  final String title;
  final String? description;
  final bool completed;
  final String userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Todo({
    required this.id,
    required this.title,
    this.description,
    required this.completed,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  Todo copyWith({
    int? id,
    String? title,
    String? description,
    bool? completed,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, title, description, completed, userId, createdAt, updatedAt];
}
