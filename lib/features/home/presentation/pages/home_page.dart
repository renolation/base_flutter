import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../core/routing/route_guards.dart';
import '../../../../shared/presentation/providers/app_providers.dart';

/// Home page with navigation to different features
class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({super.key});

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> {
  final ScrollController _scroll = ScrollController();

  // ---- Dynamic level data (change these) ----
  final int totalLevels = 60;        // total levels you want to show
  final int currentLevelIndex = 4;  // 0-based index of current level

  // ---- Layout knobs (tweak to taste) ----
  static const double kNodeSpacing = 220;     // px along the path between bubbles
  static const double kStartOffset = 140;     // first bubble offset from path start
  static const double kVerticalStep = 270;    // vertical descent per circle loop

  // The scrollable map height is finite and derived from how many levels we show.
  double get mapHeight {
    return _calculateRequiredHeight(
      totalLevels: totalLevels,
      nodeSpacing: kNodeSpacing,
      startOffset: kStartOffset,
    );
  }

  /// Calculate the actual vertical height needed for circular path
  double _calculateRequiredHeight({
    required int totalLevels,
    required double nodeSpacing,
    required double startOffset,
  }) {
    // Path parameters (must match _buildCircularPath)
    const double baseRadius = 0.32; // percentage of width
    const double topPadding = 100.0;
    const double bottomPadding = 100.0;

    // Estimate circle circumference (approximation for cubic bezier circle)
    final screenWidth = MediaQuery.of(context).size.width;
    final radiusInPixels = screenWidth * baseRadius;
    final approximateCircleLength = 2 * math.pi * radiusInPixels;

    // Total path length needed for all nodes
    final totalPathLength = startOffset + (totalLevels - 1) * nodeSpacing;

    // Calculate how many circles we need
    final numberOfCircles = (totalPathLength / approximateCircleLength).ceil();

    // Calculate actual vertical height
    final contentHeight = numberOfCircles * kVerticalStep;
    final totalHeight = topPadding + contentHeight + bottomPadding;

    return math.max(1200, totalHeight);
  }

  double? _currentLevelY; // used to auto-scroll near the current level

  @override
  void initState() {
    super.initState();
    // Auto-scroll after first layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final y = _currentLevelY ?? 0;
      final screenH = MediaQuery.of(context).size.height;
      final target = (y - screenH * 0.45).clamp(0.0, mapHeight);
      _scroll.animateTo(
        target,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFB43E), // warm island background
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: LayoutBuilder(
                builder: (ctx, c) {
                  return SingleChildScrollView(
                    controller: _scroll,
                    child: SizedBox(
                      height: mapHeight,         // <-- finite height
                      width: c.maxWidth,
                      child: LevelMap(
                        totalLevels: totalLevels,
                        currentIndex: currentLevelIndex,
                        nodeSpacing: kNodeSpacing,
                        startOffsetOnPath: kStartOffset,
                        verticalStep: kVerticalStep,
                        showFinishAtEnd: true,
                        onCurrentLevelPositionResolved: (dy) {
                          _currentLevelY = dy;
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
    child: Row(
      children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
        const Expanded(
          child: Text(
            'Kho báu đảo hoang',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
      ],
    ),
  );

  Widget _buildBottomNav() => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
          offset: const Offset(0, -2),
        )
      ],
    ),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _Nav(icon: Icons.home, label: 'Trang chủ'),
            _Nav(icon: Icons.location_on, label: 'Khám phá', active: true),
            _Nav(icon: Icons.bar_chart, label: 'Xếp hạng'),
            _Nav(icon: Icons.people, label: 'Kết nối'),
            _Nav(icon: Icons.person, label: 'Cá nhân'),
          ],
        ),
      ),
    ),
  );
}

class _Nav extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  const _Nav({required this.icon, required this.label, this.active = false, super.key});
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: active ? Colors.orange : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: active ? Colors.white : Colors.grey)),
      const SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: active ? Colors.orange : Colors.grey,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ]);
  }
}

/// Draws the path and positions dynamic level nodes **along the path**.
class LevelMap extends StatelessWidget {
  final int totalLevels;
  final int currentIndex;
  final double nodeSpacing;
  final double startOffsetOnPath;
  final double verticalStep;
  final bool showFinishAtEnd;
  final ValueChanged<double>? onCurrentLevelPositionResolved;

