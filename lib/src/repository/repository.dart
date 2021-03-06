part of flutter_data;

/// Thin wrapper on the [RemoteAdapter] API
class Repository<T extends DataModel<T>> with _Lifecycle<Repository<T>> {
  final ProviderReference _ref;
  Repository(this._ref);

  String get type => DataHelpers.getType<T>();

  final _adapters = <String, RemoteAdapter>{};

  RemoteAdapter<T> get _adapter => _adapters[type] as RemoteAdapter<T>;

  /// ONLY FOR FLUTTER DATA INTERNAL USE
  ///
  /// It must remain non-private for the model extension to use.
  @protected
  @visibleForTesting
  RemoteAdapter<T> get internalAdapter => _adapter;

  /// Initializes this [Repository]. Nothing will work without this.
  /// In standard scenarios this initialization is done by the framework.
  @override
  @mustCallSuper
  FutureOr<Repository<T>> initialize(
      {bool remote, bool verbose, Map<String, RemoteAdapter> adapters}) async {
    if (isInitialized) return this;
    _adapters.addAll(adapters);
    await _adapter.initialize(
        remote: remote, verbose: verbose, adapters: adapters, ref: _ref);
    await super.initialize();
    return this;
  }

  /// Disposes this [Repository] and everything that depends on it.
  @override
  @mustCallSuper
  void dispose() {
    super.dispose();
    _adapter?.dispose();
  }

  // public API

  /// Returns all models of type [T].
  ///
  /// If [_RemoteAdapter.shouldLoadRemoteAll] (function of [remote]) is `true`,
  /// it will initiate an HTTP call.
  /// Otherwise returns all models of type [T] in local storage.
  ///
  /// Arguments [params] and [headers] will be merged with
  /// [_RemoteAdapter.defaultParams] and [_RemoteAdapter.defaultHeaders], respectively.
  ///
  /// See also: [_RemoteAdapter.urlForFindAll], [_RemoteAdapter.methodForFindAll].
  Future<List<T>> findAll(
      {bool remote, Map<String, dynamic> params, Map<String, String> headers}) {
    return _adapter.findAll(
        remote: remote, params: params, headers: headers, init: true);
  }

  /// Returns model of type [T] by [id].
  ///
  /// If [_RemoteAdapter.shouldLoadRemoteOne] (function of [remote]) is `true`,
  /// it will initiate an HTTP call.
  /// Otherwise returns model of type [T] and [id] in local storage.
  ///
  /// Arguments [params] and [headers] will be merged with
  /// [_RemoteAdapter.defaultParams] and [_RemoteAdapter.defaultHeaders], respectively.
  ///
  /// See also: [_RemoteAdapter.urlForFindOne], [_RemoteAdapter.methodForFindOne].
  Future<T> findOne(final dynamic id,
      {bool remote, Map<String, dynamic> params, Map<String, String> headers}) {
    return _adapter.findOne(id,
        remote: remote, params: params, headers: headers, init: true);
  }

  /// Saves [model] of type [T].
  ///
  /// If [remote] is `true`, it will initiate an HTTP call.
  ///
  /// Always persists to local storage.
  ///
  /// Arguments [params] and [headers] will be merged with
  /// [_RemoteAdapter.defaultParams] and [_RemoteAdapter.defaultHeaders], respectively.
  ///
  /// See also: [_RemoteAdapter.urlForSave], [_RemoteAdapter.methodForSave].
  Future<T> save(T model,
      {bool remote, Map<String, dynamic> params, Map<String, String> headers}) {
    return _adapter.save(model,
        remote: remote, params: params, headers: headers, init: true);
  }

  /// Deletes [model] of type [T].
  ///
  /// If [remote] is `true`, it will initiate an HTTP call.
  ///
  /// Always deletes from local storage.
  ///
  /// Arguments [params] and [headers] will be merged with
  /// [_RemoteAdapter.defaultParams] and [_RemoteAdapter.defaultHeaders], respectively.
  ///
  /// See also: [_RemoteAdapter.urlForDelete], [_RemoteAdapter.methodForDelete].
  Future<void> delete(dynamic model,
      {bool remote, Map<String, dynamic> params, Map<String, String> headers}) {
    return _adapter.delete(model,
        remote: remote, params: params, headers: headers);
  }

  /// Deletes all models of type [T]. This ONLY affects local storage.
  Future<void> clear() => _adapter.clear();

  /// Deletes all models of all types. This ONLY affects local storage.
  Future<void> clearAll() => _adapter.clearAll();

  /// Watches changes on all models of type [T] in local storage.
  ///
  /// When called, will in turn call [findAll] with [remote], [params], [headers].
  DataStateNotifier<List<T>> watchAll(
      {bool remote, Map<String, dynamic> params, Map<String, String> headers}) {
    return _adapter.watchAll(remote: remote, params: params, headers: headers);
  }

  /// Watches changes on model of type [T] by [id] in local storage.
  ///
  /// Optionally [alsoWatch]es selected relationships of this model.
  ///
  /// Example: Watch `Book` with `id=1` and its `Author` relationship.
  ///
  /// ```
  /// bookRepository.watchOne('1', alsoWatch: (book) => [book.author]);
  /// ```
  ///
  /// When called, will in turn call [findAll] with [remote], [params], [headers].
  DataStateNotifier<T> watchOne(dynamic id,
      {bool remote,
      Map<String, dynamic> params,
      Map<String, String> headers,
      AlsoWatch<T> alsoWatch}) {
    return _adapter.watchOne(id,
        remote: remote, params: params, headers: headers, alsoWatch: alsoWatch);
  }
}

/// Annotation on a [DataModel] model to request a [Repository] be generated for it.
///
/// Takes a list of [adapters] to be mixed into this [Repository].
/// Public methods of these [adapters] mixins will be made available in the repository
/// via extensions.
///
/// A classic example is:
///
/// ```
/// @JsonSerializable()
/// @DataRepository([JSONAPIAdapter])
/// class Todo with DataModel<Todo> {
///   @override
///   final int id;
///   final String title;
///   final bool completed;
///
///   Todo({this.id, this.title, this.completed = false});
/// }
///```
class DataRepository {
  final List<Type> adapters;
  const DataRepository(this.adapters);
}
