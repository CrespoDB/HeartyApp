import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

enum BluetoothConnectionState {
  disconnected,
  connecting,
  connected,
}

class BluetoothManager {
  BluetoothDevice? targetDevice;
  BluetoothCharacteristic? targetCharacteristic;
  StreamController<List<int>> simulatedDataStreamController =
      StreamController.broadcast();
  Stream<BluetoothConnectionState> get connectionStateStream =>
      _connectionStateController.stream;
  final _connectionStateController =
      StreamController<BluetoothConnectionState>();
  Timer? _simulationTimer;
  Timer? _stopTimer;
  VoidCallback? onSaveGraph;
  void initialize() {
    FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.off) {
        // TODO: Prompt the user to turn on Bluetooth
      } else if (state == BluetoothAdapterState.on) {
        // Bluetooth is enabled, you can start scanning
      }
    });
  }

// We start scanning for BLE servers with specific names
  Future<String?> startScanning() async {
    try {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

      FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult r in results) {
          if (r.device.platformName == 'efepi') // name of rasp
          {
            targetDevice = r.device;
            connectToDevice();
            FlutterBluePlus.stopScan();
            break;
          }
        }
      });
      return null; // No error
    } on PlatformException catch (e) {
      if (e.code == 'startScan' && e.message == 'bluetooth must be turned on') {
        return 'Bluetooth must be turned on to start scanning.';
      }
      return 'An unexpected error occurred.';
    }
  }

  void connectToDevice() async {
    await targetDevice?.connect();
    discoverServices();
  }

  void discoverServices() async {
    if (targetDevice == null) return;

    List<BluetoothService> services = await targetDevice!.discoverServices();
    for (BluetoothService service in services) {
      if (service.uuid.toString() == '12345678-1234-5678-1234-56789abcdef1') {
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          if (c.uuid.toString() == '12345678-1234-5678-1234-56789abcdef2') {
            targetCharacteristic = c;
            await c.setNotifyValue(true);
            c.lastValueStream.listen((value) {
              // Handle incoming data here
              print("Received data: $value");
            });
            break;
          }
        }
      }
    }

    // Start simulating data reception
    startDataSimulation();
  }

  int rhythmType =
      0; // 0 for NSR, 1 for Bradycardia, 2 for Tachycardia, 3 for AFib
  void startDataSimulation() {
    _simulationTimer?.cancel(); // Cancel any existing simulation timer
    _stopTimer?.cancel(); // Cancel any existing stop timer
    int count = 0;

    _simulationTimer = Timer.periodic(Duration(milliseconds: 40), (Timer t) {
      count++;
      List<int> mockData;

      switch (rhythmType) {
        case 1: // Bradycardia
          mockData = _simulateBradycardia(count);
          break;
        case 2: // Tachycardia
          mockData = _simulateTachycardia(count);
          break;
        case 3: // AFib
          mockData = _simulateAFib(count);
          break;
        default: // NSR
          mockData = _simulateNormalSinusRhythm(count);
          break;
      }

      simulatedDataStreamController.add(mockData);
    });

    // Timer to save the graph after X seconds
    _stopTimer = Timer(Duration(seconds: 10), () {
      onSaveGraph?.call();
    });
  }

  List<int> _simulateNormalSinusRhythm(int count) {
    return _basicWaveform(count, 60); // Normal rate
  }

  List<int> _simulateBradycardia(int count) {
    return _basicWaveform(count, 100); // Slower rate
  }

  List<int> _simulateTachycardia(int count) {
    return _basicWaveform(count, 30); // Faster rate
  }

  List<int> _simulateAFib(int count) {
    // Irregular rhythm
    if (count % 20 == 0) {
      return [Random().nextInt(400) - 200]; // Random amplitude for AFib
    }
    return [0]; // Baseline
  }

  List<int> _basicWaveform(int count, int cycleLength) {
    int simulatedValue;
    if (count % cycleLength == cycleLength ~/ 6) {
      simulatedValue = 200; // Simulate P wave
    } else if (count % cycleLength == cycleLength ~/ 3) {
      simulatedValue = -500; // Start of QRS
    } else if (count % cycleLength == cycleLength ~/ 3 + 5) {
      simulatedValue = 1500; // Peak of QRS
    } else if (count % cycleLength == cycleLength ~/ 3 + 10) {
      simulatedValue = -500; // End of QRS
    } else if (count % cycleLength == cycleLength ~/ 2) {
      simulatedValue = 300; // Simulate T wave
    } else {
      simulatedValue = 0; // Baseline
    }
    return [simulatedValue];
  }

  void stopSimulationTimer() {
    _simulationTimer?.cancel();
  }

  void clearGraph() {
    simulatedDataStreamController.add([]); // Clear the graph
  }
}
