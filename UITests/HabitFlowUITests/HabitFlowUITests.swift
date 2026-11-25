import XCTest

final class HabitFlowUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["-UITestReset"]
        app.launch()
    }

    func testTodayScreenShowsProgressAndHabits() {
        XCTAssertTrue(app.staticTexts["Make today count."].exists)
        XCTAssertTrue(app.buttons["toggle-Morning meditation"].exists)
        XCTAssertTrue(app.buttons["add-habit-button"].firstMatch.exists)
    }

    func testToggleHabitUpdatesCompletion() {
        let button = app.buttons["toggle-Morning meditation"]
        XCTAssertTrue(button.exists)
        button.tap()
        XCTAssertTrue(app.staticTexts["Daily progress"].exists)
    }

    func testCreateNewHabit() {
        app.buttons["add-habit-button"].firstMatch.tap()
        let field = app.textFields["habit-name-field"]
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        field.tap()
        field.typeText("Test Habit")
        app.buttons["save-habit"].tap()
        XCTAssertTrue(app.staticTexts["Test Habit"].waitForExistence(timeout: 5))
    }

    func testInsightsShowsChartAndCalendar() {
        app.buttons["Insights"].tap()
        XCTAssertTrue(app.staticTexts["See your momentum."].exists)
        XCTAssertTrue(app.otherElements["insights-chart"].exists)
        XCTAssertTrue(app.otherElements["calendar-grid"].exists)
    }
}
