import 'package:flutter/material.dart';
import 'package:pomodoro/data.dart';

class ColorPickerRow extends StatefulWidget {
  const ColorPickerRow({super.key});

  @override
  State<ColorPickerRow> createState() => _ColorPickerRowState();
}

class _ColorPickerRowState extends State<ColorPickerRow> {
  final List<Color> colors = [
    Colors.red.shade400,
    Colors.green.shade400,
    Colors.blue.shade400,
    Colors.yellow.shade400,
    Colors.purple.shade400,
    Colors.cyan.shade400,
  ];
  final Data data = Data();

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(colors.length, (index) {
        final bool isSelected = index == selectedIndex;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
              data.newTask["color"] = index;
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors[index],
              border: isSelected
                  ? Border.all(color: Colors.black, width: 3)
                  : null,
            ),
            width: 30,
            height: 30,
          ),
        );
      }),
    );
  }
}
