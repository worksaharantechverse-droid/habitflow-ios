# Architecture — HabitFlow

## Layers

| Layer | Types | Responsibility |
|-------|-------|----------------|
| Model | `Habit` | SwiftData persistence of habit metadata and `yyyy-MM-dd` completion keys |
| Analytics | `HabitAnalytics` | Pure date and streak calculations, independent of SwiftUI |
| Store | `HabitStore` | CRUD, fetch sorting, notification scheduling and error presentation |
| Services | `HabitNotificationScheduling`, `UserNotificationScheduler`, `NoopNotificationScheduler` | Real and test notification paths |
| Views | `RootView`, `TodayView`, `HabitsView`, `InsightsView`, `CalendarHistoryView`, `HabitEditorView` | Tab navigation and feature screens |

## State flow

`RootView` creates the store, injects the SwiftData `ModelContext` on appear and shares the store with all tabs. Mutations go through `HabitStore`, which saves the context, refetches and publishes changes through `@Observable`.

## Date handling

Completion state is stored as stable date keys rather than full timestamps, so toggling a habit on a past calendar day works identically to toggling it today. `HabitAnalytics` owns key formatting and calendar arithmetic, keeping views free of date logic.

## Notifications

Reminder identifiers are generated per habit. Enabling or editing a reminder schedules a repeating `UNCalendarNotificationTrigger`; deleting or disabling cancels it. The protocol boundary allows tests to avoid real notification authorization.

## SOLID application

- Single responsibility: analytics, persistence and notifications are separate.
- Liskov substitution: the no-op scheduler conforms to the same protocol as the real scheduler.
- Dependency inversion: the store depends on a notification abstraction, not `UNUserNotificationCenter`.
