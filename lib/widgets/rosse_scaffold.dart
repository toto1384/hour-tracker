import 'package:flutter/material.dart';
import 'package:hour_tracker/utils/get_widget_utils.dart';
import 'package:hour_tracker/utils/typedef_and_enums_utils.dart';


class RosseScaffold extends StatefulWidget {
  

  final List<Widget> primaryItems;
  final List<Widget> secondaryItems;
  final String title;
  final bool isTitleCentered;
  final bool secondaryBodyAlwaysRed;
  final Color color;


  RosseScaffold(this.title,{Key key,@required this.primaryItems,@required this.secondaryItems, this.isTitleCentered, this.secondaryBodyAlwaysRed,@required this.color}) : super(key: key);

  @override
  _RosseScaffoldState createState() => _RosseScaffoldState();
}

class _RosseScaffoldState extends State<RosseScaffold> {

  

  @override
  Widget build(BuildContext context) {

    return getSmallScreen();
  }
  getSmallScreen(){
    List<Widget> smallScreenItems = widget.secondaryBodyAlwaysRed??false?widget.primaryItems:widget.primaryItems+widget.secondaryItems;

    return Scaffold(
      backgroundColor: widget.color,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: Container(),
              expandedHeight: widget.secondaryBodyAlwaysRed??false?350:100,
              floating: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: widget.isTitleCentered??false,
                  title: getText(widget.title,textType: TextType.textTypeSubtitle,color: Colors.white),
                  background: Stack(
                    children: <Widget>[
                      Container(
                        color: widget.color,
                      ),
                      widget.secondaryBodyAlwaysRed??false?Center(child: Row(mainAxisSize: MainAxisSize.min,children: widget.secondaryItems,),):Container()
                    ],
                  )
              ),
            ),
          ];
        },
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: getOverFlowColor(),borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15))),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: smallScreenItems,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}