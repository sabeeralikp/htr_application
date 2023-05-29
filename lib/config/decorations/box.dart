import 'package:flutter/material.dart';
import 'package:htr/config/borders/borders.dart';
import 'package:htr/config/colors/colors.dart';
import 'package:htr/config/measures/border_radius.dart';

// bD[Color][BorderRadius][border]
// Example: bDP16
//  [Color]: Primary Color
//  []

const BoxDecoration bDP16 =
    BoxDecoration(color: kPrimaryColor, borderRadius: bRA16);

BoxDecoration bDR50b075 = BoxDecoration(
    color: kRedBgColor,
    borderRadius: const BorderRadius.all(Radius.circular(50)),
    border: bA075);

const BoxDecoration bDW8 =
    BoxDecoration(color: kWhiteColor, borderRadius: bRA8);
const BoxDecoration bDW32 =
    BoxDecoration(color: kWhiteColor, borderRadius: bRA32);
const BoxDecoration bDSBgTS24BS24 =
    BoxDecoration(color: kSecondaryBgColor, borderRadius: bRTS24BS24);
