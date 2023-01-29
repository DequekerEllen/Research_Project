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
        style: TextStyle(color: Color(0xFF103042)),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.5),
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 5),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF103042),
                ),
                onPressed: () => generateQR(),
                child: Text(
                  'Generate',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            label: Text(
              'Enter data',
              style: TextStyle(color: Color(0xFF103042)),
            )),
      ),
    );
  }
}
