import XCTest
@testable import ShortURL

final class HomeViewControllerUITests: XCTestCase {
    let app = XCUIApplication()
    
    func testAddShortURLToList_WhenAddValidURLInTextField_ShouldAppendURLInList() {
        app.launch()
        
        let textField = app.textFields["urlTextField"]
        let shortButton = app.buttons["ShortButton"]
        let collection = app.collectionViews["collection"]
        let originalDataSourceCount = collection.cells.count
        
        textField.tap()
        textField.typeText("https://www.google.com")
        
        shortButton.tap()
        
        XCTAssertTrue(collection.waitForExistence(timeout: 5))
        let cellCount = collection.cells.count
        XCTAssertEqual(cellCount, originalDataSourceCount+1)
    }
}
