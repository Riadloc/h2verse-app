import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IdentityDetail extends StatefulWidget {
  const IdentityDetail({Key? key}) : super(key: key);

  static const routeName = '/identityDetail';

  @override
  State<IdentityDetail> createState() => _IdentityDetailState();
}

class _IdentityDetailState extends State<IdentityDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text('实名认证'),
        backgroundColor: Colors.white,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            kIsWeb
                ? Image.asset(
                    'assets/images/sheild.webp',
                    width: 300,
                    height: 300,
                    fit: BoxFit.fill,
                  )
                : Lottie.asset(
                    'assets/lottie/103555-success.zip',
                    width: 300,
                    height: 300,
                    fit: BoxFit.fill,
                  ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              '您已完成实名认证！',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.lightBlue),
            )
          ],
        ),
      ),
    );
  }
}
