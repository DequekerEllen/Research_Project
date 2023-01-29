// ignore_for_file: unused_field, depend_on_referenced_packages, unused_import, library_private_types_in_public_api, avoid_unnecessary_containers

import 'dart:async';
import 'dart:io' show sleep;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:ndef/ndef.dart' as ndef;

import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MyNFCWidget extends StatefulWidget {
  @override
  _MyNFCWidgetState createState() => _MyNFCWidgetState();
}

class _MyNFCWidgetState extends State<MyNFCWidget>
    with SingleTickerProviderStateMixin {
  NFCAvailability _availability = NFCAvailability.not_supported;
  NFCTag? _tag;
  String? _result;
  List<ndef.NDEFRecord>? _records;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _records = [];
  }

  Future<void> initPlatformState() async {
    NFCAvailability availability;
    try {
      availability = await FlutterNfcKit.nfcAvailability;
    } on PlatformException {
      availability = NFCAvailability.not_supported;
    }

    if (!mounted) return;

    setState(() {
      _availability = availability;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC Reader'),
        backgroundColor: Color(0xFFE86969),
        shadowColor: Colors.grey[100],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Center(
              child: _result != null
                  ? _result!.split(' ')[1].replaceAll('Record:', '') == 'Text'
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              padding: EdgeInsets.all(60),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200],
                              ),
                              child: Icon(
                                Icons.description_rounded,
                                size: 100,
                                color: Color(0xFF103042),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              '${_result?.split(' ').last.split('=').last}',
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF103042),
                                maximumSize: Size(320, 50),
                                minimumSize: Size(300, 50),
                              ),
                              onPressed: () async {
                                await Clipboard.setData(ClipboardData(
                                    text:
                                        '${_result?.split(' ').last.split('=').last}'));
                                // copied successfully
                              },
                              child: Text('Copy Text'),
                            )
                          ],
                        )
                      : _result!.split(' ')[1].replaceAll('Record:', '') ==
                              'Uri'
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  padding: EdgeInsets.all(60),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[200],
                                  ),
                                  child: Icon(
                                    FontAwesome.globe,
                                    size: 100,
                                    color: Color(0xFF103042),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Text(
                                  '${_result?.split(' ').last.split('=').last}',
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF103042),
                                    maximumSize: Size(320, 50),
                                    minimumSize: Size(300, 50),
                                  ),
                                  onPressed: () async {
                                    var url =
                                        '${_result?.split(' ').last.split('=').last}';
                                    if (await canLaunchUrlString(url)) {
                                      await launchUrlString(
                                        url,
                                      );
                                      //forceWebView is true now
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Text('Open Link'),
                                )
                              ],
                            )
                          : Column(
                              children: [
                                Text(
                                  '${_result?.split(' ').last.split('=').last}',
                                ),
                              ],
                            )
                  : Center(
                      heightFactor: 10,
                      child: Container(
                        width: 250,
                        child: Text(
                          'Click the '
                          'Read NFC'
                          ' button below and tap the nfc tag against your phone to get the information.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[200],
        child: TextButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Color(0xFFE86969),
          ),
          onPressed: () async {
            try {
              NFCTag tag = await FlutterNfcKit.poll();
              setState(() {
                _tag = tag;
              });
              if (tag.standard == "ISO 14443-4 (Type B)") {
                String result1 = await FlutterNfcKit.transceive("00B0950000");
                String result2 = await FlutterNfcKit.transceive(
                    "00A4040009A00000000386980701");
                setState(
                  () {
                    _result = '1: $result1\n2: $result2\n';
                  },
                );
              } else if (tag.type == NFCTagType.iso18092) {
                String result1 = await FlutterNfcKit.transceive("060080080100");
                setState(() {
                  _result = '1: $result1\n';
                });
              } else if (tag.type == NFCTagType.mifare_ultralight ||
                  tag.type == NFCTagType.mifare_classic ||
                  tag.type == NFCTagType.iso15693) {
                var ndefRecords = await FlutterNfcKit.readNDEFRecords();
                var ndefString = '';
                for (int i = 0; i < ndefRecords.length; i++) {
                  ndefString += '${i + 1}: ${ndefRecords[i]}\n';
                  print(ndefString);
                }
                setState(() {
                  _result = ndefString;
                });
              } else if (tag.type == NFCTagType.webusb) {
                var r =
                    await FlutterNfcKit.transceive("00A4040006D27600012401");
                print(r);
              }
            } catch (e) {
              setState(() {
                _result = 'error: $e';
              });
            }

            if (!kIsWeb) sleep(Duration(seconds: 1));
            await FlutterNfcKit.finish(iosAlertMessage: "Finished!");
          },
          child: Text('Read NFC'),
        ),
      ),
    );
  }
}
