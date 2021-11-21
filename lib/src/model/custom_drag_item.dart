import 'package:flutter/material.dart';

class DragItemView extends StatefulWidget {
  final Key? key;
  final bool isDraggable;
  final bool isDropable;
  final Widget child;

  const DragItemView({
    this.key,
    this.isDraggable = true,
    this.isDropable = true,
    required this.child,
  }) : super(key: key);

  @override
  _DragItemViewState createState() => _DragItemViewState();
}

class _DragItemViewState extends State<DragItemView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.key,
      child: widget.child,
    );
  }
}
