

import 'package:flutter/cupertino.dart';
import 'package:hour_tracker/pages/home_page.dart';
import 'package:hour_tracker/utils/date_utils.dart';

class HourObject{
  DateTime dateTime;
  String name;
  bool checked;
  HourTheme goalHourTheme;
  HourTheme hourTheme;

  HourObject({@required this.dateTime, this.name,  this.checked,  this.goalHourTheme, this.hourTheme});

  toMap(){
    return {
      hour_object_date_time: getForSaveFormat().format(dateTime),
      hour_object_name: name,
      hour_object_checked: checked??false?1:0,
      hour_object_goal_hour_theme: getIndexFromTheme(goalHourTheme),
      hour_object_hour_theme: getIndexFromTheme(hourTheme),
    };
  }
  
  static fromMap(Map map){
    return HourObject(
      checked: map[hour_object_checked]==1,
      dateTime: getForSaveFormat().parse(map[hour_object_date_time]),
      goalHourTheme: getThemeFromIndex(map[hour_object_goal_hour_theme]),
      hourTheme: getThemeFromIndex(map[hour_object_hour_theme]),
      name: map[hour_object_name],
    );
  }
}

const String hour_object_date_time = 'd';
const String hour_object_name = 'n';
const String hour_object_checked = 'c';
const String hour_object_goal_hour_theme = 'g';
const String hour_object_hour_theme = 'h';