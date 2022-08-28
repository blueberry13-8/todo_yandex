import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/func_for_local.dart';

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double minHeight;
  final Function callback;
  bool showDone;
  var eyeIcon = Icons.visibility;

  MySliverAppBar(
    this.callback,
    this.showDone, {
    required this.minHeight,
    required this.expandedHeight,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    if (showDone) {
      eyeIcon = Icons.visibility_off;
    } else {
      eyeIcon = Icons.visibility;
    }
    Future<int> doneNum;
    double shift = shrinkOffset / expandedHeight;
    int intShift = shrinkOffset ~/ expandedHeight;
    return Consumer(
      builder: (context, ref, _) {
        final localTasks = ref.watch(localTasksProvider);
        doneNum = localTasks.getDoneNumLocal();
        return Stack(
          clipBehavior: Clip.none,
          fit: StackFit.passthrough,
          children: [
            Material(
              shadowColor: Colors.black,
              elevation: 4.0 * intShift,
              child: Container(
                //color: const Color(0xFFF7F6F2),
                color: Theme.of(context).backgroundColor,
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
                  inherit: false,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColorDark,
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
                        style: Theme.of(context).textTheme.subtitle1,
                      );
                    }
                    return Text(
                      '${AppLocalizations.of(context)!.doneSubtitle} — ${snapshot.data}',
                      style: Theme.of(context).textTheme.subtitle1,
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
                  //showDone = !showDone;
                  callback();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
