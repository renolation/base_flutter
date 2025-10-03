import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/todo.dart';

part 'todo_model.freezed.dart';
part 'todo_model.g.dart';

@freezed
class TodoModel with _$TodoModel {
  const factory TodoModel({
    required int id,
    required String title,
    String? description,
    required bool completed,
    required String userId,
    @JsonKey(includeFromJson: false, includeToJson: false) Map<String, dynamic>? user,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _TodoModel;

  const TodoModel._();

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  /// Convert to domain entity
  Todo toEntity() => Todo(
        id: id,
        title: title,
        description: description,
        completed: completed,
        userId: userId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  /// Create from domain entity
  factory TodoModel.fromEntity(Todo todo) => TodoModel(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        completed: todo.completed,
        userId: todo.userId,
        createdAt: todo.createdAt,
        updatedAt: todo.updatedAt,
      );
}
