import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;
  static double safeScreenWidth;
  static double safeScreenHeight;
  static double safeBlockSizeHorizontal;
  static double safeBlockSizeVertical;
  static double verticalPadding;
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    verticalPadding=MediaQuery.of(context).padding.top;
    screenHeight = _mediaQueryData.size.height;
    screenWidth = _mediaQueryData.size.width;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    safeBlockSizeHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    safeBlockSizeVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;

    safeScreenWidth = (screenWidth - safeBlockSizeHorizontal) / 100;
    safeScreenHeight = (screenHeight - safeBlockSizeVertical) / 100;
  }
}
