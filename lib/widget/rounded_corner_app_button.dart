import 'package:flutter/material.dart';
import 'package:driver_3_0_5/util/constants.dart';

class RoundedCornerAppButton extends StatelessWidget {
  RoundedCornerAppButton({required this.btn_lable, required this.onPressed});

  final btn_lable;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(Constants.color_theme),
        onPrimary: Colors.white,
        shape:   RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            0, 10.0, 0, 10.0),

        child: Text(
          btn_lable,
          style: TextStyle(
              fontFamily: Constants.app_font,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontSize: 16.0),
        ),
      ),
      onPressed: onPressed as void Function()?,

    );
  }
}
