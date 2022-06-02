import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hour_tracker/pages/home_page.dart';


import '../icon_pack_icons.dart';
import '../main.dart';
import 'date_utils.dart';
import 'get_popup_and_sheets_utils.dart';
import 'typedef_and_enums_utils.dart';
import 'utils.dart';
import 'values_utils.dart';


getText(String text, { TextType textType, Color color,int maxLines,bool crossed,bool isCentered}){

  if(textType==null){
    textType=TextType.textTypeNormal;
  }

  if(color==null){
    color= MyApp.isDarkMode?Colors.white:MyColors.color_black;
  }

  if(crossed==null){
    crossed=false;
  }

  if(isCentered==null){
    isCentered=false;
  }

  return Text(text,maxLines: maxLines??1,style: TextStyle(fontSize: textType.size,
    color: color,
    fontWeight: textType.fontWeight,
    decoration: crossed?TextDecoration.lineThrough:TextDecoration.none
  ),textAlign: isCentered?TextAlign.center:null,);

}

getRichText(List<String> strings , List<TextType> textTypes, {List<Color> colors}){
  if(colors==null){
    colors=[];
  }
  return RichText(
    text: TextSpan(
      children: List.generate(strings.length, (index){
        bool existsTextType = textTypes[index]!=null;
        bool existsColor = colors.length>index;

        return TextSpan(
          text: strings[index],
          style: TextStyle(
            color: existsColor?colors[index]:getIconTextColor(),
            fontWeight: existsTextType?textTypes[index].fontWeight:TextType.textTypeNormal.fontWeight,
            fontSize: existsTextType?textTypes[index].size:TextType.textTypeNormal.size,
          ),
        );
      }),
    ),
  );
}

getColorPrimaryContainer(Widget widget){
    return Container(
      decoration: BoxDecoration(
        color: MyColors.color_primary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: getPadding(widget),
    );
}


getPadding( Widget child,{double horizontal,double vertical}){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: horizontal??8,vertical: vertical??8),
    child: child,
  );
}

getWidgetKey(GlobalKey globalKey, Widget child){
  return Container(key: globalKey,child: child,);
}


getSliderWrapperForSuperTooltip({@required StateGetter getSlider,@required String title}){
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      getPadding(getText(title,textType: TextType.textTypeTitle)),
      Container(
        height: 70,
        child: Card(
            elevation: 0,
            color: getOverFlowColor(),
            child: StatefulBuilder(
              builder: (ctx,ss){
                return getSlider(ctx,(function){
                  ss((){
                    function();
                  });
                });
              },
          ),
        ),
      ),
    ],
  );
}

getSliderThemeData(){
  return SliderThemeData(
    activeTrackColor: MyColors.color_primary,
    inactiveTrackColor: MyColors.color_primary.withOpacity(0.3),
    thumbColor: MyColors.color_secondary,
    trackHeight: 8,
    overlayColor: MyColors.color_secondary.withOpacity(0.3),
    valueIndicatorColor: MyColors.color_primary,
    activeTickMarkColor: Colors.transparent,
    inactiveTickMarkColor: Colors.transparent,
  );
}

getAppTheme(){
  return ThemeData(
    fontFamily: 'Montserrat',
    accentColor: MyColors.color_secondary,
    primaryColor: MyColors.color_primary,
    cursorColor: MyColors.color_primary,
    primaryColorDark: MyColors.color_primary,
    scaffoldBackgroundColor: Colors.white,
    bottomAppBarColor:Colors.white,
    sliderTheme: getSliderThemeData(),
    popupMenuTheme: PopupMenuThemeData(
      shape: getShape(),
    ),
    unselectedWidgetColor: Colors.white

  );
}

getAppDarkTheme(){
  return ThemeData(
    fontFamily: 'Montserrat',
    accentColor: MyColors.color_secondary,
    cursorColor: MyColors.color_secondary,
    sliderTheme: getSliderThemeData(),
    primaryColor: MyColors.color_primary,
    primaryColorDark: MyColors.color_primary,
    scaffoldBackgroundColor: MyColors.color_black,
    bottomAppBarColor: MyColors.color_black_darker,
    popupMenuTheme: PopupMenuThemeData(
      shape: getShape(),
      color: MyColors.color_black_darker,
    ),
  );
}

getFloatingActionButton(FABAction fabAction,{bool extended,@required Function onPressed}){

  IconData iconData;
  String text;

  if(extended==null){
    extended=true;
  }

  if(fabAction==FABAction.AddTask){
    iconData=IconPack.add;
    text = 'Add task';
  }

  if(extended){
    return FloatingActionButton.extended(
      label: getText(text,color: MyColors.color_black),
      icon: getIcon(iconData,color: MyColors.color_black),
      onPressed: onPressed,
    );
  }else{
    return FloatingActionButton(
      child: getIcon(iconData,color: MyColors.color_black),
      onPressed: onPressed,
    );
  }
}

