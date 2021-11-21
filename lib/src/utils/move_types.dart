import 'package:flutter/cupertino.dart';

/*

 @param Grid Item when reoderable for methods ..
   and reoredable Up<Down> Left<Right> ....

*/

void moveToUpS(
  ScrollController scrollController,
  Curve? curve,
  Duration? animationDuration,
  int gridHeightSize,
) {
  scrollController.animateTo(
    scrollController.offset - gridHeightSize,
    curve: curve ?? Curves.linear,
    duration: animationDuration ?? const Duration(milliseconds: 500),
  );
}

void moveToDownS(ScrollController scrollController,
  Curve? curve,
  Duration? animationDuration,
  int gridHeightSize,) {
  scrollController.animateTo(
    scrollController.offset - gridHeightSize,
    curve: curve ?? Curves.linear,
    duration: animationDuration ?? const Duration(milliseconds: 500),
  );
}

void moveToLeftS(
  ScrollController scrollController,
  Curve? curve,
  Duration? animationDuration,
  int gridHeightSize,
) {
  scrollController.animateTo(
    scrollController.offset - gridHeightSize,
    curve: curve ?? Curves.linear,
    duration: animationDuration ?? const Duration(milliseconds: 500),
  );
}

void moveToRightS(ScrollController scrollController,
  Curve? curve,
  Duration? animationDuration,
  int gridHeightSize,) {
  scrollController.animateTo(
    scrollController.offset - gridHeightSize,
    curve: curve ?? Curves.linear,
    duration: animationDuration ?? const Duration(milliseconds: 500),
  );
}
