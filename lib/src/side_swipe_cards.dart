import 'package:flutter/material.dart';

import 'side_swipe_controller.dart';
import 'side_swipe_direction.dart';

class SideSwipeCards extends StatefulWidget {
  const SideSwipeCards({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.onSwipe,
    this.onSwipeProgress,
    this.onUndo,
    this.onEmpty,
    this.swipeThreshold = 120,
    this.animationDuration = const Duration(milliseconds: 280),
    this.maxRotation = 0.10,
    this.stackDepth = 2,
    this.stackScale = 0.04,
    this.stackOffset = 10,
    this.borderRadius = 16,
    this.enableHapticFeedback = true,
    this.showSwipeLabels = false,
    this.leftLabel = 'NOPE',
    this.rightLabel = 'LIKE',
    this.padding = EdgeInsets.zero,
  });

  /// Total number of cards.
  final int itemCount;

  /// Builds each card.
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Optional controller for programmatic swiping.
  final SideSwipeController? controller;

  /// Called after a card is successfully swiped.
  final void Function(
      int index,
      SideSwipeDirection direction,
      )? onSwipe;

  /// Called while the current card is being dragged.
  ///
  /// Progress is between -1.0 and 1.0.
  final void Function(
      int index,
      double progress,
      )? onSwipeProgress;

  /// Called when undo is performed.
  final void Function(int index)? onUndo;

  /// Called when all cards are consumed.
  final VoidCallback? onEmpty;

  /// Distance required to complete a swipe.
  final double swipeThreshold;

  /// Duration of the fly-out / return animation.
  final Duration animationDuration;

  /// Maximum card rotation in radians.
  final double maxRotation;

  /// Number of cards visible behind the current card.
  final int stackDepth;

  /// Scale reduction for cards behind.
  final double stackScale;

  /// Vertical offset for cards behind.
  final double stackOffset;

  /// Card corner radius.
  final double borderRadius;

  /// Whether to provide haptic feedback after swipe.
  final bool enableHapticFeedback;

  /// Whether LIKE / NOPE labels are displayed.
  final bool showSwipeLabels;

  final String leftLabel;
  final String rightLabel;

  /// Space around the card.
  final EdgeInsets padding;

  @override
  State<SideSwipeCards> createState() => _SideSwipeCardsState();
}

