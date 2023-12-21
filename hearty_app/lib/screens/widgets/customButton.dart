import 'package:flutter/material.dart';

// Custom decoration for inputs. Example: login page and registration page  has inputs for the user.
//This is similar to button decoration.
final custominputDecoration = InputDecoration(
  fillColor: Colors.grey[300],
  filled: true,
  border: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.white),
    borderRadius: BorderRadius.circular(30),
  ),
  enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(30)),
  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
);

final customButtonDecoration = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
    padding: const MaterialStatePropertyAll(
        EdgeInsets.symmetric(vertical: 13, horizontal: 30)));
