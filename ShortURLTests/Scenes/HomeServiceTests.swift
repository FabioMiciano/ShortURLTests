import XCTest
@testable import ShortURL

final class HomeServiceTests: XCTestCase {
    private lazy var networkMock = NetworkManagerMock()
    private lazy var localMock = LocalDataManagerMock()
    lazy var sut = HomeService(network: networkMock, local: localMock)
    
    func testSubmitURLToShort_withValidURL_shouldCallCompletionWithSuccess() {
        // Given
        let linkModel = Link(original: "https://www.example.com", short: "https://localhost:3000/alias/1313")
        let expectedModel = ShortURL(alias: "131313", link: linkModel)
        let url = "http://www.google.com"
        let expectation = self.expectation(description: "Completion should be success")
        var expectedResult: Result<ShortURL, APIError>?
        networkMock.isSuccess = true
        networkMock.expectModel = expectedModel

        // When
        sut.submitURLToShort(url: url) { (result) in
            expectedResult = result
            expectation.fulfill()
        }

        // Then
        waitForExpectations(timeout: 1.0) { (_) in
            XCTAssertEqual(self.networkMock.executeFromEndpointCalledCount, 1)
            XCTAssertEqual(expectedResult, .success(expectedModel))
        }
    }

    func testSubmitURLToShort_withInvalidURL_shouldNotCallNetworkExecute() {
        // Given
        let url = "invalidURL"
        let expectation = self.expectation(description: "Completion should be fail")
        var expectedResult: Result<ShortURL, APIError>?
        let expectError = APIError.invalidURL
        
        networkMock.isSuccess = false
        networkMock.expectError = .invalidURL

        // When
        sut.submitURLToShort(url: url) { (result) in
            expectedResult = result
            expectation.fulfill()
        }

        // Then
        waitForExpectations(timeout: 1.0) { (_) in
            XCTAssertEqual(self.networkMock.executeFromEndpointCalledCount, 1)
            XCTAssertEqual(expectedResult, .failure(expectError))
        }
    }

    func testSaveLocalDataSource_shouldCallLocalSave() throws {
        // Given
        let linkModel = Link(original: "https://www.example.com", short: "https://localhost:3000/alias/1313")
        let expectedModel = ShortURL(alias: "131313", link: linkModel)

        // When
        try sut.saveLocalDataSource(item: expectedModel)

        // Then
        XCTAssertEqual(localMock.saveCalledCount, 1)
        XCTAssertEqual(localMock.capturedItem, expectedModel)
    }

    func testLoadLocalDataSource_shouldCallLocalLoad() throws {
        // Given
        let linkModel = Link(original: "https://www.example.com", short: "https://localhost:3000/alias/1313")
        let expectedModel = ShortURL(alias: "131313", link: linkModel)
        localMock.stubLoadResult = [expectedModel]

        // When
        let result = try sut.loadLocalDataSource()

        // Then
        XCTAssertEqual(localMock.loadCalledCount, 1)
        XCTAssertEqual(result, [expectedModel])
    }
}

private final class NetworkManagerMock: NetworkManaging {
    var isSuccess = true
    var expectModel: Codable?
    var expectError: APIError = .invalidURL
    
    private(set) var executeFromEndpointCalledCount = 0
    
    func execute<T: Codable>(from endpoint: APIRoute, completion: @escaping (Result<T, APIError>) -> Void) {
        executeFromEndpointCalledCount += 1
        
        guard let expectModel = expectModel, isSuccess else {
            completion(.failure(expectError))
            return
        }
        
        completion(.success(expectModel as! T))
    }
}

private final class LocalDataManagerMock: LocalDataManaging {
    private(set) var saveCalledCount = 0
    private(set) var capturedItem: ShortURL?
    
    func save<T: Codable>(item: T) throws {
        saveCalledCount += 1
        capturedItem = item as? ShortURL
    }
    
    var stubLoadResult: [ShortURL] = []
    private(set) var loadCalledCount = 0
    
    func load<T: Codable>() throws -> [T] {
        loadCalledCount += 1
        return stubLoadResult as![T]
    }
}
