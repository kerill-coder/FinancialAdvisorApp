import XCTest
import SwiftUI

class UITests: XCTestCase {

    func testMainViewUI() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["Финансовый AI-Советник"].exists)
        XCTAssertTrue(app.buttons["Запустить Анализ и Торговлю"].exists)
    }
}