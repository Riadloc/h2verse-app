import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/constants.dart';
import 'package:h2verse_app/constants/theme.dart';
import 'package:h2verse_app/models/compose_model.dart';
import 'package:h2verse_app/services/art_service.dart';
import 'package:h2verse_app/utils/toast.dart';
import 'package:h2verse_app/views/compose/compose_sheet.dart';
import 'package:h2verse_app/widgets/cached_image.dart';
import 'package:h2verse_app/widgets/common_field_card.dart';
import 'package:h2verse_app/widgets/loading_button.dart';
import 'package:h2verse_app/widgets/modal.dart';

class ComposeLab extends StatefulWidget {
  const ComposeLab({Key? key}) : super(key: key);

  static const routeName = '/composeLab';

  @override
  State<ComposeLab> createState() => _ComposeLabState();
}

class _ComposeLabState extends State<ComposeLab> {
  final Map<String, dynamic> params = Get.arguments;
  late Future<ComposeItem?> futureRequest;

  bool loading = false;
  Map<String, List<String>> coutMap = {};

  @override
  void initState() {
    super.initState();
    futureRequest = ArtService.getComposeDetail(id: params['id']);
  }

  void onCompose(ComposeItem data) async {
    var materials = data.materials!;
    for (int i = 0; i < materials.length; i++) {
      var item = materials[i];
      if (item.count != coutMap[item.objectId]?.length) {
        Toast.show('${item.objectName} 缺少材料');
        return;
      }
    }
    setState(() {
      loading = true;
    });
    bool res = await ArtService.onCompose(
        id: data.id,
        materials: coutMap.values.expand((element) => element).toList());
    if (res) {
      Toast.show('恭喜您，合成成功！');
      Get.dialog(
        Modal(
          title: '恭喜您，合成成功！',
          confirmText: '继续合成',
          cancelText: '返回',
          onConfirm: () {
            setState(() {
              coutMap = {};
            });
            Get.back();
          },
          onCancel: () {
            Get.back(closeOverlays: true);
          },
        ),
      );
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          floating: false,
          snap: false,
          title: const Text('合成实验室'),
          backgroundColor: Colors.white,
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                    colors: gradientButtonPrimarycolors,
                    stops: [0, 0.49, 1]),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 50,
                          spreadRadius: 0,
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                        )
                      ],
                    ),
                    child: Container(
                      width: 100,
                      height: 100,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        // border:
                        //     Border.all(width: 2, color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: kCardBoxShadow,
                      ),
                      child: CachedImage(
                        params['cover'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        FutureBuilder<ComposeItem?>(
          future: futureRequest,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
            } else if (snapshot.hasData) {
              if (snapshot.data != null) {
                ComposeItem data = snapshot.data!;
                return SliverList(
                    delegate: SliverChildListDelegate([
                  ...data.materials!.map((ele) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CommonFieldCard(
                            marginBottom: 0,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${ele.objectName} x ${ele.count}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        foregroundColor: Colors.white,
                                        // backgroundColor: Colors.green
                                      ),
                                      onPressed: () {
                                        Get.bottomSheet(
                                            ComposeSheet(
                                              goodId: ele.objectId,
                                              selectList: coutMap[ele.objectId],
                                              onChange: (selected) {
                                                if (ele.count <
                                                    selected.length) {
                                                  Toast.show(
                                                      '多选择 ${selected.length - ele.count} 个材料');
                                                  return;
                                                }
                                                setState(() {
                                                  coutMap[ele.objectId] =
                                                      selected;
                                                });
                                                Get.back(closeOverlays: false);
                                              },
                                            ),
                                            isScrollControlled: true);
                                      },
                                      child: const Text('选择')),
                                ])),
                        LinearProgressIndicator(
                          value:
                              (coutMap[ele.objectId]?.length ?? 0) / ele.count,
                          minHeight: 3,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    );
                  }),
                  CommonFieldCard(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                        Text(
                          '合成说明',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text('材料将会在合成后自动销毁')
                      ])),
                  const SizedBox(
                    height: 60,
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: LoadingButton(
                      loading: loading,
                      onPressed: () => onCompose(data),
                      style: ElevatedButton.styleFrom(
                          elevation: 1,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          textStyle: const TextStyle(fontSize: 16),
                          foregroundColor: Colors.white),
                      child: const Text('立即合成'),
                    ),
                  )
                ]));
              }
            }
            return const SliverToBoxAdapter();
          },
        )
      ]),
    );
  }
}
