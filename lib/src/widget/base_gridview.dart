import 'package:draging_gridview_package/src/model/custom_drag_item.dart';
import 'package:draging_gridview_package/src/type/mutable_type.dart';
import 'package:draging_gridview_package/src/utils/move_types.dart';
import 'package:draging_gridview_package/src/widget/header_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DevStackGridViewItem extends StatefulWidget {
  const DevStackGridViewItem(
      {this.key,
      this.header,
      this.headerItemCount,
      this.reverse = false,
      this.headerGridDelegate,
      required this.itemBuilder,
      required this.onWillAccept,
      this.feedback,
      required this.onReorder,
      this.childWhenDragging,
      this.itemBuilderHeader,
      this.controller,
      this.isVertical = true,
      this.padding,
      this.semanticChildCount,
      this.physics,
      this.addAutomaticKeepAlives = true,
      this.addRepaintBoundaries = true,
      this.addSemanticIndexes = true,
      this.headerPadding,
      this.cacheExtent,
      this.itemCount,
      this.allHeaderChildNonDraggable = false,
      this.primary,
      this.isStickyHeader = false,
      this.onReorderHeader,
      this.onWillAcceptHeader,
      this.isCustomFeedback = false,
      this.isCustomChildWhenDragging = false,
      required this.gridDelegate,
      this.dragStartBehavior = DragStartBehavior.start,
      this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
      this.curve,
      this.animationDuration})
      : super(key: key);

  final Key? key;

  final bool reverse;
  final Widget? header;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;

  // If you want to set custom feedback child at the time of drag then set this parameter to true
  final bool isCustomFeedback;

  // If you want to set custom child at the time of drag then set this parameter to true
  final bool isCustomChildWhenDragging;

  // onWillAccept determine whether the drag object will accept or not. Based on that return a bool.
  final MutableTakeFunction onWillAccept;
  final MutableTakeFunction? onWillAcceptHeader;
  final bool allHeaderChildNonDraggable;
  final EdgeInsetsGeometry? headerPadding;

  // This method onReorder has two parameters oldIndex and newIndex
  final ReorderCallback onReorder;
  final ReorderCallback? onReorderHeader;

  final EdgeInsetsGeometry? padding;
  final int? headerItemCount;
  final bool isStickyHeader;
  final SliverGridDelegate? headerGridDelegate;
  final SliverGridDelegate gridDelegate;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? itemBuilderHeader;
  final int? itemCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final bool isVertical;
  final Curve? curve;
  final Duration? animationDuration;

  // set you feedback child here and to get this working please set isCustomFeedback to true
  final MutableIndexBFunc? feedback;

  // set you custom child here and to get this working please set isCustomChildWhenDragging to true
  final MutableIndexBFunc? childWhenDragging;

  @override
  _DevStackGridViewItemState createState() => _DevStackGridViewItemState();
}

class _DevStackGridViewItemState extends State<DevStackGridViewItem> {
  late final ScrollController scrollController;
  ScrollController? _scrollController2;
  var gridHeightSize, gridWidthSize;
  var dragingSTPosition = false;
  bool persSCTR = false;

  @override
  void initState() {
    super.initState();

    final cusSCtr = widget.controller;

    if (cusSCtr == null) {
      persSCTR = true;
      scrollController = ScrollController();
      _scrollController2 = ScrollController();
    } else {
      scrollController = cusSCtr;
    }
  }

  Widget dragingItemDropV() {
    return GridView.builder(
      key: widget.key,
      reverse: widget.reverse,
      shrinkWrap: true,
      controller: widget.header == null ? scrollController : _scrollController2,
      padding: widget.padding,
      scrollDirection: widget.isVertical ? Axis.vertical : Axis.horizontal,
      semanticChildCount: widget.semanticChildCount,
      physics: widget.physics,
      addSemanticIndexes: widget.addSemanticIndexes,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      cacheExtent: widget.cacheExtent,
      itemCount: widget.itemCount,
      primary: widget.primary,
      dragStartBehavior: widget.dragStartBehavior,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      itemBuilder: (context, pos) {
        var mainWidget = widget.itemBuilder(context, pos);
        if (mainWidget is DragItemView) {
          if (!mainWidget.isDraggable) {
            if (!mainWidget.isDropable) {
              return mainWidget;
            }
            return gridItemC(mainWidget, pos, isNonDraggable: true);
          }
        }

        return gridItemC(mainWidget, pos);
      },
      gridDelegate: widget.gridDelegate,
    );
  }

  Widget gridItemC(Widget mainWidget, int pos,
      {bool isFromArrangeP = false, bool isNonDraggable = false}) {
    return DragTarget(
      builder: (_, __, ___) => isNonDraggable
          ? mainWidget
          : slideableItemBuilder(mainWidget, pos,
              isFromArrange: isFromArrangeP),
      onWillAccept: (String? data) {
        if (data != null) {
          final onWillAcceptHeader = widget.onWillAcceptHeader;
          if (!isFromArrangeP) {
            return widget.onWillAccept(int.parse(data), pos);
          }
          return data.toString().contains("h") && onWillAcceptHeader != null
              ? onWillAcceptHeader(
                  int.parse(data.toString().replaceAll("h", "")), pos)
              : false;
        }

        return false;
      },
      onAccept: (String data) {
        if (isFromArrangeP) {
          if (data.toString().contains("h") && widget.onReorderHeader != null) {
            widget.onReorderHeader!(
                int.parse(data.toString().replaceAll("h", "")), pos);
          }
        } else {
          widget.onReorder(int.parse(data), pos);
        }
      },
    );
  }

