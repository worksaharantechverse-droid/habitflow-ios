# Technical Challenges — HabitFlow

## Streak semantics

A streak should survive an incomplete current day by counting backward from yesterday, but must stop at the first missing day. `HabitAnalytics.streak` implements that rule as a pure function so it can be tested without SwiftUI or SwiftData.

## Calendar completion keys

Storing completions as `yyyy-MM-dd` strings avoids timezone drift from full timestamps and lets the calendar toggle any historical day with the same code path used for today.

## SwiftData observation

The store refetches after every save and publishes the resulting array, keeping tab views consistent after edits, deletions and calendar toggles without manual notifications.

## Notification testability

`UNUserNotificationCenter` is hard to use in deterministic tests. A protocol boundary and a no-op implementation let the store be exercised in memory without permission dialogs or pending notifications.

## Chart sizing

The weekly chart uses a fixed domain derived from the number of habits, preventing an empty chart from collapsing and keeping bar heights comparable across days.

## Physical-device testing

Notification delivery and permission prompts are documented rather than claimed as verified.
