import 'dart:developer';

import 'package:flutter/material.dart';

class ControllerButton extends StatefulWidget {
  final String path;
  final VoidCallback onTap;
  const ControllerButton({
    Key? key,
    required this.path,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ControllerButton> createState() => _ControllerButtonState();
}

class _ControllerButtonState extends State<ControllerButton> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    //* prendo le dimensioni dello schermo
    Size screenSize = MediaQuery.of(context).size;

    //*react on gestures
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTapDown: (details) {
          setState(() {
            _isPressed = true;
          });
          widget.onTap(); //* call the callback!
        },
        onTapUp: (details) {
          setState(() {
            _isPressed = false;
          });
        },
        child: Opacity(
          opacity: _isPressed ? 0.5 : 0.8,
          child: SizedBox(
              //* il bottone ha dimensioni = 1/17 della larghezza
              height: screenSize.width / 17,
              width: screenSize.width / 17,
              child: Image.asset(widget.path)),
        ),
      ),
    );
  }
}
