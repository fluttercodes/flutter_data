part of flutter_data;

/// A [Relationship] that models a to-one ownership.
///
/// Example: A book that belongs to an author
/// ```
/// class Book with DataModel<Book> {
///  @override
///  final int id;
///  final String title;
///  final BelongsTo<Author> author;
///
///  Todo({this.id, this.title, this.author});
/// }
///```
class BelongsTo<E extends DataModel<E>> extends Relationship<E, E> {
  /// Creates a [BelongsTo] relationship, with an optional initial [E] model.
  ///
  /// Example:
  /// ```
  /// final author = Author(name: 'JK Rowling');
  /// final book = Book(id: 1, author: BelongsTo(author));
  /// ```
  ///
  /// See also: [DataModelRelationshipExtension<E>.asBelongsTo]
  BelongsTo([final E model]) : super(model != null ? {model} : null);

  BelongsTo._(String key, bool _wasOmitted)
      : super._(key != null ? {key} : {}, _wasOmitted);

  /// For internal use with `json_serializable`.
  factory BelongsTo.fromJson(final Map<String, dynamic> map) {
    final key = map['_'][0] as String;
    if (key == null) {
      final wasOmitted = map['_'][1] as bool;
      return BelongsTo._(null, wasOmitted);
    }
    return BelongsTo._(key, false);
  }

  /// Obtains the single [E] value of this relationship (`null` if not present).
  E get value => safeFirst;

  /// Sets the single [E] value of this relationship, replacing any previous [value].
  ///
  /// Passing in `null` will remove the existing value from the relationship.
  set value(E value) {
    if (value != null) {
      if (super.isNotEmpty) {
        super.remove(this.value);
      }
      super.add(value);
    } else {
      super.remove(this.value);
    }
    assert(length <= 1);
  }

  /// Returns the [value]'s `key`
  @protected
  @visibleForTesting
  String get key => super.keys.safeFirst;

  String get id => super.ids.safeFirst;

  /// Returns a [StateNotifier] which emits the latest [value] of
  /// this [BelongsTo] relationship.
  @override
  StateNotifier<E> watch() {
    return _graphEvents.where((e) => e.isNotEmpty).map((e) {
      return e.last.type == DataGraphEventType.removeNode ? null : value;
    });
  }

  @override
  String toString() => 'BelongsTo<$E>($value)';
}

extension DataModelRelationshipExtension<T extends DataModel<T>>
    on DataModel<T> {
  /// Converts a [DataModel<T>] into a [BelongsTo<T>].
  ///
  /// Equivalent to using the constructor as `BelongsTo(model)`.
  BelongsTo<T> get asBelongsTo => BelongsTo<T>(this as T);
}
