import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movies_app/homepage.dart';
import 'db/model/movies.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(MovieAdapter());
  await Hive.openBox<Movie>('movies');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String title = 'MyFlix';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          brightness: Brightness.light,
          fontFamily: 'Bebas Neue',
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'Bebas Neue',
        ),
        themeMode: ThemeMode.dark,
        home: HomePage(),
      );
}
