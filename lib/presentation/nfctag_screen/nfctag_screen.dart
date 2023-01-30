import 'package:cached_network_image/cached_network_image.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/nfctag_screen/readtag_screen.dart';
import 'package:flutter_app/presentation/nfctag_screen/test.dart';
import 'package:flutter_app/presentation/nfctag_screen/writetag_screen.dart';
import 'package:flutter_app/presentation/qrcode_screen/qrcode_screen.dart';
import 'package:flutter_app/presentation/splash_screen/splash_screen.dart';
import 'package:flutter_app/widgets/bottom_navbar.dart';

class NfctagScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFF8F6F0),
      body: Column(
        children: [
          CachedNetworkImage(
            imageUrl:
                'https://images.unsplash.com/photo-1659353669929-1276a93a2d04',
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyNFCWidget()));
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
                  Icons.search,
                  color: Color(0xFFF8F6F0),
                ),
                SizedBox(width: 10),
                Text(
                  'Read Tag',
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
                  MaterialPageRoute(builder: (context) => WriteNfcScreen()));
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
                  Icons.edit,
                  color: Color(0xFFF8F6F0),
                ),
                SizedBox(width: 10),
                Text(
                  'Write Tag',
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
