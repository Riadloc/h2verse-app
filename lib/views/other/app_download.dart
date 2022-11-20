import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/models/version_upgrade_info_model.dart';
import 'package:h2verse_app/services/common_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppDownload extends StatefulWidget {
  const AppDownload({super.key});

  static const routeName = '/appDownload';

  @override
  State<AppDownload> createState() => _AppDownloadState();
}

class _AppDownloadState extends State<AppDownload> {
  String version = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getPackageInfo();
    });
  }

  void getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('APP下载'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, 8),
                      blurRadius: 20,
                      spreadRadius: 20,
                      color: Color.fromRGBO(100, 100, 100, 0.2),
                    )
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/splash_logo.png',
                    width: 200,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    'v$version',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton.icon(
                      icon: const Icon(Icons.rocket_launch),
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white),
                      onPressed: () async {
                        AppUpgradeInfo? versionInfo =
                            await CommonService.getNewestVersion();
                        if (versionInfo != null) {
                          launchUrlString(versionInfo.url);
                        }
                      },
                      label: const Text('点击下载')),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
