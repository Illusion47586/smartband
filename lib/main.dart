import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'models/bluetooth_provider.dart';
import 'screens/connected_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // not necessary
  Permission.locationAlways.request();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiProvider(
        // ignore: always_specify_types
        providers: [
          ChangeNotifierProvider<CommandModel>(
            create: (BuildContext context) => CommandModel(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: ConnectedScreen(),
        ),
      );
}
