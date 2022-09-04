import 'package:flutter/material.dart';

class IosIconWeb extends StatefulWidget {
  String? Name;
  String? IconsNames;

  IosIconWeb({Key? key, this.Name, this.IconsNames}) : super(key: key);

  @override
  State<IosIconWeb> createState() => _IosIconWebState();
}

class _IosIconWebState extends State<IosIconWeb> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Image.asset(widget.IconsNames!)),
        const SizedBox(
          height: 5,
        ),
        Text(
          widget.Name!,
          style: const TextStyle(
              fontFamily: 'SFpro', fontSize: 20, color: Colors.white),
        )
      ],
    );
  }
}
