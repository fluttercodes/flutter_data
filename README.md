<p align="center" style="margin-bottom: 0px;">
  <img src="https://avatars2.githubusercontent.com/u/61839689?s=200&v=4" width="85px">
</p>

<h1 align="center" style="margin-top: 0px; font-size: 4em;">Flutter Data</h1>

[![tests](https://img.shields.io/github/workflow/status/flutterdata/flutter_data/test/master?label=tests&labelColor=333940&logo=github)](https://github.com/flutterdata/flutter_data/actions) [![codecov](https://codecov.io/gh/flutterdata/flutter_data/branch/master/graph/badge.svg)](https://codecov.io/gh/flutterdata/flutter_data) [![pub.dev](https://img.shields.io/pub/v/flutter_data?label=pub.dev&labelColor=333940&logo=dart)](https://pub.dev/packages/flutter_data) [![license](https://img.shields.io/github/license/flutterdata/flutter_data?color=%23007A88&labelColor=333940&logo=mit)](https://github.com/flutterdata/flutter_data/blob/master/LICENSE)

Flutter Data is the seamless way to work with persistent data models in Flutter.

Inspired by [Ember Data](https://github.com/emberjs/data) and [ActiveRecord](https://guides.rubyonrails.org/active_record_basics.html).

## Features

 - **Auto-generated repositories (REST clients) for all models** 🚀
   - CRUD and custom actions on remote API
   - StateNotifier, Future and Stream APIs
 - **Built for offline-first** 🔌
   - uses Hive at its core for caching & local storage
   - included read/write retry offline adapter
 - **Effortless setup** ⏰
   - Automatically pre-configured for `provider`, `riverpod` and `get_it`
   - Convention over configuration powered by Dart mixins
 - **Exceptional relationship support** ⚡️
   - Automatically synchronized, traversable relationship graph
   - Reactive relationships
 - **Clean, intuitive API and minimal boilerplate** 💙
   - Truly configurable and composable
   - Scales very well (both up _and_ down)

#### Check out the [Documentation](https://flutterdata.dev) or the [Tutorial](https://flutterdata.dev/tutorial) 📚 where we build a CRUD app from the ground app in record time.

## Getting started

See the [quickstart guide](https://flutterdata.dev/quickstart) in the docs.

## 👩🏾‍💻 Usage

For a given `User` model annotated with `@DataRepository`...

```dart
@JsonSerializable()
@DataRepository([MyJSONServerAdapter])
class User with DataModel<User> {
  @override
  final int id;
  final String name;
  User({this.id, this.name});
}

mixin MyJSONServerAdapter on RemoteAdapter<User> {
  @override
  String get baseUrl => "https://my-json-server.typicode.com/flutterdata/demo/";
}
```

  - `id` can be of `int`, `String`, etc
  - `User.fromJson` and `toJson` are not required!

After a code-gen build, Flutter Data will generate a `Repository<User>`:

```dart
// obtain it via Provider
final repository = context.watch<Repository<User>>();

return DataStateBuilder<List<User>>(
  notifier: () => repository.watchAll();
  builder: (context, state, notifier, _) {
    if (state.isLoading) {
      return CircularProgressIndicator();
    }
    // state.model is a list of 10 user items
    return ListView.builder(
      itemBuilder: (context, i) {
        return UserTile(state.model[i]);
      },
    );
  }
}
```

`repository.watchAll()` will make an HTTP request (to `https://my-json-server.typicode.com/flutterdata/demo/users` in this case), parse the incoming JSON and listen for any further changes to the `User` collection – whether those are local or remote!

`state` is of type `DataState` which has loading/error/data substates. Moreover, `notifier.reload()` is available, useful for the classic "pull-to-refresh" scenario.

In addition to the reactivity, a `User` now gets extensions and automatic relationships, ActiveRecord-style:

```dart
final todo = await Todo(title: 'Finish docs').init(context).save();
// POST https://my-json-server.typicode.com/flutterdata/demo/todos/
print(todo.id); // 201

final user = await repository.findOne(1, params: { '_embed': 'todos' });
// GET https://my-json-server.typicode.com/flutterdata/demo/users/1?_embed=todos
print(user.todos.length); // 20

await user.todos.last.delete();
```

For an in-depth example check out the **[Tutorial](https://flutterdata.dev/tutorial)**.

Fully functional app built with Flutter Data? See the code for the finished **[Flutter Data TO-DOs Sample App](https://github.com/flutterdata/flutter_data_todos)**.

## Compatibility

Fully compatible with the tools we know and love:

|                   | &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp; |                                                               |
| ----------------- | ----------------------------------------------------- | ------------------------------------------------------------- |
| Flutter           | &nbsp; ✅                                              | It can also be used with pure Dart                            |
| json_serializable | &nbsp; ✅                                              | Not required! Other `fromJson`/`toJson` can be supplied       |
| JSON REST API     | &nbsp; ✅                                              | Great support                                                 |
| JSON:API          | &nbsp; ✅                                              | Great support                                                 |
| Firebase          | &nbsp; ✅                                              | Adapter coming soon 🎉 as well as Firebase Auth                |
| Provider          | &nbsp; ✅                                              | Not required! Configure in a few lines of code                |
| Riverpod          | &nbsp; ✅                                              | Not required! Configure in a few lines of code                |
| get_it            | &nbsp; ✅                                              | Not required! Configure in a few lines of code                |
| BLoC              | &nbsp; ✅                                              | Great support                                                 |
| Freezed           | &nbsp; ✅                                              | Good support                                                  |
| Flutter Web       | &nbsp; ✅                                              | Great support                                                 |
| Hive              | &nbsp; ✅                                              | Flutter Data uses Hive internally for local storage           |
| Chopper/Retrofit  |                                                       | Not required: Flutter Data **generates its own REST clients** |



## 📲 Apps using Flutter Data

![](https://mk0scoutforpetsedheb.kinstacdn.com/wp-content/uploads/scout.svg)

The new offline-first [Scout](https://scoutforpets.com) Flutter app is being developed in record time with Flutter Data.

## ➕ Questions and collaborating

Please use Github to ask questions, open issues and send PRs. Thanks!

You can also hit me up on Twitter [@thefrank06](https://twitter.com/thefrank06)

Tests can be run with: `pub run test`

## 📝 License

See [LICENSE](https://github.com/flutterdata/flutter_data/blob/master/LICENSE).