import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:logger/logger.dart';
import 'package:system_shortcuts/system_shortcuts.dart';

import '../utils/constants.dart';

enum Command {
  camera,
  find,
  none,
}

class CommandModel extends ChangeNotifier {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  BluetoothDevice _device;
  BluetoothService _service;
  BluetoothCharacteristic _characteristic;
  Command _command = Command.none;
  bool _cameraOn = false, _findOn = false, _found = false;
  final Logger _logger = Logger();

  // ignore: avoid_void_async
  Future<void> _checkConnection() async {
    bool ble = await SystemShortcuts.checkBluetooth;
    if (!ble) {
      SystemShortcuts.bluetooth();
    }
    ble = await SystemShortcuts.checkBluetooth;
    _logger.i('Bluetooth on!');
    _found = false;
    notifyListeners();
  }

  Future<void> isConnected() async {
    _flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) async {
      for (BluetoothDevice device in devices) {
        if (device.id.toString() == kDeviceAddress) {
          try {
            await device.connect();
          } catch (e) {
            if (e.code != 'already_connected') {
              rethrow;
            }
          } finally {
            _device = device;
            _logger.i('found: ${device.id}');
            _findCharacteristics();
            _found = true;
            notifyListeners();
          }
        }
      }
    });
  }

  // ignore: sort_constructors_first
  CommandModel() {
    _checkConnection().then((void _) {
      isConnected();
    });
  }

  Future<void> _findCharacteristics() async {
    _logger.i(_device.name);
    final List<BluetoothService> services = await _device.discoverServices();
    _service = services[3];
    _logger.i(_service.uuid.toString());
    _characteristic = _service.characteristics.firstWhere(
        (BluetoothCharacteristic element) => element.properties.notify);
    _logger.i('found everything!');
    _listen();
  }

  void _listen() {
    _characteristic.value.listen((List<int> value) {
      if (value.length == kCameraCommand.length) {
        _cameraOn = !_cameraOn;
        if (_cameraOn)
          _command = Command.camera;
        else
          _command = Command.none;
      } else if (value.length == kFindCommand.length) {
        _findOn = !_findOn;
        if (_findOn)
          _command = Command.find;
        else
          _command = Command.none;
      } else
        _command = Command.none;
      _logger.d(_command);
      notifyListeners();
    });
    _characteristic.setNotifyValue(true);
  }

  void setCommandToNone() {
    _command = Command.none;
    _findOn = false;
    _cameraOn = false;
    notifyListeners();
  }

  Command get command => _command;

  bool get cameraState => _cameraOn;
  bool get findState => _findOn;
  bool get found => _found;
}
