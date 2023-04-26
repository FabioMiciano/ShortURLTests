import XCTest
@testable import ShortURL

final class NetworkManagerTests: XCTestCase {
    private lazy var linkModel = Link(
        original: "https://www.example.com",
        short: "https://localhost:3000/alias/1313"
    )
    private lazy var expectedModel = ShortURL(alias: "131313", link: linkModel)
    private lazy var parserMock = ParserMock()
    private lazy var sessionMock = URLSessionMock()
    lazy var sut = NetworkManager(session: sessionMock, parser: parserMock)
    
    func testExecute_WhenReceiveValidEndpoint_ShouldHasResponseSuccess() {
        let endPoint = APIRoute.submit(url: "http://example.com")
        createSessionMock(data: true, response: true, error: false)
        parserMock.expectedModelToReturn = expectedModel
        let expectation = XCTestExpectation(description: "Completion Handler Called")
        
        sut.execute(from: endPoint) { (result: Result<ShortURL, APIError>) in
            switch result {
            case let .success(model):
                XCTAssertEqual(model.link.short, "https://localhost:3000/alias/1313")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected Success")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testExecute_WhenCompletionReturnError_ShouldReturnFailed() {
        let enpoint = APIRoute.submit(url: "http://example.com")
        createSessionMock(data: false, response: false, error: true)
        let expectation = XCTestExpectation(description: "Completion Handler Called")
        
        sut.execute(from: enpoint) { (result: Result<ShortURL, APIError>) in
            switch result {
            case .success:
                XCTFail("Expecter Failure Request")
            case let .failure(error):
                XCTAssertEqual(error, .requestFailed(error: APIError.invalidURL))
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testExecute_WhenCompletionNoHasURLResponse_ShouldReturnFailed() {
        let enpoint = APIRoute.submit(url: "http://example.com")
        createSessionMock(data: false, response: false, error: false)
        let expectation = XCTestExpectation(description: "Completion Handler Called")
        
        sut.execute(from: enpoint) { (result: Result<ShortURL, APIError>) in
            switch result {
            case .success:
                XCTFail("Expecter Failure Request")
            case let .failure(error):
                XCTAssertEqual(error, .invalidResponse)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testExecute_WhenCompletionHasErrorStatusCode_ShouldReturnFailed() {
        let enpoint = APIRoute.submit(url: "http://example.com")
        createSessionMock(data: false, response: true, error: false, statusCode: 400)
        let expectation = XCTestExpectation(description: "Completion Handler Called")
        
        sut.execute(from: enpoint) { (result: Result<ShortURL, APIError>) in
            switch result {
            case .success:
                XCTFail("Expecter Failure Request")
            case let .failure(error):
                XCTAssertEqual(error, .requestFailedWith(statusCode: 400, message: "bad request"))
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testExecute_WhenCompletionNoHasData_ShouldReturnFailed() {
        let enpoint = APIRoute.submit(url: "http://example.com")
        createSessionMock(data: false, response: true, error: false)
        let expectation = XCTestExpectation(description: "Completion Handler Called")
        
        sut.execute(from: enpoint) { (result: Result<ShortURL, APIError>) in
            switch result {
            case .success:
                XCTFail("Expecter Failure Request")
            case let .failure(error):
                XCTAssertEqual(error, .invalidResponse)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testExecute_WhenCompletionCantParseData_ShouldReturnFailed() {
        let enpoint = APIRoute.submit(url: "http://example.com")
        createSessionMock(data: true, response: true, error: false)
        parserMock.isSuccess = false
        let expectation = XCTestExpectation(description: "Completion Handler Called")
        
        sut.execute(from: enpoint) { (result: Result<ShortURL, APIError>) in
            switch result {
            case .success:
                XCTFail("Expecter Failure Request")
            case let .failure(error):
                XCTAssertEqual(error, .decodingFailed)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

private extension NetworkManagerTests {
    func createSessionMock(data: Bool, response: Bool, error: Bool, statusCode: Int = 200) {
        if data {
            let expectedData = try? JSONEncoder().encode(expectedModel)
            sessionMock.data = expectedData
        }
        
        if response {
            guard let expectedURL = URL(string: "http://example.com") else { return }
            let expectedResponse = HTTPURLResponse(
                url: expectedURL,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )
            sessionMock.urlResponse = expectedResponse
        }
        
        if error {
            sessionMock.error = APIError.invalidURL
        }
    }
}

private final class ParserMock: Parser {
    var expectedModelToReturn: ShortURL?
    var isSuccess = true
    func parse<T: Decodable>(model: T.Type, from data: Data) throws -> T {
        guard isSuccess else {
            throw APIError.decodingFailed
        }
        
        return expectedModelToReturn as! T
    }
}
