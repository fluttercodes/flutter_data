part of flutter_data;

class BelongsTo<E extends DataSupportMixin<E>> extends Relationship<E, E> {
  BelongsTo([E model, DataManager manager, bool _save])
      : super({model}, manager, _save);

  BelongsTo._(String key, DataManager manager, bool _wasOmitted)
      : super._({key}, manager, _wasOmitted);

  factory BelongsTo.fromJson(Map<String, dynamic> map) {
    final key = map['_'][0] as String;
    final manager = map['_'][2] as DataManager;
    if (key == null) {
      final wasOmitted = map['_'][1] as bool;
      return BelongsTo._(null, manager, wasOmitted);
    }
    if (key.startsWith('${Repository.getType<E>()}#')) {
      // we got key
      return BelongsTo._(key, manager, false);
    }
    // we got id (key is actually the ID)
    return BelongsTo._(manager.getId(key), manager, false);
  }

  //

  E get value {
    return super.isNotEmpty ? super.first : null;
  }

  set value(E value) {
    super.add(value);
  }

  String get key => super.keys.isNotEmpty ? super.keys.first : null;

  //

  @override
  DataStateNotifier<E> watch() {
    // lazily initialize notifier
    return _notifier ??= _initNotifierOne();
  }

  //

  DataStateNotifier<E> _initNotifierOne() {
    _notifier = DataStateNotifier<E>(DataState());
    // _repository.box
    //     .watch(key: key)
    //     .buffer(Stream.periodic(_repository.oneFrameDuration))
    //     .forEach((events) {
    //   if (events.isNotEmpty && events.last.deleted) {
    //     key = null;
    //   }
    //   _notifier.state = DataState(model: value);
    // });
    return _notifier;
  }

  //

  @override
  dynamic toJson() => key;

  @override
  String toString() => 'BelongsTo<$E>($key)';
}
