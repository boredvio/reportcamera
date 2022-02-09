import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {Key? key,
      required this.textButton,
      required this.colorButton,
      required this.onTap})
      : super(key: key);

  final String textButton;
  final Color colorButton;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      // <----------------------------- Outer Material
      shadowColor: Colors.blueGrey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: AlignmentDirectional.bottomStart,
            end: AlignmentDirectional.topEnd,
            colors: [colorButton, colorButton],
          ),
        ),
        child: Material(
          // <------------------------- Inner Material
          type: MaterialType.transparency,
          elevation: 6.0,
          color: Colors.transparent,
          shadowColor: Colors.grey[50],
          child: InkWell(
            //<------------------------- InkWell
            splashColor: Colors.white30,
            onTap: onTap,
            child: SizedBox(
              height: 40,
              child: Center(
                child: Text(
                  textButton,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
