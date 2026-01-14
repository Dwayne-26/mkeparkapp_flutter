# Alternate Side Parking Feature

## Overview

This feature helps users comply with alternate side parking regulations, which are common in many cities for street cleaning and snow removal. The system automatically determines which side of the street to park on based on the day of the month.

## Algorithm

The algorithm is simple and robust:

- **Odd Days** (1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31): Park on the **odd-numbered** side of the street
- **Even Days** (2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30): Park on the **even-numbered** side of the street

The rule resets at **midnight (12:00 AM)** each day.

## Implementation Details

### Core Service: `AlternateSideParkingService`

**Location:** `lib/services/alternate_side_parking_service.dart`

**Key Methods:**

```dart
// Get parking instructions for any date
ParkingInstructions getParkingInstructions(DateTime date)

// Get today's instructions
ParkingInstructions getTodayInstructions()

// Get tomorrow's instructions
ParkingInstructions getTomorrowInstructions()

// Check if side will change tomorrow
bool willSideChangeTomorrow()

// Get instructions for next N days
List<ParkingInstructions> getUpcomingInstructions(int days)

// Generate user-friendly reminder text
String getParkingReminder({DateTime? forDate, bool includeTime = false})

// Validate if vehicle is parked on correct side
bool isCorrectSide(ParkingSide vehicleSide, {DateTime? forDate})

// Generate notification messages
NotificationMessage getNotificationMessage({required NotificationType type, DateTime? forDate})
```

**Data Structures:**

```dart
enum ParkingSide {
  odd,   // Odd-numbered addresses (1, 3, 5, 7...)
  even,  // Even-numbered addresses (2, 4, 6, 8...)
}

class ParkingInstructions {
  final DateTime date;
  final int dayOfMonth;
  final bool isOddDay;
  final ParkingSide parkingSide;
  final DateTime nextSwitchDate;
  
  String get sideLabel;        // "Odd" or "Even"
  String get sideExamples;     // "1, 3, 5, 7, 9..." or "2, 4, 6, 8, 10..."
  Duration get timeUntilSwitch;
  bool get isSwitchingSoon;    // True if < 2 hours until midnight
}
```

### UI Components

#### 1. Dashboard Tile Widget
**Location:** `lib/widgets/alternate_side_parking_card.dart`

**Class:** `AlternateSideParkingTile`

- Compact card for the dashboard
- Shows today's parking side with large day number
- Color-coded: Orange for odd days, Blue for even days
- Tappable to navigate to full screen

#### 2. Full Information Card
**Location:** `lib/widgets/alternate_side_parking_card.dart`

**Class:** `AlternateSideParkingCard`

- Detailed view with today and tomorrow
- Shows upcoming 7-14 days
- Warning banner when side changes soon (< 2 hours)
- Visual indicators with colored badges

#### 3. Full Screen
**Location:** `lib/screens/alternate_side_parking_screen.dart`

**Class:** `AlternateSideParkingScreen`

Features:
- Complete parking schedule
- "How It Works" explanation
- Parking tips
- Notification configuration options
- Info dialog with detailed rules

### Integration Points

#### Main App Routes
Added route in `lib/main.dart`:
```dart
'/alternate-side-parking': (context) => const AlternateSideParkingScreen()
```

#### Dashboard Integration
Added to `lib/screens/landing_screen.dart`:
```dart
const AlternateSideParkingTile()
```

## Visual Design

### Color Scheme

- **Odd Days**: Orange (#FF9800)
  - Signifies caution and attention
  - Easy to distinguish from even days
  
- **Even Days**: Blue (#2196F3)
  - Calm and professional
  - Clear visual contrast

### Layout Features

- Rounded corners (12-16px) for modern look
- Subtle shadows for depth
- Clear typography hierarchy
- Color-coded badges for quick identification
- Generous whitespace for readability

## Notification Types

The system supports three notification types:

1. **Morning Reminder** (7:00 AM)
   - Normal priority
   - Daily reminder of current parking side
   - "Today is odd. Park on the odd-numbered side."

2. **Evening Warning** (9:00 PM)
   - High priority
   - Advance warning before midnight switch
   - "Move your car before midnight! Tomorrow park on the even side."

3. **Midnight Alert** (12:00 AM)
   - Urgent priority
   - Immediate notification when side changes
   - "Switch parking side now! Park on the odd-numbered side."

## Testing

Comprehensive test suite: `test/alternate_side_parking_service_test.dart`

**Test Coverage:**
- ✅ Odd day identification
- ✅ Even day identification
- ✅ Side label generation
- ✅ Next switch date calculation
- ✅ Tomorrow side detection
- ✅ Upcoming days generation
- ✅ Vehicle parking validation
- ✅ Notification message generation
- ✅ Parking reminder formatting
- ✅ JSON serialization
- ✅ Month transition handling
- ✅ Leap year handling

## Edge Cases Handled

1. **Month Transitions**
   - Jan 31 (odd) → Feb 1 (odd): Same side
   - Jan 30 (even) → Jan 31 (odd): Different side

2. **Leap Years**
   - Feb 29 (odd) → Mar 1 (odd): Same side
   - Handles both leap and non-leap years

3. **Time Zones**
   - Uses device local time
   - Midnight switch respects local timezone

4. **Near-Midnight Scenarios**
   - "Switching soon" warning when < 2 hours until midnight
   - Time until switch displayed in hours and minutes

## User Benefits

1. **Never Forget**: Automatic daily reminders
2. **Plan Ahead**: See upcoming week's schedule
3. **Avoid Tickets**: Warnings before side changes
4. **Visual Clarity**: Color-coded interface
5. **Quick Reference**: Dashboard widget for instant info
6. **Educational**: Built-in explanation of rules

## Future Enhancements

Potential improvements:
- Push notifications at scheduled times
- Integration with calendar app
- Custom notification times
- Location-based rules (some cities have exceptions)
- Photo upload of street signs
- Historical parking side tracking
- Share schedule with family/roommates

## Usage Example

```dart
// Get today's parking side
final service = AlternateSideParkingService.instance;
final today = service.getTodayInstructions();

print('Day: ${today.dayOfMonth}');
print('Side: ${today.sideLabel}');
print('Examples: ${today.sideExamples}');

// Check if vehicle is parked correctly
bool isCorrect = service.isCorrectSide(ParkingSide.odd);

// Get reminder text
String reminder = service.getParkingReminder(includeTime: true);
// Output: "Park on the odd-numbered side today (Mon, 1). Switch in 13h 24m."

// Get upcoming week
List<ParkingInstructions> week = service.getUpcomingInstructions(7);
for (var day in week) {
  print('${day.dayOfMonth}: ${day.sideLabel} side');
}
```

## Technical Notes

- **Singleton Pattern**: Service uses singleton for consistent state
- **Immutable Data**: ParkingInstructions is immutable
- **Type Safety**: Strong typing with enums
- **Testability**: Pure functions, easy to test
- **Performance**: O(1) calculations, no external dependencies
- **Memory Efficient**: Stateless calculations, no caching needed

## Accessibility

- Clear visual indicators (color + icons + text)
- Large touch targets (minimum 48px)
- High contrast color scheme
- Screen reader compatible
- Supports dynamic text sizing

---

**Last Updated:** November 24, 2025
**Version:** 1.0.0
**Status:** Production Ready ✅
