import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/qrcode.dart';
import 'package:flutter_app/widgets/textfield.dart';

class QrSendScreen extends StatefulWidget {
  const QrSendScreen({super.key, required this.title});
  final String title;

  @override
  State<QrSendScreen> createState() => _QrSendScreenState();
}

class _QrSendScreenState extends State<QrSendScreen> {
  late TextEditingController textEditingController;
  String data = '';

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create QR code'),
          backgroundColor: Color(0xFFE86969),
        ),
        body: Column(
          children: [
            InputField(
                controller: textEditingController,
                generateQR: () => generateQRCode()),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            QRWidget(data: textEditingController.text),
          ],
        ));
  }

  generateQRCode() {
    setState(() => data = textEditingController.text);
  }
}
