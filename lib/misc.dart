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

class RepeatPicker extends StatefulWidget {
  const RepeatPicker({super.key});

  @override
  State<RepeatPicker> createState() => _RepeatPicker();
}

class _RepeatPicker extends State<RepeatPicker> {
  final List<String> repeats = ["Daily", "Weekly", "Monthly", "Never"];
  int selected = 0;
  Data data = Data();

  @override
  Widget build(BuildContext context) {
    for (int i=0; i<repeats.length; i++) {
      if (repeats[i]==data.newWork["repeat"]) {
        selected = i;
      }
    }
    return Row(
      spacing: 0,
      children: List.generate(repeats.length, (index) {
        final bool isSelected = index==selected;
        return GestureDetector(
          onTap: () {
            setState(() {
              selected = index;
              data.newWork["repeat"] = repeats[index];
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: isSelected
                  ? Border.all(color: Colors.black, width: 3)
                  : null,
            ),
            width: 69,
            height: 30,
            child: Center(child: Text(repeats[index])),
          ),
        );
      })
    );
  }
}

class IconGrid extends StatefulWidget {
  const IconGrid({super.key});

  @override
  State<IconGrid> createState() => _IconGrid();
}

class _IconGrid extends State<IconGrid> {
  List<IconData> icons = [Icons.check_circle, Icons.check_box, Icons.calendar_today, Icons.alarm, Icons.event, Icons.star, Icons.flag, Icons.priority_high, Icons.work, Icons.home, Icons.school, Icons.fitness_center, Icons.shopping_cart, Icons.book, Icons.movie, Icons.music_note, Icons.restaurant, Icons.flight, Icons.directions_car, Icons.pets, Icons.lightbulb, Icons.note, Icons.mail, Icons.phone, Icons.cloud, Icons.bug_report, Icons.lock, Icons.star_border, Icons.label, Icons.hourglass_empty];
  int selected = 0;
  Data data = Data();

  @override
  Widget build(BuildContext context) {
    selected = data.newWork["icon"]-2;
    return Container(
      height: 260,
      width: 320,
      child: GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 6,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(30, (index) {
          final bool isSelected = index==selected;
          return GestureDetector(
            onTap: () {
              setState(() {
                selected = index;
                data.newWork["icon"] = index+2;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: isSelected
                    ? Border.all(color: Colors.black, width: 1)
                    : null,
              ),
              child: Icon(icons[index]),
            ),
          );
        }),
      )
    );
  }
}