// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

import 'package:flutter/material.dart';

import 'package:ndef/ndef.dart' as ndef;

class TextRecordSetting extends StatefulWidget {
  final ndef.TextRecord record;
  TextRecordSetting({Key? key, ndef.TextRecord? record})
      : record = record ?? ndef.TextRecord(language: 'en', text: ''),
        super(key: key);
  @override
  _TextRecordSetting createState() => _TextRecordSetting();
}

class _TextRecordSetting extends State<TextRecordSetting> {
  GlobalKey _formKey = GlobalKey<FormState>();
  late TextEditingController _languageController;
  late TextEditingController _textController;
  late int _dropButtonValue;

  @override
  initState() {
    super.initState();

    _languageController = TextEditingController.fromValue(
        TextEditingValue(text: widget.record.language!));
    _textController = TextEditingController.fromValue(
        TextEditingValue(text: widget.record.text!));
    _dropButtonValue = ndef.TextEncoding.values.indexOf(widget.record.encoding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write Text Record'),
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
                    DropdownMenuItem(value: 0, child: Text('UTF-8')),
                    DropdownMenuItem(value: 1, child: Text('UTF-16')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _dropButtonValue = value as int;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'language'),
                  validator: (v) {
                    return v!.trim().length % 2 == 0
                        ? null
                        : 'length must not be blank';
                  },
                  controller: _languageController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'text'),
                  controller: _textController,
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
                          ndef.TextRecord(
                              encoding:
                                  ndef.TextEncoding.values[_dropButtonValue],
                              language: (_languageController.text),
                              text: (_textController.text)));
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
