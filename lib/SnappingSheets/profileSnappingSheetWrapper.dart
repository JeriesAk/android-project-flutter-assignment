import 'package:flutter/material.dart';
import 'package:flutter_app/Authentication/UserState.dart';
import 'package:flutter_app/ProfilePage/profilePage.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'dart:ui' as ui;

class ProfileSnappingSheetWrapper extends StatefulWidget {
  final Widget Function() _body;

  ProfileSnappingSheetWrapper(this._body);

  @override
  _ProfileSnappingSheetWrapperState createState() =>
      _ProfileSnappingSheetWrapperState(this._body);
}

class _ProfileSnappingSheetWrapperState
    extends State<ProfileSnappingSheetWrapper> {
  final Widget Function() _body;
  final SnappingSheetController _snappingSheetController =
      SnappingSheetController();
  var _arrowIcon = Icons.keyboard_arrow_up;
  var _isDragged = false;
  final _textStyle = TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontFamily: 'Montserrat',
  );

  _ProfileSnappingSheetWrapperState(this._body);

  void _setIsDragged(bool value) {
    setState(() {
      _isDragged = value;
      _arrowIcon = _isDragged ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up;
    });
  }


  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);
    const double sheetGrabbingHeight = 60;
    const double openSheetPosition = 200.0;
    final closedSheetPosition = sheetGrabbingHeight / 2;

    final onArrowTap = () =>
    setState(() {
      if(_arrowIcon == Icons.keyboard_arrow_up) {
        _arrowIcon = Icons.keyboard_arrow_down;
        _snappingSheetController.setSnappingSheetPosition(openSheetPosition);
        _isDragged = true;
      } else {
        _arrowIcon = Icons.keyboard_arrow_up;
        _snappingSheetController.setSnappingSheetPosition(closedSheetPosition);
        _isDragged = false;
      }

    });

    final snappingSheet = () {
      final text = Row(children: [
        Text(
          'Welcome back ${userState.user.email}',
          style: _textStyle,
          textAlign: TextAlign.left,
        ),
        Icon(_arrowIcon)
      ], mainAxisAlignment: MainAxisAlignment.spaceBetween);


      const sheetSnappingPositions = [
        SnappingPosition.factor(
          positionFactor: 0.0,
          snappingCurve: Curves.easeOutExpo,
          snappingDuration: Duration(seconds: 1),
          grabbingContentOffset: GrabbingContentOffset.top,
        ),
        SnappingPosition.pixels(
          positionPixels: openSheetPosition,
          snappingCurve: Curves.elasticOut,
          snappingDuration: Duration(milliseconds: 1750),
        ),
        SnappingPosition.factor(
          positionFactor: 1.0,
          snappingCurve: Curves.bounceOut,
          snappingDuration: Duration(seconds: 1),
          grabbingContentOffset: GrabbingContentOffset.bottom,
        ),
      ];

      return SnappingSheet(
        snappingPositions: sheetSnappingPositions,
        lockOverflowDrag: true,
        onSheetMoved: (position) {
          if(position > closedSheetPosition) {
            _setIsDragged(true);
          } else {
            _setIsDragged(false);
          }
        },
        child: _isDragged
            ? Stack(children: [
                _body(),
                BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaY: 2.0, sigmaX: 2.0),
                    child: Container(color: Colors.transparent))
              ])
            : _body(),
        grabbingHeight: sheetGrabbingHeight,
        controller: _snappingSheetController,
        sheetBelow: SnappingSheetContent(
            draggable: true, child: ProfilePage(userState.user.email)),
        grabbing: GestureDetector(
            onTap: onArrowTap,
            child: Container(
              child: Center(
                child: Padding(
                  child: text,
                  padding: EdgeInsets.all(16.0),
                ),
                widthFactor: 0.2,
              ),
              color: Colors.grey,
              height: 20.0,
            )),
      );
    };

    return userState.isUserLoggedIn() ? snappingSheet() : _body();
  }
}
