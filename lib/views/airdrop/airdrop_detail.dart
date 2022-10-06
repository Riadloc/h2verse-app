import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/constants.dart';
import 'package:h2verse_app/models/art_model.dart';
import 'package:h2verse_app/providers/user_provider.dart';
import 'package:h2verse_app/services/art_service.dart';
import 'package:h2verse_app/widgets/back_button.dart';
import 'package:h2verse_app/widgets/cached_image.dart';
import 'package:h2verse_app/widgets/gradient_button.dart';
import 'package:h2verse_app/widgets/loading_sceen.dart';
import 'package:provider/provider.dart';

class AirdropDetail extends StatefulWidget {
  const AirdropDetail({Key? key}) : super(key: key);

  static const String routeName = '/airdropDetail';

  @override
  State<AirdropDetail> createState() => _AirdropDetailState();
}

class _AirdropDetailState extends State<AirdropDetail> {
  final Color descriptionColor = const Color.fromRGBO(141, 152, 175, 1);
  final Map params = Get.arguments;
  int titleAlpha = 0;
  late final ScrollController scrollController;
  late Future<Art> futureRequest;

  Widget bottomButtonBuilder(UserProvider state, Art data) {
    void Function()? onPressed;
    String btnText = '';
    List<Color>? colors;

    btnText = '立即兑换';
    colors = gradientButtonPrimarycolors;

    return GradientButton(
        text: btnText,
        onPressed: onPressed,
        borderRadius: 8,
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 18),
          textStyle: const TextStyle(fontSize: 16),
        ),
        colors: colors);
  }

  @override
  void initState() {
    super.initState();
    futureRequest = ArtService.getArtDetail(params['goodId']);
    scrollController = ScrollController();
    scrollController.addListener(() {
      var offset = scrollController.offset;
      int alpha = 0;
      if (offset > 100) {
        alpha = 255;
      } else if (offset <= 0) {
        alpha = 0;
      } else {
        alpha = offset * 255 ~/ 100;
      }
      if (alpha != titleAlpha) {
        setState(() {
          titleAlpha = alpha;
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Art>(
      initialData: Art.empty(),
      future: futureRequest,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
        } else if (snapshot.hasData) {
          Art detailData = snapshot.data!;
          return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.white.withAlpha(titleAlpha),
                elevation: 0,
                title: Text(detailData.name,
                    style:
                        TextStyle(color: Colors.black.withAlpha(titleAlpha))),
                leading: const CircleBackButton(),
              ),
              body: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView(
                    controller: scrollController,
                    children: [
                      CachedImage(params['cover'] ?? detailData.cover),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${detailData.name}${detailData.serial != null ? ' #${detailData.serial}' : ''}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      height: 1.5),
                                ),
                                Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      detailData.description == null ||
                                              detailData.description == ''
                                          ? '藏品没有介绍'
                                          : (detailData.description ?? ''),
                                      style: TextStyle(color: descriptionColor),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '兑换规则',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  height: 1.5),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                                '氢宇宙中的数字藏品是虚拟数字商品，而非实物商品。因数字藏品的特殊性，一经购买成功，将不支持退换。数字藏品的知识产权或其他权益属发行方或权利人所有，除另行取得发行方或权利人授权外，您不得将数字藏品用于任何商业用途。请勿对数字藏品进行炒作、场外交易或任何非法方式进行使用。',
                                style: TextStyle(color: descriptionColor))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '兑换规则',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  height: 1.5),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                                '氢宇宙中的数字藏品是虚拟数字商品，而非实物商品。因数字藏品的特殊性，一经购买成功，将不支持退换。数字藏品的知识产权或其他权益属发行方或权利人所有，除另行取得发行方或权利人授权外，您不得将数字藏品用于任何商业用途。请勿对数字藏品进行炒作、场外交易或任何非法方式进行使用。',
                                style: TextStyle(color: descriptionColor))
                          ],
                        ),
                      ),
                    ],
                  )),
              bottomNavigationBar: BottomAppBar(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          '${detailData.price} RMB',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      Expanded(
                          child: Consumer<UserProvider>(
                        builder: (context, value, child) => bottomButtonBuilder(
                          value,
                          detailData,
                        ),
                      ))
                    ],
                  ),
                ),
              ));
        }
        return Container();
      },
    );
  }
}
