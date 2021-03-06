part of flutter_data;

/// A `Set` that models a relationship between one or more [DataModel] objects
/// and their a [DataModel] owner. Backed by a [GraphNotifier].
abstract class Relationship<E extends DataModel<E>, N>
    with SetMixin<E>, _Lifecycle<Relationship<E, N>> {
  @protected
  Relationship([Set<E> models])
      : _uninitializedKeys = {},
        _uninitializedModels = models ?? {},
        _wasOmitted = models == null;

  Relationship._(Iterable<String> keys, this._wasOmitted)
      : _uninitializedKeys = keys.toSet(),
        _uninitializedModels = {};

  String _ownerKey;
  String _name;
  String _inverseName;
  Map<String, RemoteAdapter> _adapters;
  RemoteAdapter<E> _adapter;
  GraphNotifier get _graph => _adapter?.localAdapter?.graph;

  final Set<String> _uninitializedKeys;
  final Set<E> _uninitializedModels;
  final bool _wasOmitted;

  @protected
  String get type => DataHelpers.getType<E>();

  /// Initializes this relationship (typically when initializing the owner
  /// in [DataModel]) by supplying the owner, and related [adapters] and metadata.
  @override
  @mustCallSuper
  Future<Relationship<E, N>> initialize(
      {@required final Map<String, RemoteAdapter> adapters,
      @required final DataModel owner,
      @required final String name,
      @required final String inverseName}) async {
    if (isInitialized) return this;

    _adapters = adapters;
    _adapter = adapters[type] as RemoteAdapter<E>;

    assert(owner != null && _adapter != null);
    _ownerKey = owner._key;
    _name = name;
    _inverseName = inverseName;

    // initialize uninitialized models and get keys
    final newKeys = _uninitializedModels.map((model) {
      return model._initialize(_adapters, save: true)._key;
    });
    _uninitializedKeys..addAll(newKeys);
    _uninitializedModels.clear();

    // initialize keys
    if (!_wasOmitted) {
      // if it wasn't omitted, we overwrite
      _graph._removeEdges(_ownerKey,
          metadata: _name, inverseMetadata: _inverseName);
      _graph._addEdges(
        _ownerKey,
        tos: _uninitializedKeys,
        metadata: _name,
        inverseMetadata: _inverseName,
      );
      _uninitializedKeys.clear();
    }

    super.initialize();
    return this;
  }

  @override
  bool get isInitialized => _ownerKey != null && _adapters != null;

  // implement the `Set`

  /// Add a [value] to this [Relationship]
  ///
  /// Attempting to add an existing [value] has no effect as this is a [Set]
  @override
  bool add(E value, {bool notify = true}) {
    if (value == null) {
      return false;
    }
    if (contains(value)) {
      return false;
    }

    // try to ensure value is initialized
    _ensureModelIsInitialized(value);

    if (value._isInitialized && isInitialized) {
      _graph._addEdge(_ownerKey, value._key,
          metadata: _name, inverseMetadata: _inverseName);
    } else {
      // if it can't be initialized, add to the models queue
      _uninitializedModels.add(value);
    }
    return true;
  }

  @override
  bool contains(Object element) {
    return _iterable.contains(element);
  }

  @override
  Iterator<E> get iterator => _iterable.iterator;

  @override
  E lookup(Object element) {
    return toSet().lookup(element);
  }

  /// Removes a [value] from this [Relationship]
  @override
  bool remove(Object value, {bool notify = true}) {
    assert(value is E);
    final model = value as E;
    if (isInitialized) {
      _ensureModelIsInitialized(model);
      _graph._removeEdge(
        _ownerKey,
        model._key,
        metadata: _name,
        inverseMetadata: _inverseName,
        notify: notify,
      );
      return true;
    }
    return _uninitializedModels.remove(model);
  }

  @override
  int get length => _iterable.length;

  @override
  Set<E> toSet() {
    return _iterable.toSet();
  }

  // support methods

  Iterable<E> get _iterable {
    if (isInitialized) {
      return keys
          .map((key) => _adapter.localAdapter
              .findOne(key)
              ?._initialize(_adapters, key: key))
          .filterNulls;
    }
    return _uninitializedModels;
  }

  /// Returns keys as [Set] in relationship if initialized, otherwise an empty set
  @protected
  @visibleForTesting
  Set<String> get keys {
    if (isInitialized) {
      return _graph?._getEdge(_ownerKey, metadata: _name)?.toSet() ?? {};
    }
    return _uninitializedKeys;
  }

  Set<String> get ids {
    return keys.map(_graph?.getId).filterNulls.toSet();
  }

  E _ensureModelIsInitialized(E model) {
    if (!model._isInitialized && isInitialized) {
      model._initialize(_adapters, save: true);
    }
    return model;
  }

  StateNotifier<List<DataGraphEvent>> get _graphEvents {
    assert(_adapter != null);
    return _adapter.throttledGraph.map((events) {
      final appliesToRelationship = (DataGraphEvent event) {
        return event.type.isEdge &&
            event.metadata == _name &&
            event.keys.containsFirst(_ownerKey);
      };
      return events.where(appliesToRelationship).toImmutableList();
    });
  }

  StateNotifier<N> watch();

  /// This is used to make `json_serializable`'s `explicitToJson` transparent.
  ///
  /// For internal use. Does not return valid JSON.
  dynamic toJson() => this;

  @override
  String toString();

  // equality

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      other is Relationship && toSet() == other.toSet();

  @override
  int get hashCode => runtimeType.hashCode ^ toSet().hashCode;
}

// annotation

class DataRelationship {
  final String inverse;
  const DataRelationship({@required this.inverse});
}
