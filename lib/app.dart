import 'package:flutter/material.dart';
import 'package:sonic_flutter/pages/home.page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sonic Chat Dev',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        Home.route: (BuildContext context) => const Home(),
      },
      initialRoute: Home.route,
    );
  }
}

