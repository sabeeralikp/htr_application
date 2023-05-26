import 'package:flutter/material.dart';
import 'package:htr/config/fonts/fonts.dart';

FloatingActionButton floatingActionButton(onPressedFn, title, icon) {
  return FloatingActionButton.extended(
    label: Text(title, style: fW16M),
    icon: icon,
    onPressed: onPressedFn,
  );
}
