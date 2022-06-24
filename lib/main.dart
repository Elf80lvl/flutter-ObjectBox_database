import 'package:flutter/material.dart';
import 'package:faker/faker.dart';

import 'helper/object_box.dart';
import 'user.dart';

late ObjectBox objectBox;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ObjectBox database',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List<User> users = [
  //   User(name: 'User 1', email: 'user1@gmail.com'),
  //   User(name: 'User 2', email: 'user2@gmail.com'),
  //   User(name: 'User 3', email: 'user3@gmail.com'),
  // ];

  late Stream<List<User>> streamUsers;

  @override
  void initState() {
    super.initState();
    streamUsers = objectBox.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter no sql database'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<User>>(
        stream: streamUsers,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final users = snapshot.data!;
            return ListView.builder(
                itemCount: users.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        objectBox.deleteUser(user.id);
                      },
                    ),
                  );
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final user = User(
            name: Faker().person.firstName(),
            email: Faker().internet.email(),
          );

          print(Faker().person.firstName());

          objectBox.insertUser(user);

          //setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
