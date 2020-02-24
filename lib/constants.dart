import 'package:flutter/material.dart';
enum EventLoadingState{
  NOT_SELECTED,
  LOADING,
  DONE_LOADING
}

const color = Color.fromARGB(255, 149, 208, 158);


const appGradient =  BoxDecoration(
  gradient: LinearGradient(colors: [
    Color.fromARGB(255, 0, 26, 71),
    Color.fromARGB(255, 149, 208, 158)
  ], begin: Alignment.center, end: Alignment(2.0, 1.5)),
);


const tableTextStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w300,
  color: Colors.white,

);