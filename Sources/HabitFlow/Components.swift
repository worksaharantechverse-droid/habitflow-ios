import SwiftUI

struct SectionCard<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(AppTheme.Typography.section)
                .foregroundStyle(AppTheme.primaryText)
            content
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

struct HabitRow: View {
    let habit: Habit
    let isCompleted: Bool
    let toggle: () -> Void
    let edit: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Button(action: edit) {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(habit.color.opacity(0.16))
                        Image(systemName: habit.symbol)
                            .foregroundStyle(habit.color)
                    }
                    .frame(width: 44, height: 44)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(habit.name)
                            .font(AppTheme.Typography.body.weight(.semibold))
                            .foregroundStyle(AppTheme.primaryText)
                        Text("\(HabitAnalytics.streak(habit)) day streak")
                            .font(AppTheme.Typography.caption)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                }
            }
            .buttonStyle(.plain)
            Spacer()
            Button(action: toggle) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isCompleted ? habit.color : AppTheme.secondaryText)
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("toggle-\(habit.name)")
        }
        .padding(.vertical, 6)
    }
}

struct ProgressRing: View {
    let progress: Double
    let tint: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(AppTheme.surfaceAlt, lineWidth: 12)
            Circle()
                .trim(from: 0, to: min(max(progress, 0), 1))
                .stroke(tint, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))
            VStack {
                Text("\(Int(min(max(progress, 0), 1) * 100))%")
                    .font(AppTheme.Typography.title)
                Text("complete")
                    .font(AppTheme.Typography.caption)
            }
            .foregroundStyle(AppTheme.primaryText)
        }
        .frame(width: 130, height: 130)
    }
}

struct EmptyStateView: View {
    let title: String
    let message: String
    let systemImage: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 40))
                .foregroundStyle(AppTheme.violet)
            Text(title)
                .font(AppTheme.Typography.section)
                .foregroundStyle(AppTheme.primaryText)
            Text(message)
                .font(AppTheme.Typography.body)
                .foregroundStyle(AppTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(28)
    }
}
