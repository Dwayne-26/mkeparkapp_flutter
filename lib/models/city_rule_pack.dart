class CityRulePack {
  const CityRulePack({
    required this.cityId,
    required this.displayName,
    this.maxVehicles = 5,
    this.defaultAlertRadius = 5,
    this.quotaRequestsPerHour = 100,
    this.rateLimitPerMinute = 30,
  });

  final String cityId;
  final String displayName;
  final int maxVehicles;
  final int defaultAlertRadius;
  final int quotaRequestsPerHour;
  final int rateLimitPerMinute;
}
