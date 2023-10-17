import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dhriti/config/colors/colors.dart';

/// f[Color]-[Size]-[Weight]-[LetterSpacing:optional]

// [Size] => Number of Pixels

// [Weight]
//  => Light w300 (L)
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
TextStyle fP20SB = GoogleFonts.inter(
    color: kPrimaryColor, fontSize: 20, fontWeight: FontWeight.w600);
TextStyle fP16SB = GoogleFonts.inter(
    color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w600);
TextStyle fP16M = GoogleFonts.inter(
    color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500);
TextStyle fP14N = GoogleFonts.inter(
    color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w400);
TextStyle fP14M = GoogleFonts.inter(
    color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500);

// Primary Color with Opacity
TextStyle fP7014L = GoogleFonts.inter(
    color: kPrimaryColor.withOpacity(0.70),
    fontSize: 14,
    fontWeight: FontWeight.w300);

// White Color (w)
TextStyle fW16M = GoogleFonts.inter(
    color: kWhiteColor, fontSize: 16, fontWeight: FontWeight.w500);
TextStyle fW16N = GoogleFonts.inter(
    color: kWhiteColor, fontSize: 14, fontWeight: FontWeight.w400);

//grey
TextStyle fG14N = GoogleFonts.inter(
    color: kGreyColor, fontSize: 14, fontWeight: FontWeight.w400);

TextStyle fTG14N = GoogleFonts.inter(
    color: kTextGreyColor, fontSize: 14, fontWeight: FontWeight.w400);

TextStyle fTG12N = GoogleFonts.inter(
    color: kTextGreyColor, fontSize: 12, fontWeight: FontWeight.w400);
TextStyle fTG14M = GoogleFonts.inter(
    color: kTextGreyColor, fontSize: 14, fontWeight: FontWeight.w500);
TextStyle fTG16M = GoogleFonts.inter(
    color: kTextGreyColor, fontSize: 16, fontWeight: FontWeight.w500);
TextStyle fTG24SB = GoogleFonts.inter(
    color: kTextGreyColor, fontSize: 24, fontWeight: FontWeight.w600);

// Black
TextStyle fB16M = GoogleFonts.inter(
    color: kBlackColor, fontSize: 16, fontWeight: FontWeight.w500);
TextStyle fB14M = GoogleFonts.inter(
    color: kBlackColor, fontSize: 14, fontWeight: FontWeight.w500);
TextStyle fB14N = GoogleFonts.inter(
    color: kBlackColor, fontSize: 14, fontWeight: FontWeight.w400);
TextStyle fB12N = GoogleFonts.inter(
    color: kBlackColor, fontSize: 12, fontWeight: FontWeight.w400);
TextStyle fB18SB = GoogleFonts.inter(
    color: kBlackColor, fontSize: 18, fontWeight: FontWeight.w500);
TextStyle fB24SB = GoogleFonts.inter(
    color: kBlackColor, fontSize: 28, fontWeight: FontWeight.w600);

//Malayalam
TextStyle fMP24SB = GoogleFonts.notoSansMalayalam(
    color: kBlackColor, fontSize: 24, fontWeight: FontWeight.w600);

TextStyle fMB16SB = GoogleFonts.notoSansMalayalam(
    color: kBlackColor, fontSize: 16, fontWeight: FontWeight.w600);
