import 'package:flutter/material.dart';

/// p[sides]-[value]-[sides]-[value]-...
/// [sides]
///    A => all sides
///    X => horizontal sides
///    Y => vertical sides
//    L => Left side
//    T => Top side
//    B => bottom side
//    R => right side

const EdgeInsets p0 = EdgeInsets.zero;

// All-Directional Padding
const EdgeInsets pA4 = EdgeInsets.all(4);
const EdgeInsets pA8 = EdgeInsets.all(8);
const EdgeInsets pA16 = EdgeInsets.all(16);
const EdgeInsets pA32 = EdgeInsets.all(32);

// X-Directional Padding
const EdgeInsets pX16 = EdgeInsets.symmetric(horizontal: 16);
const EdgeInsets pX32 = EdgeInsets.symmetric(horizontal: 32);

// Y-Directional Padding
const EdgeInsets pY8 = EdgeInsets.symmetric(vertical: 8);
const EdgeInsets pY32 = EdgeInsets.symmetric(vertical: 32);

// XY-Directional Padding
const EdgeInsets pX16Y32 = EdgeInsets.symmetric(horizontal: 16, vertical: 32);

// Only Right Padding
const EdgeInsets pR8 = EdgeInsets.only(right: 8);


// Others
const EdgeInsets pX16T32B64 =
    EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 64);
const EdgeInsets pX16T32B80 =
    EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 80);
const EdgeInsets pT16B64 = EdgeInsets.only(top: 16, bottom: 32);
