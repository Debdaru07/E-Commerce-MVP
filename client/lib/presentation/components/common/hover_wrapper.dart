import 'package:flutter/material.dart';

class HoverWrapper extends StatefulWidget {
  final Widget Function(bool hovered) builder;
  const HoverWrapper({super.key, required this.builder});

  @override
  State<HoverWrapper> createState() => _HoverWrapperState();
}

class _HoverWrapperState extends State<HoverWrapper> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: widget.builder(hovered),
    );
  }
}
