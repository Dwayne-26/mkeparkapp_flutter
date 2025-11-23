import '../models/city_rule_pack.dart';

const defaultRulePack = CityRulePack(
  cityId: 'default',
  displayName: 'Default City',
);

const cityRulePacks = <CityRulePack>[
  CityRulePack(
    cityId: 'milwaukee',
    displayName: 'Milwaukee, WI',
    maxVehicles: 7,
    defaultAlertRadius: 5,
    quotaRequestsPerHour: 200,
    rateLimitPerMinute: 60,
  ),
  CityRulePack(
    cityId: 'chicago',
    displayName: 'Chicago, IL',
    maxVehicles: 6,
    defaultAlertRadius: 8,
    quotaRequestsPerHour: 180,
    rateLimitPerMinute: 50,
  ),
  CityRulePack(
    cityId: 'madison',
    displayName: 'Madison, WI',
    maxVehicles: 5,
    defaultAlertRadius: 6,
    quotaRequestsPerHour: 150,
    rateLimitPerMinute: 40,
  ),
];

CityRulePack rulePackFor(String cityId) {
  return cityRulePacks.firstWhere(
    (c) => c.cityId == cityId,
    orElse: () => defaultRulePack,
  );
}
