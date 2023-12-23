import XCTest
@testable import Recipes

class DessertsListViewTest: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false;
        let app = XCUIApplication();
        app.launch();
    }

    func testDessertListViewLoadsCorrectlyAndNavigatesToDetailedView() throws {
        let app = XCUIApplication();

        // Verify desserts list view was correctly rendered.
        XCTAssertTrue(app.navigationBars["Desserts"].exists, "Desserts list not rendered correctly.");
        let dessertList = app.scrollViews.children(matching: .any).element(boundBy: 0);
        let exists = NSPredicate(format: "exists == 1");
        expectation(for: exists, evaluatedWith: dessertList, handler: nil);
        waitForExpectations(timeout: 2, handler: nil);
            
        // Verify that tapping on dessert card leads to dessert detail view.
        let firstDessertCard = dessertList.children(matching: .any).element(boundBy: 0);
        XCTAssertTrue(firstDessertCard.exists);
        firstDessertCard.tap();
        sleep(2);
        let dessertDetailTitle = app.staticTexts["Dessert Details"];
        XCTAssertTrue(dessertDetailTitle.exists, "Did not successfully navigate to detailed view.");
        
        // Verify dessert instructions renders.
        let instructionsText = app.staticTexts["RequiredIngredientsText"];
        XCTAssertTrue(instructionsText.exists, "Instructions text does not exist.");
        }
}
