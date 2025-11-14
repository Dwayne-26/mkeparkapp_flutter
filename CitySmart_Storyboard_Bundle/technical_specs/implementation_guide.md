# CitySmart Technical Specifications

## Platform Requirements

### Flutter Framework
- **Minimum Version**: Flutter 3.13.0
- **Dart Version**: 3.1.0+
- **Target Platforms**: iOS, Android, Web (responsive)

### iOS Requirements
- **Minimum iOS Version**: 15.0
- **Xcode Version**: 15.0+
- **Device Support**: iPhone 8 and newer, iPad (6th generation) and newer

### Android Requirements
- **Minimum API Level**: 26 (Android 8.0)
- **Target API Level**: 34 (Android 14)
- **Architecture**: arm64-v8a, armeabi-v7a, x86_64

## Core Dependencies

### Navigation & State Management
```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^12.0.0
  provider: ^6.1.0
  flutter_bloc: ^8.1.0
```

### Location & Maps
```yaml
  google_maps_flutter: ^2.5.0
  geolocator: ^10.0.0
  geocoding: ^2.1.0
  permission_handler: ^11.0.0
```

### Networking & Data
```yaml
  http: ^1.1.0
  dio: ^5.3.0
  json_annotation: ^4.8.0
  json_serializable: ^6.7.0
```

### Local Storage
```yaml
  hive: ^2.2.0
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.0
  path_provider: ^2.1.0
```

### UI & Animations
```yaml
  flutter_svg: ^2.0.0
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  lottie: ^2.7.0
```

### Authentication & Security
```yaml
  firebase_auth: ^4.15.0
  google_sign_in: ^6.1.0
  crypto: ^3.0.0
  flutter_secure_storage: ^9.0.0
```

### Notifications & Background Tasks
```yaml
  firebase_messaging: ^14.7.0
  flutter_local_notifications: ^16.0.0
  workmanager: ^0.5.0
```

## API Specifications

### Base Configuration
```dart
class ApiConfig {
  static const String baseUrl = 'https://api.citysmart-milwaukee.com/v1';
  static const String mapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  static const String firebaseApiKey = 'YOUR_FIREBASE_API_KEY';
  static const int timeoutSeconds = 30;
}
```

### Authentication Endpoints
```
POST /auth/login
POST /auth/register
POST /auth/refresh
DELETE /auth/logout
GET /auth/profile
PUT /auth/profile
```

### Parking Endpoints
```
GET /parking/search
  - Parameters: lat, lng, radius, filters
  - Returns: List of available parking spots

GET /parking/spot/{id}
  - Returns: Detailed spot information

POST /parking/reserve
  - Body: spot_id, duration, vehicle_info
  - Returns: Reservation confirmation

DELETE /parking/reserve/{id}
  - Cancels reservation

GET /parking/history
  - Returns: User parking history

POST /parking/payment
  - Body: reservation_id, payment_method
  - Returns: Payment confirmation
```

### Permit Endpoints
```
GET /permits
  - Returns: User's active permits

POST /permits/renew
  - Body: permit_id, duration, payment_info
  - Returns: Renewed permit details

GET /permits/{id}/qr
  - Returns: QR code for permit verification

GET /permits/history
  - Returns: Permit history and transactions
```

### Street Sweeping Endpoints
```
GET /street-sweeping/schedule
  - Parameters: lat, lng, radius
  - Returns: Upcoming street sweeping schedule

POST /street-sweeping/alert
  - Body: location, notification_preferences
  - Returns: Alert subscription confirmation

GET /street-sweeping/violations
  - Returns: User's violation history
```

## Data Models

### User Model
```dart
class User {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final List<Vehicle> vehicles;
  final UserPreferences preferences;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### Vehicle Model
```dart
class Vehicle {
  final String id;
  final String licensePlate;
  final String make;
  final String model;
  final int year;
  final String color;
  final VehicleType type;
  final bool isDefault;
}
```

### Parking Spot Model
```dart
class ParkingSpot {
  final String id;
  final double latitude;
  final double longitude;
  final String address;
  final SpotType type;
  final SpotStatus status;
  final double? hourlyRate;
  final double? maxDuration;
  final List<String> restrictions;
  final double distance;
  final DateTime? availableUntil;
}
```

### Permit Model
```dart
class Permit {
  final String id;
  final String permitNumber;
  final PermitType type;
  final DateTime startDate;
  final DateTime endDate;
  final PermitStatus status;
  final Vehicle vehicle;
  final String? zone;
  final double cost;
  final String qrCode;
}
```

## Local Storage Schema

### Hive Boxes
```dart
// User data and preferences
@HiveType(typeId: 0)
class LocalUser extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String email;
  @HiveField(2) String? firstName;
  @HiveField(3) String? lastName;
  @HiveField(4) List<LocalVehicle> vehicles;
  @HiveField(5) LocalPreferences preferences;
}

// Cached parking spots
@HiveType(typeId: 1)
class CachedParkingSpot extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) double latitude;
  @HiveField(2) double longitude;
  @HiveField(3) String address;
  @HiveField(4) String type;
  @HiveField(5) DateTime cachedAt;
  @HiveField(6) DateTime? expiresAt;
}
```

### SharedPreferences Keys
```dart
class PreferenceKeys {
  static const String userToken = 'user_token';
  static const String refreshToken = 'refresh_token';
  static const String lastKnownLocation = 'last_known_location';
  static const String notificationSettings = 'notification_settings';
  static const String mapSettings = 'map_settings';
  static const String onboardingCompleted = 'onboarding_completed';
}
```

## Performance Specifications

### App Launch Time
- **Cold Start**: < 3 seconds
- **Warm Start**: < 1 second
- **Memory Usage**: < 150MB baseline

### Network Performance
- **API Response Time**: < 2 seconds (95th percentile)
- **Image Loading**: Progressive loading with placeholders
- **Offline Capability**: 24 hours cached data

### Battery Optimization
- **Location Updates**: Intelligent frequency based on movement
- **Background Tasks**: Minimal processing, efficient scheduling
- **Network Calls**: Batching and deduplication

## Security Requirements

### Data Protection
- **Encryption**: AES-256 for sensitive data storage
- **API Communication**: HTTPS/TLS 1.3 minimum
- **Token Management**: JWT with refresh token rotation
- **Biometric Auth**: Face ID, Touch ID, Fingerprint support

### Privacy Compliance
- **Location Data**: Opt-in consent, minimal retention
- **User Data**: GDPR/CCPA compliant data handling
- **Analytics**: Anonymized usage data only
- **Third-Party SDKs**: Privacy-compliant integrations

## Testing Requirements

### Unit Tests
- **Coverage**: Minimum 80% code coverage
- **Business Logic**: All service classes and utilities
- **Data Models**: Serialization and validation

### Integration Tests
- **API Integration**: Mock server testing
- **Database Operations**: Local storage CRUD operations
- **Authentication Flow**: Complete auth cycle testing

### Widget Tests
- **UI Components**: All custom widgets
- **Screen Interactions**: User flow testing
- **Accessibility**: Screen reader compatibility

### End-to-End Tests
- **Critical Paths**: Parking search, payment, permit renewal
- **Cross-Platform**: iOS and Android parity
- **Performance**: Load testing and memory profiling

---
*Technical specifications for CitySmart v1.6 - Milwaukee Implementation*