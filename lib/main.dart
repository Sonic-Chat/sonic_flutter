import 'package:flutter/material.dart';
import 'package:sonic_flutter/app.dart';
import 'package:sonic_flutter/providers.dart';
import 'package:sonic_flutter/utils/startup.util.dart';

Future<void> main() async {
  await startup();

  runApp(const Root());
}

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Providers(
      child: App(),
      apiUrl: "http://10.0.2.2:5000/v1/api",
      rawApiUrl: "10.0.2.2:5000",
    );
  }
}
