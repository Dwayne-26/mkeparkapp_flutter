import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../citysmart/theme.dart';
import '../providers/user_provider.dart';
import '../services/risk_alert_service.dart';
import '../services/alternate_side_parking_service.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, _) {
        if (provider.isInitializing) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final profile = provider.profile;
        final isGuest = provider.isGuest;
        // Start in-app risk watcher (no-op if already running).
        RiskAlertService.instance.start(provider);
        if (!isGuest && profile == null) {
          return Scaffold(
            backgroundColor: CSTheme.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Please sign in to view your dashboard.',
                    style: TextStyle(color: CSTheme.text),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/auth'),
                    child: const Text('Sign in'),
                  ),
                ],
              ),
            ),
          );
        }

        final vehicles = profile?.vehicles ?? const [];
        final name = profile?.name.split(' ').first ?? 'Guest';
        final address =
            profile?.address?.isNotEmpty == true
                ? profile!.address!
                : isGuest
                ? 'Exploring in guest mode. Sign in to personalize alerts.'
                : 'Set your address for hyper-local alerts.';
        final alertsLabel = isGuest
            ? 'Preview'
            : (profile?.preferences.parkingNotifications ?? false
                ? 'Enabled'
                : 'Muted');
        final altService = AlternateSideParkingService();
        final addressNumber = _addressNumber(profile?.address);
        final altStatus = altService.status(addressNumber: addressNumber);
        return Scaffold(
          backgroundColor: CSTheme.background,
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _HeaderCard(
                name: name,
                address: address,
                isGuest: isGuest,
                riskScore: provider.towRiskIndex,
                radius: provider.profile?.preferences.geoRadiusMiles ?? 5,
                alertsLabel: alertsLabel,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _OverviewTile(
                    icon: Icons.directions_car,
                    label: 'Vehicles',
                    value: vehicles.length.toString(),
                    onTap: () => Navigator.pushNamed(context, '/vehicles'),
                  ),
                  _OverviewTile(
                    icon: Icons.badge,
                    label: 'Permit workflow',
                    value: 'Eligibility',
                    onTap: () => Navigator.pushNamed(context, '/permit-workflow'),
                  ),
                  _OverviewTile(
                    icon: Icons.compare_arrows,
                    label: 'Alt-side parking',
                    value: altStatus.sideToday == ParkingSide.odd
                        ? 'Odd side'
                        : 'Even side',
                    onTap: () =>
                        Navigator.pushNamed(context, '/alternate-parking'),
                  ),
                  _OverviewTile(
                    icon: Icons.notifications_active_outlined,
                    label: 'Alerts',
                    value: alertsLabel,
                    onTap: () => Navigator.pushNamed(context, '/preferences'),
                  ),
                  _OverviewTile(
                    icon: Icons.electric_bolt,
                    label: 'EV charging',
                    value: 'Map',
                    onTap: () => Navigator.pushNamed(context, '/charging'),
                  ),
                  _OverviewTile(
                    icon: Icons.workspace_premium,
                    label: 'Plan',
                    value: 'Free/Plus/Pro',
                    onTap: () => Navigator.pushNamed(context, '/subscriptions'),
                  ),
                  _OverviewTile(
                    icon: Icons.delete_outline,
                    label: 'Garbage day',
                    value: 'Schedule',
                    onTap: () => Navigator.pushNamed(context, '/garbage'),
                  ),
                  _OverviewTile(
                    icon: Icons.home_repair_service,
                    label: 'Maintenance',
                    value: 'Report',
                    onTap: () => Navigator.pushNamed(context, '/maintenance'),
                  ),
                  _OverviewTile(
                    icon: Icons.warning_amber_rounded,
                    label: 'Report sighting',
                    value: 'Tow/Enforcer',
                    onTap: () =>
                        Navigator.pushNamed(context, '/report-sighting'),
                  ),
                  _OverviewTile(
                    icon: Icons.receipt_long,
                    label: 'Tickets',
                    value: 'Lookup',
                    onTap: () => Navigator.pushNamed(context, '/tickets'),
                  ),
                  _OverviewTile(
                    icon: Icons.history_edu,
                    label: 'Receipts',
                    value: 'History',
                    onTap: () =>
                        Navigator.pushNamed(context, '/history/receipts'),
                  ),
                  _OverviewTile(
                    icon: Icons.public,
                    label: 'City & language',
                    value: 'Settings',
                    onTap: () => Navigator.pushNamed(context, '/city-settings'),
                  ),
                  _OverviewTile(
                    icon: Icons.history,
                    label: 'History',
                    value: 'View',
                    onTap: () => Navigator.pushNamed(context, '/history'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Profile & settings'),
                      subtitle: Text(
                        isGuest
                            ? 'Sign in to save preferences'
                            : profile!.email,
                      ),
                      onTap: () {
                        if (isGuest) {
                          Navigator.pushReplacementNamed(context, '/auth');
                        } else {
                          Navigator.pushNamed(context, '/profile');
                        }
                      },
                    ),
                    const Divider(height: 0),
                    ListTile(
                      leading: const Icon(Icons.directions_car_filled),
                      title: const Text('Vehicle garage'),
                      subtitle: Text('${vehicles.length} vehicle(s) connected'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.pushNamed(context, '/vehicles'),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      leading: const Icon(Icons.settings_suggest_outlined),
                      title: const Text('Notification preferences'),
                      subtitle: const Text('Customize tow alerts & reminders'),
                      onTap: () => Navigator.pushNamed(context, '/preferences'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int _addressNumber(String? address) {
    if (address == null) return 0;
    final match = RegExp(r'(\\d+)').firstMatch(address);
    if (match == null) return 0;
    return int.tryParse(match.group(0) ?? '0') ?? 0;
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.name,
    required this.address,
    required this.isGuest,
    required this.riskScore,
    required this.radius,
    required this.alertsLabel,
  });

  final String name;
  final String address;
  final bool isGuest;
  final int riskScore;
  final int radius;
  final String alertsLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [CSTheme.primary, CSTheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, $name',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        address,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                _RiskBadge(score: riskScore),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _InfoPill(
                  icon: Icons.radar,
                  label: 'Alert radius: $radius mi',
                ),
                _InfoPill(
                  icon: Icons.notifications_active_outlined,
                  label: 'Alerts: $alertsLabel',
                ),
                if (isGuest)
                  const _InfoPill(
                    icon: Icons.visibility_outlined,
                    label: 'Guest preview',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewTile extends StatelessWidget {
  const _OverviewTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 40) / 2;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: width.clamp(150, double.infinity),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CSTheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
          border: Border.all(color: CSTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: CSTheme.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: CSTheme.primary),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                color: CSTheme.text,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: CSTheme.textMuted,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiskBadge extends StatelessWidget {
  const _RiskBadge({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    Color color;
    if (score >= 70) {
      color = Colors.redAccent;
    } else if (score >= 40) {
      color = Colors.orange;
    } else {
      color = Colors.green;
    }
    final status = score >= 70
        ? 'High risk'
        : score >= 40
            ? 'Moderate'
            : 'Low';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$score',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            status,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
