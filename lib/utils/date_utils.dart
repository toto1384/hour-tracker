
import 'package:intl/intl.dart';

DateFormat _getDateFormat(){
  
  return DateFormat('HH:mm');
}

DateFormat getForSaveFormat(){
    return DateFormat('HH:00 : dd-MM-yy');
}

DateTime getDateFromString(String string){
  if(string==null||string.trim()==''){
    return null;
  }

  return _getDateFormat().parse(string);
}

getStringFromDate(DateTime dateTime){
  if(dateTime==null){
    return null;
  }else{
    return _getDateFormat().format(dateTime);
  }
  
}

DateTime getOneHourFromNow(){
  return DateTime.now().subtract(Duration(minutes: DateTime.now().minute)).add(Duration(hours: 1));
}

DateTime getThisHour(){
  return DateTime.now().subtract(Duration(minutes: DateTime.now().minute));
}


//For this project 