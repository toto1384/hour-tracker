

import 'package:flutter/material.dart';


launchPage(BuildContext context , Widget page){
  Navigator.push(context, MaterialPageRoute(
    builder: (context){
      return page;
    }
  ));
}



//Specific for this app

// getColorValue(int index) {
//   switch(index){
//     case 1 : return MyColors.color_red;break;
//     case 2 : return MyColors.color_secondary;break;
//     case 3 : return MyColors.color_purple;break;
//     case 4 : return MyColors.color_green;break;
//     case 5 : return MyColors.color_cyan;break;
//     case 6 : return MyColors.color_orange;break;
//     case 7 : return MyApp.isDarkMode?Colors.white:MyColors.color_black;break;
//     default : return MyColors.color_primary;break;
//   }
// }