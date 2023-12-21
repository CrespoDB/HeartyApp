import 'package:flutter/material.dart';
import 'package:hearty/services/bluetooth_manager.dart';
import 'package:hearty/screens/widgets/ECGGraph.dart';

class ConnectScreen extends StatefulWidget {
  @override
  _ConnectScreenState createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  final BluetoothManager _bluetoothManager = BluetoothManager();
  final GlobalKey<ECGGraphState> _ecgGraphKey = GlobalKey();

  void initState() {
    super.initState();
    _bluetoothManager.initialize();

    // Setup the onSaveGraph callback
    _bluetoothManager.onSaveGraph = () async {
      await _ecgGraphKey.currentState?.saveGraphToCache();
      _bluetoothManager.clearGraph(); // Clear the graph after saving
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () async {
              String? errorMessage = await _bluetoothManager.startScanning();
              if (errorMessage != null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Fejl'),
                      content: Text(errorMessage),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: const Text('Forbind til EKG'),
          ),
          ElevatedButton(
            onPressed: () {
              _bluetoothManager.startDataSimulation();
            },
            child: const Text('Forbind til EKG'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ECGGraph(
                key: _ecgGraphKey,
                dataStream:
                    _bluetoothManager.simulatedDataStreamController.stream,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
