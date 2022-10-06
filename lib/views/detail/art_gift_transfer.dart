import 'package:flutter/material.dart';

class ArtGiftTransfer extends StatefulWidget {
  const ArtGiftTransfer({super.key});

  static const routeName = '/artGiftTransfer';

  @override
  State<ArtGiftTransfer> createState() => _ArtGiftTransferState();
}

class _ArtGiftTransferState extends State<ArtGiftTransfer> {
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text('转赠'),
      ),
      body: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 12),
        child: Column(
          children: [
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                hintText: '请输入接收者手机号',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(children: [
          Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 1,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                      foregroundColor: Colors.white),
                  onPressed: () {
                    //
                  },
                  child: const Text('转赠')))
        ]),
      )),
    );
  }
}
