// [sides]-[value]-[sides]-[value]-...
// [sides]
//    a => all sides
//    x => horizontal sides
//    y => vertical sides
//    l => Left side
//    t => Top side
//    b => bottom side
//    r => right side

import 'package:flutter/material.dart';

const EdgeInsets x32 = EdgeInsets.symmetric(horizontal: 32);
const EdgeInsets x16 = EdgeInsets.symmetric(horizontal: 16);

const EdgeInsets y32 = EdgeInsets.symmetric(vertical: 32);
const EdgeInsets y8 = EdgeInsets.symmetric(vertical: 8);

const EdgeInsets x16Y32 = EdgeInsets.symmetric(horizontal: 16, vertical: 32);
const EdgeInsets x16T32B64 =
    EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 64);
const EdgeInsets x16T32B80 =
    EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 80);
const EdgeInsets t16B64 = EdgeInsets.only(top: 16, bottom: 32);
