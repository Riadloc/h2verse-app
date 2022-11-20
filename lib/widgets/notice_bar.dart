import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:h2verse_app/models/bulletin_model.dart';
import 'package:h2verse_app/services/common_service.dart';
import 'package:h2verse_app/views/bulletin/bulletin.dart';

class NoticeBar extends StatefulWidget {
  const NoticeBar({Key? key}) : super(key: key);

  @override
  State<NoticeBar> createState() => _NoticeBarState();
}

class _NoticeBarState extends State<NoticeBar> {
  final double height = 40;
  List<Bulletin> bulletins = [];

  void getLatestBulletins() async {
    var res = await CommonService.getLatestBulletins();
    setState(() {
      bulletins = res;
    });
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      getLatestBulletins();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: const Color.fromRGBO(240, 242, 240, 1),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: () {
          Get.toNamed(BulletinList.routeName);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.notes_outlined),
            Expanded(
                flex: 2,
                child: bulletins.isNotEmpty
                    ? CarouselSlider.builder(
                        options: CarouselOptions(
                            autoPlay: true,
                            height: 20,
                            viewportFraction: 1,
                            scrollPhysics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical),
                        itemCount: bulletins.length >= 3 ? 3 : bulletins.length,
                        itemBuilder: (BuildContext context, int itemIndex,
                                int pageViewIndex) =>
                            Text(bulletins[itemIndex].name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 15.0)),
                      )
                    : Container()),
            const Icon(
              Icons.arrow_forward,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
