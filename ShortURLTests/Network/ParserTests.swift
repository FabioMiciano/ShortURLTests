import XCTest
@testable import ShortURL

final class ParserTests: XCTestCase {
    let sut = DefatultParser()
    
    func testParse_WhenReceiveValidData_ShouldReturnDecodedObject() {
        guard let json = """
            {
                "url": "http://localhost:3000",
                "id": 1313
            }
        """.data(using: .utf8) else {
            XCTFail("I Cant create JsonMock")
            return
        }
        
        let result = try? sut.parse(model: ShortURLMock.self, from: json)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.url, "http://localhost:3000")
        XCTAssertEqual(result?.id, 1313)
    }
    
    func testParse_WhenReceiveInvalidData_ShoudlReturnError() {
        guard let json = """
            {url": "http://localhost:3000", "ids": "1313"}
        """.data(using: .utf8) else {
            XCTFail("I Cant create JsonMock")
            return
        }
        
        XCTAssertThrowsError(try sut.parse(model: ShortURLMock.self, from: json))
    }
}

private struct ShortURLMock: Decodable {
    let url: String
    let id: Int
}
