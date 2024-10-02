import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:http/http.dart' as http;

class BTTest extends StatefulWidget {
  const BTTest({super.key});

  @override
  State<BTTest> createState() => _BTTestState();
}

class _BTTestState extends State<BTTest> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devicesList = [];
  BluetoothDevice? connectedDevice;
  List<BluetoothService>? services;
  BluetoothCharacteristic? characteristic;

  @override
  void initState() {
    super.initState();
    // 블루투스 장치 검색 시작
    flutterBlue.scan().listen((scanResult) {
      setState(() {
        devicesList.add(scanResult.device);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    flutterBlue.stopScan();
    // 장치가 연결되어 있는 경우 연결 해제
    if (connectedDevice != null) {
      disconnectFromDevice(connectedDevice!);
    }
  }

  void connectToDevice(BluetoothDevice device) async {
    await device.connect();
    setState(() {
      connectedDevice = device;
    });

    // 서비스 탐색
    services = await device.discoverServices();
    for (var service in services!) {
      for (var char in service.characteristics) {
        // 원하는 특성 UUID를 찾아서 설정 (예: "your_characteristic_uuid")
        if (char.properties.notify) {
          characteristic = char;
          await characteristic!.setNotifyValue(true);
          characteristic!.value.listen((value) {
            String rfidData = String.fromCharCodes(value);
            _sendRFIDDataToServer(rfidData);
          });
        }
      }
    }

    // 장치가 연결되었음을 표시하는 추가 로직을 작성할 수 있습니다.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Connected to ${device.name}')),
    );
  }

  void disconnectFromDevice(BluetoothDevice device) async {
    await device.disconnect();
    setState(() {
      connectedDevice = null;
      services = null;
      characteristic = null; // 연결 해제 시 특성도 초기화
    });
    // 장치 연결 해제 시 표시하는 추가 로직을 작성할 수 있습니다.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Disconnected from ${device.name}')),
    );
  }

  Future<void> _sendRFIDDataToServer(String rfidData) async {
    final String apiUrl = 'http://your-server-url.com/api/rfid'; // 서버 URL 수정
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'rfid': rfidData}),
      );

      if (response.statusCode == 200) {
        print('RFID 데이터 전송 성공: ${response.body}');
      } else {
        print('RFID 데이터 전송 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
      ),
      body: Column(
        children: [
          Text('Connected Device: ${connectedDevice != null ? connectedDevice!.name : 'None'}'),
          Expanded(
            child: ListView.builder(
              itemCount: devicesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(devicesList[index].name),
                  onTap: () {
                    if (connectedDevice == devicesList[index]) {
                      // 이미 연결된 장치라면 연결 해제
                      disconnectFromDevice(devicesList[index]);
                    } else {
                      // 새 장치에 연결
                      connectToDevice(devicesList[index]);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
