import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:notes_api/src/models/json_map.dart';
import 'package:uuid/uuid.dart';

part 'note.g.dart';

///
@immutable
@JsonSerializable()
class Note extends Equatable {
  /// Constructor of Note
  Note({String? id, this.title = '', this.description = ''})
      : assert(
          id == null || id.isNotEmpty,
          'id cannot be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// Unique identifier of the 'note'.
  ///
  /// Cannot be empty.
  final String id;

  /// Title of 'note'.
  ///
  /// TDefaults to an empty string.
  final String title;

  /// Description of 'note'.
  ///
  /// Defaults to an empty string.
  final String description;

  /// Returns a copy of this 'note' with the given values updated
  ///
  ///
  Note copyWith({
    String? id,
    String? title,
    String? description,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  /// Deserializes the given [JsonMap] into a [Note].
  static Note fromJson (JsonMap jsonMap) => _$NoteFromJson(jsonMap);

  /// Converts this [Note] into a [JsonMap].
  JsonMap toJson() => _$NoteToJson(this);

  @override
  List<Object> get props => [id, title, description];
}