getBottomAppBar({@required Function onPressed,Function onPressed1,IconData icon1, IconData icon2}){
  return BottomAppBar(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        getPadding(
            IconButton(
            icon: getIcon(icon1??IconPack.menu_line),
            onPressed: onPressed,
          ),
        ),
        Visibility(
          visible: onPressed1!=null,
          child: getPadding(IconButton(
            icon: getIcon(icon2??IconPack.dots_vertical),
            onPressed: onPressed1,
          ),
        ),
        )
      ],
    ),
    elevation: 10,
  );
}

getSignInLaterButton(BuildContext context){
  return getButton(
    "Sign in later!",
    onPressed: (){
      launchPage(context, HomePage());
    },
    variant: 2,
  );
}

getTabBar({@required List<String> items,@required List<int> selected, Function(int,bool) onSelected}){
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    shrinkWrap: true,
    itemCount: items.length,
    itemBuilder: (ctx,index){
      bool isSelected = selected.contains(index);
      return getPadding(
        getButton(
          items[index],
          variant: isSelected?1:2,
          onPressed: (){
            onSelected(index,!isSelected);
          },
        ),
      );
    },
  );
}

getIcon(IconData iconData,{Color color, double size}){


  if(color==null){
    color=getIconTextColor();
  }
  return Icon(iconData,size: size,color: color,);
}

getPopupMenuItem({@required int value,@required String name, @required IconData iconData,String description}){
  return PopupMenuItem(
    value: value,
    child: ListTile(
      trailing: getIcon(iconData),
      title: getText(name),
      subtitle: description!=null?getText(description,textType: TextType.textTypeSubNormal):null,
    ),
  );
}


getTextField(TextEditingController textEditingController,{String hint,@required int width,
  TextInputType textInputType,bool focus,int variant,Function(String) onChanged}){

    if(focus==null){
      focus = false;
    }

    if(textInputType==null){
      textInputType = TextInputType.text;
    }

    if(variant==null){
      variant=1;
    }

  return Container(
    width: width.toDouble(),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: variant==1?getGrayBackground():Colors.transparent),
    child: Center(
      child: Container(
        width: (width.toDouble()-30),
        child: TextFormField(
          onChanged: (str){onChanged(str);},
          autofocus: focus,
          keyboardType: textInputType,
          controller: textEditingController,
          style: TextStyle(fontSize: TextType.textTypeNormal.size,color: MyApp.isDarkMode?Colors.white:MyColors.color_black,fontWeight: TextType.textTypeNormal.fontWeight),
          decoration: InputDecoration.collapsed(
            hintText: hint??'',
            hintStyle: TextStyle(fontSize: TextType.textTypeNormal.size,color: MyApp.isDarkMode||(!MyApp.isDarkMode&&variant==1)?MyColors.color_gray_darker:MyColors.color_gray_lighter,fontWeight: TextType.textTypeNormal.fontWeight),
          ),
        ),
      ),
    ),
  );

}

getSkeletonView(int width,int height,{int radius}){
  return Container(
    height: height.toDouble(),
    width: width.toDouble(),
    decoration: BoxDecoration( color: MyColors.color_gray_darker,borderRadius: BorderRadius.circular(radius??7)),
  );
}



getButton(String text,{int variant,@required Function onPressed}){
  if(variant==null||variant>2){
    variant=1;
  }

  return FlatButton(
    child: getPadding(getText("$text",color: variant==1?Colors.white:MyApp.isDarkMode?MyColors.color_secondary:MyColors.color_primary),
      horizontal: 5,vertical: 7),
    onPressed: onPressed,
    shape: getShape(),
    color: variant==1?MyColors.color_secondary:Colors.transparent,
  );
}



getSwitchable({@required String text,@required bool checked,@required Function(bool) onCheckedChanged, @required bool isCheckboxOrSwitch, Color color}){
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      getPadding(isCheckboxOrSwitch?
        Checkbox(
          activeColor: MyColors.color_black,
          onChanged: onCheckedChanged,
          value: checked,
        ):
        Switch(
          onChanged: onCheckedChanged,
          value: checked,
        ),horizontal: 5,vertical: 0),
      getText(text,color: color),
    ],

  );
}

