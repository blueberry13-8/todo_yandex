import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdderSliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double minHeight;
  final VoidCallback saveFunc;
  final Function backFunc;

  AdderSliverAppBar(
      {required this.minHeight,
      required this.expandedHeight,
      required this.saveFunc,
      required this.backFunc});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double shift = shrinkOffset / expandedHeight;
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: [
        Material(
          shadowColor: Theme.of(context).shadowColor,
          elevation: 4.0 * shift,
          child: Container(
            color: Theme.of(context).backgroundColor,
            width: MediaQuery.of(context).size.width,
            height: expandedHeight,
          ),
        ),
        Positioned(
          left: 10,
          top: 23,
          child: IconButton(
            icon: Icon(
              Icons.close,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () async {
              bool result = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      AppLocalizations.of(context)!.confirmDelete,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    content: Text(
                      AppLocalizations.of(context)!.unsafeConfirm,
                      style: TextStyle(
                          fontSize: 16,
                          height: 20 / 16,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).primaryColorDark
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(
                          AppLocalizations.of(context)!.yes,
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                    ],
                  );
                },
              );
              if (result) {
                backFunc();
                Navigator.pop(context);
              }
            },
          ),
        ),
        Positioned(
          right: 16,
          top: 20,
          child: TextButton(
            onPressed: () {
              saveFunc();
            },
            child: Text(
              AppLocalizations.of(context)!.save,
              style: Theme.of(context).textTheme.button,
            ),
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
