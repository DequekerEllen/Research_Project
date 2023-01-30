import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/presentation/home_screen/home_screen.dart';
import 'package:flutter_app/presentation/qrcode_screen/qrcode_screen.dart';
import 'package:flutter_app/widgets/bottom_navbar.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher_string.dart';

class QrReceiveScreen extends StatefulWidget {
  const QrReceiveScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrReceiveScreenState();
}

class _QrReceiveScreenState extends State<QrReceiveScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void _onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.flipCamera();
    controller.flipCamera();
    controller.scannedDataStream.listen((scanData) {
      setState(() => result = scanData);
    });
  }

  void readQr() {
    if (result != null) {
      controller!.pauseCamera();
      print(result!.code);
      controller!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    // readQr();
    return Scaffold(
      appBar: AppBar(
          title: const Text('Mobile Scanner'),
          backgroundColor: Color(0xFFE86969),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
          )),
      body: Column(
        children: [
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (result != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF103042),
                            maximumSize: Size(320, 60),
                            minimumSize: Size(100, 50),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    QrDataScreen(data: result),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.launch),
                              SizedBox(width: 10),
                              Text('View Data'),
                            ],
                          ),
                        )
                      ],
                    )
                  else
                    const Text('Scan a code'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Color(0xFFE86969),
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class QrDataScreen extends StatelessWidget {
  final Barcode? data;

  QrDataScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('data:  ${data!.code}');
    return Scaffold(
      appBar: AppBar(
          title: const Text('Data received'),
          backgroundColor: Color(0xFFE86969),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QrReceiveScreen(),
                ),
              );
            },
          )),
      body: Column(
        children: [
          data!.code.toString().contains('http')
              ? Center(
                  child: Column(
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
                        '${data!.code}',
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
                          var url = '${data!.code}';
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
                  ),
                )
              : Center(
                  child: Column(
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
                        '${data!.code}',
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
                          await Clipboard.setData(
                              ClipboardData(text: '${data!.code}'));
                          // copied successfully
                        },
                        child: Text('Copy Text'),
                      )
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
