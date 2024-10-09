import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';

class BtTest extends StatefulWidget {
  const BtTest({super.key});

  @override
  State<BtTest> createState() => _BtTestState();
}

class _BtTestState extends State<BtTest> {
  BluetoothConnection? _connection;
  String _receivedData = 'No data received';
  String _buffer = ''; // 데이터를 임시로 저장할 버퍼
  final String deviceAddress = '94:B9:7E:CE:03:FA'; // YELLCA 지팡이의 MAC 주소로 변경해야 함

  @override
  void initState() {
    super.initState();
    _connectToBluetooth();
  }

  Future<void> _connectToBluetooth() async {
    try {
      // YELLCA 장치의 Bluetooth 주소로 바로 연결
      _connection = await BluetoothConnection.toAddress(deviceAddress);
      print('Connected to YELLCA device');

      // 데이터 수신 대기
      _connection!.input!.listen((data) {
        _handleReceivedData(data);
      }).onDone(() {
        print('Disconnected from device');
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _handleReceivedData(Uint8List data) {
    // 데이터를 2바이트씩 String으로 변환하여 버퍼에 추가
    _buffer += String.fromCharCodes(data);

    if (_buffer.length >= 8) {
      // 태그 데이터가 8자리(4바이트)가 쌓이면 화면에 표시
      setState(() {
        _receivedData = _buffer;
      });
      _buffer = ''; // 버퍼 초기화
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bluetooth RFID Tag Reader')),
      body: Center(
        child: Text(
          'Received Data: $_receivedData',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _connection?.dispose();
    super.dispose();
  }
}
