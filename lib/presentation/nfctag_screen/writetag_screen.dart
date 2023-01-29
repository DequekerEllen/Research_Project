// ignore_for_file: unused_field, depend_on_referenced_packages, unused_import, library_private_types_in_public_api, avoid_unnecessary_containers

import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform, sleep;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logging/logging.dart';
import 'package:ndef/ndef.dart' as ndef;

import 'record-setting/raw_record_setting.dart';
import 'record-setting/text_record_setting.dart';
import 'record-setting/uri_record_setting.dart';

class WriteNfcScreen extends StatefulWidget {
  @override
  _WriteNfcScreenState createState() => _WriteNfcScreenState();
}

class _WriteNfcScreenState extends State<WriteNfcScreen>
    with SingleTickerProviderStateMixin {
  String _platformVersion = '';
  NFCAvailability _availability = NFCAvailability.not_supported;
  NFCTag? _tag;
  String? _writeResult;
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

  // Platform messages are asynchronous, so we initialize in an async method.
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

  Future<bool?> toast(String message) {
    Fluttertoast.cancel();
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 15.0);
  }

  String toText(Iterable<int>? data) {
    print(data);
    final String text = utf8.decode(data?.toList() ?? []);
    print(text);
    return text.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC Writer'),
        backgroundColor: Color(0xFFE86969),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF103042),
                    maximumSize: Size(320, 50),
                    minimumSize: Size(300, 50),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: Text("Record Type"),
                          children: <Widget>[
                            SimpleDialogOption(
                              child: Text("Text Record"),
                              onPressed: () async {
                                Navigator.pop(context);
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return TextRecordSetting();
                                    },
                                  ),
                                );
                                if (result != null) {
                                  if (result is ndef.TextRecord) {
                                    setState(
                                      () {
                                        _records!.add(result);
                                      },
                                    );
                                  }
                                }
                              },
                            ),
                            SimpleDialogOption(
                              child: Text("Uri Record"),
                              onPressed: () async {
                                Navigator.pop(context);
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return UriRecordSetting();
                                    },
                                  ),
                                );
                                if (result != null) {
                                  if (result is ndef.UriRecord) {
                                    setState(
                                      () {
                                        _records!.add(result);
                                      },
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Add record"),
                      Icon(Icons.add),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            // Text('Result: $_writeResult'),
            const SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: ListView(
                shrinkWrap: true,
                children: List<Widget>.generate(
                  _records!.length,
                  (index) => GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _records![index].type?.toHexString() == '54'
                              ? Text(
                                  'Value: ${toText(_records![index].payload?.getRange(3, _records![index].payload!.length))}\n')
                              : Text(
                                  '${toText(_records![index].payload?.getRange(0, _records![index].payload!.length))}\n'),
                          IconButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return NDEFRecordSetting(
                                        record: _records![index]);
                                  },
                                ),
                              );
                              if (result != null) {
                                if (result is ndef.NDEFRecord) {
                                  setState(
                                    () {
                                      _records![index] = result;
                                    },
                                  );
                                } else if (result is String &&
                                    result == "Delete") {
                                  _records!.removeAt(index);
                                }
                              }
                            },
                            icon: Icon(Icons.edit),
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return NDEFRecordSetting(record: _records![index]);
                          },
                        ),
                      );
                      if (result != null) {
                        if (result is ndef.NDEFRecord) {
                          setState(
                            () {
                              _records![index] = result;
                            },
                          );
                        } else if (result is String && result == "Delete") {
                          _records!.removeAt(index);
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Color(0xFFE86969),
          ),
          onPressed: () async {
            if (_records!.isNotEmpty) {
              try {
                NFCTag tag = await FlutterNfcKit.poll();
                setState(
                  () {
                    _tag = tag;
                  },
                );
                if (tag.type == NFCTagType.mifare_ultralight ||
                    tag.type == NFCTagType.mifare_classic ||
                    tag.type == NFCTagType.iso15693) {
                  await FlutterNfcKit.writeNDEFRecords(_records!);
                  setState(
                    () {
                      _writeResult = 'OK';
                    },
                  );
                } else {
                  setState(
                    () {
                      _writeResult = 'error: NDEF not supported: ${tag.type}';
                    },
                  );
                }
              } catch (e, stacktrace) {
                setState(
                  () {
                    _writeResult = 'error: $e';
                  },
                );
                print(stacktrace);
              } finally {
                await FlutterNfcKit.finish();
              }
            } else {
              setState(
                () {
                  _writeResult = 'error: No record';
                },
              );
            }
            toast('Result: $_writeResult');
          },
          child: Text("Start writing"),
        ),
      ),
    );
  }
}
