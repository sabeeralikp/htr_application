
import 'package:flutter/material.dart';
import 'package:htr/config/assets/assets.dart';
import 'package:htr/config/fonts/fonts.dart';

FloatingActionButton floatingActionButton(onPressedFn) {
    return FloatingActionButton.extended(
      label: Text('Upload', style: w16M),
      icon: cloudUploadIcon,
      onPressed: onPressedFn,
    );
  }