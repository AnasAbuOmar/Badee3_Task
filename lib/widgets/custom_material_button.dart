import 'package:flutter/material.dart';
class CustomMaterialButton extends StatelessWidget {
  const CustomMaterialButton({Key key, @required this.color, @required this.text, @required this.onPressed})
      : super(key: key);

  final Color color;
  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      minWidth: double.maxFinite,
      height: 50,
      onPressed: onPressed,
      color: color,
      child: Text(text,
          style: TextStyle(color: Colors.white, fontSize: 16)),
      textColor: Colors.white,
    );
  }
}
