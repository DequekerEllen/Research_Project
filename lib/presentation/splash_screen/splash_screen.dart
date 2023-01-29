import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/home_screen/home_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF1A1F24),
        alignment: Alignment.center,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image(image: AssetImage('assets/images/logo.png'), height: 100),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE86969),
                minimumSize: Size(200, 50),
              ),
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
