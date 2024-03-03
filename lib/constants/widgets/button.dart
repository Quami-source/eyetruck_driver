import 'package:eyetruck_driver/constants/colors.dart';
import 'package:flutter/material.dart';

Widget primaryButton({
  required String text,
  required Function() onPressed,
}) =>
    SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: primaryWhite,
          ),
        ),
      ),
    );
