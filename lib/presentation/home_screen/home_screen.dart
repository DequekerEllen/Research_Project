import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/bottom_navbar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BasicBottomNavBar(),
      ),
    );
  }
}
