import 'package:flutter/material.dart';

// bR[sides]-[value]-[sides]-[value]-...
// [sides]
//    a => all sides
//    x => horizontal sides
//    y => vertical sides
//    l => Left side
//    t => Top side
//    b => bottom side
//    r => right side

const BorderRadius bRA8 = BorderRadius.all(Radius.circular(8));
const BorderRadius bRA16 = BorderRadius.all(Radius.circular(16));
const BorderRadius bRA32 = BorderRadius.all(Radius.circular(32));
const BorderRadius bRA50 = BorderRadius.all(Radius.circular(50));
const BorderRadius bRTL24TR24 = BorderRadius.only(
    topLeft: Radius.circular(24), topRight: Radius.circular(24));
const BorderRadiusDirectional bRTS24BS24 = BorderRadiusDirectional.only(
    topStart: Radius.circular(24), bottomStart: Radius.circular(24));
