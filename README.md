# HabitFlow

A native SwiftUI habit tracker for building streaks, reviewing history and scheduling daily reminders. Data is stored locally with SwiftData; no account, cloud sync or paid dependency is required.

## Installation

```bash
cd 03-HabitFlow
brew install xcodegen
xcodegen generate
open HabitFlow.xcodeproj
```

## Build

```bash
xcodebuild -project HabitFlow.xcodeproj -scheme HabitFlow \
  -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath /tmp/HabitFlowDerived CODE_SIGNING_ALLOWED=NO build
```

## Architecture

- **Model**: `Habit` (SwiftData `@Model`) stores its name, icon, colour, completion day keys and reminder settings.
- **Analytics**: `HabitAnalytics` computes day keys, current streaks, weekly per-day totals, monthly completion rate and calendar cells.
- **Store**: `@Observable HabitStore` owns CRUD, persistence and notification scheduling behind `HabitNotificationScheduling`.
- **Views**: `TodayView`, `HabitsView`, `InsightsView`, `CalendarHistoryView` and `HabitEditorView`; reusable `HabitRow`, `ProgressRing`, `SectionCard` and `EmptyStateView`.

## Features

- Today dashboard with completion ring, streak labels and one-tap check-off.
- Create, edit and delete habits with icon, colour and hour picker.
- Daily local notifications with authorization handling.
- Insights with Swift Charts weekly bars, best streak, total completions and monthly rate.
- Interactive month calendar; tap any day to add or remove a completion.
- Demo data seeded on first run so the UI is immediately useful.
- Light and dark adaptive colours.

## Verification

- Build: passed on Xcode 26.0.1, iOS 17.0 deployment target.
- Test targets compile via `build-for-testing`.
- Unit and UI tests authored; execution skipped at the user's request after the earlier long test run.
- Installed and launched on iPhone 17 (iOS 26.0); genuine light and dark screenshots captured.

## Known limitations

- Local notification delivery and authorization prompts should be confirmed on a physical device.
- Data is local to one device; there is no iCloud sync or backup.
- Demo data is seeded once on first launch and can be deleted individually.
