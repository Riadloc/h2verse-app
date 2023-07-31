import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

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
        child: Animate(
          effects: const [ShimmerEffect(duration: Duration(milliseconds: 500))],
          child: Text(
            'H2VERSE',
            style: GoogleFonts.limelight(
              fontSize: 50.0,
              color: Colors.black38,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }
}
