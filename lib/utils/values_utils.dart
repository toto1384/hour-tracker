
import 'dart:ui';

import '../main.dart';



class MyColors{
  static const Color color_primary = Color(0xff74b772);
  static const Color color_secondary = Color(0xffc43e3b);
  static const Color color_primary_lighter = Color(0xff9ece9b);

  static const Color color_black = Color(0xff202020);
  static const Color color_black_darker = Color(0xff161616);


  static const Color color_gray_darker = Color(0xff393939);
  static const Color color_gray_lighter = Color(0xffd6d6d6);

  static getIconTextGray(){
    return MyApp.isDarkMode?color_gray_lighter:color_gray_darker;
  }

}

class AssetsPath{
  static var checkboxAnimation = "assets/animations/checkbox.flr";
  static var emptyIcon = "assets/svgs/empty.svg";
  static var welcomeIcon = "assets/svgs/welcome.svg";
  static var gIcon = "assets/g_icon.png";
  static var actionStain1 = "assets/svgs/stains/action_stain1.svg";
  static var actionStain2 = "assets/svgs/stains/action_stain2.svg";
  static var backgroundStain = "assets/svgs/stains/background_stain.svg";
  static var welcome1 = "assets/svgs/welcome_page/welcome1.svg";
  static var welcome2 = "assets/svgs/welcome_page/welcome2.svg";
  static var welcome3 = "assets/svgs/welcome_page/welcome3.svg";
  static var habits = "assets/svgs/wides/habits.svg";
  static var nutrition = "assets/svgs/wides/nutrition.svg";
  static var sleep = "assets/svgs/wides/sleep.svg";
}