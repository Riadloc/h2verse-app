import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final colorizeColors = [
    Colors.white,
    Colors.red,
    Colors.orange,
    Colors.yellow,
  ];

  @override
  Widget build(BuildContext context) {
    Color bgColor = Theme.of(context).backgroundColor;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        toolbarHeight: 0,
      ),
      body: Center(
        child: Shimmer.fromColors(
          baseColor: Colors.black38,
          highlightColor: Colors.white,
          child: Text(
            'H2VERSE',
            style: GoogleFonts.limelight(
              fontSize: 50.0,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }
}
