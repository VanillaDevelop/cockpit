import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double tabletBreakpoint;
  final double desktopBreakpoint;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final bool constrainHeight;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.tabletBreakpoint = 768,
    this.desktopBreakpoint = 1024,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.constrainHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        final int columns;
        if (maxWidth < tabletBreakpoint) {
          columns = mobileColumns;
        } else if (maxWidth < desktopBreakpoint) {
          columns = tabletColumns;
        } else {
          columns = desktopColumns;
        }

        return AlignedGridView.count(
            shrinkWrap: constrainHeight,
            crossAxisCount: columns,
            itemCount: children.length,
            itemBuilder: (context, index) {
              final int rows = (children.length / columns).ceil();
              return SizedBox(
                height: constrainHeight ? constraints.maxHeight / rows : null,
                child: children[index],
              );
            });
      },
    );
  }
}
