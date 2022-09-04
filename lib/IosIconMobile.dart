import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IosIconMobile extends StatefulWidget {
  String? Name;
  String? IconsNames;

  IosIconMobile({
    this.Name, this.IconsNames
  });

  @override
  State<IosIconMobile> createState() => _IosIconMobileState();
}

class _IosIconMobileState extends State<IosIconMobile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(widget.IconsNames!,scale: 2.7,),
        SizedBox(height: 5,),
        Text(widget.Name!,style: TextStyle(
            fontFamily: 'SFpro',
            color: Colors.white
        ),)
      ],
    );
  }
}
