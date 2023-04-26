import XCTest
@testable import ShortURL

final class HomePresenterTests: XCTestCase {
    private lazy var displaySpy = HomeViewControllerSpy()
    lazy var sut: HomePresenter = {
        let controller = HomePresenter()
        controller.display = displaySpy
        return controller
    }()
    
    func testAddShortURLToView_WhenReceiveValidModel_ShouldCallAddFunctionInDisplay() {
        // Given
        let shortURL = ShortURL(alias: "1313", link: Link(original: "https://www.example.com", short: "https://localhost:3000/alias/1313"))
        
        // When
        sut.addShortURLToView(model: shortURL)
        
        // Then
        XCTAssertEqual(displaySpy.addShortURLToViewCalledCount, 1)
        XCTAssertEqual(displaySpy.addShortURLToViewModel, shortURL)
    }
    
    func testShowError_WhenReceiveRequestFailedErrorType_ShouldCallSnackBarInDisplay() {
        // Given
        let error = APIError.requestFailed(error: NSError(domain: "Test", code: 0, userInfo: nil))
        
        // When
        sut.showError(error: error)
        
        // Then
        XCTAssertEqual(displaySpy.showErrorSnackBarCalledCount, 1)
        XCTAssertNotNil(displaySpy.showErrorSnackBarMessage)
    }
    
    func testShowError_WhenReceiveRequestFailedWithMessageErrorType_ShouldCallSnackBarInDisplay() {
        // Given
        let statusCode = 400
        let message = "Bad Request"
        let error = APIError.requestFailedWith(statusCode: statusCode, message: message)
        
        // When
        sut.showError(error: error)
        
        // Then
        XCTAssertEqual(displaySpy.showErrorSnackBarCalledCount, 1)
        XCTAssertEqual(displaySpy.showErrorSnackBarMessage, "CODE: \(statusCode) | \(message)")
    }
    
    func testShowError_WhenReceiveDecodingErrorType_ShouldCallSnackBarInDisplay() {
        // Given
        let error = APIError.decodingFailed
        
        // When
        sut.showError(error: error)
        
        // Then
        XCTAssertEqual(displaySpy.showErrorSnackBarCalledCount, 1)
        XCTAssertEqual(displaySpy.showErrorSnackBarMessage, "Ops, algo deu errado, tente novamente")
    }
    
    func testLoadLocalList_WhenReceiveValidDataSource_ShouldCallLoadDataInDisplay() {
        // Given
        let dataSource = [
            ShortURL(alias: "1313", link: Link(original: "https://www.example.com/abc", short: "https://localhost:3000/1313")),
            ShortURL(alias: "1414", link: Link(original: "https://www.example.com/def", short: "https://localhost:3000/1414")),
            ShortURL(alias: "1515", link: Link(original: "https://www.example.com/ghi", short: "https://localhost:3000/1515"))
        ]
        
        // When
        sut.loadLocalList(dataSource: dataSource)
        
        // Then
        XCTAssertEqual(displaySpy.loadLocalCalledCount, 1)
        XCTAssertEqual(displaySpy.loadLocalDataSource, dataSource)
    }
}

private final class HomeViewControllerSpy: HomeDisplay {
    private(set) var loadLocalCalledCount = 0
    private(set) var loadLocalDataSource: [ShortURL]?
    
    func loadLocal(dataSource: [ShortURL]) {
        loadLocalCalledCount += 1
        loadLocalDataSource = dataSource
    }
    
    private(set) var addShortURLToViewCalledCount = 0
    private(set) var addShortURLToViewModel: ShortURL?
    
    func addShortURLToView(model: ShortURL) {
        addShortURLToViewCalledCount += 1
        addShortURLToViewModel = model
    }
    
    private(set) var showErrorSnackBarCalledCount = 0
    private(set) var showErrorSnackBarMessage: String?
    
    func showErrorSnackBar(error: String) {
        showErrorSnackBarCalledCount += 1
        showErrorSnackBarMessage = error
    }
}
