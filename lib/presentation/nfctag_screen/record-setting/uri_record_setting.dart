// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

import 'package:flutter/material.dart';

import 'package:ndef/ndef.dart' as ndef;

class UriRecordSetting extends StatefulWidget {
  final ndef.UriRecord record;
  UriRecordSetting({Key? key, ndef.UriRecord? record})
      : record = record ?? ndef.UriRecord(prefix: '', content: ''),
        super(key: key);
  @override
  _UriRecordSetting createState() => _UriRecordSetting();
}

class _UriRecordSetting extends State<UriRecordSetting> {
  GlobalKey _formKey = GlobalKey<FormState>();
  late TextEditingController _contentController;
  String? _dropButtonValue;

  @override
  initState() {
    super.initState();

    _contentController = TextEditingController.fromValue(
        TextEditingValue(text: widget.record.content!));
    _dropButtonValue = widget.record.prefix;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write Uri Record'),
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
                  items: ndef.UriRecord.prefixMap.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _dropButtonValue = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'content'),
                  controller: _contentController,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF103042),
                    maximumSize: Size(320, 50),
                    minimumSize: Size(300, 50),
                  ),
                  child: Text('OK'),
                  onPressed: () {
                    if ((_formKey.currentState as FormState).validate()) {
                      Navigator.pop(
                          context,
                          ndef.UriRecord(
                            prefix: _dropButtonValue,
                            content: (_contentController.text),
                          ));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
