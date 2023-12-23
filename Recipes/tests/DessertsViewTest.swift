import XCTest
@testable import Recipes

class DessertListViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false

        let app = XCUIApplication()
        app.launch()
    }

    func testDessertListView() throws {
        let app = XCUIApplication()

        // Assert that the navigation title is present
        XCTAssertTrue(app.navigationBars["Desserts"].exists)

        // Wait for the desserts list to load
        let dessertList = app.scrollViews.children(matching: .any).element(boundBy: 0)
        let exists = NSPredicate(format: "exists == 1")
        
        expectation(for: exists, evaluatedWith: dessertList, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        // Assert that at least one dessert card is present
        XCTAssertTrue(dessertList.exists)

        // Optionally, tap on the first dessert card if it's identifiable
        // app.buttons["DessertCardIdentifier"].firstMatch.tap()

        // Add more assertions as needed to verify the UI's behavior
    }
}
