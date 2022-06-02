
import 'package:flutter/material.dart';

typedef ReturnChild = Widget Function(BuildContext buildContext,Function closeTooltip);

typedef StateGetter = Widget Function( BuildContext buildContext , Function(Function) state);

class TextType{

  double size;
  FontWeight fontWeight;
  TextType(this.size,this.fontWeight);

  static final TextType textTypeTitle =TextType(34,FontWeight.w800);
  static final TextType textTypeSubtitle =TextType(26,FontWeight.w700);
  static final TextType textTypeNormal =TextType(15,FontWeight.w600);
  static final TextType textTypeSubNormal =TextType(12,FontWeight.w400);
  static final TextType textTypeGigant =TextType(52,FontWeight.w900);

}

enum FABAction{
  AddTask,
}


