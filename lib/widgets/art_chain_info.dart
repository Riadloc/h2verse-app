import 'package:flutter/material.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/utils/helper.dart';
import 'package:h2verse_app/widgets/copy_field.dart';

class ArtChainInfo extends StatelessWidget {
  const ArtChainInfo({Key? key, required this.token}) : super(key: key);

  final String token;
  final EdgeInsetsGeometry padding = const EdgeInsets.all(12);
  final Divider divider = const Divider(
    endIndent: 20,
    height: 1,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '唯一标识',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  token,
                  style: const TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
          divider,
          Padding(
            padding: padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.black,
                  child: Image.asset(
                    'assets/images/bsn.png',
                    height: 30,
                    fit: BoxFit.fitHeight,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
