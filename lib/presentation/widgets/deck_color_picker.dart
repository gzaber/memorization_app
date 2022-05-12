import 'package:flutter/material.dart';

class DeckColorPicker extends StatefulWidget {
  const DeckColorPicker({
    Key? key,
  }) : super(key: key);

  @override
  State<DeckColorPicker> createState() => _DeckColorPickerState();
}

class _DeckColorPickerState extends State<DeckColorPicker> {
  final double sideLength = 60.0;
  late Color currentColor;

  @override
  void initState() {
    currentColor = const Color(0xffff8a80);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                currentColor = Color(colors[index]);
              });
            },
            child: Container(
              margin: currentColor == Color(colors[index])
                  ? const EdgeInsets.symmetric(horizontal: 10.0)
                  : const EdgeInsets.all(10.0),
              width: currentColor == Color(colors[index])
                  ? sideLength + 20.0
                  : sideLength,
              height: currentColor == Color(colors[index])
                  ? sideLength + 10.0
                  : sideLength,
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
