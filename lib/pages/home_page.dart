import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hour_tracker/database.dart';
import 'package:hour_tracker/hour_object.dart';
import 'package:hour_tracker/utils/date_utils.dart';
import 'package:hour_tracker/utils/get_popup_and_sheets_utils.dart';
import 'package:hour_tracker/utils/get_widget_utils.dart';
import 'package:hour_tracker/utils/typedef_and_enums_utils.dart';
import 'package:hour_tracker/widgets/rosse_scaffold.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  HourTheme hourTheme;
  DateTime daySelected;
  List<HourObject> hourObjects;


  @override
  void initState() {
    super.initState();
    scheduleFuture();
  }

  scheduleFuture(){
    Future.delayed(Duration(minutes: 1),(){setState(() {
      scheduleFuture();
    });});
  }

  @override
  Widget build(BuildContext context) {
    if(daySelected==null){
      daySelected=getThisHour();
    }

    return FutureBuilder(
      future: DataHelper.getInstance(context),
      builder: (context,AsyncSnapshot<DataHelper> snapshot) {

        if(snapshot.hasData&& hourObjects==null){
          hourObjects = snapshot.data.getHours(daySelected);
        }

        if(snapshot.hasData && hourTheme==null){
          hourTheme = hourObjects[getCurrentHourIndex()].hourTheme;
        }
        return RosseScaffold(
           '${getStringFromDate(DateTime.now())} -> ${getStringFromDate(getOneHourFromNow())}',
           primaryItems: <Widget>[
             Padding(
               padding: const EdgeInsets.all(15),
               child: Center(
                 child: DropdownButton<HourTheme>(
                   hint: getText('Select activity'),
                   value: hourTheme,
                   items: (List<HourTheme>.generate(9, (ind){return getThemeFromIndex(ind);})) .map((HourTheme value) {
                      return new DropdownMenuItem<HourTheme>(
                        value: value,
                        child: getText(getThemeText(value),),
                      );
                    }).toList(),
                   onChanged: (val) {
                      setState(() {
                        hourTheme=val;
                        if(snapshot.hasData){
                          hourObjects[getCurrentHourIndex()].hourTheme = val;
                          snapshot.data.addHour(hourObjects[getCurrentHourIndex()],getThisHour());
                        }
                      });
                    },
                  ),
               ),
             ),
             getButton(
              'Pick date',
              onPressed: (){
                showDistivityDatePicker(
                  context,
                  onDateSelected: (dt){
                    setState(() {
                      daySelected=dt;
                    });
                  },
                  );
              },
              variant: 2,

            ),
            snapshot.hasData?Column(
              mainAxisSize: MainAxisSize.min,
              children: List<Widget>.generate(
                hourObjects.length,
                (ind){
                    print(hourObjects[ind].hourTheme);
                    return Card(
                      shape: getShape(),
                      color: getThemeColor(hourObjects[ind].hourTheme),
                      child: ListTile(
                        title: Visibility(
                          visible: hourObjects[ind].name!=null&&hourObjects[ind].name!="",
                          child: getSwitchable(
                            color: Colors.white,
                            text: hourObjects[ind].name??'',
                            checked: hourObjects[ind].checked,
                            onCheckedChanged: (val){
                              setState(() {
                                hourObjects[ind].checked=val;
                                snapshot.data.addHour(hourObjects[ind],getThisHour());
                              });
                            },
                            isCheckboxOrSwitch: true,
                          ),
                        ),
                        onTap: (){
                          showDistivityModalBottomSheet(context , (ctx,ss){
                            TextEditingController nameTEC = TextEditingController(text: hourObjects[ind].name);
                            HourTheme thisHourTheme = hourObjects[ind].hourTheme;
                            HourTheme thisGoalHourTheme = hourObjects[ind].goalHourTheme;
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                getPadding(getButton('Save', onPressed: (){
                                  setState(() {
                                    hourObjects[ind].name=nameTEC.text;
                                    hourObjects[ind].hourTheme = thisHourTheme;
                                    hourObjects[ind].goalHourTheme = thisGoalHourTheme;
                                    snapshot.data.addHour(hourObjects[ind],getThisHour());
                                  });
                                  Navigator.pop(context);
                                }),),

                                getTextField(nameTEC, width: 250,hint:'Hour name' ),

                                DropdownButton<HourTheme>(
                                  hint: getText('Select activity'),
                                  value: thisHourTheme,
                                  items: (List<HourTheme>.generate(9, (ind){return getThemeFromIndex(ind);})) .map((HourTheme value) {
                                      return new DropdownMenuItem<HourTheme>(
                                        value: value,
                                        child: getText(getThemeText(value),),
                                      );
                                    }).toList(),
                                  onChanged: (val) {
                                      setState(() {
                                        thisHourTheme=val;
                                      });
                                    },
                                ),

                                DropdownButton<HourTheme>(
                                  hint: getText('Select goal activity'),
                                  value: thisGoalHourTheme,
                                  items: (List<HourTheme>.generate(9, (ind){return getThemeFromIndex(ind);})) .map((HourTheme value) {
                                      return new DropdownMenuItem<HourTheme>(
                                        value: value,
                                        child: getText(getThemeText(value),),
                                      );
                                    }).toList(),
                                  onChanged: (val) {
                                      setState(() {
                                        thisGoalHourTheme=val;
                                      });
                                    },
                                ),
                              ],
                            );
                          },hideHandler: true);
                        },
                        leading: getText(getForSaveFormat().format(hourObjects[ind].dateTime)??'',color: Colors.white,textType: TextType.textTypeSubNormal),
                        trailing: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            getText(getThemeText(hourObjects[ind].hourTheme)??'',color: Colors.white,textType: TextType.textTypeSubNormal),
                            getPadding(CircleAvatar(radius: 7,backgroundColor: getThemeColor(hourObjects[ind].goalHourTheme),))
                          ],
                        ),
                      ),
                    );
                }
              ),
            ):Center(child: CircularProgressIndicator(),)
           ], 
           secondaryItems: <Widget>[
             CountdownFormatted(
                duration: getOneHourFromNow().difference(DateTime.now()),
                builder: (BuildContext ctx, String remaining) {
                  return getText(remaining,textType: TextType.textTypeGigant,color: Colors.white); // 01:00:00
                },
              ),
            ],
           color: getThemeColor(hourTheme),
           secondaryBodyAlwaysRed: true,
           isTitleCentered: true,
        );
      }
    );
  }

  getCurrentHourIndex(){
    int index= 0;
    hourObjectsForEach((i,k){
      if(k.dateTime.hour==getThisHour().hour){
        index=i;
      }
    });
    return index;
  }

  hourObjectsForEach(Function(int,HourObject) function){
    for(int i = 0 ; i< hourObjects.length;i++){
      function(i,hourObjects[i]);
    }
  }
}

