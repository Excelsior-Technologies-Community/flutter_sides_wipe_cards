import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_sideswipe_cards/flutter_sideswipe_cards.dart';

void main() {
  test('SideSwipeController initialization test', () {
    final controller = SideSwipeController();
    expect(controller, isNotNull);
  });
}