class _SideSwipeCardsState extends State<SideSwipeCards>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  double _dragX = 0;

  int _currentIndex = 0;

  int? _lastSwipedIndex;

  bool _isAnimating = false;

  // ignore: unused_field
  SideSwipeDirection? _animationDirection;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _attachController();
  }

  @override
  void didUpdateWidget(covariant SideSwipeCards oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.detach();
      _attachController();
    }
  }

  void _attachController() {
    widget.controller?.attach(
      onSwipeLeft: () {
        _startSwipe(SideSwipeDirection.left);
      },
      onSwipeRight: () {
        _startSwipe(SideSwipeDirection.right);
      },
      onUndo: _undo,
    );
  }

  // ---------------------------------------------------------------------------
  // DRAG
  // ---------------------------------------------------------------------------

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_isAnimating) {
      return;
    }

    if (_currentIndex >= widget.itemCount) {
      return;
    }

    setState(() {
      _dragX += details.delta.dx;
    });

    _notifyProgress();
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_isAnimating) {
      return;
    }

    if (_currentIndex >= widget.itemCount) {
      return;
    }

    if (_dragX.abs() >= widget.swipeThreshold) {
      final direction = _dragX > 0
          ? SideSwipeDirection.right
          : SideSwipeDirection.left;

      _startSwipe(direction);
    } else {
      _returnToCenter();
    }
  }

  void _notifyProgress() {
    final progress =
    (_dragX / widget.swipeThreshold).clamp(-1.0, 1.0);

    widget.onSwipeProgress?.call(
      _currentIndex,
      progress,
    );
  }

  // ---------------------------------------------------------------------------
  // SWIPE
  // ---------------------------------------------------------------------------

  Future<void> _startSwipe(
      SideSwipeDirection direction,
      ) async {
    if (_isAnimating) {
      return;
    }

    if (_currentIndex >= widget.itemCount) {
      return;
    }

    _isAnimating = true;
    _animationDirection = direction;

    final screenWidth = MediaQuery.sizeOf(context).width;

    final targetX = direction == SideSwipeDirection.right
        ? screenWidth * 1.5
        : -screenWidth * 1.5;

    final animation = Tween<double>(
      begin: _dragX,
      end: targetX,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    void listener() {
      if (!mounted) {
        return;
      }

      setState(() {
        _dragX = animation.value;
      });

      _notifyProgress();
    }

    animation.addListener(listener);

    _animationController.reset();

    await _animationController.forward();

    animation.removeListener(listener);

    if (!mounted) {
      return;
    }

    _completeSwipe(direction);
  }

  void _completeSwipe(
      SideSwipeDirection direction,
      ) {
    final swipedIndex = _currentIndex;

    setState(() {
      _currentIndex++;
      _dragX = 0;
      _isAnimating = false;
      _animationDirection = null;
      _lastSwipedIndex = swipedIndex;
    });

    if (widget.enableHapticFeedback) {
      Feedback.forTap(context);
    }

    widget.onSwipe?.call(
      swipedIndex,
      direction,
    );

    if (_currentIndex >= widget.itemCount) {
      widget.onEmpty?.call();
    }
  }

  // ---------------------------------------------------------------------------
  // RETURN TO CENTER
  // ---------------------------------------------------------------------------

  Future<void> _returnToCenter() async {
    if (_dragX == 0) {
      return;
    }

    _isAnimating = true;

    final animation = Tween<double>(
      begin: _dragX,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    void listener() {
      if (!mounted) {
        return;
      }

      setState(() {
        _dragX = animation.value;
      });

      _notifyProgress();
    }

    animation.addListener(listener);

    _animationController.reset();

    await _animationController.forward();

    animation.removeListener(listener);

    if (!mounted) {
      return;
    }

    setState(() {
      _dragX = 0;
      _isAnimating = false;
    });

    _notifyProgress();
  }

  // ---------------------------------------------------------------------------
  // UNDO
  // ---------------------------------------------------------------------------

  void _undo() {
    if (_isAnimating) {
      return;
    }

    if (_lastSwipedIndex == null) {
      return;
    }

    if (_currentIndex <= 0) {
      return;
    }

    final index = _lastSwipedIndex!;

    setState(() {
      _currentIndex--;
      _dragX = 0;
      _lastSwipedIndex = null;
    });

    widget.onUndo?.call(index);
  }

  // ---------------------------------------------------------------------------
  // CARD STACK
  // ---------------------------------------------------------------------------

  Widget _buildStackCard(
      BuildContext context,
      int index,
      int depth,
      ) {
    final scale =
        1 - (depth * widget.stackScale);

    final offsetY =
        depth * widget.stackOffset;

    return Positioned.fill(
      child: Padding(
        padding: widget.padding,
        child: Transform.translate(
          offset: Offset(
            0,
            offsetY,
          ),
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                widget.borderRadius,
              ),
              child: widget.itemBuilder(
                context,
                index,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentCard(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final normalized =
    (_dragX / width).clamp(-1.0, 1.0);

    final rotation =
        normalized * widget.maxRotation;

    final swipeProgress =
    (_dragX.abs() / widget.swipeThreshold)
        .clamp(0.0, 1.0);

    return Positioned.fill(
      child: Padding(
        padding: widget.padding,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate:
          _handleDragUpdate,
          onHorizontalDragEnd:
          _handleDragEnd,
          child: Transform.translate(
            offset: Offset(
              _dragX,
              0,
            ),
            child: Transform.rotate(
              angle: rotation,
              alignment: Alignment.center,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius:
                    BorderRadius.circular(
                      widget.borderRadius,
                    ),
                    child: widget.itemBuilder(
                      context,
                      _currentIndex,
                    ),
                  ),

                  if (widget.showSwipeLabels)
                    _buildSwipeLabel(
                      progress: swipeProgress,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SWIPE LABEL
  // ---------------------------------------------------------------------------

  Widget _buildSwipeLabel({
    required double progress,
  }) {
    if (_dragX == 0) {
      return const SizedBox.shrink();
    }

    final isRight = _dragX > 0;

    final label = isRight
        ? widget.rightLabel
        : widget.leftLabel;

    final color =
    isRight ? Colors.green : Colors.red;

    return Positioned(
      top: 30,
      left: isRight ? null : 30,
      right: isRight ? 30 : null,
      child: Opacity(
        opacity: progress,
        child: Transform.rotate(
          angle: isRight ? 0.12 : -0.12,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: color,
                width: 3,
              ),
              borderRadius:
              BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount <= 0) {
      return const SizedBox.shrink();
    }

    if (_currentIndex >= widget.itemCount) {
      return const SizedBox.shrink();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Back cards.
        for (
        int depth = widget.stackDepth;
        depth >= 1;
        depth--
        )
          if (_currentIndex + depth <
              widget.itemCount)
            _buildStackCard(
              context,
              _currentIndex + depth,
              depth,
            ),

        // Current card.
        _buildCurrentCard(context),
      ],
    );
  }

  @override
  void dispose() {
    widget.controller?.detach();
    _animationController.dispose();
    super.dispose();
  }
}