enum HourTheme{
  Programming,
  Business,
  GraphicDesign,
  System,
  Learn,
  Think,
  ProductDesign,
  PrepareActions,
  Nothing
}

getThemeFromIndex(int index){
  switch(index){
    case 0: return HourTheme.Programming; break;
    case 1: return HourTheme.Business; break;
    case 2: return HourTheme.GraphicDesign; break;
    case 3: return HourTheme.System; break;
    case 4: return HourTheme.Learn; break;
    case 5: return HourTheme.Think; break;
    case 6: return HourTheme.ProductDesign; break;
    case 7: return HourTheme.PrepareActions; break;
    case 8: return HourTheme.Nothing;break;
  }
}

getIndexFromTheme(HourTheme hourTheme){
  switch(hourTheme){
    
    case HourTheme.Programming:
      return 0;
      break;
    case HourTheme.Business:
      return 1;
      break;
    case HourTheme.GraphicDesign:
      return 2;
      break;
    case HourTheme.System:
      return 3;
      break;
    case HourTheme.Learn:
      return 4;
      break;
    case HourTheme.Think:
      return 5;
      break;
    case HourTheme.ProductDesign:
      return 6;
      break;
    case HourTheme.PrepareActions:
      return 7;
      break;
    case HourTheme.Nothing:
      return 8;
      break;
  }
}

getThemeText(HourTheme hourTheme){

  switch(hourTheme){
    case HourTheme.Programming:
      return 'Programming';
      break;
    case HourTheme.Business:
      return 'Business';
      break;
    case HourTheme.GraphicDesign:
      return 'Graphic Design';
      break;
    case HourTheme.System:
      return 'System';
      break;
    case HourTheme.Learn:
      return 'Learn';
      break;
    case HourTheme.Think:
      return 'Think';
      break;
    case HourTheme.ProductDesign:
      return 'Product Design';
      break;
    case HourTheme.PrepareActions:
      return 'Prepare actions';
      break;
    case HourTheme.Nothing:
      return 'Nothing';
      break;
  }
}

getThemeColor(HourTheme hourTheme){

  if(hourTheme==null){
    return Color(0xff161616);
  }

  switch(hourTheme){
    
    case HourTheme.Programming:
      return Color(0xff6a8caf);
      break;
    case HourTheme.Business:
      return Color(0xffa7e9af);
      break;
    case HourTheme.GraphicDesign:
      return Color(0xffc295d8);
      break;
    case HourTheme.System:
      return Color(0xffeb8242);
      break;
    case HourTheme.Learn:
      return Color(0xfff0cf85);
      break;
    case HourTheme.Think:
      return Color(0xffe3c878);
      break;
    case HourTheme.ProductDesign:
      return Color(0xff39375b);
      break;
    case HourTheme.PrepareActions:
      return Color(0xffbd574e);
      break;
    case HourTheme.Nothing:
      return Color(0xff161616);
      break;
  }
}