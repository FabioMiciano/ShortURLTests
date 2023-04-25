import XCTest
@testable import ShortURL

final class HomeInteractorTests: XCTestCase {
    private lazy var serviceMock = MockHomeService()
    private lazy var presenterSpy = SpyHomePresenter()
    lazy var sut = HomeInteractor(service: serviceMock, presenter: presenterSpy)
    
    func testPushToShortURL_WhenReceiveValidURL_ShouldReturnSuccess() {
        // Given
        let linkModel = Link(original: "https://www.example.com", short: "https://localhost:3000/alias/1313")
        let expectedModel = ShortURL(alias: "131313", link: linkModel)
        serviceMock.submitURLToShortResult = .success(expectedModel)
        
        // When
        sut.pushToShortURL(url: "https://www.example.com")
        
        // Then
        XCTAssertEqual(presenterSpy.addShortURLToViewModel, expectedModel)
        XCTAssertEqual(serviceMock.submitURLToShortURLPassed, "https://www.example.com")
        XCTAssertEqual(serviceMock.submitURLToShortCompletionCalledCount, 1)
        XCTAssertEqual(serviceMock.saveLocalDataSourceItem, expectedModel)
        XCTAssertEqual(serviceMock.saveLocalDataSourceCalledCount, 1)
    }
    
    func testPushToShortURL_WhenReceiveValidURLAndErroInSave_ShouldReturnfailure() {
        // Given
        let linkModel = Link(original: "https://www.example.com", short: "https://localhost:3000/alias/1313")
        let expectedModel = ShortURL(alias: "131313", link: linkModel)
        serviceMock.submitURLToShortResult = .success(expectedModel)
        serviceMock.saveLocalDataSourceError = .decodingFailed
        
        // When
        sut.pushToShortURL(url: "https://www.example.com")
        
        // Then
        XCTAssertEqual(presenterSpy.addShortURLToViewModel, expectedModel)
        XCTAssertEqual(serviceMock.submitURLToShortURLPassed, "https://www.example.com")
        XCTAssertEqual(serviceMock.submitURLToShortCompletionCalledCount, 1)
        XCTAssertEqual(serviceMock.saveLocalDataSourceItem, expectedModel)
        XCTAssertEqual(serviceMock.saveLocalDataSourceCalledCount, 1)
    }
    
    func testPushToShortURL_WhenReceiveValidURL_ShouldReturnFailure() {
        // Given
        let expectedError = APIError.decodingFailed
        serviceMock.submitURLToShortResult = .failure(expectedError)

        // When
        sut.pushToShortURL(url: "https://www.example.com")

        // Then
        XCTAssertEqual(presenterSpy.showErrorCalledCount, 1)
        XCTAssertEqual(presenterSpy.showErrorReceivedError, expectedError)
        XCTAssertEqual(serviceMock.submitURLToShortURLPassed, "https://www.example.com")
        XCTAssertEqual(serviceMock.submitURLToShortCompletionCalledCount, 1)
    }

    func testLoadLocalList_WhenLoadIsCompleted_ShouldReturnSuccess() {
        // Given
        let linkModel = Link(original: "https://www.example.com", short: "https://localhost:3000/alias/1313")
        let expectedModel = ShortURL(alias: "131313", link: linkModel)
        let expectedDataSource = [expectedModel]
        serviceMock.loadLocalDataSourceResult = expectedDataSource

        // When
        sut.loadLocalList()

        // Then
        XCTAssertEqual(presenterSpy.loadLocalListDataSource, expectedDataSource)
        XCTAssertEqual(serviceMock.loadLocalDataSourceCalledCount, 1)
    }

    func testLoadLocalList_WhenNoHasDataInLocal_ShouldReturnFailure() {
        // Given
        serviceMock.loadLocalDataSourceResult = nil

        // When
        sut.loadLocalList()

        // Then
        XCTAssertEqual(presenterSpy.showErrorCalledCount, 1)
        XCTAssertEqual(presenterSpy.showErrorReceivedError, .decodingFailed)
        XCTAssertEqual(serviceMock.loadLocalDataSourceCalledCount, 1)
    }
}

private final class MockHomeService: HomeServicing {
    var submitURLToShortResult: Result<ShortURL, APIError>?
    
    private(set) var submitURLToShortURLPassed: String?
    private(set) var submitURLToShortCompletionCalledCount = 0
   
    func submitURLToShort(url: String, completion: @escaping (Result<ShortURL, APIError>) -> Void) {
        submitURLToShortURLPassed = url
        submitURLToShortCompletionCalledCount += 1
                
        if let result = submitURLToShortResult {
            completion(result)
        }
    }
    
    var saveLocalDataSourceError: APIError?
    private(set) var saveLocalDataSourceItem: ShortURL?
    private(set) var saveLocalDataSourceCalledCount = 0
    
    func saveLocalDataSource(item: ShortURL) throws {
        saveLocalDataSourceCalledCount += 1
        saveLocalDataSourceItem = item
                
        if let error = saveLocalDataSourceError {
            throw error
        }
    }
    
    var loadLocalDataSourceResult: [ShortURL]?
    private(set) var loadLocalDataSourceCalledCount = 0
    
    func loadLocalDataSource() throws -> [ShortURL] {
        loadLocalDataSourceCalledCount += 1
                
        guard let result = loadLocalDataSourceResult else  {
            throw APIError.decodingFailed
        }
        
        return result
    }
}

private final class SpyHomePresenter: HomePresenting {
    private(set) var addShortURLToViewModel: ShortURL?
    
    func addShortURLToView(model: ShortURL) {
        addShortURLToViewModel = model
    }
    
    private(set) var showErrorCalledCount = 0
    private(set) var showErrorReceivedError: APIError?
    private(set) var showErrorMessage: String?
    
    func showError(error: APIError) {
        showErrorCalledCount += 1
        showErrorReceivedError = error
        showErrorMessage = "Ops, aconteceu um erro"
    }
    
    private(set) var loadLocalListDataSource: [ShortURL]?
    
    func loadLocalList(dataSource: [ShortURL]) {
        loadLocalListDataSource = dataSource
    }
}
