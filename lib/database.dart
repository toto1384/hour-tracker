
import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/cupertino.dart';
import 'package:hour_tracker/hour_object.dart';
import 'package:hour_tracker/pages/home_page.dart';
import 'package:hour_tracker/utils/date_utils.dart';
import 'package:path/path.dart';
import "package:path_provider/path_provider.dart";

class DataHelper{

  static const String fileName = 'user.json';


  Map<String,dynamic> user;
  io.Directory localDirectory;
  Function onDataUpdated;
  int timesOpened;



  static DataHelper _dataHelper;

  static Future<DataHelper> getInstance(BuildContext context)async{

    if(_dataHelper==null){
      _dataHelper=DataHelper();
    }

      if(_dataHelper.localDirectory==null){
        _dataHelper.localDirectory =await getApplicationDocumentsDirectory();
      

      io.File file = io.File(join(_dataHelper.localDirectory.path,fileName));

      if(!await file.exists()){
        await file.create();
        await file.writeAsString(json.encode({
          'firstValue':true,
        }));
        _dataHelper.user = Map();
      }else{
        _dataHelper.user = jsonDecode((await file.readAsString())??json.encode(Map()));
      }
    }

    return _dataHelper;
  }



  List<HourObject> getHours(DateTime dateTime){

    List hourMaps =  user['${getForSaveFormat().format(DateTime(dateTime.year,dateTime.month,dateTime.day))}']??getSkeletList(dateTime);

    List<HourObject> toReturn = List();

    for(int i = 0;i<16;i++){
      DateTime toGetDateTime = DateTime(dateTime.year,dateTime.month,dateTime.day,i+6);

      toReturn.add(HourObject.fromMap(hourMaps[i]??HourObject(dateTime: toGetDateTime).toMap()));
    }
    return toReturn;
  }

  getSkeletList(DateTime dateTime){
    return List.generate(16, (i){
      return HourObject(hourTheme: HourTheme.Nothing, dateTime: DateTime(dateTime.year,dateTime.month,dateTime.day,i+6)).toMap();
    });
  }

  addHour(HourObject hourObject, DateTime dateTime){


    List hourMaps =  user['${getForSaveFormat().format(DateTime(dateTime.year,dateTime.month,dateTime.day))}']??getSkeletList(dateTime);

    
    for(int i = 0 ; i < hourMaps.length ; i++){
      if(hourMaps[i][hour_object_date_time]==getForSaveFormat().format(hourObject.dateTime)){
        hourMaps[i]=hourObject.toMap();
      }
    }

    user['${getForSaveFormat().format(DateTime(dateTime.year,dateTime.month,dateTime.day))}']=hourMaps;
    saveJson();
  }






  

  saveJson()async{
    await io.File(join(localDirectory.path,fileName)).writeAsString(jsonEncode(user));
    if(onDataUpdated!=null){
      onDataUpdated();
    }
  }

  deleteJson()async{
    await io.File(join(localDirectory.path,fileName)).delete();
    if(onDataUpdated!=null){
      onDataUpdated();
    }
  }


}




