// import 'package:flutter/material.dart';

// import 'dart:async';
// import 'dart:io' show Platform;

// import 'package:flutter/services.dart';

// class TestApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Material App',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Material App Bar'),
//         ),
//         body: Center(child: NfcScan()),
//       ),
//     );
//   }
// }

// class NfcScan extends StatefulWidget {
//   NfcScan({Key? key}) : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _NfcScanState createState() => _NfcScanState();
// }

// class _NfcScanState extends State<NfcScan> {
//   TextEditingController writerController = TextEditingController();

//   @override
//   initState() {
//     super.initState();
//     FlutterNfcReader.onTagDiscovered().listen((onData) {
//       print(onData.id);
//       print(onData.content);
//     });
//   }

//   @override
//   void dispose() {
//     // Clean up the controller when the widget is removed from the
//     // widget tree.
//     writerController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         TextField(
//           controller: writerController,
//         ),
//         ElevatedButton(
//           onPressed: () {
//             FlutterNfcReader.read(instruction: "It's reading");
//           },
//           child: Text("Read"),
//         ),
//       ],
//     );
//   }
// }

// enum NFCStatus {
//   none,
//   reading,
//   read,
//   stopped,
//   error,
// }

// class NfcData {
//   final String? id;
//   final String? content;
//   final String? error;
//   final String? statusMapper;

//   NFCStatus status = NFCStatus.none;

//   NfcData({
//     this.id,
//     this.content,
//     this.error,
//     this.statusMapper,
//   });

//   factory NfcData.fromMap(Map data) {
//     NfcData result = NfcData(
//       id: data['nfcId'],
//       content: data['nfcContent'],
//       error: data['nfcError'],
//       statusMapper: data['nfcStatus'],
//     );
//     switch (result.statusMapper) {
//       case 'none':
//         result.status = NFCStatus.none;
//         break;
//       case 'reading':
//         result.status = NFCStatus.reading;
//         break;
//       case 'stopped':
//         result.status = NFCStatus.stopped;
//         break;
//       case 'error':
//         result.status = NFCStatus.error;
//         break;
//       default:
//         result.status = NFCStatus.none;
//     }
//     return result;
//   }
// }

// class FlutterNfcReader {
//   static const MethodChannel _channel = MethodChannel('flutter_nfc_reader');
//   static const stream =
//       EventChannel('it.matteocrippa.flutternfcreader.flutter_nfc_reader');

//   static Future<NfcData> enableReaderMode() async {
//     final Map data = await _channel.invokeMethod('NfcEnableReaderMode');
//     final NfcData result = NfcData.fromMap(data);

//     return result;
//   }

//   static Future<NfcData> disableReaderMode() async {
//     final Map data = await _channel.invokeMethod('NfcDisableReaderMode');
//     final NfcData result = NfcData.fromMap(data);

//     return result;
//   }

//   static Future<void> stop() => _channel.invokeMethod('NfcStop');

//   static Future<NfcData> read({String? instruction}) async {
//     final Map data = await _callRead(instruction: instruction);
//     final NfcData result = NfcData.fromMap(data);
//     return result;
//   }

//   static Stream<NfcData> onTagDiscovered({String? instruction}) {
//     if (Platform.isIOS) {
//       _callRead(instruction: instruction);
//     }
//     return stream.receiveBroadcastStream().map((rawNfcData) {
//       return NfcData.fromMap(rawNfcData);
//     });
//   }

//   static Future<Map> _callRead({instruction}) async {
//     return await _channel
//         .invokeMethod('NfcRead', <String, dynamic>{"instruction": instruction});
//   }

//   static Future<NfcData> write(String path, String label) async {
//     final Map data = await _channel.invokeMethod(
//         'NfcWrite', <String, dynamic>{'label': label, 'path': path});

//     final NfcData result = NfcData.fromMap(data);

//     return result;
//   }

//   static Future<NFCAvailability> checkNFCAvailability() async {
//     var availability =
//         "NFCAvailability.${await _channel.invokeMethod<String>("NfcAvailable")}";
//     return NFCAvailability.values
//         .firstWhere((item) => item.toString() == availability);
//   }
// }

// // ignore: constant_identifier_names
// enum NFCAvailability { available, disabled, not_supported }
