import 'dart:html';
import 'dart:io';
import 'dart:ui' as one;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled2/HomeWeb.dart';
import 'package:untitled2/MobileWeb.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pspdfkit_flutter/src/main.dart';

import 'IosIconWeb.dart';



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {

    return MediaQuery.of(context).size.width > 1000 ?
    HomeWeb():MobileWeb();
  }
}

