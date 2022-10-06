import 'package:flutter/material.dart';

class CommunityGroups extends StatefulWidget {
  const CommunityGroups({super.key});

  static const routeName = '/groups';

  @override
  State<CommunityGroups> createState() => _CommunityGroupsState();
}

class _CommunityGroupsState extends State<CommunityGroups> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('官方社群'),
      ),
      body: ListView(),
    );
  }
}
