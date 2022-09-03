import 'package:flutter/material.dart';

class DeckColorPicker extends StatefulWidget {
  const DeckColorPicker({
    Key? key,
    required this.color,
    required this.onColorChanged,
  }) : super(key: key);

  final int color;
  final Function(int) onColorChanged;

  @override
  State<DeckColorPicker> createState() => _DeckColorPickerState();
}

class _DeckColorPickerState extends State<DeckColorPicker> {
  late int _color;
  final double sideLength = 60;

  @override
  void initState() {
    _color = widget.color;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller:
            ScrollController(initialScrollOffset: colors.indexOf(_color) * 70),
        itemCount: colors.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                _color = colors[index];
                widget.onColorChanged(_color);
              });
            },
            child: Container(
              margin: _color == colors[index]
                  ? const EdgeInsets.symmetric(horizontal: 10)
                  : const EdgeInsets.all(10),
              width: _color == colors[index] ? sideLength + 20 : sideLength,
              height: _color == colors[index] ? sideLength + 10 : sideLength,
              color: Color(
                colors[index],
              ),
            ),
          );
        },
      ),
    );
  }
}

const List<int> colors = [
  0xffff8a80,
  0xffff80ab,
  0xffea80fc,
  0xffb388ff,
  0xff8c9eff,
  0xff82b1ff,
  0xff80d8ff,
  0xff84ffff,
  0xffa7ffeb,
  0xffb9f6ca,
  0xffccff90,
  0xfff4ff81,
  0xffffe57f,
  0xffffd180,
  0xffff9e80,
];
