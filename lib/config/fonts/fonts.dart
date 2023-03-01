import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:htr/config/colors/colors.dart';

// [Color]-[Size]-[Weight]-[LetterSpacing:optional]

// [Size] => Number of Pixels

// [Weight]
//  => light w300 (L)
//  => Normal w400 (N)
//  => Medium w500 (M)
//  => SemiBold w600 (SB)
//  => Bold w700 (B)

// [Color]
//  => primaryColor : kPrimaryColor opacity 1 (p)
//  => primaryColor : kPrimaryColor opacity 0.90 (p90)
//  => whiteColor : kPrimaryColor opacity 1 (p)

// Example
// p16SB

// Primary Color
TextStyle p16SB = GoogleFonts.inter(
    color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w600);

//    Primary Color with Opacity
TextStyle p7014L = GoogleFonts.inter(
    color: kPrimaryColor.withOpacity(0.70),
    fontSize: 14,
    fontWeight: FontWeight.w300);

// White Color (w)
TextStyle w16M = GoogleFonts.inter(
    color: kWhiteColor, fontSize: 16, fontWeight: FontWeight.w500);
