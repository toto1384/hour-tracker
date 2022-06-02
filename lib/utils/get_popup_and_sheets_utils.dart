import 'dart:async';

import 'package:flutter/material.dart';

import '../main.dart';
import 'get_widget_utils.dart';
import 'typedef_and_enums_utils.dart';
import 'values_utils.dart';

showDistivityPopupMenu(BuildContext context,{@required GlobalKey globalKey,@required ReturnChild popupContentBuilder,bool above}){

  // try not to lose your braincells challenge

  if(above==null){
    above=false;
  }

  Completer<OverlayEntry> future = Completer();

  Offset positionRed = getWidgetPosition(globalKey);

  future.complete(
    OverlayEntry(
      builder: (ctx){
        return getPadding(Stack(
            children: <Widget>[
              Positioned.fill(
                child: GestureDetector(
                  onTap: (){
                    future.future.then((entry){
                      entry.remove();
                    });
                  },
                  child: Container(
                    color: MyColors.color_black_darker.withOpacity(0.7),
                  ),
                ),
              ),
              Positioned(
                top: above?positionRed.dy-30:positionRed.dy,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Card(
                    elevation: 10,
                    color: getOverFlowColor(),
                    shape: getShape(),
                    child: popupContentBuilder(ctx,(){
                      future.future.then((entry){
                        entry.remove();
                      });
                    }),
                  ),
                ),
              ),
            ],
          ),);
      },
    )
  );

  future.future.then((entry){
    Overlay.of(context).insert(entry);
  });
}

showDistivityDialog(BuildContext context,{@required List<Widget> actions ,@required String title,@required StateGetter stateGetter}){

  showDialog(context: context,builder: (ctx){
    return StatefulBuilder(
      builder: (ctx,setState){
        return AlertDialog(
          backgroundColor: MyApp.isDarkMode?MyColors.color_black_darker:Colors.white,
          shape: getShape(),
          actions: [
            getPadding(Row(
                mainAxisSize: MainAxisSize.min,
                children: actions
              ),)
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              getPadding(getText(title,textType: TextType.textTypeSubtitle),vertical: 20,horizontal: 0),
              stateGetter(context,(func){
                setState((){
                  func();
                });
              }),
            ],
          ),
        );
      },
    );
  });
}

showDistivityModalBottomSheet(BuildContext context, StateGetter stateGetter,{bool hideHandler}){

  if(hideHandler==null){
    hideHandler=false;
  }


  showModalBottomSheet(
    shape: getShape(bottomSheetShape: true),
    backgroundColor: getOverFlowColor(),
    isScrollControlled: true,context: context,builder: (ctx){
      return StatefulBuilder(
        builder: (ctx,setState){
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Visibility(
                    visible: !hideHandler,
                    child: getPadding(GestureDetector(
                        onTap: (){Navigator.pop(context);},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            getSkeletonView(75, 4)
                          ],
                        ),
                      ),vertical: 15,horizontal: 0),
                  ),
                  stateGetter(context,(func){
                      setState((){
                        func();
                      });
                    }),
                ],
              ),
            ),
          );
        },
      );
  },
  );
}

showDistivityDatePicker(BuildContext context,{@required Function(DateTime) onDateSelected}){

  Future<DateTime> dateTime =showDatePicker(
    context: context,
    firstDate: DateTime.now().subtract(Duration(days: 30)),
    lastDate: DateTime(2050),
    initialDate: DateTime.now(),
  );

  dateTime.then((onValue){
    onDateSelected(onValue);
  });

}