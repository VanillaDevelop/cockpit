import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double tabletBreakpoint;
  final double desktopBreakpoint;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.tabletBreakpoint = 768,
    this.desktopBreakpoint = 1024,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        final int columns;
        if (maxWidth < tabletBreakpoint) {
          columns = 1;
        } else if (maxWidth < desktopBreakpoint) {
          columns = 2;
        } else {
          columns = 3;
        }

        return AlignedGridView.count(
          crossAxisCount: columns,
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}
