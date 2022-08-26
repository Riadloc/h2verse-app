// import 'package:easy_refresh/easy_refresh.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pearmeta_fapp/constants/enum.dart';
// import 'package:pearmeta_fapp/services/art.service.dart';
// import 'package:pearmeta_fapp/views/search_screen.dart';

// import 'art_detail.dart';
// import 'package:pearmeta_fapp/models/art.model.dart';

// enum FilterKeys { latest, lowPrice, highPrice }

// class Market extends StatefulWidget {
//   const Market({Key? key}) : super(key: key);

//   @override
//   State<Market> createState() => _MarketState();
// }

// class _MarketState extends State<Market> with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;

//   int pageNo = 1;
//   final int pageSize = 12;
//   bool noMore = false;
//   FilterKeys selectedKey = FilterKeys.latest;
//   List<FilterItemKeysEnum> selectedKeys = [];

//   List<dynamic> artList = [];
//   List<dynamic> filterItems = [
//     {'key': FilterKeys.latest, 'label': '按最新'},
//     {'key': FilterKeys.lowPrice, 'label': '按低价'},
//     {'key': FilterKeys.highPrice, 'label': '按高价'}
//   ];
//   final List<Widget> _tabs = const <Widget>[
//     Tab(text: '藏品'),
//     Tab(text: '盲盒'),
//     Tab(text: '权益卡'),
//     Tab(text: '已发布'),
//   ];

//   void getList() {
//     if (!noMore) {
//       artService.getMarketArts(pageNo: pageNo, type: 0).then((value) => {
//             setState(() {
//               List<Art> data = value.data;
//               artList.addAll(data);
//               if (data.length < pageSize) {
//                 noMore = true;
//               } else {
//                 pageNo += 1;
//               }
//             }),
//           });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     double itemWidth = (MediaQuery.of(context).size.width - 60) / 2;
//     return Scaffold(
//         backgroundColor: const Color.fromARGB(255, 247, 247, 247),
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           toolbarHeight: 0,
//           backgroundColor: Colors.white,
//           elevation: 0,
//           bottom: PreferredSize(
//               preferredSize: const Size.fromHeight(70),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     height: 70,
//                     padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
//                     child: Row(
//                       children: [
//                         Expanded(
//                             child: Card(
//                           elevation: 0,
//                           margin: const EdgeInsets.all(0),
//                           color: Colors.grey.shade200,
//                           child: InkWell(
//                             onTap: () {
//                               Get.toNamed(SearchScreen.routeName);
//                             },
//                             child: Container(
//                               height: double.infinity,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(6)),
//                               child: Row(
//                                 children: const [
//                                   SizedBox(
//                                     width: 8,
//                                   ),
//                                   Icon(Icons.search),
//                                   SizedBox(
//                                     width: 8,
//                                   ),
//                                   Text(
//                                     '搜索',
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )),
//                         const SizedBox(
//                           width: 12,
//                         ),
//                         IconButton(
//                             padding: EdgeInsets.zero,
//                             onPressed: () {
//                               Get.bottomSheet(
//                                 FilterSheet(
//                                   selectedKeys: selectedKeys,
//                                   onSelect: (id) {
//                                     setState(() {
//                                       selectedKeys.add(id);
//                                     });
//                                   },
//                                 ),
//                               );
//                             },
//                             icon: const Icon(Icons.tune))
//                       ],
//                     ),
//                   ),
//                 ],
//               )),
//         ),
//         body: EasyRefresh(
//           onRefresh: () async {
//             setState(() {
//               pageNo = 1;
//               noMore = false;
//               artList.clear();
//               getList();
//             });
//           },
//           onLoad: () async {
//             getList();
//           },
//           child: ListView(
//             padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
//             children: [
//               Wrap(
//                 spacing: 20,
//                 children: artList
//                     .map(
//                       (e) => MarketSmallCard(
//                         artData: e,
//                         vw: itemWidth,
//                       ),
//                     )
//                     .toList(),
//               )
//             ],
//           ),
//         ));
//   }
// }

// class MarketSmallCard extends StatelessWidget {
//   const MarketSmallCard({Key? key, required this.artData, required this.vw})
//       : super(key: key);

//   final Art artData;
//   final double vw;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: vw,
//       child: Card(
//           elevation: 0,
//           margin: const EdgeInsets.only(bottom: 20),
//           shape: const RoundedRectangleBorder(
//             side: BorderSide(
//               color: Colors.transparent,
//             ),
//           ),
//           child: InkWell(
//             onTap: () => {
//               Navigator.pushNamed(context, ArtDetail.routeName, arguments: {
//                 'goodNo': artData.goodNo,
//                 'artType': ArtType.second
//               })
//             },
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               AspectRatio(
//                   aspectRatio: 1,
//                   child: Image.network(
//                     artData.cover,
//                     fit: BoxFit.cover,
//                   )),
//               Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         artData.name,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             height: 1.5),
//                       ),
//                       Text(
//                         '￥${artData.price}',
//                         style: const TextStyle(height: 1.5),
//                       )
//                     ]),
//               )
//             ]),
//           )),
//     );
//   }
// }

// class FilterSheet extends StatelessWidget {
//   const FilterSheet(
//       {Key? key, required this.selectedKeys, required this.onSelect})
//       : super(key: key);

//   final List<FilterItemKeysEnum> selectedKeys;
//   final dynamic Function(FilterItemKeysEnum id) onSelect;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 300,
//       color: Colors.white,
//       padding: const EdgeInsets.all(24),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               '排序',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//             Wrap(
//               spacing: 8,
//               children: [
//                 ChoiceChip(
//                   label: const Text('最新上架'),
//                   elevation: 0,
//                   pressElevation: 0,
//                   padding: EdgeInsets.zero,
//                   backgroundColor: Colors.grey[300],
//                   selectedColor: Colors.lightGreen,
//                   labelStyle: const TextStyle(color: Colors.white),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   selected: selectedKeys.contains(FilterItemKeysEnum.SORT_NEW),
//                   onSelected: (bool selected) {
//                     onSelect(FilterItemKeysEnum.SORT_NEW);
//                   },
//                 ),
//                 ChoiceChip(
//                   label: const Text('价格升序'),
//                   elevation: 0,
//                   pressElevation: 0,
//                   padding: EdgeInsets.zero,
//                   backgroundColor: Colors.grey[300],
//                   selectedColor: Colors.lightGreen,
//                   labelStyle: const TextStyle(color: Colors.white),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   selected:
//                       selectedKeys.contains(FilterItemKeysEnum.SORT_LOW_PRICE),
//                   onSelected: (bool selected) {
//                     onSelect(FilterItemKeysEnum.SORT_LOW_PRICE);
//                   },
//                 ),
//               ],
//             )
//           ],
//         ),
//         const SizedBox(
//           height: 12,
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               '系列',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//             Wrap(
//               spacing: 8,
//               children: [],
//             )
//           ],
//         ),
//         const Spacer(),
//         ElevatedButton(
//             style: ElevatedButton.styleFrom(
//                 onPrimary: Colors.white,
//                 minimumSize: const Size(double.infinity, 44),
//                 shape: const StadiumBorder()),
//             onPressed: () => null,
//             child: const Text('应用'))
//       ]),
//     );
//   }
// }
