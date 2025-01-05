import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// A responsive grid that adjusts the number of columns based on the screen width
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double tabletBreakpoint;
  final double desktopBreakpoint;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  //If true, assigns a fixed size box to each child based on the screen height
  //If false, the grid may overflow the current screen height
  final bool adjustToScreenHeight;

  const ResponsiveGrid({
    super.key,
    required this.children,
    required this.adjustToScreenHeight,
    this.tabletBreakpoint = 768,
    this.desktopBreakpoint = 1024,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
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

        final int rows = (children.length / columns).ceil();
        final double? height =
            adjustToScreenHeight ? constraints.maxHeight / rows : null;

        return AlignedGridView.count(
          crossAxisCount: columns,
          itemCount: children.length,
          itemBuilder: (context, index) {
            return SizedBox(
              height: height,
              child: children[index],
            );
          },
        );
      },
    );
  }
}
