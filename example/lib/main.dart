import 'package:flutter/material.dart';
import 'package:flutter_sideswipe_cards/flutter_sideswipe_cards.dart';

void main() {
  runApp(const SideSwipeExampleApp());
}

class SideSwipeExampleApp extends StatelessWidget {
  const SideSwipeExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SideSwipeCards',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const SwipeDemoPage(),
    );
  }
}

class SwipeDemoPage extends StatefulWidget {
  const SwipeDemoPage({super.key});

  @override
  State<SwipeDemoPage> createState() => _SwipeDemoPageState();
}

class _SwipeDemoPageState extends State<SwipeDemoPage> {
  final SideSwipeController _controller = SideSwipeController();

  final List<DemoProfile> _profiles = const [
    DemoProfile(
      name: 'Alex Rivers',
      age: 25,
      location: 'New York',
      imageUrl:
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e'
          '?auto=format&fit=crop&w=900&q=80',
      description:
      'Tech enthusiast 💻 | Coffee ☕ | Photography 📸',
    ),
    DemoProfile(
      name: 'Liam Smith',
      age: 27,
      location: 'Los Angeles',
      imageUrl:
      'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d'
          '?auto=format&fit=crop&w=900&q=80',
      description:
      'Fitness lover 💪 | Travel ✈️ | Music 🎵',
    ),
    DemoProfile(
      name: 'Ethan James',
      age: 24,
      location: 'Chicago',
      imageUrl:
      'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7'
          '?auto=format&fit=crop&w=900&q=80',
      description:
      'Entrepreneur 🚀 | Surfing 🏄‍♂️ | Foodie 🍕',
    ),
    DemoProfile(
      name: 'Noah Bennett',
      age: 26,
      location: 'Miami',
      imageUrl:
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d'
          '?auto=format&fit=crop&w=900&q=80',
      description:
      'Architect 🏛️ | Books 📚 | Weekend explorer',
    ),
    DemoProfile(
      name: 'Lucas Miller',
      age: 28,
      location: 'San Francisco',
      imageUrl:
      'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6'
          '?auto=format&fit=crop&w=900&q=80',
      description:
      'Developer 💻 | Hiking 🥾 | Good vibes ✨',
    ),
  ];

  int _swipedCount = 0;
  String _status = 'Swipe a card';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'SideSwipeCards',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),

            _buildHeader(),

            const SizedBox(height: 16),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: SideSwipeCards(
                  controller: _controller,
                  itemCount: _profiles.length,

                  stackDepth: 2,
                  stackScale: 0.045,
                  stackOffset: 12,

                  swipeThreshold: 120,

                  animationDuration:
                  const Duration(milliseconds: 280),

                  maxRotation: 0.10,

                  borderRadius: 24,

                  enableHapticFeedback: true,

                  showSwipeLabels: true,

                  leftLabel: 'NOPE',
                  rightLabel: 'LIKE',

                  itemBuilder: (
                      context,
                      index,
                      ) {
                    return _buildProfileCard(
                      _profiles[index],
                    );
                  },

                  onSwipe: (
                      index,
                      direction,
                      ) {
                    setState(() {
                      _swipedCount++;

                      if (direction ==
                          SideSwipeDirection.right) {
                        _status =
                        '${_profiles[index].name} liked ❤️';
                      } else {
                        _status =
                        '${_profiles[index].name} skipped';
                      }
                    });
                  },

                  onSwipeProgress: (
                      index,
                      progress,
                      ) {
                    // Progress:
                    // -1.0 = fully left
                    //  0.0 = center
                    // +1.0 = fully right
                  },

                  onUndo: (index) {
                    setState(() {
                      _swipedCount =
                          (_swipedCount - 1)
                              .clamp(0, _profiles.length);

                      _status =
                      'Card restored ↩';
                    });
                  },

                  onEmpty: () {
                    setState(() {
                      _status =
                      'No more cards 🎉';
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 12),

            _buildStatus(),

            const SizedBox(height: 14),

            _buildActionButtons(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.style_rounded,
            size: 28,
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Text(
              'Discover',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(20),
              color: Colors.black.withValues(alpha: 0.06),
            ),
            child: Text(
              '$_swipedCount / ${_profiles.length}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(
      DemoProfile profile,
      ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // IMAGE
        Image.network(
          profile.imageUrl,
          fit: BoxFit.cover,

          loadingBuilder: (
              context,
              child,
              loadingProgress,
              ) {
            if (loadingProgress == null) {
              return child;
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },

          errorBuilder: (
              context,
              error,
              stackTrace,
              ) {
            return const Center(
              child: Icon(
                Icons.person,
                size: 80,
              ),
            );
          },
        ),

        // DARK GRADIENT
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [
                0.45,
                0.75,
                1.0,
              ],
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.35),
                Colors.black.withValues(alpha: 0.90),
              ],
            ),
          ),
        ),

        // PROFILE INFORMATION
        Positioned(
          left: 20,
          right: 20,
          bottom: 20,
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      '${profile.name}, ${profile.age}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const Icon(
                    Icons.verified_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                    size: 18,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    profile.location,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                profile.description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatus() {
    return AnimatedSwitcher(
      duration: const Duration(
        milliseconds: 200,
      ),
      child: Text(
        _status,
        key: ValueKey(_status),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.center,
      children: [
        _ActionButton(
          icon: Icons.close_rounded,
          size: 58,
          onTap: () {
            _controller.swipeLeft();
          },
        ),

        const SizedBox(width: 20),

        _ActionButton(
          icon: Icons.undo_rounded,
          size: 48,
          onTap: () {
            _controller.undo();
          },
        ),

        const SizedBox(width: 20),

        _ActionButton(
          icon: Icons.favorite_rounded,
          size: 58,
          onTap: () {
            _controller.swipeRight();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.size,
    required this.onTap,
  });

  final IconData icon;
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 4,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            size: size * 0.42,
          ),
        ),
      ),
    );
  }
}

class DemoProfile {
  const DemoProfile({
    required this.name,
    required this.age,
    required this.location,
    required this.imageUrl,
    required this.description,
  });

  final String name;
  final int age;
  final String location;
  final String imageUrl;
  final String description;
}