  const LevelMap({
    super.key,
    required this.totalLevels,
    required this.currentIndex,
    required this.nodeSpacing,
    required this.startOffsetOnPath,
    required this.verticalStep,
    this.showFinishAtEnd = false,
    this.onCurrentLevelPositionResolved,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, c) {
      final size = Size(c.maxWidth, c.maxHeight);

      // Build a circular/spiral path that fills this finite canvas.
      final path = _buildCircularPath(size, verticalStep);

      // Measure the path
      final metrics = path.computeMetrics().toList();
      if (metrics.isEmpty) return const SizedBox.shrink();
      final metric = metrics.first; // single contour
      final totalLen = metric.length;

      // Required length to host all visible levels
      final requiredLen =
          startOffsetOnPath + (math.max(1, totalLevels) - 1) * nodeSpacing;

      // Clamp to available path length
      final effectiveLen = requiredLen.clamp(0, totalLen - 1);

      // Compute bubble positions
      final nodes = <Widget>[];
      const bubbleRadius = 28.0; // 56x56
      const eps = 0.001;

      double d = startOffsetOnPath;
      Offset? lastNodePosition; // Track last node position for finish flag

      for (int i = 0; i < totalLevels; i++) {
        final clamped = d.clamp(0, totalLen - eps);
        final tan = metric.getTangentForOffset(clamped.toDouble())!;
        final pos = tan.position;

        // Store last node position
        if (i == totalLevels - 1) {
          lastNodePosition = pos;
        }

        nodes.add(Positioned(
          left: pos.dx - bubbleRadius,
          top: pos.dy - bubbleRadius,
          child: LevelNode(
            level: i + 1,
            isCompleted: i < currentIndex,
            isCurrent: i == currentIndex,
            isLocked: i > currentIndex,
            onTap: i > currentIndex ? null : () {
              debugPrint('Level ${i + 1} tapped');
              context.pushNamed('lesson');
            },
          ),
        ));

        d += nodeSpacing;
        if (d > totalLen - eps) break; // stop when path ends
      }

      // Report current Y for auto-scroll
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (onCurrentLevelPositionResolved != null &&
            currentIndex >= 0 &&
            currentIndex < nodes.length) {
          final clamped = (startOffsetOnPath + currentIndex * nodeSpacing)
              .clamp(0, totalLen - eps);
          final tan = metric.getTangentForOffset(clamped.toDouble())!;
          onCurrentLevelPositionResolved!(tan.position.dy);
        }
      });

      // Optional finish flag at last level position
      if (showFinishAtEnd && lastNodePosition != null) {
        nodes.add(Positioned(
          left: lastNodePosition.dx - 18,
          top: lastNodePosition.dy - 60,
          child: const Icon(Icons.flag, color: Colors.red, size: 36),
        ));
      }

      return Stack(
        clipBehavior: Clip.none,
        children: [
          // Cute background bits (optional)
          Positioned.fill(child: CustomPaint(painter: DecorationPainter())),
          // Sandy road
          Positioned.fill(child: CustomPaint(painter: SandPathPainter(path))),
          // Bubbles
          ...nodes,
        ],
      );
    });
  }

  /// Creates a circular/spiral path that goes in circles while progressing downward
  Path _buildCircularPath(Size size, double verticalStep) {
    final path = Path();

    final centerX = size.width * 0.5;
    final baseRadius = size.width * 0.32; // radius of the circular motion

    double y = 100;

    // Start at top center
    path.moveTo(centerX, y);

    // Create circular loops going downward
    while (y < size.height - 100) {
      // Create a full circle using cubic bezier curves (4 curves make a circle)
      final startY = y;

      // Right curve (0° to 90°)
      path.cubicTo(
        centerX + baseRadius * 0.55, startY,
        centerX + baseRadius, startY + verticalStep * 0.25 - baseRadius * 0.55,
        centerX + baseRadius, startY + verticalStep * 0.25,
      );

      // Bottom curve (90° to 180°)
      path.cubicTo(
        centerX + baseRadius, startY + verticalStep * 0.25 + baseRadius * 0.55,
        centerX + baseRadius * 0.55, startY + verticalStep * 0.5,
        centerX, startY + verticalStep * 0.5,
      );

      // Left curve (180° to 270°)
      path.cubicTo(
        centerX - baseRadius * 0.55, startY + verticalStep * 0.5,
        centerX - baseRadius, startY + verticalStep * 0.75 - baseRadius * 0.55,
        centerX - baseRadius, startY + verticalStep * 0.75,
      );

      // Top curve (270° to 360°)
      path.cubicTo(
        centerX - baseRadius, startY + verticalStep * 0.75 + baseRadius * 0.55,
        centerX - baseRadius * 0.55, startY + verticalStep,
        centerX, startY + verticalStep,
      );

      y += verticalStep;
    }

    return path;
  }
}

/// Painter for the sand road with subtle depth.
class SandPathPainter extends CustomPainter {
  final Path path;
  SandPathPainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    // Glow/soft highlight
    final glow = Paint()
      ..color = const Color(0x26FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 84
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawPath(path, glow);

    // Main sand
    final sand = Paint()
      ..color = const Color(0xFFFFD18C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 64
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, sand);

    // Inner shade for depth
    final inner = Paint()
      ..color = const Color(0xFFEAB66F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 36
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, inner);
  }

  @override
  bool shouldRepaint(covariant SandPathPainter oldDelegate) =>
      oldDelegate.path != path;
}

/// Simple decorative painter (palms/hills placeholders).
class DecorationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final palm = Paint()..color = const Color(0xFF66A060);
    final hill = Paint()..color = const Color(0xFFFFE1A8).withOpacity(.35);

    for (double y = 160; y < size.height; y += 260) {
      canvas.drawCircle(Offset(size.width * 0.18, y), 10, palm);
      canvas.drawCircle(Offset(size.width * 0.82, y + 70), 10, palm);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width * 0.5, y + 120),
            width: 140,
            height: 60,
          ),
          const Radius.circular(30),
        ),
        hill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LevelNode extends StatelessWidget {
  final int level;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLocked;
  final VoidCallback? onTap;

  const LevelNode({
    super.key,
    required this.level,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLocked,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: isCurrent ? Colors.orange : Colors.white,
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: _inner()),
      ),
    );
  }

  Widget _inner() {
    if (isCompleted) {
      return const Icon(Icons.check_circle, color: Colors.green, size: 28);
    }
    if (isLocked) {
      return const Icon(Icons.lock, color: Colors.grey, size: 22);
    }
    if (isCurrent) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.orange.shade300, Colors.orange.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(Icons.play_arrow, color: Colors.white),
      );
    }
    return Text(
      '$level',
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
    );
  }
}