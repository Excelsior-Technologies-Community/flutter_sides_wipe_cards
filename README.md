# flutter_sideswipe_cards

[![Flutter Version](https://img.shields.io/badge/Flutter-%3E%3D1.17.0-blue.svg)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-orange.svg)](#)

**flutter_sideswipe_cards** is a premium, highly customizable, and fluid tinder-style card swiping widget for Flutter. It features smooth gesture animations, configurable card stacks, programmatic controller support (swipe left/right & undo), real-time swipe progress callbacks, visual swipe label overlays, and haptic feedback integration.

---

## 📷 Preview

<p align="center">
  <img src="assets/sideswipe_cards.gif" alt="SideSwipe Cards Preview" width="320"/>
</p>

*A premium interactive card swiping component featuring smooth gesture tracking, depth-scaled background cards, directional badge overlays, programmatic controller integration, and undo support.*

---

## ✨ Features

- **🎴 Dynamic Card Stacking**
  - Configurable stack depth, depth scaling ratio, and vertical offsets for realistic multi-layered card depth.
- **⚡ Programmatic Control**
  - Easily trigger `swipeLeft()`, `swipeRight()`, or `undo()` actions using `SideSwipeController`.
- **📊 Real-time Swipe Callbacks**
  - Track drag progress dynamically from `-1.0` (fully left) to `1.0` (fully right) via `onSwipeProgress`.
- **🏷️ Customizable Swipe Labels**
  - Interactive overlay badges (e.g. 'LIKE' and 'NOPE') that fade and rotate smoothly in sync with gesture distance.
- **↩️ Built-in Undo Capability**
  - Effortlessly restore previously swiped cards back to the top of the stack with full state management.
- **📳 Integrated Haptic Feedback**
  - Automatic tactile vibration feedback when swipe threshold is reached.

---

## 📦 Installation

To use this library in your Flutter project, add it to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  # From pub.dev
  flutter_sideswipe_cards: ^0.0.1
```

Or reference it directly from a Git repository:

```yaml
dependencies:
  flutter_sideswipe_cards:
    git:
      url: https://github.com/your_username/flutter_sideswipe_cards.git
      ref: main
```

---

## 🚀 Usage

Import the package in your Dart code:

```dart
import 'package:flutter_sideswipe_cards/flutter_sideswipe_cards.dart';
```

### 1. Basic Standalone Swiper
A simple card stack with swipe callbacks.

```dart
SideSwipeCards(
  itemCount: profiles.length,
  itemBuilder: (context, index) {
    return Card(
      child: Center(
        child: Text('Card ${profiles[index].name}'),
      ),
    );
  },
  onSwipe: (index, direction) {
    if (direction == SideSwipeDirection.right) {
      print('Liked item at $index');
    } else {
      print('Skipped item at $index');
    }
  },
  onEmpty: () {
    print('No more cards!');
  },
)
```

### 2. Programmatic Controller & Action Buttons
Use `SideSwipeController` to drive swiping or undoing from external buttons.

```dart
final SideSwipeController _controller = SideSwipeController();

// Inside your widget build:
Column(
  children: [
    Expanded(
      child: SideSwipeCards(
        controller: _controller,
        itemCount: profiles.length,
        itemBuilder: (context, index) => ProfileCard(profile: profiles[index]),
      ),
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _controller.swipeLeft(),
        ),
        IconButton(
          icon: const Icon(Icons.undo),
          onPressed: () => _controller.undo(),
        ),
        IconButton(
          icon: const Icon(Icons.favorite),
          onPressed: () => _controller.swipeRight(),
        ),
      ],
    ),
  ],
)
```

### 3. Custom Stack Styling & Interactive Labels
Customize stack depth, card scaling, and show directional overlay labels like 'NOPE' and 'LIKE'.

```dart
SideSwipeCards(
  controller: _controller,
  itemCount: profiles.length,
  stackDepth: 3,
  stackScale: 0.05,
  stackOffset: 14.0,
  swipeThreshold: 130.0,
  borderRadius: 20.0,
  showSwipeLabels: true,
  leftLabel: 'NOPE',
  rightLabel: 'LIKE',
  itemBuilder: (context, index) => ProfileCard(profile: profiles[index]),
  onSwipeProgress: (index, progress) {
    // progress ranges from -1.0 (left) to 1.0 (right)
    print('Dragging card $index at progress: $progress');
  },
)
```

---

## 🛠️ API Reference

### `SideSwipeCards` properties:

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `itemCount` | `int` | *required* | Total number of cards to display. |
| `itemBuilder` | `Widget Function(BuildContext, int)` | *required* | Builder function to construct each card at a specific index. |
| `controller` | `SideSwipeController?` | `null` | Optional controller for programmatic swipe and undo actions. |
| `onSwipe` | `void Function(int, SideSwipeDirection)?` | `null` | Callback triggered when a card is swiped left or right. |
| `onSwipeProgress` | `void Function(int, double)?` | `null` | Callback invoked during card drag (`-1.0` for full left to `1.0` for full right). |
| `onUndo` | `void Function(int)?` | `null` | Callback triggered when a card swipe is undone. |
| `onEmpty` | `VoidCallback?` | `null` | Callback triggered when all cards have been consumed. |
| `swipeThreshold` | `double` | `120.0` | Minimum horizontal drag distance in pixels required to complete a swipe. |
| `animationDuration` | `Duration` | `Duration(milliseconds: 280)` | Duration of fly-out and restore animations. |
| `maxRotation` | `double` | `0.10` | Maximum card rotation angle (in radians) applied during drag. |
| `stackDepth` | `int` | `2` | Number of background cards rendered behind the active card. |
| `stackScale` | `double` | `0.04` | Scale reduction applied to each underlying background card. |
| `stackOffset` | `double` | `10.0` | Vertical offset in pixels between background cards in the stack. |
| `borderRadius` | `double` | `16.0` | Corner radius applied to card clipping and label badges. |
| `enableHapticFeedback` | `bool` | `true` | Enables tactile haptic feedback on successful swipe threshold reached. |
| `showSwipeLabels` | `bool` | `false` | Enables interactive 'LIKE' and 'NOPE' text overlays during drag. |
| `leftLabel` | `String` | `'NOPE'` | Label text displayed when dragging towards the left. |
| `rightLabel` | `String` | `'LIKE'` | Label text displayed when dragging towards the right. |
| `padding` | `EdgeInsets` | `EdgeInsets.zero` | Outer padding around the card stack container. |

### `SideSwipeController` methods:

| Method | Return Type | Description |
| :--- | :--- | :--- |
| `swipeLeft()` | `void` | Programmatically triggers a swipe left animation on the current top card. |
| `swipeRight()` | `void` | Programmatically triggers a swipe right animation on the current top card. |
| `undo()` | `void` | Restores the last swiped card back to the top of the stack. |

---

## 📄 License

```lic
MIT License

Copyright (c) 2026 Excelsior Technologies

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
