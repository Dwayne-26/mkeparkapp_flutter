import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherSummary {
  WeatherSummary({
    required this.temperatureF,
    required this.shortForecast,
    required this.probabilityOfPrecip,
  });

  final double temperatureF;
  final String shortForecast;
  final int probabilityOfPrecip;
}

class WeatherService {
  Future<WeatherSummary?> fetchCurrent({
    required double lat,
    required double lng,
  }) async {
    // Step 1: resolve grid via points endpoint
    final pointsUri = Uri.parse(
        'https://api.weather.gov/points/${lat.toStringAsFixed(4)},${lng.toStringAsFixed(4)}');
    final pointsResp =
        await http.get(pointsUri, headers: _headers()).timeout(const Duration(seconds: 10));
    if (pointsResp.statusCode != 200) return null;
    final pointsJson = jsonDecode(pointsResp.body) as Map<String, dynamic>;
    final hourlyUrl =
        (pointsJson['properties']?['forecastHourly'] as String?)?.trim();
    if (hourlyUrl == null) return null;

    // Step 2: grab first period from hourly forecast
    final hourlyResp =
        await http.get(Uri.parse(hourlyUrl), headers: _headers()).timeout(const Duration(seconds: 10));
    if (hourlyResp.statusCode != 200) return null;
    final hourlyJson = jsonDecode(hourlyResp.body) as Map<String, dynamic>;
    final periods = hourlyJson['properties']?['periods'] as List<dynamic>?;
    if (periods == null || periods.isEmpty) return null;
    final first = periods.first as Map<String, dynamic>;
    final temp = (first['temperature'] as num?)?.toDouble();
    final precip = (first['probabilityOfPrecipitation']?['value'] as num?)
            ?.toDouble()
            ?.round() ??
        0;
    final short = (first['shortForecast'] as String?) ?? 'N/A';
    if (temp == null) return null;

    return WeatherSummary(
      temperatureF: temp,
      shortForecast: short,
      probabilityOfPrecip: precip,
    );
  }

  Map<String, String> _headers() => const {
        'Accept': 'application/geo+json',
        'User-Agent': 'mkeparkapp_flutter/1.0 (support@mkeparkapp.com)',
      };
}
