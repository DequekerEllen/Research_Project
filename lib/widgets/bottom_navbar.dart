import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/nfctag_screen/nfctag_screen.dart';
import 'package:flutter_app/presentation/qrcode_screen/qrcode_screen.dart';

class BasicBottomNavBar extends StatefulWidget {
  const BasicBottomNavBar({Key? key}) : super(key: key);

  @override
  _BasicBottomNavBarState createState() => _BasicBottomNavBarState();
}

class _BasicBottomNavBarState extends State<BasicBottomNavBar> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    NfctagScreen(),
    QrcodeScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F6F0),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: FloatingNavbar(
        backgroundColor: Color(0xFF131619),
        selectedBackgroundColor: Color(0xFF262D34),
        borderRadius: 50,
        itemBorderRadius: 30,
        unselectedItemColor: Color.fromARGB(255, 136, 136, 136),
        selectedItemColor: Color(0xFFE86969),
        margin: EdgeInsetsDirectional.only(bottom: 20, start: 10, end: 10),
        items: [
          FloatingNavbarItem(
            icon: Icons.nfc,
            title: 'NFC',
          ),
          FloatingNavbarItem(
            icon: Icons.qr_code,
            title: 'QR',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
