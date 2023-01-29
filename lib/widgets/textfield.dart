import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField(
      {super.key, required this.controller, required this.generateQR});

  final TextEditingController controller;
  final Function generateQR;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.5),
            ),
            enabledBorder: OutlineInputBorder(),
            suffixIcon: Container(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () => generateQR(),
                  child: Text(
                    'Generate',
                    style: TextStyle(color: Color(0xFF103042)),
                  ),
                ),
              ),
            ),
            filled: true,
            fillColor: Color(0xFF103042),
            label: Text(
              'Enter data',
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}
