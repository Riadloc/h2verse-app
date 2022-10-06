import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/models/compose_material_model.dart';
import 'package:h2verse_app/services/art_service.dart';

class ComposeSheet extends StatefulWidget {
  const ComposeSheet(
      {Key? key,
      required this.goodId,
      required this.selectList,
      required this.onChange})
      : super(key: key);
  final String goodId;
  final List<String>? selectList;
  final Function(List<String> selected) onChange;

  @override
  State<ComposeSheet> createState() => _ComposeSheetState();
}

class _ComposeSheetState extends State<ComposeSheet> {
  int pageNo = 1;
  final int pageSize = 12;
  List<ComposeMaterial> materials = [];
  final double mainPadding = 15.0;
  List<String> selectList = [];

  void getList() {
    ArtService.getComposeMaterials(goodId: widget.goodId).then((value) => {
          setState(() {
            List<ComposeMaterial> data = value;
            materials.addAll(data);
          }),
        });
  }

  @override
  void initState() {
    super.initState();
    selectList.addAll(widget.selectList ?? []);
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GridView.builder(
              shrinkWrap: true,
              itemCount: materials.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: mainPadding,
                  crossAxisSpacing: mainPadding,
                  childAspectRatio: 1.5),
              itemBuilder: (context, index) {
                var ele = materials[index];
                return Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border(
                        left: BorderSide(
                            width: 6,
                            color: selectList.contains(ele.id)
                                ? Colors.lightBlue
                                : Colors.grey.shade200),
                      )),
                  child: Card(
                    color: Colors.grey.shade200,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (selectList.contains(ele.id)) {
                            selectList.remove(ele.id);
                          } else {
                            selectList.add(ele.id);
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '#${ele.serial}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(children: [
              Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(44),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        widget.onChange(selectList);
                      },
                      child: Text('选择 ${selectList.length} 个'))),
            ])
          ],
        ));
  }
}
