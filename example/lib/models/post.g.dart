// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
    id: json['id'] as int,
    title: json['title'] as String,
    body: json['body'] as String,
    comments: json['comments'] == null
        ? null
        : HasMany.fromJson(json['comments'] as Map<String, dynamic>),
    user: json['user'] == null
        ? null
        : BelongsTo.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'comments': instance.comments,
      'user': instance.user,
    };

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, non_constant_identifier_names

mixin $PostLocalAdapter on LocalAdapter<Post> {
  @override
  Map<String, Map<String, Object>> relationshipsFor([Post model]) => {
        'comments': {
          'inverse': 'post',
          'type': 'comments',
          'kind': 'HasMany',
          'instance': model?.comments
        },
        'user': {'type': 'users', 'kind': 'BelongsTo', 'instance': model?.user}
      };

  @override
  Post deserialize(map) {
    for (final key in relationshipsFor().keys) {
      map[key] = {
        '_': [map[key], !map.containsKey(key)],
      };
    }
    return _$PostFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model) => _$PostToJson(model);
}

// ignore: must_be_immutable
class $PostHiveLocalAdapter = HiveLocalAdapter<Post> with $PostLocalAdapter;

class $PostRemoteAdapter = RemoteAdapter<Post> with JSONServerAdapter<Post>;

//

final postLocalAdapterProvider = Provider<LocalAdapter<Post>>((ref) =>
    $PostHiveLocalAdapter(
        ref.read(hiveLocalStorageProvider), ref.read(graphProvider)));

final postRemoteAdapterProvider = Provider<RemoteAdapter<Post>>(
    (ref) => $PostRemoteAdapter(ref.read(postLocalAdapterProvider)));

final postRepositoryProvider =
    Provider<Repository<Post>>((ref) => Repository<Post>(ref));

final _watchPost = StateNotifierProvider.autoDispose
    .family<DataStateNotifier<Post>, WatchArgs<Post>>((ref, args) {
  return ref.watch(postRepositoryProvider).watchOne(args.id,
      remote: args.remote,
      params: args.params,
      headers: args.headers,
      alsoWatch: args.alsoWatch);
});

AutoDisposeStateNotifierStateProvider<DataState<Post>> watchPost(dynamic id,
    {bool remote = true,
    Map<String, dynamic> params = const {},
    Map<String, String> headers = const {},
    AlsoWatch<Post> alsoWatch}) {
  return _watchPost(WatchArgs(
          id: id,
          remote: remote,
          params: params,
          headers: headers,
          alsoWatch: alsoWatch))
      .state;
}

final _watchPosts = StateNotifierProvider.autoDispose
    .family<DataStateNotifier<List<Post>>, WatchArgs<Post>>((ref, args) {
  return ref.watch(postRepositoryProvider).watchAll(
      remote: args.remote, params: args.params, headers: args.headers);
});

AutoDisposeStateNotifierStateProvider<DataState<List<Post>>> watchPosts(
    {bool remote, Map<String, dynamic> params, Map<String, String> headers}) {
  return _watchPosts(
          WatchArgs(remote: remote, params: params, headers: headers))
      .state;
}

extension PostX on Post {
  /// Initializes "fresh" models (i.e. manually instantiated) to use
  /// [save], [delete] and so on.
  ///
  /// Pass:
  ///  - A `BuildContext` if using Flutter with Riverpod or Provider
  ///  - Nothing if using Flutter with GetIt
  ///  - A Riverpod `ProviderContainer` if using pure Dart
  ///  - Its own [Repository<Post>]
  Post init([container]) {
    final repository = container is Repository<Post>
        ? container
        : internalLocatorFn(postRepositoryProvider, container);
    return repository.internalAdapter.initializeModel(this, save: true) as Post;
  }
}
