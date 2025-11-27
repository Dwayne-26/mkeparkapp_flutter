import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/garbage_schedule.dart';

class GarbageScheduleService {
  GarbageScheduleService({required this.baseUrl, this.authToken});

  final String baseUrl;
  final String? authToken;

  Map<String, String> _headers() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (authToken != null && authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
  }

  Future<List<GarbageSchedule>> fetchByLocation({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse('$baseUrl/garbage/schedule')
        .replace(queryParameters: {
      'lat': latitude.toString(),
      'lng': longitude.toString(),
    });
    final resp = await http.get(uri, headers: _headers());
    if (resp.statusCode != 200) {
      throw Exception('Failed to fetch schedule: ${resp.statusCode}');
    }
    final data = jsonDecode(resp.body) as List<dynamic>;
    return data
        .map((json) => _fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<GarbageSchedule>> fetchByAddress(String address) async {
    final uri = Uri.parse('$baseUrl/garbage/schedule')
        .replace(queryParameters: {'address': address});
    final resp = await http.get(uri, headers: _headers());
    if (resp.statusCode != 200) {
      throw Exception('Failed to fetch schedule: ${resp.statusCode}');
    }
    final data = jsonDecode(resp.body) as List<dynamic>;
    return data
        .map((json) => _fromJson(json as Map<String, dynamic>))
        .toList();
  }

  GarbageSchedule _fromJson(Map<String, dynamic> json) {
    return GarbageSchedule(
      routeId: json['routeId'] as String? ?? 'unknown',
      address: json['address'] as String? ?? '',
      pickupDate: _parseDate(json['pickupDate']),
      type: (json['type'] as String?)?.toLowerCase() == 'recycling'
          ? PickupType.recycling
          : PickupType.garbage,
    );
  }

  DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}
