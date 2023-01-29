import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

class QRWidget extends StatelessWidget {
  const QRWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  final String data;

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: data.isNotEmpty ? true : false,
        child: BarcodeWidget(
          barcode: Barcode.qrCode(),
          data: data,
          width: 200,
          height: 200,
        ));
  }
}
