import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/garbage_schedule.dart';

class GarbageScheduleService {
  GarbageScheduleService({required this.baseUrl});

  final String baseUrl;

  Future<List<GarbageSchedule>> fetchByAddress(String address) async {
    final parts = _AddressParts.fromFreeform(address);
    final form = {
      'embed': 'N',
      'laddr': parts.houseNumber,
      'sdir': parts.direction ?? '',
      'sname': parts.streetName,
      'stype': parts.streetType ?? '',
      'faddr': parts.formattedStreet,
    };

    final resp = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: form,
    );
    if (resp.statusCode != 200) {
      throw Exception('Failed to fetch schedule: ${resp.statusCode}');
    }

    final html = resp.body;
    final garbage = _extractSection(html, 'Next Scheduled Garbage Pickup:');
    final recycling = _extractSection(html, 'Next Scheduled Recycling Pickup:');

    final schedules = <GarbageSchedule>[];
    if (garbage != null) {
      schedules.add(
        GarbageSchedule(
          routeId: garbage.route,
          address: parts.formattedAddress,
          pickupDate: garbage.date,
          type: PickupType.garbage,
        ),
      );
    }
    if (recycling != null) {
      schedules.add(
        GarbageSchedule(
          routeId: recycling.route,
          address: parts.formattedAddress,
          pickupDate: recycling.date,
          type: PickupType.recycling,
        ),
  GarbageScheduleService({
    required this.baseUrl,
    this.authToken,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final String? authToken;
  final http.Client _client;

  Future<http.Response> _safeGet(Uri uri) async {
    try {
      return await _client.get(uri, headers: _headers());
    } on http.ClientException catch (e) {
      throw Exception(
        'Network blocked fetching schedule (CORS/offline): ${e.message}',
      );
    }

    if (schedules.isEmpty) {
      throw Exception('Schedule not found for the provided address.');
    }

    return schedules;
  }

  _PickupInfo? _extractSection(String html, String heading) {
    final start = html.toLowerCase().indexOf(heading.toLowerCase());
    if (start == -1) return null;

    final slice = html.substring(start);
    final matches = RegExp(r'<strong>([^<]+)</strong>', caseSensitive: false, dotAll: true)
        .allMatches(slice)
        .take(2)
        .toList();
    if (matches.length < 2) return null;

    final route = matches[0].group(1)?.trim();
    final dateStr = matches[1].group(1)?.trim();
    if (route == null || route.isEmpty || dateStr == null || dateStr.isEmpty) {
      return null;
    }

    final parsedDate = _parseDate(dateStr);
    if (parsedDate == null) return null;

    return _PickupInfo(route: route, date: parsedDate);
  }

  DateTime? _parseDate(String raw) {
    final normalized = _titleCase(raw.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim());
    try {
      return DateFormat('EEEE MMMM d, yyyy', 'en_US').parse(normalized);
    } catch (_) {
      return null;
    }
  }

  String _titleCase(String input) {
    return input
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}

class _AddressParts {
  _AddressParts({
    required this.houseNumber,
    required this.streetName,
    required this.formattedStreet,
    required this.formattedAddress,
    this.direction,
    this.streetType,
  });

  final String houseNumber;
  final String streetName;
  final String formattedStreet;
  final String formattedAddress;
  final String? direction;
  final String? streetType;

  static _AddressParts fromFreeform(String address) {
    final cleaned = address.trim().toUpperCase().replaceAll(RegExp(r'\s+'), ' ');
    final parts = cleaned.split(' ');
    if (parts.length < 2) {
      throw Exception('Enter a full street address (number, direction, name, type).');
    }

    final house = parts.removeAt(0);
    if (!RegExp(r'^\d+').hasMatch(house)) {
      throw Exception('Include a house number.');
    }

    const dirs = {'N', 'S', 'E', 'W'};
    String? direction;
    if (parts.isNotEmpty && dirs.contains(parts.first)) {
      direction = parts.removeAt(0);
    }

    const suffixes = {
      'ST',
      'AVE',
      'AV',
      'BLVD',
      'RD',
      'DR',
      'CT',
      'LN',
      'PL',
      'PKWY',
      'WAY',
      'TER',
      'CIR',
      'HWY',
    };
    String? type;
    if (parts.isNotEmpty && suffixes.contains(parts.last)) {
      type = parts.removeLast();
    }

    if (parts.isEmpty) {
      throw Exception('Street name missing.');
    }
    final name = parts.join(' ');
    final formattedStreet = [
      if (direction != null) direction,
      name,
      if (type != null) type,
    ].join(' ');

    return _AddressParts(
      houseNumber: house,
      direction: direction,
      streetName: name,
      streetType: type,
      formattedStreet: formattedStreet,
      formattedAddress: '$house $formattedStreet',
    );
  }
}

class _PickupInfo {
  _PickupInfo({required this.route, required this.date});
  final String route;
  final DateTime date;
}
