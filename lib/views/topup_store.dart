import 'package:flutter/material.dart';
import 'package:pearmeta_fapp/constants/theme.dart';

class TopupStore extends StatefulWidget {
  const TopupStore({Key? key}) : super(key: key);

  static const routeName = '/topupStore';

  @override
  State<TopupStore> createState() => _TopupStoreState();
}

class _TopupStoreState extends State<TopupStore> {
  final List<int> values = [100, 300, 500, 1000, 5000, 10];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('储值卡'),
        ),
        body: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: values.length,
            separatorBuilder: (BuildContext itemContext, int index) =>
                const SizedBox(
                  height: 12,
                ),
            itemBuilder: (BuildContext itemContext, int index) {
              return Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: kCardBoxShadow),
                child: Card(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              'lib/assets/value_cards/${values[index]}.jpg',
                              height: 80,
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                              child: SizedBox(
                            height: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(TextSpan(
                                    text: '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${values[index]}',
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                      const TextSpan(text: ' 额度储值卡')
                                    ])),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          onPrimary: Colors.white,
                                          minimumSize: const Size(0, 30),
                                          shape: const BeveledRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ))),
                                      onPressed: () {
                                        //
                                      },
                                      child: Text('￥${values[index]}')),
                                )
                              ],
                            ),
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }));
  }
}
