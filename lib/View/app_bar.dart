import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double minHeight;
  Future<int> doneNum;
  final Function callback;
  final bool showDown;
  var eyeIcon = Icons.visibility;

  MySliverAppBar(this.callback, this.showDown,
      {required this.minHeight,
      required this.expandedHeight,
      required this.doneNum});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double shift = shrinkOffset / expandedHeight;
    int intShift = shrinkOffset ~/ expandedHeight;
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: [
        Material(
          shadowColor: Colors.black,
          elevation: 4.0 * intShift,
          child: Container(
            color: const Color(0xFFF7F6F2),
            width: MediaQuery.of(context).size.width,
            height: expandedHeight,
          ),
        ),
        Positioned(
          left: 60 - 44 * shift,
          top: 82 - 46 * shift,
          child: Text(
            AppLocalizations.of(context)!.mainTitle,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 40 - 12 * shift,
              height: (47 - 6 * shift) / (40 - 12 * shift),
            ),
          ),
        ),
        Positioned(
          left: 60 - 44 * shift,
          top: 130 - 34 * shift,
          child: Opacity(
            opacity: 1 - shift,
            child: FutureBuilder<int>(
              future: doneNum,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text(
                    '${AppLocalizations.of(context)!.doneSubtitle} — "~"',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0x4C000000),
                    ),
                  );
                }
                return Text(
                  '${AppLocalizations.of(context)!.doneSubtitle} — ${snapshot.data}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0x4C000000),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          right: 24 - 6 * shift,
          top: 114 - 77 * shift,
          child: IconButton(
            splashRadius: 1,
            icon: Icon(
              eyeIcon,
              color: Colors.blue,
            ),
            onPressed: () {
              //TODO: Change the ICON and send the callback!!!
              if (eyeIcon == Icons.visibility) {
                eyeIcon = Icons.visibility_off;
              } else {
                eyeIcon = Icons.visibility;
              }
              callback;
            },
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
