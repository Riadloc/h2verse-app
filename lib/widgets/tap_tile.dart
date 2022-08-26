import 'package:flutter/material.dart';

class TapTile extends StatelessWidget {
  const TapTile(
      {Key? key,
      required this.title,
      this.icon,
      this.color,
      this.contentPadding = 24,
      this.onTap})
      : super(key: key);
  final String title;
  final Color? color;
  final IconData? icon;
  final double contentPadding;
  final dynamic Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        margin: const EdgeInsets.all(0),
        child: InkWell(
          onTap: onTap,
          child: ListTile(
            minLeadingWidth: 0,
            contentPadding: EdgeInsets.symmetric(horizontal: contentPadding),
            leading: icon != null
                ? Icon(
                    icon,
                    color: color,
                  )
                : null,
            title: Text(
              title,
              style: TextStyle(color: color),
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: color),
            style: ListTileStyle.drawer,
          ),
        ));
  }
}
