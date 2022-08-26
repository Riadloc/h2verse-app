import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pearmeta_fapp/constants/enum.dart';
import 'package:pearmeta_fapp/models/artSnsList.model.dart';
import 'package:pearmeta_fapp/services/art.service.dart';
import 'package:pearmeta_fapp/views/art_detail.dart';

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

  void getList() {
    if (!noMore) {
      artService
          .getMyArtsSns(pageNo: pageNo, goodId: widget.goodId)
          .then((value) => {
                setState(() {
                  List<ArtSns> data = value.list;
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
      'goodNo': ele.goodNo,
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
      color: Colors.white,
      constraints: const BoxConstraints(maxHeight: 200),
      padding: const EdgeInsets.all(20),
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 1.5,
        shrinkWrap: true,
        children: artList
            .map((ele) => Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border(
                        left: BorderSide(
                            width: 6,
                            color: ele.status == 0
                                ? Colors.lightBlue
                                : Colors.red),
                      )),
                  child: Card(
                    color: Colors.grey.shade200,
                    child: InkWell(
                      onTap: () => goDetail(ele),
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
