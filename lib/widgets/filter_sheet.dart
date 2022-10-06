import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2verse_app/constants/enum.dart';
import 'package:h2verse_app/constants/theme.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet(
      {Key? key, required this.onApply, required this.onReset, this.sortKey})
      : super(key: key);
  final void Function(Map<String, int> values) onApply;
  final void Function() onReset;
  final int? sortKey;

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  FilterItemKeysEnum sortKey = FilterItemKeysEnum.SORT_NEW;
  String serialId = '';

  void onSelectFilterItem(FilterItemKeysEnum id) {
    setState(() {
      sortKey = id;
    });
  }

  void onSelectSerialItem(String id) {
    setState(() {
      serialId = id;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.sortKey != null) {
      sortKey = FilterItemKeysEnum.values[widget.sortKey!];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '排序',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  title: '最新上架',
                  selected: sortKey == FilterItemKeysEnum.SORT_NEW,
                  onSelected: (bool selected) {
                    onSelectFilterItem(FilterItemKeysEnum.SORT_NEW);
                  },
                ),
                FilterChip(
                  title: '价格升序',
                  selected: sortKey == FilterItemKeysEnum.SORT_LOW_PRICE,
                  onSelected: (bool selected) {
                    onSelectFilterItem(FilterItemKeysEnum.SORT_LOW_PRICE);
                  },
                ),
                FilterChip(
                  title: '价格降序',
                  selected: sortKey == FilterItemKeysEnum.SORT_HIGH_PRICE,
                  onSelected: (bool selected) {
                    onSelectFilterItem(FilterItemKeysEnum.SORT_HIGH_PRICE);
                  },
                ),
              ],
            )
          ],
        ),
        // const SizedBox(
        //   height: 12,
        // ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     const Text(
        //       '系列',
        //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        //     ),
        //     Wrap(
        //       spacing: 8,
        //       children: [
        //         FilterChip(
        //           title: '创世之星',
        //           selected: serialId == 'cs',
        //           onSelected: (bool selected) {
        //             onSelectSerialItem('cs');
        //           },
        //         ),
        //         FilterChip(
        //           title: '山海经',
        //           selected: serialId == 'shj',
        //           onSelected: (bool selected) {
        //             onSelectSerialItem('shj');
        //           },
        //         ),
        //       ],
        //     )
        //   ],
        // ),
        const Spacer(),
        Row(
          children: [
            Expanded(
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                      side: BorderSide(
                        width: 1,
                        color: Colors.grey.shade200,
                      ),
                    ),
                    onPressed: () {
                      widget.onReset();
                      Get.back(closeOverlays: false, canPop: false);
                    },
                    child: const Text('重 置'))),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(44),
                    ),
                    onPressed: () {
                      widget.onApply({
                        'sortKey': sortKey.index,
                      });
                      Get.back(closeOverlays: false, canPop: false);
                    },
                    child: const Text('应 用')))
          ],
        )
      ]),
    );
  }
}

class FilterChip extends StatelessWidget {
  const FilterChip(
      {Key? key,
      required this.title,
      required this.selected,
      required this.onSelected})
      : super(key: key);

  final String title;
  final bool selected;
  final void Function(bool) onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(title),
      elevation: 0,
      pressElevation: 0,
      padding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      selectedColor: Colors.white,
      labelStyle:
          TextStyle(color: selected ? xPrimaryColor : Colors.grey.shade500),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: BorderSide(
          width: 0.5,
          color: selected ? xPrimaryColor : Colors.grey.shade200,
        ),
      ),
      selected: selected,
      onSelected: onSelected,
    );
  }
}
