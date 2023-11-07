// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';

import '../firebase/firebase_function.dart';

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

Event make_event (String string){
  return Event(string);
}

// LinkedHashMap<DateTime, List<Event>> kEvents =
// LinkedHashMap<DateTime, List<Event>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// );

Map<DateTime, List<Event>> events = {};

Map<DateTime, List<Event>> kEvents = {};
//     LinkedHashMap<DateTime, List<Event>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// )..addAll(
//         {
//         DateTime(2023, 10, 3): [
//           Event('DateTime(2022, 8, 4)'),
//           Event('DateTime(2022, 8, 5)'),
//           Event('DateTime(2022, 8, 6)'),
//           Event('DateTime(2022, 8, 4)'),
//           Event('DateTime(2022, 8, 5)'),
//           Event('DateTime(2022, 8, 6)')
//         ],
//         DateTime(2023, 10, 4): [Event('date: DateTime(2022, 8, 6)')],
//         DateTime(2023, 10, 5): [Event('date: DateTime(2022, 8, 6)')],
//       }
//     );

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
// LinkedHashMap<DateTime, List<Event>> kEvents =
//     LinkedHashMap<DateTime, List<Event>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// )..addAll(
//         {
//         DateTime(2023, 10, 3): [
//           Event('DateTime(2022, 8, 4)'),
//           Event('DateTime(2022, 8, 5)'),
//           Event('DateTime(2022, 8, 6)'),
//           Event('DateTime(2022, 8, 4)'),
//           Event('DateTime(2022, 8, 5)'),
//           Event('DateTime(2022, 8, 6)')
//         ],
//         DateTime(2023, 10, 4): [Event('date: DateTime(2022, 8, 6)')],
//         DateTime(2023, 10, 5): [Event('date: DateTime(2022, 8, 6)')],
//       }
//     );

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);