import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hour_tracker/pages/home_page.dart';
import 'utils/get_widget_utils.dart';

void main() => runApp(MyApp());


class MyApp extends StatefulWidget{

  
  static bool isDarkMode = false;
  static bool firstTime = true;

  static restartApp(BuildContext context) {
    final MyAppState state =
        context.findAncestorStateOfType<MyAppState>();
    state.restartApp();
  }

  @override
  MyAppState createState() {
    return MyAppState();
  }

}

class MyAppState extends State<MyApp>{

  Key key = new UniqueKey();

  void restartApp() {
    this.setState(() {
      key = new UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
              title: 'Rosse',
              theme: getAppTheme(),
              darkTheme: getAppDarkTheme(),
              home: HomePage(),
              debugShowCheckedModeBanner: false,
              themeMode: MyApp.isDarkMode?ThemeMode.dark:ThemeMode.light,
          );

  }

}
