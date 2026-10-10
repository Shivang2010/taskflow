import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/utils/date_utils.dart';

void main() {
  final now = DateTime(2026, 5, 1, 15, 30);

  test('past date is Overdue', () {
    expect(AppDateUtils.groupLabel(DateTime(2026, 4, 30), now: now), 'Overdue');
  });

  test('same day is Today', () {
    expect(AppDateUtils.groupLabel(DateTime(2026, 5, 1), now: now), 'Today');
  });

  test('next day is Tomorrow', () {
    expect(AppDateUtils.groupLabel(DateTime(2026, 5, 2), now: now), 'Tomorrow');
  });

  test('later date is Upcoming', () {
    expect(AppDateUtils.groupLabel(DateTime(2026, 5, 9), now: now), 'Upcoming');
  });

  test('formatShort shows day and month', () {
    expect(AppDateUtils.formatShort(DateTime(2026, 5, 2)), '2 May');
  });
}
