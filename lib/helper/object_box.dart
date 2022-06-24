import 'package:no_sql_database/user.dart';
import 'package:no_sql_database/objectbox.g.dart';

class ObjectBox {
  late final Store _store;
  late final Box<User> _userBox;

  ObjectBox._init(this._store) {
    _userBox = Box<User>(_store);
  }

  static Future<ObjectBox> init() async {
    final store = await openStore();

    if (Sync.isAvailable()) {
      final syncClient = Sync.client(
        store,
        'ws://0.0.0.0:9999',
        SyncCredentials.none(),
      );
      syncClient.start();
    }

    return ObjectBox._init(store);
  }

  User? getUser(int id) => _userBox.get(id);

  Stream<List<User>> getUsers() => _userBox
      .query()
      .watch(triggerImmediately: true)
      .map((query) => query.find());

  int insertUser(User user) => _userBox.put(user);

  bool deleteUser(int id) => _userBox.remove(id);
}
