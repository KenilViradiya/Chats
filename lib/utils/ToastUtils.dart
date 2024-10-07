import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static void showtoast(String msg) {
    Fluttertoast.showToast(msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        // Background color
        textColor: Colors.white,
        // Text color
        fontSize: 16.0);
  }
}