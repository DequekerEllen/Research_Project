import 'package:cached_network_image/cached_network_image.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/nfctag_screen/nfctag_screen.dart';
import 'package:flutter_app/presentation/qrcode_screen/receive.dart';
import 'package:flutter_app/presentation/qrcode_screen/send.dart';
import 'package:flutter_app/widgets/bottom_navbar.dart';

class QrcodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F6F0),
      body: Column(
        children: [
          CachedNetworkImage(
            imageUrl:
                'https://images.unsplash.com/photo-1626682561113-d1db402cc866',
            fit: BoxFit.cover,
            height: 250,
            width: double.infinity,
            placeholder: (context, url) => Container(
              color: Colors.black87,
              width: double.infinity,
              height: 250,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QrSendScreen(
                            title: 'Create QR code',
                          )));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE86969),
              maximumSize: Size(320, 50),
              minimumSize: Size(100, 50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.send_rounded,
                  color: Color(0xFFF8F6F0),
                ),
                SizedBox(width: 10),
                Text(
                  'Send data',
                  style: TextStyle(
                    color: Color(0xFFF8F6F0),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => QrReceiveScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF103042),
              maximumSize: Size(320, 50),
              minimumSize: Size(100, 50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.call_received_rounded,
                  color: Color(0xFFF8F6F0),
                ),
                SizedBox(width: 10),
                Text(
                  'Receive data',
                  style: TextStyle(
                    color: Color(0xFFF8F6F0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
