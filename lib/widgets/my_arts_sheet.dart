import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/enum.dart';
import 'package:h2verse_app/models/art_sns_model.dart';
import 'package:h2verse_app/services/art_service.dart';
import 'package:h2verse_app/views/detail/art_detail.dart';

class MyArtsSheet extends StatefulWidget {
  const MyArtsSheet({Key? key, required this.goodId}) : super(key: key);
  final String goodId;

  @override
  State<MyArtsSheet> createState() => _MyArtsSheetState();
}

class _MyArtsSheetState extends State<MyArtsSheet> {
  int pageNo = 1;
  final int pageSize = 12;
  bool noMore = false;
  List<ArtSns> artList = [];
  final double mainPadding = 15.0;

  void getList() {
    if (!noMore) {
      ArtService.getMyArtsSns(pageNo: pageNo, goodId: widget.goodId)
          .then((value) => {
                setState(() {
                  List<ArtSns> data = value;
                  artList.addAll(data);
                  if (data.length < pageSize) {
                    noMore = true;
                  } else {
                    pageNo += 1;
                  }
                }),
              });
    }
  }

  void goDetail(ArtSns ele) {
    Get.toNamed(ArtDetail.routeName, arguments: {
      'goodId': ele.id,
      'artType': ArtType.second,
    });
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      padding: EdgeInsets.all(mainPadding),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          )),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: artList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: mainPadding,
            crossAxisSpacing: mainPadding,
            childAspectRatio: 1.5),
        itemBuilder: (context, index) {
          var ele = artList[index];
          return Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: Border(
                  left: BorderSide(
                      width: 6,
                      color: ele.status == 0 ? Colors.lightBlue : Colors.red),
                )),
            child: Card(
              color: Colors.grey.shade200,
              child: InkWell(
                onTap: () {
                  Get.back();
                  goDetail(ele);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '#${ele.serial} / ${ele.copies}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 13),
                      ),
                      Text(
                        '￥${ele.price}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
