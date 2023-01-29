// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

import 'package:flutter/material.dart';

import 'package:ndef/ndef.dart' as ndef;

class NDEFRecordSetting extends StatefulWidget {
  final ndef.NDEFRecord record;
  NDEFRecordSetting({Key? key, ndef.NDEFRecord? record})
      : record = record ?? ndef.NDEFRecord(),
        super(key: key);
  @override
  _NDEFRecordSetting createState() => _NDEFRecordSetting();
}

class _NDEFRecordSetting extends State<NDEFRecordSetting> {
  GlobalKey _formKey = GlobalKey<FormState>();
  late TextEditingController _identifierController;
  late TextEditingController _payloadController;
  late TextEditingController _typeController;
  late int _dropButtonValue;

  @override
  initState() {
    super.initState();

    if (widget.record.id == null) {
      _identifierController =
          TextEditingController.fromValue(TextEditingValue(text: ""));
    } else {
      _identifierController = TextEditingController.fromValue(
          TextEditingValue(text: widget.record.id!.toHexString()));
    }
    if (widget.record.payload == null) {
      _payloadController =
          TextEditingController.fromValue(TextEditingValue(text: ""));
    } else {
      _payloadController = TextEditingController.fromValue(
          TextEditingValue(text: widget.record.payload!.toHexString()));
    }
    if (widget.record.encodedType == null &&
        widget.record.decodedType == null) {
      // bug in ndef package (fixed in newest version)
      _typeController =
          TextEditingController.fromValue(TextEditingValue(text: ""));
    } else {
      _typeController = TextEditingController.fromValue(
          TextEditingValue(text: widget.record.type!.toHexString()));
    }
    _dropButtonValue = ndef.TypeNameFormat.values.indexOf(widget.record.tnf);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
        backgroundColor: Color(0xFFE86969),
        shadowColor: Colors.grey[100],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                DropdownButton(
                  value: _dropButtonValue,
                  items: [
                    DropdownMenuItem(
                      value: 0,
                      child: Text('empty'),
                    ),
                    DropdownMenuItem(
                      value: 1,
                      child: Text('nfcWellKnown'),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text('media'),
                    ),
                    DropdownMenuItem(
                      value: 3,
                      child: Text('absoluteURI'),
                    ),
                    DropdownMenuItem(value: 4, child: Text('nfcExternal')),
                    DropdownMenuItem(value: 5, child: Text('unchanged')),
                    DropdownMenuItem(
                      value: 6,
                      child: Text('unknown'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _dropButtonValue = value as int;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'identifier'),
                  validator: (v) {
                    return v!.trim().length % 2 == 0
                        ? null
                        : 'length must be even';
                  },
                  controller: _identifierController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'type'),
                  validator: (v) {
                    return v!.trim().length % 2 == 0
                        ? null
                        : 'length must be even';
                  },
                  controller: _typeController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'payload'),
                  validator: (v) {
                    return v!.trim().length % 2 == 0
                        ? null
                        : 'length must be even';
                  },
                  controller: _payloadController,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF103042),
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(24),
                      ),
                      child: Text('OK'),
                      onPressed: () {
                        if ((_formKey.currentState as FormState).validate()) {
                          Navigator.pop(
                              context,
                              ndef.NDEFRecord(
                                  tnf: ndef
                                      .TypeNameFormat.values[_dropButtonValue],
                                  type: (_typeController.text).toBytes(),
                                  id: (_identifierController.text).toBytes(),
                                  payload:
                                      (_payloadController.text).toBytes()));
                        }
                      },
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF103042),
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                      ),
                      onPressed: () {
                        if ((_formKey.currentState as FormState).validate()) {
                          Navigator.pop(context, 'Delete');
                        }
                      },
                      child: Icon(Icons.delete),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
