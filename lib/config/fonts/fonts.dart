import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:htr/config/colors/colors.dart';

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
TextStyle fP48B = GoogleFonts.inter(
    color: kPrimaryColor, fontSize: 48, fontWeight: FontWeight.w700);
TextStyle fP32SB = GoogleFonts.inter(
    color: kPrimaryColor, fontSize: 32, fontWeight: FontWeight.w600);
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

TextStyle fP7014N = GoogleFonts.inter(
    color: kPrimaryColor.withOpacity(0.70),
    fontSize: 20,
    fontWeight: FontWeight.w400);
// White Color (w)
TextStyle fW16M = GoogleFonts.inter(
    color: kWhiteColor, fontSize: 16, fontWeight: FontWeight.w500);
TextStyle fW16N = GoogleFonts.inter(
    color: kWhiteColor, fontSize: 16, fontWeight: FontWeight.w400);

//grey
TextStyle fG14N = GoogleFonts.inter(
    color: kGreyColor, fontSize: 14, fontWeight: FontWeight.w400);
TextStyle fG16N = GoogleFonts.inter(
    color: kGreyColor, fontSize: 16, fontWeight: FontWeight.w400);
TextStyle fG18N = GoogleFonts.inter(
    color: kGreyColor, fontSize: 18, fontWeight: FontWeight.w400);

TextStyle fG20N = GoogleFonts.inter(
    color: kGreyColor, fontSize: 20, fontWeight: FontWeight.w400);

// Black
TextStyle fB72B = GoogleFonts.inter(
    color: kBlackColor, fontSize: 72, fontWeight: FontWeight.w700);
TextStyle fB64SB = GoogleFonts.inter(
    color: kBlackColor, fontSize: 64, fontWeight: FontWeight.w600);
TextStyle fB16N = GoogleFonts.inter(
    color: kBlackColor, fontSize: 16, fontWeight: FontWeight.w400);
TextStyle fB16M = GoogleFonts.inter(
    color: kBlackColor, fontSize: 16, fontWeight: FontWeight.w500);
TextStyle fB18N = GoogleFonts.inter(
    color: kBlackColor, fontSize: 18, fontWeight: FontWeight.w400);
TextStyle fB18SB = GoogleFonts.inter(
    color: kBlackColor, fontSize: 18, fontWeight: FontWeight.w600);
TextStyle fB20N = GoogleFonts.inter(
    color: kBlackColor, fontSize: 20, fontWeight: FontWeight.w400);
TextStyle fB32SB = GoogleFonts.inter(
    color: kBlackColor, fontSize: 32, fontWeight: FontWeight.w600);
TextStyle fB20SB = GoogleFonts.inter(
    color: kBlackColor, fontSize: 20, fontWeight: FontWeight.w600);

// kTextGreyColor
TextStyle fTG20N = GoogleFonts.inter(
    color: kTextGreyColor, fontSize: 20, fontWeight: FontWeight.w400);
TextStyle fTG16N = GoogleFonts.inter(
    color: kTextGreyColor, fontSize: 16, fontWeight: FontWeight.w400);
TextStyle fTG64SB = GoogleFonts.inter(
    color: kTextGreyColor, fontSize: 64, fontWeight: FontWeight.w600);
TextStyle fTG32SB = GoogleFonts.inter(
    color: kTextGreyColor, fontSize: 32, fontWeight: FontWeight.w600);
TextStyle fTG30SB = GoogleFonts.inter(
    color: kTextGreyColor, fontSize: 30, fontWeight: FontWeight.w600);
TextStyle fTG24SB = GoogleFonts.inter(
    color: kTextGreyColor, fontSize: 24, fontWeight: FontWeight.w600);

//Malayalam
TextStyle fMTG32SB = GoogleFonts.notoSansMalayalam(
    color: kBlackColor, fontSize: 32, fontWeight: FontWeight.w600);
TextStyle fMP24SB
 = GoogleFonts.notoSansMalayalam(
    color: kBlackColor, fontSize: 24, fontWeight: FontWeight.w600);
TextStyle fMP16N = GoogleFonts.notoSansMalayalam(
    color: kBlackColor, fontSize: 16, fontWeight: FontWeight.w500);
