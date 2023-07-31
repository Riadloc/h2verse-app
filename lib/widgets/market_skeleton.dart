import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MarketSkeleton extends StatelessWidget {
  const MarketSkeleton({Key? key, this.padding = 0}) : super(key: key);
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(padding),
        child: Animate(
            effects: const [
              ShimmerEffect(duration: Duration(milliseconds: 500))
            ],
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisSpacing: padding,
                crossAxisSpacing: padding,
                childAspectRatio: 0.6,
                maxCrossAxisExtent: 200,
              ),
              itemCount: 8,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              color: Colors.black12,
                            )),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  height: 20,
                                  color: Colors.black12,
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Container(
                                  width: 50,
                                  height: 20,
                                  color: Colors.black12,
                                )
                              ]),
                        )
                      ]),
                );
              },
            )));
  }
}
