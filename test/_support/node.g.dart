// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Node _$_$_NodeFromJson(Map<String, dynamic> json) {
  return _$_Node(
    id: json['id'] as int,
    name: json['name'] as String,
    parent: json['parent'] == null
        ? null
        : BelongsTo.fromJson(json['parent'] as Map<String, dynamic>),
    children: json['children'] == null
        ? null
        : HasMany.fromJson(json['children'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_$_NodeToJson(_$_Node instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'parent': instance.parent,
      'children': instance.children,
    };

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, non_constant_identifier_names

mixin $NodeLocalAdapter on LocalAdapter<Node> {
  @override
  Map<String, Map<String, Object>> relationshipsFor([Node model]) => {
        'parent': {
          'inverse': 'children',
          'type': 'nodes',
          'kind': 'BelongsTo',
          'instance': model?.parent
        },
        'children': {
          'inverse': 'parent',
          'type': 'nodes',
          'kind': 'HasMany',
          'instance': model?.children
        }
      };

  @override
  Node deserialize(map) {
    for (final key in relationshipsFor().keys) {
      map[key] = {
        '_': [map[key], !map.containsKey(key)],
      };
    }
    return Node.fromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model) => model.toJson();
}

// ignore: must_be_immutable
class $NodeHiveLocalAdapter = HiveLocalAdapter<Node> with $NodeLocalAdapter;

class $NodeRemoteAdapter = RemoteAdapter<Node> with NothingMixin;

//

final nodeLocalAdapterProvider = Provider<LocalAdapter<Node>>((ref) =>
    $NodeHiveLocalAdapter(
        ref.read(hiveLocalStorageProvider), ref.read(graphProvider)));

final nodeRemoteAdapterProvider = Provider<RemoteAdapter<Node>>(
    (ref) => $NodeRemoteAdapter(ref.read(nodeLocalAdapterProvider)));

final nodeRepositoryProvider =
    Provider<Repository<Node>>((ref) => Repository<Node>(ref));

final _watchNode = StateNotifierProvider.autoDispose
    .family<DataStateNotifier<Node>, WatchArgs<Node>>((ref, args) {
  return ref.watch(nodeRepositoryProvider).watchOne(args.id,
      remote: args.remote,
      params: args.params,
      headers: args.headers,
      alsoWatch: args.alsoWatch);
});

AutoDisposeStateNotifierStateProvider<DataState<Node>> watchNode(dynamic id,
    {bool remote = true,
    Map<String, dynamic> params = const {},
    Map<String, String> headers = const {},
    AlsoWatch<Node> alsoWatch}) {
  return _watchNode(WatchArgs(
          id: id,
          remote: remote,
          params: params,
          headers: headers,
          alsoWatch: alsoWatch))
      .state;
}

final _watchNodes = StateNotifierProvider.autoDispose
    .family<DataStateNotifier<List<Node>>, WatchArgs<Node>>((ref, args) {
  return ref.watch(nodeRepositoryProvider).watchAll(
      remote: args.remote, params: args.params, headers: args.headers);
});

AutoDisposeStateNotifierStateProvider<DataState<List<Node>>> watchNodes(
    {bool remote, Map<String, dynamic> params, Map<String, String> headers}) {
  return _watchNodes(
          WatchArgs(remote: remote, params: params, headers: headers))
      .state;
}

extension NodeX on Node {
  /// Initializes "fresh" models (i.e. manually instantiated) to use
  /// [save], [delete] and so on.
  ///
  /// Pass:
  ///  - A `BuildContext` if using Flutter with Riverpod or Provider
  ///  - Nothing if using Flutter with GetIt
  ///  - A Riverpod `ProviderContainer` if using pure Dart
  ///  - Its own [Repository<Node>]
  Node init(container) {
    final repository = container is Repository<Node>
        ? container
        : internalLocatorFn(nodeRepositoryProvider, container);
    return repository.internalAdapter.initializeModel(this, save: true) as Node;
  }
}
