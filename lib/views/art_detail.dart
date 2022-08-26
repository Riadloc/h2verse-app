import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pearmeta_fapp/constants/utils.dart';
import 'package:pearmeta_fapp/models/art.model.dart';
import 'package:pearmeta_fapp/services/art.service.dart';
import 'package:pearmeta_fapp/views/order_detail.dart';

import 'package:pearmeta_fapp/constants/enum.dart';
import 'package:pearmeta_fapp/widgets/back_button.dart';
import 'package:pearmeta_fapp/widgets/cached_image.dart';
import 'package:pearmeta_fapp/widgets/split_line.dart';
import 'package:pearmeta_fapp/widgets/tap_tile.dart';

class ArtDetail extends StatefulWidget {
  const ArtDetail({Key? key}) : super(key: key);

  static const String routeName = '/detail';

  @override
  State<ArtDetail> createState() => _ArtDetailState();
}

class _ArtDetailState extends State<ArtDetail> {
  Art detailData = Art.empty();
  final Color descriptionColor = const Color.fromRGBO(141, 152, 175, 1);

  final Map params = Get.arguments;

  @override
  void initState() {
    super.initState();

    var method = params['artType'] == ArtType.main
        ? artService.getArtDetail
        : artService.getFluxArtDetail;
    method(params['goodNo']).then((value) => {
          if (mounted)
            {
              setState(() {
                detailData = value;
              })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leadingWidth: 40,
        leading: const CircleBackButton(),
      ),
      body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView(
            children: [
              Hero(
                  tag: params['cover'] ?? detailData.cover,
                  child: CachedImage(params['cover'] ?? detailData.cover)),
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
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              detailData.description == null ||
                                      detailData.description == ''
                                  ? '藏品没有介绍'
                                  : (detailData.description ?? ''),
                              style: TextStyle(color: descriptionColor),
                            )),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          decoration: const ShapeDecoration(
                              color: Color.fromRGBO(248, 250, 251, 1),
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)))),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Column(
                                children: [
                                  const Text(
                                    '拥有者',
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(141, 152, 175, 1)),
                                  ),
                                  Text(
                                    '${detailData.ownner}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                ],
                              )),
                              const SplitLine(),
                              Expanded(
                                  child: Column(
                                children: const [
                                  Text(
                                    '发行',
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(141, 152, 175, 1)),
                                  ),
                                  Text(
                                    '1000',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  )
                                ],
                              )),
                              const SplitLine(),
                              Expanded(
                                child: Column(
                                  children: const [
                                    Text(
                                      '流通',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(141, 152, 175, 1)),
                                    ),
                                    Text(
                                      '800',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(10, 178, 125, 1),
                                          fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TapTile(
                  title: '上链信息',
                  onTap: () {
                    Get.bottomSheet(ArtChainInfo(
                        contract: detailData.contract ?? '',
                        token: detailData.tokenId ?? '排队上链中'));
                  }),
              const Divider(
                indent: 10,
                endIndent: 20,
                height: 1,
              ),
              TapTile(
                  title: '查看流转',
                  onTap: () {
                    //
                  }),
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
                      '购买须知',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          height: 1.5),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                        '梨数字中的数字藏品是虚拟数字商品，而非实物商品。因数字藏品的特殊性，一经购买成功，将不支持退换。数字藏品的知识产权或其他权益属发行方或权利人所有，除另行取得发行方或权利人授权外，您不得将数字藏品用于任何商业用途。请勿对数字藏品进行炒作、场外交易或任何非法方式进行使用。',
                        style: TextStyle(color: descriptionColor))
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              if (params['artType'] != ArtType.main) ...[
                TapTile(
                    title: '流转历史',
                    onTap: () {
                      //
                    }),
                const SizedBox(
                  height: 12,
                ),
              ]
            ],
          )),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 1,
                          padding: const EdgeInsets.symmetric(
                              vertical: 13, horizontal: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          textStyle: const TextStyle(fontSize: 16),
                          onPrimary: Colors.white),
                      onPressed: () {
                        Get.toNamed(OrderDetail.routeName,
                            arguments: detailData);
                      },
                      child: const Text('立即购买')))
            ],
          ),
        ),
      ),
    );
  }
}

class StaticsCard extends StatelessWidget {
  const StaticsCard({Key? key, required this.label, required this.value})
      : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: ShapeDecoration(
        color: Colors.lightGreen[50],
        shape: const StadiumBorder(
          side: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      child: RichText(
        text: TextSpan(
          text: '$label ',
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(
                text: value,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class ArtChainInfo extends StatelessWidget {
  const ArtChainInfo({Key? key, required this.contract, required this.token})
      : super(key: key);

  final String contract;
  final String token;
  final EdgeInsetsGeometry padding = const EdgeInsets.all(12);
  final Divider divider = const Divider(
    endIndent: 20,
    height: 1,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      constraints: const BoxConstraints(maxHeight: 180),
      padding: padding,
      child: Column(
        children: [
          Padding(
            padding: padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '合同地址',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(formatHex(contract)),
              ],
            ),
          ),
          divider,
          Padding(
            padding: padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '唯一标识',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(token),
              ],
            ),
          ),
          divider,
          Padding(
            padding: padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '合约标准',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text('ERC-721'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
