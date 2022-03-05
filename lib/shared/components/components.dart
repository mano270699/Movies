import 'package:flutter/material.dart';

PreferredSizeWidget defaultAppBar(
        {String? title, List<Widget>? action, required BuildContext context}) =>
    AppBar(
      backgroundColor: Colors.white,
      title: Text(
        title!,
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'Jannah',
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ),
      actions: action,
    );
Widget myDiver() => Container(
      width: double.infinity,
      height: 1,
      color: Colors.grey,
    );
void navigateTo(context, widget) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ));
void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false,
    );
