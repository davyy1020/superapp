import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';

class CurvedNavItem {
  final IconData? icon;
  final IconData? activeIcon;
  final String? emoji;
  final String label;

  CurvedNavItem({
    this.icon,
    this.activeIcon,
    this.emoji,
    required this.label,
  });
}

class AnimatedCurvedNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<CurvedNavItem> items;

  const AnimatedCurvedNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  State<AnimatedCurvedNavBar> createState() => _AnimatedCurvedNavBarState();
}

class _AnimatedCurvedNavBarState extends State<AnimatedCurvedNavBar> with TickerProviderStateMixin {
  late AnimationController _moveController;
  late AnimationController _bounceController;
  late Animation<double> _moveAnim;
  late Animation<double> _bounceAnim;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.currentIndex;
    
    // Smooth gliding movement controller with Spring Ease physics
    _moveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _moveAnim = Tween<double>(
      begin: widget.currentIndex.toDouble(),
      end: widget.currentIndex.toDouble(),
    ).animate(CurvedAnimation(
      parent: _moveController,
      curve: const Cubic(0.175, 0.885, 0.32, 1.25), // Smooth spring curve
    ));

    // Elastic bounce controller on tab click
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _bounceAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.82), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 0.82, end: 1.15), weight: 45),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 20),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeOutQuad,
    ));
  }

  @override
  void didUpdateWidget(AnimatedCurvedNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _moveAnim = Tween<double>(
        begin: _previousIndex.toDouble(),
        end: widget.currentIndex.toDouble(),
      ).animate(CurvedAnimation(
        parent: _moveController,
        curve: const Cubic(0.175, 0.885, 0.32, 1.25),
      ));
      _previousIndex = widget.currentIndex;
      _moveController.forward(from: 0.0);
      _bounceController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _moveController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double barContainerHeight = 68.0;
    final int count = widget.items.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: AnimatedBuilder(
        animation: Listenable.merge([_moveController, _bounceController]),
        builder: (context, child) {
          final double activePos = _moveController.isAnimating
              ? _moveAnim.value
              : widget.currentIndex.toDouble();

          final currentActiveItem = widget.items[widget.currentIndex];

          return SizedBox(
            height: barContainerHeight + 28,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double totalWidth = constraints.maxWidth;
                final double itemWidth = totalWidth / count;
                final double notchCenterX = (activePos * itemWidth) + (itemWidth / 2);

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // 1. CLEAR CURVED NOTCH BAR WITH DISTINCT DIPPING CURVE
                    Positioned(
                      top: 24,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: const [
                            BoxShadow(
                              color: NeoColors.black,
                              offset: Offset(4.5, 4.5),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: CustomPaint(
                          size: Size(totalWidth, barContainerHeight),
                          painter: _DistinctCurvedBarPainter(
                            notchX: notchCenterX,
                            backgroundColor: NeoColors.white,
                            borderColor: NeoColors.black,
                            borderWidth: 2.5,
                          ),
                        ),
                      ),
                    ),

                    // 2. FLOATING ACTIVE BUBBLE BUTTON IN NOTCH
                    Positioned(
                      top: 2,
                      left: notchCenterX - 28,
                      child: Transform.scale(
                        scale: _bounceController.isAnimating ? _bounceAnim.value : 1.0,
                        child: GestureDetector(
                          onTap: () => widget.onTap(widget.currentIndex),
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [NeoColors.brand, Color(0xFF0040B8)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(color: NeoColors.black, width: 2.5),
                              boxShadow: [
                                BoxShadow(
                                  color: NeoColors.brand.withOpacity(0.4),
                                  blurRadius: 14,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 4),
                                ),
                                const BoxShadow(
                                  color: NeoColors.black,
                                  offset: Offset(3, 3),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                            child: Center(
                              child: currentActiveItem.emoji != null
                                  ? Text(
                                      currentActiveItem.emoji!,
                                      style: const TextStyle(fontSize: 26),
                                    )
                                  : Icon(
                                      currentActiveItem.activeIcon ?? Icons.star_rounded,
                                      color: NeoColors.gold,
                                      size: 26,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 3. TAB ICONS & LABELS WITH PROPER SPACING
                    Positioned(
                      top: 28,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Row(
                        children: List.generate(count, (index) {
                          final bool isActive = widget.currentIndex == index;
                          final item = widget.items[index];

                          return Expanded(
                            child: GestureDetector(
                              onTap: () => widget.onTap(index),
                              behavior: HitTestBehavior.opaque,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (!isActive) ...[
                                    item.emoji != null
                                        ? Text(item.emoji!, style: const TextStyle(fontSize: 20))
                                        : Icon(
                                            item.icon ?? Icons.circle_outlined,
                                            color: NeoColors.black.withOpacity(0.6),
                                            size: 22,
                                          ),
                                    const SizedBox(height: 4),
                                  ] else ...[
                                    const SizedBox(height: 22),
                                  ],
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 200),
                                    style: TextStyle(
                                      color: isActive ? NeoColors.brand : NeoColors.black.withOpacity(0.55),
                                      fontSize: isActive ? 11 : 10,
                                      fontWeight: isActive ? FontWeight.w900 : FontWeight.w600,
                                      fontFamily: 'Inter',
                                    ),
                                    child: Text(item.label),
                                  ),
                                  if (isActive) ...[
                                    const SizedBox(height: 3),
                                    Container(
                                      width: 16,
                                      height: 3,
                                      decoration: BoxDecoration(
                                        color: NeoColors.gold,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Custom Painter for Distinct U-Curved Notch Dip
class _DistinctCurvedBarPainter extends CustomPainter {
  final double notchX;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;

  _DistinctCurvedBarPainter({
    required this.notchX,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = 30.0;
    final double notchRadius = 35.0;
    final double notchDepth = 22.0;

    final Paint fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final Path path = Path();

    path.moveTo(radius, 0);

    double leftNotchStart = notchX - notchRadius - 14;
    double rightNotchEnd = notchX + notchRadius + 14;

    if (leftNotchStart < radius) leftNotchStart = radius;
    if (rightNotchEnd > size.width - radius) rightNotchEnd = size.width - radius;

    path.lineTo(leftNotchStart, 0);

    path.cubicTo(
      notchX - notchRadius + 2, 0,
      notchX - notchRadius + 4, notchDepth,
      notchX, notchDepth,
    );
    path.cubicTo(
      notchX + notchRadius - 4, notchDepth,
      notchX + notchRadius - 2, 0,
      rightNotchEnd, 0,
    );

    path.lineTo(size.width - radius, 0);
    path.arcToPoint(Offset(size.width, radius), radius: Radius.circular(radius));

    path.lineTo(size.width, size.height - radius);
    path.arcToPoint(Offset(size.width - radius, size.height), radius: Radius.circular(radius));

    path.lineTo(radius, size.height);
    path.arcToPoint(Offset(0, size.height - radius), radius: Radius.circular(radius));

    path.lineTo(0, radius);
    path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));

    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _DistinctCurvedBarPainter oldDelegate) {
    return oldDelegate.notchX != notchX ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.borderColor != borderColor;
  }
}
