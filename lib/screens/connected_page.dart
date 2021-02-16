import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/bluetooth_provider.dart';

class ConnectedScreen extends StatefulWidget {
  @override
  _ConnectedScreenState createState() => _ConnectedScreenState();
}

class _ConnectedScreenState extends State<ConnectedScreen> {
  CommandModel command;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    command = Provider.of<CommandModel>(context);
  }

  @override
  void dispose() {
    command.setCommandToNone();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    command.addListener(() {
      if (command.cameraState == true) {
        // do something
      } else if (command.cameraState == false) {
        // do something
      }
    });

    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  'Connected: ${command.found ? 'connected' : 'No, please connect'}'),
              const SizedBox(
                height: 20,
              ),
              Text('Camera: ${command.cameraState}'),
              const SizedBox(
                height: 20,
              ),
              Text('Find: ${command.findState}'),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