  Widget slideableItemBuilder(Widget mainWidget, int pos,
      {bool isFromArrange = false}) {
    final feedback = widget.feedback;
    final childWhenDragging = widget.childWhenDragging;

    return LongPressDraggable(
      data: isFromArrange ? "h$pos" : "$pos",
      child: mainWidget,
      feedback: widget.isCustomFeedback && feedback != null
          ? feedback(pos)
          : mainWidget,
      childWhenDragging:
          widget.isCustomChildWhenDragging && childWhenDragging != null
              ? childWhenDragging(pos)
              : mainWidget,
      axis: isFromArrange
          ? widget.isVertical
              ? Axis.horizontal
              : Axis.vertical
          : null,
      onDragStarted: () {
        setState(() {
          dragingSTPosition = true;
        });
      },
      onDragCompleted: () {
        setState(() {
          dragingSTPosition = false;
        });
      },
    );
  }

  Widget slideableHorizantalBuilder() {
    return Row(
      children: [
        NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return true;
          },
          child: GridView.builder(
            shrinkWrap: true,
            padding: widget.headerPadding,
            gridDelegate: widget.headerGridDelegate ?? widget.gridDelegate,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, pos) {
              var mainWidget = widget.itemBuilderHeader!(context, pos);
              if (widget.allHeaderChildNonDraggable) {
                return mainWidget;
              }
              if (mainWidget is DragItemView) {
                if (!mainWidget.isDraggable) {
                  if (!mainWidget.isDropable) {
                    return mainWidget;
                  }
                  return gridItemC(mainWidget, pos,
                      isFromArrangeP: true, isNonDraggable: true);
                }
              }

              return gridItemC(mainWidget, pos, isFromArrangeP: true);
            },
            itemCount: widget.headerItemCount,
          ),
        ),
        Expanded(
          child: dragingItemDropV(),
        ),
      ],
    );
  }

  Widget gridTabBuilderWidget() {
    return Column(
      children: [
        NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return true;
          },
          child: GridView.builder(
            shrinkWrap: true,
            padding: widget.headerPadding,
            gridDelegate: widget.headerGridDelegate ?? widget.gridDelegate,
            itemBuilder: (context, pos) {
              var mainWidget = widget.itemBuilderHeader!(context, pos);
              if (widget.allHeaderChildNonDraggable) {
                return mainWidget;
              }
              if (mainWidget is DragItemView) {
                if (!mainWidget.isDraggable) {
                  if (!mainWidget.isDropable) {
                    return mainWidget;
                  }
                  return gridItemC(mainWidget, pos,
                      isFromArrangeP: true, isNonDraggable: true);
                }
              }

              return gridItemC(mainWidget, pos, isFromArrangeP: true);
            },
            itemCount: widget.headerItemCount,
          ),
        ),
        Expanded(
          child: dragingItemDropV(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final header = widget.header;
    return Stack(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          gridHeightSize = constraints.maxHeight;
          gridWidthSize = constraints.maxWidth;
          return widget.isStickyHeader
              ? widget.isVertical
                  ? gridTabBuilderWidget()
                  : slideableHorizantalBuilder()
              : header == null
                  ? dragingItemDropV()
                  : gridHeadItem(
                      header,
                      dragingItemDropV,
                      scrollController,
                    );
        }),
        !dragingSTPosition
            ? const SizedBox()
            : Align(
                alignment: widget.isVertical
                    ? Alignment.topCenter
                    : Alignment.centerRight,
                child: DragTarget(
                  builder:
                      (context, List<String?> candidateData, rejectedData) =>
                          Container(
                    height: widget.isVertical ? 20 : double.infinity,
                    width: widget.isVertical ? double.infinity : 20,
                    color: Colors.transparent,
                  ),
                  onWillAccept: (_) {
                    if (!widget.isVertical) {
                      moveToRightS(
                        scrollController,
                        widget.curve,
                        widget.animationDuration,
                        gridWidthSize,
                      );
                      return false;
                    }
                    moveToUpS(
                      scrollController,
                      widget.curve,
                      widget.animationDuration,
                      gridHeightSize,
                    );
                    return false;
                  },
                ),
              ),
        !dragingSTPosition
            ? const SizedBox()
            : Align(
                alignment: widget.isVertical
                    ? Alignment.bottomCenter
                    : Alignment.centerLeft,
                child: DragTarget(
                  builder:
                      (context, List<String?> candidateData, rejectedData) =>
                          Container(
                    height: widget.isVertical ? 20 : double.infinity,
                    width: widget.isVertical ? double.infinity : 20,
                    color: Colors.transparent,
                  ),
                  onWillAccept: (_) {
                    if (!widget.isVertical) {
                      moveToLeftS(
                        scrollController,
                        widget.curve,
                        widget.animationDuration,
                        gridWidthSize,
                      );
                      return false;
                    }
                    moveToDownS(
                      scrollController,
                      widget.curve,
                      widget.animationDuration,
                      gridHeightSize,
                    );
                    return false;
                  },
                ),
              ),
      ],
    );
  }

  @override
  void dispose() {
    if (persSCTR) {
      scrollController.dispose();
    }
    _scrollController2?.dispose();
    super.dispose();
  }
}