RoundedRectangleBorder getShape({bool bottomSheetShape,bool smallRadius, bool webCardShape}){

  if(bottomSheetShape==null){
    bottomSheetShape=false;
  }
  if(smallRadius==null){
    smallRadius=false;
  }

  if(webCardShape==null){
    webCardShape=false;
  }

  if(bottomSheetShape){
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      )
    );
  }else if(webCardShape){
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(15),
        bottomRight: Radius.circular(15),
      ),
    );
  }else{
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15)
    );
  }
}

Offset getWidgetPosition(GlobalKey key){

  final RenderBox renderBoxRed = key.currentContext.findRenderObject();
  final Offset positionRed = renderBoxRed.localToGlobal(Offset.zero);

  return positionRed;
}

Widget getAppBar(String title,{bool backEnabled,bool centered, BuildContext context,bool drawerEnabled}){
  if(centered==null){
    centered=false;
  }

  if(drawerEnabled==null){
    drawerEnabled=false;
  }
  if(backEnabled==null){
    backEnabled=false;
  }
  return PreferredSize(
    preferredSize: Size.fromHeight(85),
    child: getPadding(Align(
        alignment: centered?Alignment.bottomCenter:Alignment.bottomLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Visibility(
              visible: backEnabled,
              child: IconButton(icon: getIcon(IconPack.carret_backward),onPressed: (){Navigator.pop(context);},),
            ),
            Visibility(
              visible: drawerEnabled,
              child: IconButton(
                icon: getIcon(IconPack.menu_line,),
                onPressed: (){
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            getText(title, textType: TextType.textTypeTitle)
          ],
        ),
      ),horizontal: 10,vertical: 0),
  );
}

getPickDateButton(BuildContext buildContext,{@required DateTime dateTime,@required Function(DateTime) onDateTimeSet}){
  return getButton(
    dateTime==null?'Pick date': getStringFromDate(dateTime),
    variant: 2,
    onPressed: (){
      showDistivityDatePicker(
        buildContext,onDateSelected: (DateTime val){
          onDateTimeSet(val);
        }
      );
    },
  );
}



getOverFlowColor(){
  return MyApp.isDarkMode?MyColors.color_black_darker:Colors.white;
}

getBackgroundColor(){
  return MyApp.isDarkMode?MyColors.color_black:Colors.white;
}

getGrayBackground(){
  return !MyApp.isDarkMode?MyColors.color_gray_lighter:MyColors.color_gray_darker;
}

getIconTextColor(){
    return MyApp.isDarkMode?Colors.white:MyColors.color_black;
}



//Specific for this app

// getColorPickRow(int selected,Function(int) onSelected){
//   return Row(
//     mainAxisSize: MainAxisSize.min,
//     children: List.generate(8, (index){
//        return getPadding(getColorPickCircle(index, selected,onSelected: (){onSelected(index);}),vertical: 2,horizontal: 5,);
//     }),
//   );
// }

// getColorPickCircle(int color,int selectedColor,{Function onSelected}){
//   return Container(
//     width: 30,
//     height: 30,
//     decoration: BoxDecoration(
//       shape: BoxShape.circle,
//       color: getColorValue(color),
//       border: color==selectedColor? Border.all(color: MyApp.isDarkMode?Colors.white:MyColors.color_black,width: 5):null,
//     ),
//     child: GestureDetector(
//       onTap: (){
//         onSelected();
//       },
//     ),
//   );
// }

// Widget getColorPickerButton(BuildContext context, int color, Function(int) onColorSelected){
//     GlobalKey colorPickerGlobalKey = GlobalKey();

//     return getWidgetKey(colorPickerGlobalKey, 
//       getColorPickCircle(color, color,onSelected: (){
//         showDistivityPopupMenu(context,above: true,globalKey: colorPickerGlobalKey,
//           popupContentBuilder: (ctx,closePopup){
//             return getColorPickRow(color, (val){
//               onColorSelected(val);
//               closePopup();
//             });
//           });
//       }),);
//   }

getTipWidget(){


  List<String> tips = [
    'If you found some bug or you want to suggest some feature, send me some feedback(from the menu)',
    '80% of the results come from 20% of the efforts, so make sure to delete tasks that don\'t have enough importance',
    'Swipe left and right to plan your days in more detail',
    'You can see how important a task is by looking at how opaque the color of the task is',
    'You can see how much time a task is going to take by looking at how tall is it',
    'Productivity is not about how many tasks you need to get done, but choosing what tasks you need to get done',
    'Always remember to plan your days the night before(Swipe left and right to see an overview of your week)',
  ];

  return ListTile(
    leading: getIcon(IconPack.info,color: MyColors.color_secondary),
    title: getText(tips[Random().nextInt(tips.length-1)],maxLines: 5),
  );
}
